-- Table pour stocker les abonnements push par utilisateur
create table if not exists push_subscriptions (
  id uuid default gen_random_uuid() primary key,
  user_id uuid references auth.users(id) on delete cascade not null,
  endpoint text not null,
  p256dh text not null,
  auth text not null,
  created_at timestamptz default now(),
  unique(user_id, endpoint)
);

alter table push_subscriptions enable row level security;

-- Chaque utilisateur gère ses propres abonnements
create policy "Users manage own push subscriptions"
  on push_subscriptions for all
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

-- La service role peut tout lire (pour l'Edge Function)
create policy "Service role full access"
  on push_subscriptions for all
  to service_role
  using (true);
