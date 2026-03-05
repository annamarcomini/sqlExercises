CREATE SCHEMA IF NOT EXISTS exercicio5;

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
    exercicio5.validate_cpf(cpf)
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
  code VARCHAR(8) NOT NULL DEFAULT exercicio5.generate_product_code(),
  
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
    exercicio5.validate_cnpj(cnpj)
  ),
  CONSTRAINT exercicio5_clients_ck_telephone
  CHECK (
    exercicio5.validate_telephone(telephone)
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