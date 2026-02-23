CREATE SCHEMA IF NOT EXISTS exercicio4;

CREATE OR REPLACE FUNCTION validate_cpf(cpf_input TEXT)
 RETURNS BOOLEAN AS $$
 DECLARE
    cpf TEXT;
    soma1 INT;
    soma2 INT;
    dig1 INT;
    dig2 INT;
 BEGIN
    -- Remove tudo que não for número
    cpf := regexp_replace(cpf_input, '[^0-9]', '', 'g');

    -- Verifica tamanho
    IF length(cpf) <> 11 THEN
        RETURN FALSE;
    END IF;

    -- Rejeita CPFs com todos os dígitos iguais
    IF cpf ~ '^(\d)\1{10}$' THEN
        RETURN FALSE;
    END IF;

    -- Primeiro dígito
    soma1 :=
        substring(cpf,1,1)::INT * 10 +
        substring(cpf,2,1)::INT * 9  +
        substring(cpf,3,1)::INT * 8  +
        substring(cpf,4,1)::INT * 7  +
        substring(cpf,5,1)::INT * 6  +
        substring(cpf,6,1)::INT * 5  +
        substring(cpf,7,1)::INT * 4  +
        substring(cpf,8,1)::INT * 3  +
        substring(cpf,9,1)::INT * 2;
    
    --pego o resto de soma1 divido por 11
    dig1 := (soma1 * 10) % 11;
    --se o resto de 10 então o valor de dig1 vai ficar como 0
    IF dig1 = 10 THEN dig1 := 0; END IF;
    --se dig1 calculado for diferente de (<>) do decimo digito que ta sendo inserido no banco barra o cpf
    IF dig1 <> substring(cpf,10,1)::INT THEN
        RETURN FALSE;
    END IF;

    -- Segundo dígito
    soma2 :=
        substring(cpf,1,1)::INT * 11 +
        substring(cpf,2,1)::INT * 10 +
        substring(cpf,3,1)::INT * 9  +
        substring(cpf,4,1)::INT * 8  +
        substring(cpf,5,1)::INT * 7  +
        substring(cpf,6,1)::INT * 6  +
        substring(cpf,7,1)::INT * 5  +
        substring(cpf,8,1)::INT * 4  +
        substring(cpf,9,1)::INT * 3  +
        substring(cpf,10,1)::INT * 2;

    dig2 := (soma2 * 10) % 11;
    IF dig2 = 10 THEN dig2 := 0; END IF;
    IF dig2 <> substring(cpf,11,1)::INT THEN
        RETURN FALSE;
    END IF;

    RETURN TRUE;
 END;
$$ LANGUAGE plpgsql IMMUTABLE;

CREATE OR REPLACE FUNCTION validate_cnpj(cnpj_input TEXT)
 RETURNS BOOLEAN AS $$
 DECLARE
    cnpj TEXT;
    soma1 INT;
    soma2 INT;
    dig1 INT;
    dig2 INT;
 BEGIN
    -- Remove tudo que não for número
    cnpj := regexp_replace(cnpj_input, '[^0-9]', '', 'g');

    IF length(cnpj) <> 14 THEN
        RETURN FALSE;
    END IF;

    -- Rejeita números repetidos
    IF cnpj ~ '^(\d)\1{13}$' THEN
        RETURN FALSE;
    END IF;

    -- Primeiro dígito
    soma1 :=
        substring(cnpj,1,1)::INT * 5 +
        substring(cnpj,2,1)::INT * 4 +
        substring(cnpj,3,1)::INT * 3 +
        substring(cnpj,4,1)::INT * 2 +
        substring(cnpj,5,1)::INT * 9 +
        substring(cnpj,6,1)::INT * 8 +
        substring(cnpj,7,1)::INT * 7 +
        substring(cnpj,8,1)::INT * 6 +
        substring(cnpj,9,1)::INT * 5 +
        substring(cnpj,10,1)::INT * 4 +
        substring(cnpj,11,1)::INT * 3 +
        substring(cnpj,12,1)::INT * 2;

    dig1 := soma1 % 11;
    dig1 := CASE WHEN dig1 < 2 THEN 0 ELSE 11 - dig1 END;

    IF dig1 <> substring(cnpj,13,1)::INT THEN
        RETURN FALSE;
    END IF;

    -- Segundo dígito
    soma2 :=
        substring(cnpj,1,1)::INT * 6 +
        substring(cnpj,2,1)::INT * 5 +
        substring(cnpj,3,1)::INT * 4 +
        substring(cnpj,4,1)::INT * 3 +
        substring(cnpj,5,1)::INT * 2 +
        substring(cnpj,6,1)::INT * 9 +
        substring(cnpj,7,1)::INT * 8 +
        substring(cnpj,8,1)::INT * 7 +
        substring(cnpj,9,1)::INT * 6 +
        substring(cnpj,10,1)::INT * 5 +
        substring(cnpj,11,1)::INT * 4 +
        substring(cnpj,12,1)::INT * 3 +
        substring(cnpj,13,1)::INT * 2;

    dig2 := soma2 % 11;
    dig2 := CASE WHEN dig2 < 2 THEN 0 ELSE 11 - dig2 END;

    IF dig2 <> substring(cnpj,14,1)::INT THEN
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
    telephone := regexp_replace(telefone_input, '[^0-9]', '', 'g');

    IF length(telephone) NOT IN (10, 11) THEN
        RETURN FALSE;
    END IF;

    IF telefone ~ '^(\d)\1+$' THEN
        RETURN FALSE;
    END IF;

    IF telefone !~ '^(?:[1-9]{2})(?:9\d{8}|\d{8})$' THEN
        RETURN FALSE;
    END IF;

    RETURN TRUE;
    
 END;
$$ LANGUAGE plpgsql IMMUTABLE;

CREATE TYPE exercicio4.product_category_enum AS ENUM (
  'eletronico',
  'alimento',
  'vestuario',
  'outros'
);

CREATE TABLE IF NOT EXISTS exercicio4.clients(
  id INTEGER GENERATED ALWAYS AS IDENTITY,
  name VARCHAR(150) NOT NULL, 
  email VARCHAR(320) NOT NULL,
  birth_date DATE NOT NULL,
  cpf VARCHAR(11) NOT NULL,
  active BOOLEAN NOT NULL DEFAULT TRUE,
  password_hash VARCHAR(128) NOT NULL,

  --declaração de chaves primárias
  CONSTRAINT exercicio4_clients_pk PRIMARY KEY (id),

  --decalaração de chaves únicas
  CONSTRAINT exercicio4_clients_uq_email UNIQUE (email),
  CONSTRAINT exercicio4_clients_uq_cpf UNIQUE (cpf),

  --declaração de restrições check
  CONSTRAINT exercicio4_clients_ck_email
  CHECK (
    email ~ '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'
  ),
  CONSTRAINT exercicio4_clients_ck_birth_date
  CHECK (
    birth_date <= CURRENT_DATE
  ),
  CONSTRAINT exercicio4_clients_ck_cpf
  CHECK (
    validate_cpf(cpf)
  ),
  CONSTRAINT exercicio4_clients_ck_name
  CHECK (
    trim(name) <> ''
    AND char_length(name) BETWEEN 2 AND 150
    AND name ~ '^[A-Za-zÀ-ÿ]+( [A-Za-zÀ-ÿ]+)*$'
  )
);

CREATE TABLE IF NOT EXISTS exercicio4.products(
  id INTEGER GENERATED ALWAYS AS IDENTITY,
  name VARCHAR(150) NOT NULL, 
  price_cents  INTEGER NOT NULL,
  stock INTEGER NOT NULL,
  category  exercicio4.product_category_enum NOT NULL,
  
  --declaração de chaves primárias
  CONSTRAINT exercicio4_products_pk PRIMARY KEY (id),

  --declaração de restrições check
  CONSTRAINT exercicio4_products_ck_name
  CHECK (
    trim(name) <> ''
    AND char_length(name) BETWEEN 2 AND 150
  ),
  CONSTRAINT exercicio4_products_ck_price_cents
  CHECK (
    price_cents > 0
  ),
  CONSTRAINT exercicio4_products_ck_stock
  CHECK (
    stock >= 0
  )
);

CREATE TABLE IF NOT EXISTS exercicio4.sellers(
  id INTEGER GENERATED ALWAYS AS IDENTITY,
  name VARCHAR(150) NOT NULL,
  cnpj VARCHAR(14) NOT NULL,
  email VARCHAR(320) NOT NULL,
  telephone VARCHAR(11),
  status BOOLEAN NOT NULL DEFAULT TRUE,
  product_id INTEGER NOT NULL,
  
  --declaração de chaves primárias
  CONSTRAINT exercicio4_sellers_pk PRIMARY KEY (id),

  --declaração de chaves únicas
  CONSTRAINT exercicio4_sellers_uq_cnpj UNIQUE (cnpj),
  CONSTRAINT exercicio4_sellers_uq_email UNIQUE (email),

  --declaração de restrições check
  CONSTRAINT exercicio4_clients_ck_cnpj
  CHECK (
    validate_cnpj(cnpj)
  ),
  CONSTRAINT exercicio4_clients_ck_telephone
  CHECK (
    validate_telephone(telephone)
  ),

  --declaração de chaves estrangeiras
  CONSTRAINT exercicio4_products_fk
  FOREIGN KEY (product_id)
  REFERENCES exercicio4.products (id)

);

CREATE TABLE IF NOT EXISTS exercicio4.sales(
  id INTEGER GENERATED ALWAYS AS IDENTITY,
  quantities_sold INTEGER NOT NULL,
  sale_date TIMESTAMPTZ NOT NULL,
  discount_percent  NUMERIC(5,2),
  client_id INTEGER NOT NULL,
  product_id INTEGER NOT NULL,

  --declaração de chaves primárias 
  CONSTRAINT exercicio4_sales_pk PRIMARY KEY (id),

  --declaração de restrições check
  CONSTRAINT exercicio4_sales_ck_sale_date
  CHECK (
    sale_date <= CURRENT_DATE  
  ),

  CONSTRAINT exercicio4_sales_ck_discount_percent
  CHECK (
    discount_percent >= 0
    AND discount_percent <= 100
  ),

  CONSTRAINT exercicio4_sales_ck_quantities_sold
  CHECK (
    quantities_sold > 0
  ),

  --declaração de chaves estrangeiras
  CONSTRAINT exercicio4_clients_fk
  FOREIGN KEY (client_id)
  REFERENCES exercicio4.clients (id),

  CONSTRAINT exercicio4_products_fk
  FOREIGN KEY (product_id)
  REFERENCES exercicio4.products (id)
);

CREATE OR REPLACE FUNCTION exercicio4.fn_check_and_update_stock()
  RETURNS TRIGGER AS $$
  DECLARE
  v_stock INTEGER;
  BEGIN
  -- buscar estoque atual do produto
  SELECT stock
  INTO v_stock
  FROM exercicio4.products
  WHERE id = NEW.product_id
  FOR UPDATE;

  -- validar estoque
  IF NEW.quantities_sold > v_stock THEN
    RAISE EXCEPTION
      'Quantidade vendida (%) maior que o estoque disponível (%)',
      NEW.quantities_sold, v_stock;
  END IF;

  -- atualizar estoque
  UPDATE exercicio4.products
  SET stock = stock - NEW.quantities_sold
  WHERE id = NEW.product_id;

  RETURN NEW;
  END;
  $$ LANGUAGE plpgsql;

  CREATE TRIGGER exercicio4_sales_trg_check_stock
  BEFORE INSERT ON exercicio4.sales
  FOR EACH ROW
  EXECUTE FUNCTION exercicio4.fn_check_and_update_stock();