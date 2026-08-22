-- Phase 1 central storage. Access is limited by RLS policies tied to each
-- signed-in Supabase user.

create extension if not exists pgcrypto;

create table if not exists public.profiles (
  id uuid primary key references auth.users (id) on delete cascade,
  account_type text not null default 'guest'
    check (account_type in ('guest', 'email')),
  display_name text,
  support_code uuid not null default gen_random_uuid() unique,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now())
);

create table if not exists public.resumes (
  id uuid primary key,
  user_id uuid not null references auth.users (id) on delete cascade,
  title text not null,
  template_id text not null,
  content_language text not null default 'tr',
  document jsonb not null,
  schema_version integer not null default 1 check (schema_version > 0),
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now())
);

create index if not exists resumes_user_updated_at_idx
  on public.resumes (user_id, updated_at desc);

alter table public.profiles enable row level security;
alter table public.resumes enable row level security;

grant usage on schema public to authenticated;
grant select, insert, update, delete on public.profiles to authenticated;
grant select, insert, update, delete on public.resumes to authenticated;
create or replace function public.set_updated_at()
returns trigger
language plpgsql
set search_path = public
as $$
begin
  new.updated_at = timezone('utc', now());
  return new;
end;
$$;

create or replace function public.create_profile_for_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.profiles (id, account_type)
  values (
    new.id,
    case when new.is_anonymous
      then 'guest'
      else 'email'
    end
  )
  on conflict (id) do nothing;
  return new;
end;
$$;

create or replace function public.sync_profile_account_type()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  update public.profiles
  set account_type = case when new.is_anonymous then 'guest' else 'email' end
  where id = new.id;
  return new;
end;
$$;

drop trigger if exists sync_profile_account_type_on_auth_update on auth.users;
create trigger sync_profile_account_type_on_auth_update
after update on auth.users
for each row execute function public.sync_profile_account_type();
drop trigger if exists profiles_set_updated_at on public.profiles;
create trigger profiles_set_updated_at
before update on public.profiles
for each row execute function public.set_updated_at();

drop trigger if exists resumes_set_updated_at on public.resumes;
create trigger resumes_set_updated_at
before update on public.resumes
for each row execute function public.set_updated_at();

drop trigger if exists create_profile_on_signup on auth.users;
create trigger create_profile_on_signup
after insert on auth.users
for each row execute function public.create_profile_for_new_user();

create policy "Users can view their profile"
on public.profiles for select to authenticated
using ((select auth.uid()) = id);

create policy "Users can update their profile"
on public.profiles for update to authenticated
using ((select auth.uid()) = id)
with check ((select auth.uid()) = id);

create policy "Users can read their resumes"
on public.resumes for select to authenticated
using ((select auth.uid()) = user_id);

create policy "Users can create their resumes"
on public.resumes for insert to authenticated
with check ((select auth.uid()) = user_id);

create policy "Users can update their resumes"
on public.resumes for update to authenticated
using ((select auth.uid()) = user_id)
with check ((select auth.uid()) = user_id);

create policy "Users can delete their resumes"
on public.resumes for delete to authenticated
using ((select auth.uid()) = user_id);
