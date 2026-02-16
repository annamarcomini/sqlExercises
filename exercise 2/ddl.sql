CREATE TABLE IF NOT EXISTS exercicio2.product(
  id INTEGER GENERATED ALWAYS AS IDENTITY;
  barcode VARCHAR(200) NOT NULL, 
  name VARCHAR(50) NOT NULL, 
  description VARCHAR(10000) NOT NULL,
  quantity INTEGER NOT NULL,
  price NUMERIC(10,2) NOT NULL

  --declaração de chaves únicas
  CONSTRAINT exercicio2_product_uq_barcode (barcode)
);

CREATE TABLE IF NOT EXISTS exercicio2.user(
  name VARCHAR(40) NOT NULL, 
  email VARCHAR(50) NOT NULL, 
  password_hash VARCHAR(200) NOT NULL 
  
  --declaração de chaves únicas
  CONSTRAINT exercicio2_user_email_uq UNIQUE (email)
);