BEGIN;
SELECT plan(4);

SET search_path to ext_pgtap;

-----kitchens table ck tests
SELECT lives_ok(
  $$
    INSERT INTO exercicio7.kitchens
      (name, city, street, number, neighborhood, state, zip_code, max_stations_number)
    VALUES
      ('cozinha 1', 'Ribeirão', 'Rua 1', '104', 'Jardim clara', 'SP', '19909-000', 10);
  $$,
  'Permite valor total positivo'
);

SELECT throws_ok(
  $$
    INSERT INTO exercicio7.kitchens
      (name, city, street, number, neighborhood, state, zip_code, max_stations_number)
    VALUES
      ('cozinha 1', 'Ribeirão', 'Rua 1', '104', 'Jardim clara', 'SP', '19909-000', -10);
  $$,
  '23514',
  'violates check constraint',
  'Bloqueia valor negativo'
);

-----orders table ck tests
SELECT lives_ok(
  $$
    INSERT INTO exercicio7.orders
      (total_value_cents, situation, exercicio7_t_menus_c_id)
    VALUES
      (100, 'pendente', 1);
  $$,
  'Permite valor total positivo'
);

SELECT throws_ok(
  $$
    INSERT INTO exercicio7.orders
      (total_value_cents, situation, exercicio7_t_menus_c_id)
    VALUES
      (-100, 'pendente', 1);
  $$,
  '23514',
  'violates check constraint',
  'Bloqueia valor negativo'
);

SELECT * FROM finish();

ROLLBACK;