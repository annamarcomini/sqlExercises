BEGIN

SELECT plan(3);

SELECT diag('Retorna TRUE se o cpf for válido');
SELECT ok(exercicio5.validate_cpf('39053344705'), 'CPF válido');

SELECT diag('CPF com digitos repetidos deve ser inválido');
SELECT ok(NOT exercicio5.validate_cpf('11111111111'), 'CPF com dígitos repetidos');

SELECT diag('CPF com os digitos verificadores errados deve ser inválido');
SELECT ok(NOT exercicio5.validate_cpf('39053344716'), 'CPF com dígitos verificadores errados');

SELECT * FROM finish();

ROLLBACK