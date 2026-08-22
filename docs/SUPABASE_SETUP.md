# Supabase local setup

This application never stores Supabase keys in Git. Copy
`config/supabase.json.example` to `config/supabase.json` and enter only the
project URL and publishable key from Supabase Dashboard > Connect > API Keys.

Run the app locally with:

```powershell
flutter run --dart-define-from-file=config/supabase.json
```

Do not use the `service_role` key in Flutter or share it in chat.

## Dashboard actions

1. In **Authentication > Providers**, enable **Anonymous Sign-Ins**.
2. Leave **Email** enabled. We will use passwordless email sign-in in the next
   Phase 1 checkpoint.
3. In **SQL Editor**, run the contents of
   `supabase/migrations/202608220001_phase_one_core.sql` once.
4. In **Authentication > URL Configuration**, add
   `aicvbuilder://login-callback` to the allowed redirect URLs.

The SQL migration enables RLS and limits every profile and resume record to
its owner. The support code is intentionally not searchable through the mobile
client; any future support tooling will use a protected backend.
