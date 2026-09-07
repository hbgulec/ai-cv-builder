-- Phase 2: immutable resume snapshots for user-controlled version history.

create table if not exists public.resume_versions (
  id uuid primary key default gen_random_uuid(),
  resume_id uuid not null references public.resumes (id) on delete cascade,
  user_id uuid not null references auth.users (id) on delete cascade,
  document jsonb not null,
  created_at timestamptz not null default timezone('utc', now())
);

create index if not exists resume_versions_resume_created_at_idx
  on public.resume_versions (resume_id, created_at desc);

alter table public.resume_versions enable row level security;

grant select, insert, delete on public.resume_versions to authenticated;

create policy "Users can read their resume versions"
on public.resume_versions for select to authenticated
using ((select auth.uid()) = user_id);

create policy "Users can create their resume versions"
on public.resume_versions for insert to authenticated
with check ((select auth.uid()) = user_id);

create policy "Users can delete their resume versions"
on public.resume_versions for delete to authenticated
using ((select auth.uid()) = user_id);

-- Keep cloud storage predictable while retaining enough recovery points.
create or replace function public.trim_resume_versions()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  delete from public.resume_versions
  where id in (
    select id
    from public.resume_versions
    where resume_id = new.resume_id
    order by created_at desc
    offset 20
  );
  return new;
end;
$$;

drop trigger if exists trim_resume_versions_after_insert on public.resume_versions;
create trigger trim_resume_versions_after_insert
after insert on public.resume_versions
for each row execute function public.trim_resume_versions();