-- ============================================================
-- Schema do Campeonato Society — rodar no SQL Editor do Supabase
-- ============================================================

create extension if not exists "pgcrypto";

create table if not exists organizers (
  id uuid primary key default gen_random_uuid(),
  nome text not null,
  usuario text not null unique,
  senha text not null,
  created_at timestamptz default now()
);

create table if not exists teams (
  id uuid primary key default gen_random_uuid(),
  nome text not null,
  grupo text,
  responsavel_nome text,
  responsavel_contato text,
  codigo_acesso text not null,
  created_at timestamptz default now()
);

create table if not exists players (
  id uuid primary key default gen_random_uuid(),
  team_id uuid references teams(id) on delete cascade,
  nome text not null,
  numero text,
  posicao text,
  foto text,
  created_at timestamptz default now()
);

create table if not exists matches (
  id uuid primary key default gen_random_uuid(),
  fase text not null,
  grupo text,
  time_a uuid references teams(id) on delete cascade,
  time_b uuid references teams(id) on delete cascade,
  data date,
  finalizado boolean default false,
  created_at timestamptz default now()
);

create table if not exists match_events (
  id uuid primary key default gen_random_uuid(),
  match_id uuid references matches(id) on delete cascade,
  team_id uuid references teams(id) on delete cascade,
  player_id uuid references players(id) on delete cascade,
  tipo text not null check (tipo in ('gol','amarelo','vermelho')),
  created_at timestamptz default now()
);

create table if not exists config (
  id int primary key default 1,
  owner_code text not null default 'owner2027',
  constraint single_row check (id = 1)
);
insert into config (id, owner_code) values (1, 'owner2027')
  on conflict (id) do nothing;

-- ------------------------------------------------------------
-- Row Level Security
-- ------------------------------------------------------------
alter table organizers enable row level security;
alter table teams enable row level security;
alter table players enable row level security;
alter table matches enable row level security;
alter table match_events enable row level security;
alter table config enable row level security;

-- Políticas abertas: a chave "anon" (pública, embutida no site) pode ler e
-- escrever em todas as tabelas. O controle de quem pode fazer o quê fica
-- por conta da lógica do próprio site (login de proprietário/organizador/
-- responsável), não do banco. Isso é suficiente para um campeonato amador,
-- mas tecnicamente qualquer pessoa com a chave anon (ela fica visível no
-- código-fonte do site) consegue acessar a API do Supabase diretamente.
-- Se quiser reforçar isso no futuro, migre para Supabase Auth + políticas
-- por usuário autenticado.
create policy "allow all organizers" on organizers for all using (true) with check (true);
create policy "allow all teams" on teams for all using (true) with check (true);
create policy "allow all players" on players for all using (true) with check (true);
create policy "allow all matches" on matches for all using (true) with check (true);
create policy "allow all match_events" on match_events for all using (true) with check (true);
create policy "allow all config" on config for all using (true) with check (true);
