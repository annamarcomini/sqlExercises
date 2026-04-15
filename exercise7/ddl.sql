CREATE SCHEMA IF NOT EXISTS exercicio7;

CREATE TYPE exercicio7.chefs_situation_enum AS ENUM (
  'ativo',
  'suspenso',
  'inativo',
);

CREATE TYPE exercicio7.menus_situation_enum AS ENUM (
  'ativo',
  'suspenso',
  'inativo',
);

CREATE TYPE exercicio7.orders_situation_enum AS ENUM (
  'pendente', 
  'confirmado', 
  'cancelado', 
  'concluído',
);

CREATE TYPE exercicio7.stations_operational_type_enum AS ENUM (
  'grelha',
  'fritura', 
  'preparo', 
  'forno',
);

CREATE TYPE exercicio7.stations_operational_situation_enum AS ENUM (
  'disponível', 
  'manutenção', 
  'inativa',
);

CREATE TABLE IF NOT EXISTS chefs(
  id NTEGER GENERATED ALWAYS AS IDENTITY,
  name VARCHAR(150) NOT NULL,
  email VARCHAR(320) NOT NULL,
  cpf VARCHAR(11) NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  situation exercicio7.chefs_situation_enum NOT NULL,

  --declaração de chaves primárias
  CONSTRAINT exercicio7_chefs_pk PRIMARY KEY (id),

  --declaração de chaves únicas
  CONSTRAINT exercicio7_chefs_uq_email UNIQUE (email),
  CONSTRAINT exercicio7_chefs_uq_cpf UNIQUE (cpf),
);

CREATE TABLE IF NOT EXISTS menus(
  id NTEGER GENERATED ALWAYS AS IDENTITY,
  name VARCHAR(150) NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  situation exercicio7.menus_situation_enum NOT NULL,
  exercicio7_t_chefs_c_id INTEGER NOT NULL,

  --declaração de chaves primárias
  CONSTRAINT exercicio7_menus_pk PRIMARY KEY (id),
);

CREATE TABLE IF NOT EXISTS orders(
  id INTEGER GENERATED ALWAYS AS IDENTITY,
  total_value_cents INTEGER NOT NULL,
  situation exercicio7.orders_situation_enum NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  exercicio7_t_menus_c_id INTEGER NOT NULL,
);

CREATE TABLE IF NOT EXISTS reservations(
  id INTEGER GENERATED ALWAYS AS IDENTITY,
  reservation_interval TSTZRANGE NOT NULL,
  exercicio7_t_station_c_id INTEGER NOT NULL,
  exercicio7_t_chefs_c_id INTEGER NOT NULL,
);

CREATE TABLE IF NOT EXISTS kitchens(
  id INTEGER GENERATED ALWAYS AS IDENTITY,
  name VARCHAR(150) NOT NULL,
  address VARCHAR(255) NOT NULL,
  city VARCHAR(150) NOT NULL,
  max_stations_number INTEGER NOT NULL,
);

CREATE TABLE IF NOT EXISTS stations(
  id INTEGER GENERATED ALWAYS AS IDENTITY,
  kitchen_identifier TEXT NOT NULL DEFAULT generate_random_identifier_3(),
  operational_type VARCHAR(255) NOT NULL,
  operational_situation VARCHAR(150) NOT NULL,
  exercicio7_t_kitchens_c_id INTEGER NOT NULL,
);



