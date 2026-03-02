CREATE SCHEMA IF NOT EXISTS exercicio5;

CREATE OR REPLACE FUNCTION validate_cpf(cpf_input TEXT)
 RETURNS BOOLEAN AS $$
 DECLARE
    weights1 INT[] := ARRAY[10,9,8,7,6,5,4,3,2];
    weights2 INT[] := ARRAY[11,10,9,8,7,6,5,4,3,2];
    sum1 INT:= 0;
    sum2 INT:= 0;
    dig1 INT;
    dig2 INT;
 BEGIN

    -- Verifica tamanho
    IF length(cpf_input) <> 11 THEN
        RETURN FALSE;
    END IF;

    -- Rejeita CPFs com todos os dígitos iguais
    IF cpf_input ~ '^(\d)\1{10}$' THEN
        RETURN FALSE;
    END IF;

    -- Primeiro dígito
    FOR i IN 1..9 LOOP
        sum1 := sum1 + substring(cpf_input, i, 1)::INT * weights1[i];
    END LOOP;
    
    --pego o resto de sum1 divido por 11
    dig1 := (sum1 * 10) % 11;
    --se o resto de 10 então o valor de dig1 vai ficar como 0
    IF dig1 = 10 THEN dig1 := 0; END IF;
    --se dig1 calculado for diferente de (<>) do decimo digito que ta sendo inserido no banco barra o cpf
    IF dig1 <> substring(cpf_input,10,1)::INT THEN
        RETURN FALSE;
    END IF;

    -- Segundo dígito
    FOR i IN 1..10 LOOP
        sum2 := sum2 + substring(cpf_input, i, 1)::INT * weights2[i];
    END LOOP;


    dig2 := (sum2 * 10) % 11;
    IF dig2 = 10 THEN dig2 := 0; END IF;
    IF dig2 <> substring(cpf_input,11,1)::INT THEN
        RETURN FALSE;
    END IF;

    RETURN TRUE;
 END;
$$ LANGUAGE plpgsql IMMUTABLE;

CREATE OR REPLACE FUNCTION validate_cnpj(cnpj_input TEXT)
 RETURNS BOOLEAN AS $$
 DECLARE
    weights1 INT[] := ARRAY[5,4,3,2,9,8,7,6,5,4,3,2];
    weights2 INT[] := ARRAY[6,5,4,3,2,9,8,7,6,5,4,3,2];
    i INT;
    sum1 INT:= 0;
    sum2 INT:= 0;
    dig1 INT;
    dig2 INT;
 BEGIN

    IF length(cnpj_input) <> 14 THEN
        RETURN FALSE;
    END IF;

    -- Rejeita números repetidos
    IF cnpj_input ~ '^(\d)\1{13}$' THEN
        RETURN FALSE;
    END IF;

    -- Primeiro dígito
    FOR i IN 1..12 LOOP
        sum1 := sum1 + substring(cnpj_input, i, 1)::INT * weights1[i];
    END LOOP;

    dig1 := sum1 % 11;
    dig1 := CASE WHEN dig1 < 2 THEN 0 ELSE 11 - dig1 END;

    IF dig1 <> substring(cnpj_input,13,1)::INT THEN
        RETURN FALSE;
    END IF;

    -- Segundo dígito
    FOR i IN 1..13 LOOP
        sum2 := sum2 + substring(cnpj_input, i, 1)::INT * weights2[i];
    END LOOP;

    dig2 := sum2 % 11;
    dig2 := CASE WHEN dig2 < 2 THEN 0 ELSE 11 - dig2 END;

    IF dig2 <> substring(cnpj_input,14,1)::INT THEN
        RETURN FALSE;
    END IF;

    RETURN TRUE;
 END;
$$ LANGUAGE plpgsql IMMUTABLE;

CREATE OR REPLACE FUNCTION validate_telephone(telephone_input TEXT)
 RETURNS BOOLEAN AS $$ 
 DECLARE
    telephone TEXT;
 BEGIN

    IF length(telephone) NOT IN (10, 11) THEN
        RETURN FALSE;
    END IF;

    IF telefone ~ '^(\d)\1+$' THEN
        RETURN FALSE;
    END IF;

    IF telefone !~ '^(?:[1-9]{2})(?:9\d{8}|\d{8})$' THEN
        RETURN FALSE;
    END IF;

    IF NOT (
        substring(telephone, 1, 2)::INT = ANY (
            ARRAY[
                11,12,13,14,15,16,17,18,19,
                21,22,24,
                27,28,
                31,32,33,34,35,37,38,
                41,42,43,44,45,46,
                47,48,49,
                51,53,54,55,
                61,
                62,64,
                63,
                65,66,
                67,
                68,
                69,
                71,73,74,75,77,
                79,
                81,87,
                82,
                83,
                84,
                85,88,
                86,89,
                91,93,94,
                92,97,
                95,
                96,
                98,99
            ]
        )
        ) THEN
        RETURN FALSE;
    END IF;

    RETURN TRUE;
    
 END;
$$ LANGUAGE plpgsql IMMUTABLE;

CREATE OR REPLACE FUNCTION generate_product_code()
 RETURNS text
 LANGUAGE sql
 IMMUTABLE
 AS $$
  SELECT string_agg(
    substr(
      'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789',
      (random() * 61)::int + 1,
      1
    ),
    ''
  )
  FROM generate_series(1, 8);
$$;

CREATE TYPE exercicio5.product_category_enum AS ENUM (
  'eletronico',
  'alimento',
  'vestuario',
  'outros'
);

CREATE TABLE IF NOT EXISTS exercicio5.clients(
  id INTEGER GENERATED ALWAYS AS IDENTITY,
  name VARCHAR(150) NOT NULL, 
  email VARCHAR(320) NOT NULL,
  birth_date DATE NOT NULL,
  cpf VARCHAR(11) NOT NULL,
  active BOOLEAN NOT NULL DEFAULT TRUE,
  password_hash VARCHAR(128) NOT NULL,

  --declaração de chaves primárias
  CONSTRAINT exercicio5_clients_pk PRIMARY KEY (id),

  --decalaração de chaves únicas
  CONSTRAINT exercicio5_clients_uq_email UNIQUE (email),
  CONSTRAINT exercicio5_clients_uq_cpf UNIQUE (cpf),

  --declaração de restrições check
  CONSTRAINT exercicio5_clients_ck_email
  CHECK (
    email ~ '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'
  ),
  CONSTRAINT exercicio5_clients_ck_birth_date
  CHECK (
    birth_date <= CURRENT_DATE
  ),
  CONSTRAINT exercicio5_clients_ck_cpf
  CHECK (
    validate_cpf(cpf)
  ),
  CONSTRAINT exercicio5_clients_ck_name
  CHECK (
    trim(name) <> ''
    AND char_length(name) BETWEEN 2 AND 150
    AND name ~ '^[A-Za-zÀ-ÿ]+( [A-Za-zÀ-ÿ]+)*$'
  )
);

CREATE TABLE IF NOT EXISTS exercicio5.products(
  id INTEGER GENERATED ALWAYS AS IDENTITY,
  name VARCHAR(150) NOT NULL, 
  price_cents  INTEGER NOT NULL,
  stock INTEGER NOT NULL,
  category  exercicio5.product_category_enum NOT NULL,
  code VARCHAR(8) NOT NULL DEFAULT generate_product_code(),
  
  --declaração de chaves primárias
  CONSTRAINT exercicio5_products_pk PRIMARY KEY (id),

  --declaração de chaves únicas
  CONSTRAINT exercicio5_products_uq_code UNIQUE (code),

  --declaração de restrições check
  CONSTRAINT exercicio5_products_ck_name
  CHECK (
    trim(name) <> ''
    AND char_length(name) BETWEEN 2 AND 150
  ),
  CONSTRAINT exercicio5_products_ck_price_cents
  CHECK (
    price_cents > 0
  ),
  CONSTRAINT exercicio5_products_ck_stock
  CHECK (
    stock >= 0
  )
);

CREATE TABLE IF NOT EXISTS exercicio5.sellers(
  id INTEGER GENERATED ALWAYS AS IDENTITY,
  name VARCHAR(150) NOT NULL,
  cnpj VARCHAR(14) NOT NULL,
  email VARCHAR(320) NOT NULL,
  telephone VARCHAR(11),
  status BOOLEAN NOT NULL DEFAULT TRUE,
  product_id INTEGER NOT NULL,
  
  --declaração de chaves primárias
  CONSTRAINT exercicio5_sellers_pk PRIMARY KEY (id),

  --declaração de chaves únicas
  CONSTRAINT exercicio5_sellers_uq_cnpj UNIQUE (cnpj),
  CONSTRAINT exercicio5_sellers_uq_email UNIQUE (email),

  --declaração de restrições check
  CONSTRAINT exercicio5_clients_ck_cnpj
  CHECK (
    validate_cnpj(cnpj)
  ),
  CONSTRAINT exercicio5_clients_ck_telephone
  CHECK (
    validate_telephone(telephone)
  ),

  --declaração de chaves estrangeiras
  CONSTRAINT exercicio5_products_fk
  FOREIGN KEY (product_id)
  REFERENCES exercicio5.products (id)

);

CREATE TABLE IF NOT EXISTS exercicio5.sales(
  id INTEGER GENERATED ALWAYS AS IDENTITY,
  quantities_sold INTEGER NOT NULL,
  sale_date TIMESTAMPTZ NOT NULL,
  discount_percent  NUMERIC(5,2),
  client_id INTEGER NOT NULL,
  product_id INTEGER NOT NULL,

  --declaração de chaves primárias 
  CONSTRAINT exercicio5_sales_pk PRIMARY KEY (id),

  --declaração de restrições check
  CONSTRAINT exercicio5_sales_ck_sale_date
  CHECK (
    sale_date <= CURRENT_DATE  
  ),

  CONSTRAINT exercicio5_sales_ck_discount_percent
  CHECK (
    discount_percent >= 0
    AND discount_percent <= 100
  ),

  CONSTRAINT exercicio5_sales_ck_quantities_sold
  CHECK (
    quantities_sold > 0
  ),

  --declaração de chaves estrangeiras
  CONSTRAINT exercicio5_clients_fk
  FOREIGN KEY (client_id)
  REFERENCES exercicio5.clients (id),

  CONSTRAINT exercicio5_products_fk
  FOREIGN KEY (product_id)
  REFERENCES exercicio5.products (id)
);

CREATE OR REPLACE FUNCTION exercicio5.fn_check_and_update_stock()
  RETURNS TRIGGER AS $$
  DECLARE
  v_stock INTEGER;
  BEGIN
  -- buscar estoque atual do produto
  SELECT stock
  INTO v_stock
  FROM exercicio5.products
  WHERE id = NEW.product_id
  FOR UPDATE;

  -- validar estoque
  IF NEW.quantities_sold > v_stock THEN
    RAISE EXCEPTION
      'Quantidade vendida (%) maior que o estoque disponível (%)',
      NEW.quantities_sold, v_stock;
  END IF;

  -- atualizar estoque
  UPDATE exercicio5.products
  SET stock = stock - NEW.quantities_sold
  WHERE id = NEW.product_id;

  RETURN NEW;
  END;
  $$ LANGUAGE plpgsql;

  CREATE TRIGGER exercicio5_sales_trg_check_stock
  BEFORE INSERT ON exercicio5.sales
  FOR EACH ROW
  EXECUTE FUNCTION exercicio5.fn_check_and_update_stock();

COMMENT ON TABLE exercicio5.clients IS 'Tabela de clientes do sistema';
COMMENT ON TABLE exercicio5.products IS 'Tabela de produtos do sistema';
COMMENT ON TABLE exercicio5.sellers IS 'Tabela de vendedores do sistema';
COMMENT ON TABLE exercicio5.sales IS 'Tabela de vendas do sistema';
COMMENT ON FUNCTION validate_cpf(TEXT) IS 'Função que valida cfp com os dois digitos verificadores e filtra numeros iguais';
COMMENT ON FUNCTION validate_cnpj(TEXT) IS 'Função que valida cnpj com os dois digitos verificadores e filtra numeros iguais';
COMMENT ON FUNCTION validate_telephone(TEXT) IS 'Função que valida ddd valido e formato de 10 ou 11 digitos e filtra numeros iguais';
COMMENT ON FUNCTION generate_product_code() IS 'Função que cria como valor default na tabela de products na coluna code, um código de 8 caracteres aleatórios entre letras maiúsculas, minúsculas e numeros do 0 ao 9';