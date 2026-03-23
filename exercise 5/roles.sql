-- =========================================
--app_anonymous role and permissions
-- =========================================
CREATE ROLE app_anonymous;
--clients table
GRANT INSERT (name, email, birth_date, cpf, password_hash)
ON exercicio5.clients
TO app_anonymous;
GRANT SELECT (id, email, password_hash)
ON exercicio5.clients
TO app_anonymous;

-- =========================================
--app_customer role and permissions
-- =========================================
CREATE ROLE app_customer;
--clients table
GRANT SELECT (id, name, email, birth_date, cpf, active)
ON exercicio5.clients
TO app_customer;
GRANT UPDATE (name, email, password_hash)
ON exercicio5.clients
TO app_customer;

--products table
GRANT SELECT (id, name, price_cents, stock, category, code)
ON exercicio5.products
TO app_customer;

--sales table
GRANT INSERT (quantities_sold, sale_date, discount_percent, product_id)
ON exercicio5.sales
TO app_customer;
GRANT SELECT (id, quantities_sold, sale_date, discount_percent, product_id)
ON exercicio5.sales
TO app_customer;

-- =========================================
--app_admin role and permissions
-- =========================================
CREATE ROLE app_admin;
--clients table
GRANT SELECT (id, name, email, birth_date, cpf, active, password_hash)
ON exercicio5.clients
TO app_admin;
GRANT UPDATE (active)
ON exercicio5.clients
TO app_admin;

--products table
GRANT SELECT (id, quantities_sold, sale_date, discount_percent, product_id, code)
ON exercicio5.products
TO app_admin;
GRANT INSERT (name, price_cents, stock, category)
ON exercicio5.products
TO app_admin;
GRANT UPDATE (name, price_cents, stock, category)
ON exercicio5.products
TO app_admin;

--sellers table
GRANT SELECT (id,name, cnpj, email, telephone, status, product_id)
ON exercicio5.sellers
TO app_admin; 
GRANT INSERT (name, cnpj, email, telephone, product_id)
ON exercicio5.sellers
TO app_admin;
GRANT UPDATE (name, cnpj, email, telephone, product_id)
ON exercicio5.sellers
TO app_admin;

--sales table
GRANT SELECT (id, quantities_sold, sale_date, discount_percent, client_id, product_id)
ON exercicio5.sales
TO app_admin;