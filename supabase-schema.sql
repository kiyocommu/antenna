-- Web Antenna Cloud 用 Supabase スキーマ
-- Supabase SQL Editor で実行してください。

create table if not exists public.antenna_sites (
  profile_id text not null,
  url text not null,
  label text not null default '',
  selector text not null default '',
  ignore_selector text not null default '',
  ignore_text_pattern text not null default '',
  tags jsonb not null default '[]'::jsonb,
  pinned boolean not null default false,
  added_at timestamptz not null default now(),
  last_checked_at timestamptz,
  last_changed_at timestamptz,
  prev_text text,
  prev_hash text,
  snippet text,
  snippet_diff jsonb,
  status text not null default 'unchecked',
  error_msg text,
  updated_at timestamptz not null default now(),
  primary key (profile_id, url)
);

alter table public.antenna_sites enable row level security;

grant select, insert, update, delete on public.antenna_sites to anon;

drop policy if exists "antenna_sites_anon_select" on public.antenna_sites;
drop policy if exists "antenna_sites_anon_insert" on public.antenna_sites;
drop policy if exists "antenna_sites_anon_update" on public.antenna_sites;
drop policy if exists "antenna_sites_anon_delete" on public.antenna_sites;

create policy "antenna_sites_anon_select" on public.antenna_sites for select to anon using (true);
create policy "antenna_sites_anon_insert" on public.antenna_sites for insert to anon with check (profile_id <> '');
create policy "antenna_sites_anon_update" on public.antenna_sites for update to anon using (profile_id <> '') with check (profile_id <> '');
create policy "antenna_sites_anon_delete" on public.antenna_sites for delete to anon using (profile_id <> '');

create index if not exists antenna_sites_profile_updated_idx on public.antenna_sites (profile_id, updated_at desc);
create index if not exists antenna_sites_profile_changed_idx on public.antenna_sites (profile_id, last_changed_at desc);
