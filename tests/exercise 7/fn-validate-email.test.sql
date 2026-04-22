BEGIN;
  SET search_path TO ext_pgtap;
  SELECT plan(21);



  -- ============================================================
  -- BLOCO 1: Validação de NULL e string vazia
  -- ============================================================

  SELECT diag('Retorna FALSE para NULL');
  SELECT is(
    exercicio7.fn_validate_email(NULL),
    FALSE
  );

  SELECT diag('Retorna FALSE para string vazia');
  SELECT is(
    exercicio7.fn_validate_email(''),
    FALSE
  );



  -- ============================================================
  -- BLOCO 2: Estrutura inválida
  -- ============================================================

  SELECT diag('Retorna FALSE para e-mail sem @');
  SELECT is(
    exercicio7.fn_validate_email('invalidemail.com'),
    FALSE
  );

  SELECT diag('Retorna FALSE para e-mail sem domínio após @');
  SELECT is(
    exercicio7.fn_validate_email('user@'),
    FALSE
  );

  SELECT diag('Retorna FALSE para e-mail sem parte local antes de @');
  SELECT is(
    exercicio7.fn_validate_email('@domain.com'),
    FALSE
  );

  SELECT diag('Retorna FALSE para e-mail sem ponto no domínio');
  SELECT is(
    exercicio7.fn_validate_email('user@domaincom'),
    FALSE
  );

  SELECT diag('Retorna FALSE para e-mail com @ duplicado');
  SELECT is(
    exercicio7.fn_validate_email('user@@domain.com'),
    FALSE
  );

  SELECT diag('Retorna FALSE para e-mail com espaço');
  SELECT is(
    exercicio7.fn_validate_email('user name@domain.com'),
    FALSE
  );



  -- ============================================================
  -- BLOCO 3: Validações de tamanho
  -- ============================================================

  SELECT diag('Retorna FALSE para e-mail com comprimento total acima de 255 caracteres');
  SELECT is(
    exercicio7.fn_validate_email(repeat('a', 64) || '@' || repeat('a', 187) || '.com'),
    FALSE
  );

  SELECT diag('Retorna TRUE para e-mail com comprimento total igual a 255 caracteres');
  SELECT is(
    exercicio7.fn_validate_email(repeat('a', 64) || '@' || repeat('a', 186) || '.com'),
    TRUE
  );

  SELECT diag('Retorna FALSE para parte local com mais de 64 caracteres');
  SELECT is(
    exercicio7.fn_validate_email(repeat('a', 65) || '@domain.com'),
    FALSE
  );

  SELECT diag('Retorna TRUE para parte local com exatamente 64 caracteres');
  SELECT is(
    exercicio7.fn_validate_email(repeat('a', 64) || '@domain.com'),
    TRUE
  );

  SELECT diag('Retorna FALSE para domínio com mais de 191 caracteres');
  SELECT is(
    exercicio7.fn_validate_email('user@' || repeat('a', 188) || '.com'),
    FALSE
  );

  SELECT diag('Retorna TRUE para domínio com exatamente 191 caracteres');
  SELECT is(
    exercicio7.fn_validate_email('user@' || repeat('a', 187) || '.com'),
    TRUE
  );



  -- ============================================================
  -- BLOCO 4: Formatos válidos
  -- ============================================================

  SELECT diag('Retorna TRUE para e-mail simples válido');
  SELECT is(
    exercicio7.fn_validate_email('user@domain.com'),
    TRUE
  );

  SELECT diag('Retorna TRUE para e-mail com subdomínio');
  SELECT is(
    exercicio7.fn_validate_email('user@mail.domain.com'),
    TRUE
  );

  SELECT diag('Retorna TRUE para e-mail com caracteres especiais permitidos na parte local');
  SELECT is(
    exercicio7.fn_validate_email('user.name+tag_test-1%ok@domain.com'),
    TRUE
  );

  SELECT diag('Retorna TRUE para e-mail com números na parte local e no domínio');
  SELECT is(
    exercicio7.fn_validate_email('user123@domain456.com'),
    TRUE
  );

  SELECT diag('Retorna TRUE para e-mail com TLD longo');
  SELECT is(
    exercicio7.fn_validate_email('user@domain.technology'),
    TRUE
  );

  SELECT diag('Retorna TRUE para e-mail com múltiplos subdomínios');
  SELECT is(
    exercicio7.fn_validate_email('user@a.b.c.domain.com'),
    TRUE
  );

  SELECT diag('Retorna TRUE para e-mail com letras maiúsculas');
  SELECT is(
    exercicio7.fn_validate_email('User.Name@Domain.COM'),
    TRUE
  );



  SELECT * FROM finish();
ROLLBACK;