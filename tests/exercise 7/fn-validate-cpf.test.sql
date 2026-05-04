BEGIN;

SET search_path to ext_pgtap;
SELECT plan(3);

SELECT diag('Retorna TRUE se o cpf for válido');
SELECT is(exercicio7.validate_cpf('39053344705'), TRUE, 'CPF válido');

SELECT diag('CPF com digitos repetidos deve ser inválido');
SELECT is(exercicio7.validate_cpf('11111111111'), FALSE, 'CPF com dígitos repetidos');

SELECT diag('CPF com os digitos verificadores errados deve ser inválido');
SELECT is(exercicio7.validate_cpf('39053344716'), FALSE, 'CPF com dígitos verificadores errados');

SELECT * FROM finish();

ROLLBACK;