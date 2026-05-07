BEGIN;

    SET search_path TO ext_pgtap;

  SELECT plan(5);

  -- string normal
  SELECT ok(
    exercicio7.fn_validate_blank_strings('Joao'),
    'Texto comum deve retornar true'
  );

  -- string com espaços externos
  SELECT ok(
    exercicio7.fn_validate_blank_strings('   Maria   '),
    'Texto com espaços nas bordas deve retornar true'
  );

  -- string vazia
  SELECT ok(
    NOT exercicio7.fn_validate_blank_strings(''),
    'String vazia deve retornar false'
  );

  -- apenas espaços
  SELECT ok(
    NOT exercicio7.fn_validate_blank_strings('     '),
    'String só com espaços deve retornar false'
  );

  -- NULL
  SELECT ok(
    NOT exercicio7.fn_validate_blank_strings(NULL),
    'NULL deve retornar false'
  );

  SELECT * FROM finish();
ROLLBACK;