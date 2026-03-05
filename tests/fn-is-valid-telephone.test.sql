BEGIN;

SELECT plan(5);

-- Telefones válidos
SELECT diag('telefone celular com ddd existente deve ser válido');
SELECT ok(
  exercicio5.validate_telephone('16991234567'),
  'Celular válido com DDD 16'
);

SELECT diag('telefone fixo com ddd existente deve ser válido');
SELECT ok(
  exercicio5.validate_telephone('1631234567'),
  'Telefone fixo válido com DDD 16'
);


-- Telefones inválidos
SELECT diag('telefones com todos os digitos repetidos devem ser inválidos');
SELECT ok(
  NOT exercicio5.validate_telephone('11111111111'),
  'Telefone com todos os dígitos repetidos é inválido'
);

SELECT diag('telefone com ddd inexistente deve ser inválido');
SELECT ok(
  NOT exercicio5.validate_telephone('00991234567'),
  'DDD que não está na lista de permitidos é inválido'
);

SELECT diag('telefone com tamanho errado deve ser inválido');
SELECT ok(
  NOT exercicio5.validate_telephone('169123456'),
  'Telefone com tamanho inválido'
);

SELECT * FROM finish();

ROLLBACK;
