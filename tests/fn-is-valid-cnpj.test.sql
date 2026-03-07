BEGIN;

SELECT plan(3);

SELECT diag('Retorna TRUE se o cnpj for válido');
SELECT is(exercicio5.validate_cnpj('81995971000110'), true, 'CPF válido');

SELECT diag('CNPJ com digitos repetidos deve ser inválido');
SELECT is(exercicio5.validate_cnpj('11111111111111'), false, 'CNPJ com dígitos repetidos');

SELECT diag('CNPJ com os digitos verificadores errados deve ser inválido');
SELECT is(exercicio5.validate_cnpj('81995971000121'), false, 'CNPJS com dígitos verificadores errados');

SELECT * FROM finish();

ROLLBACK;