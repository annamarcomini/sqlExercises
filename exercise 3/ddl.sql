CREATE TABLE IF NOT EXISTS exercicio3.clients(
  id INTEGER GENERATED ALWAYS AS IDENTITY,
  name VARCHAR(150) NOT NULL, 
  email VARCHAR(320) NOT NULL,
  birth_date DATE NOT NULL,
  cpf CHAR(11) NOT NULL,
  active BOOLEAN NOT NULL DEFAULT true,
  password_hash VARCHAR(128) NOT NULL,

  --declaração de chaves primárias
  CONSTRAINT exercicio3_clients_pk PRIMARY KEY (id),

  --decalaração de chaves únicas
  CONSTRAINT exercicio3_clients_uq_email UNIQUE (email),
  CONSTRAINT exercicio3_clients_uq_cpf UNIQUE (cpf),

  --declaração de restrições check
  CONSTRAINT exercicio3_clients_ck_email
  CHECK (
  email ~ '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'
  ),
  CONSTRAINT exercicio3_clients_ck_birth_date
  CHECK (
  birth_date <= CURRENT_DATE
  ),
  CONSTRAINT exercicio3_clients_ck_cpf
  CHECK (
  cpf ~ '^[0-9]{11}$' 
  AND is_valid_cpf(cpf)
  ),
  CONSTRAINT exercicio3_clients_ck_name
  CHECK (
  trim(name) <> ''
  AND char_length(name) BETWEEN 2 AND 150
  AND name ~ '^[A-Za-zÀ-ÿ]+( [A-Za-zÀ-ÿ]+)*$'
  )
);

CREATE TABLE IF NOT EXISTS exercicio3.products(
  id INTEGER GENERATED ALWAYS AS IDENTITY,
  name VARCHAR(150) NOT NULL, 
  price_cents  INTEGER NOT NULL,
  stock INTEGER NOT NULL,
  category  VARCHAR(20) NOT NULL,
  
  --declaração de chaves primárias
  CONSTRAINT exercicio3_products_pk PRIMARY KEY (id),

  --declaração de restrições check
  CONSTRAINT exercicio3_products_ck_name
  CHECK (
  trim(name) <> ''
  AND char_length(name) BETWEEN 2 AND 150
  ),
  CONSTRAINT exercicio3_products_ck_price_cents
  CHECK (
  price_cents > 0
  ),
  CONSTRAINT exercicio3_products_ck_stock
  CHECK (
  stock >= 0
  ),
  CONSTRAINT exercicio3_products_ck_category
  CHECK (
  category IN ('eletronico', 'alimento', 'vestuario', 'outros')
  )
);

CREATE TABLE IF NOT EXISTS exercicio3.sales(
  id INTEGER GENERATED ALWAYS AS IDENTITY,
  quantities_sold INTEGER NOT NULL,
  sale_date DATE NOT NULL,
  discount_percent  NUMERIC(5,2),
  client_id INTEGER NOT NULL,
  product_id INTEGER NOT NULL,

  --declaração de chaves primárias 
  CONSTRAINT exercicio3_sales_pk PRIMARY KEY (id),

  --declaração de restrições check
  CONSTRAINT exercicio3_sales_ck_sale_date
  CHECK (
  sale_date <= CURRENT_DATE  
  ),

  CONSTRAINT exercicio3_sales_ck_discount_percent
  CHECK (
  discount_percent >= 0
  AND discount_percent <= 100
  ),

  CONSTRAINT exercicio3_sales_ck_quantities_sold
  CHECK (quantities_sold > 0)


  --declaração de chaves estrangeiras
  CONSTRAINT exercicio3_clients_fk
  FOREIGN KEY (client_id)
  REFERENCES exercicio3.clients (id),

  CONSTRAINT exercicio3_products_fk
  FOREIGN KEY (product_id)
  REFERENCES exercicio3.products (id)
);

CREATE OR REPLACE FUNCTION exercicio3.fn_check_and_update_stock()
  RETURNS TRIGGER AS $$
  DECLARE
  v_stock INTEGER;
  BEGIN
  -- buscar estoque atual do produto
  SELECT stock
  INTO v_stock
  FROM exercicio3.products
  WHERE id = NEW.product_id
  FOR UPDATE;

  -- validar estoque
  IF NEW.quantities_sold > v_stock THEN
    RAISE EXCEPTION
      'Quantidade vendida (%) maior que o estoque disponível (%)',
      NEW.quantities_sold, v_stock;
  END IF;

  -- atualizar estoque
  UPDATE exercicio3.products
  SET stock = stock - NEW.quantities_sold
  WHERE id = NEW.product_id;

  RETURN NEW;
  END;
  $$ LANGUAGE plpgsql;

  CREATE TRIGGER exercicio3_sales_trg_check_stock
  BEFORE INSERT ON exercicio3.sales
  FOR EACH ROW
  EXECUTE FUNCTION exercicio3.fn_check_and_update_stock();