BEGIN;

  SET search_path TO ext_pgtap;

  SELECT plan(12);

  SELECT ok(
    exercicio7.fn_validate_strings('Pikachu'),
    'Deve aceitar string simples'
  );

  SELECT ok(
    exercicio7.fn_validate_strings(
      'Pikachu',
      p_has_letters := TRUE
    ),
    'Deve aceitar texto com letras quando letras são exigidas'
  );

  SELECT ok(
    exercicio7.fn_validate_strings(
      'abc123',
      p_has_numbers := TRUE
    ),
    'Deve aceitar texto com números quando números são exigidos'
  );

  SELECT ok(
    exercicio7.fn_validate_strings(
      'abcdef',
      p_min_length := 5
    ),
    'Deve respeitar tamanho mínimo'
  );

  SELECT ok(
    exercicio7.fn_validate_strings(
      'Senha123',
      p_has_uppercase := TRUE
    ),
    'Deve aceitar texto com maiúscula'
  );

  SELECT ok(
    exercicio7.fn_validate_strings(
      'Senha123!',
      p_has_special_chars := TRUE
    ),
    'Deve aceitar caractere especial'
  );

  SELECT ok(
    exercicio7.fn_validate_strings(
      'João Silva',
      p_has_spaces := TRUE
    ),
    'Deve aceitar texto com espaços quando espaços são exigidos'
  );

  SELECT ok(
    exercicio7.fn_validate_strings(
      'senha123',
      p_has_lowercase := TRUE
    ),
    'Deve aceitar texto com letras minúsculas'
  );

  SELECT ok(
    NOT exercicio7.fn_validate_strings(
      'SENHA123',
      p_has_lowercase := TRUE
    ),
    'Deve rejeitar texto sem letras minúsculas'
 );
  
  SELECT ok(
    NOT exercicio7.fn_validate_strings(
      'JoãoSilva',
      p_has_spaces := TRUE
    ),
    'Deve rejeitar texto sem espaços quando espaços são exigidos'
  );

  SELECT ok(
    NOT exercicio7.fn_validate_strings(
      'Senha123',
      p_has_special_chars := TRUE
    ),
    'Deve rejeitar quando caractere especial é exigido'
  );

  SELECT ok(
    NOT exercicio7.fn_validate_strings(NULL),
    'Deve rejeitar NULL'
  );

  SELECT ok(
    NOT exercicio7.fn_validate_strings(
      '12345',
      p_has_letters := TRUE
    ),
    'Deve rejeitar números quando letras são exigidas'
  );

  SELECT ok(
    NOT exercicio7.fn_validate_strings(
      'senha123',
      p_has_uppercase := TRUE
    ),
    'Deve rejeitar texto sem maiúscula'
  );

  SELECT ok(
    NOT exercicio7.fn_validate_strings(
      'abcdef',
      p_has_numbers := TRUE
    ),
    'Deve rejeitar texto sem números quando números são exigidos'
 );

  SELECT ok(
    NOT exercicio7.fn_validate_strings(
      'abc',
      p_min_length := 5
    ),
    'Deve rejeitar texto menor que o mínimo'
  );

  SELECT * FROM finish();
ROLLBACK;