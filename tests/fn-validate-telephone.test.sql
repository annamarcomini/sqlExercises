BEGIN;

SET search_path to ext_pgtap;
SELECT plan(5);

-- Telefones válidos
SELECT diag('telefone celular com ddd existente deve ser válido');
SELECT is(
  exercicio5.validate_telephone('16991234567'), 
  true,
  'Celular válido com DDD 16'
);

SELECT diag('telefone fixo com ddd existente deve ser válido');
SELECT is(
  exercicio5.validate_telephone('1631234567'),
  true,
  'Telefone fixo válido com DDD 16'
);


-- Telefones inválidos
SELECT diag('telefones com todos os digitos repetidos devem ser inválidos');
SELECT is(
  exercicio5.validate_telephone('11111111111'), 
  false,
  'Telefone com todos os dígitos repetidos é inválido'
);

SELECT diag('telefone com ddd inexistente deve ser inválido');
SELECT is(
  exercicio5.validate_telephone('00991234567'),
  false,
  'DDD que não está na lista de permitidos é inválido'
);

SELECT diag('telefone com tamanho errado deve ser inválido');
SELECT is(
  exercicio5.validate_telephone('169123456'),
  false,
  'Telefone com tamanho inválido'
);

SELECT * FROM finish();

ROLLBACK;
