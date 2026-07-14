-- =========================================
--owners role and permissions
-- =========================================
CREATE ROLE owners;
GRANT USAGE ON SCHEMA exercicio8 TO owners;
------ owners table
GRANT INSERT (name, email, telephone, password_hash)
ON exercicio8.owners
TO owners;
GRANT SELECT (id, email, telephone)
ON exercicio8.owners
TO owners;
GRANT UPDATE (name, email, telephone, password_hash)
ON exercicio8.owners
TO owners;

------ houses table
GRANT SELECT (id,name, address, start_day_purchase, end_day_purchase, start_time_purchase, end_time_purchase)
ON exercicio8.houses
TO owners;
GRANT INSERT (name, address, start_day_purchase, end_day_purchase, start_time_purchase, end_time_purchase)
ON exercicio8.houses
TO owners;
GRANT UPDATE (name, address, start_day_purchase, end_day_purchase, start_time_purchase, end_time_purchase, deleted_at)
ON exercicio8.houses
TO owners;

------ furniture table
GRANT SELECT (id, name, house_id, room_id, description)
ON exercicio8.furniture
TO owners;

------ rooms table
GRANT SELECT (id, house_id, name)
ON exercicio8.rooms
TO owners;


-- =========================================
--sellers role and permissions
-- =========================================
CREATE ROLE sellers;
GRANT USAGE ON SCHEMA exercicio8 TO sellers;

------ sellers table
GRANT INSERT (name, email, telephone, password_hash)
ON exercicio8.sellers
TO sellers;
GRANT SELECT (id, email, telephone)
ON exercicio8.sellers
TO sellers;
GRANT UPDATE (name, email, telephone, password_hash)
ON exercicio8.sellers
TO sellers;

------ houses table
GRANT SELECT (id,name, address, start_day_purchase, end_day_purchase, start_time_purchase, end_time_purchase, deleted_at)
ON exercicio8.houses
TO sellers;
GRANT INSERT (name, address, start_day_purchase, end_day_purchase, start_time_purchase, end_time_purchase)
ON exercicio8.houses
TO sellers;
GRANT UPDATE (name, address, start_day_purchase, end_day_purchase, start_time_purchase, end_time_purchase, deleted_at)
ON exercicio8.houses
TO sellers;

------ furniture table
GRANT SELECT (id, name, house_id, room_id, description, deleted_at)
ON exercicio8.furniture
TO sellers;
GRANT INSERT (name, house_id, room_id, description)
ON exercicio8.furniture
TO sellers;
GRANT UPDATE (name, house_id, room_id, description, deleted_at)
ON exercicio8.furniture
TO sellers;

------ rooms table
GRANT SELECT (id, house_id, name)
ON exercicio8.rooms
TO sellers;
GRANT INSERT (name, house_id)
ON exercicio8.rooms
TO sellers;
GRANT UPDATE (house_id, name, deleted_at)
ON exercicio8.rooms
TO sellers;

------ sales table
GRANT SELECT (id, seller_id, owner_id, house_id, furniture_id, value, sale_date)
ON exercicio8.sales
TO sellers;
GRANT INSERT (seller_id, owner_id, house_id, furniture_id, value, sale_date)
ON exercicio8.sales
TO sellers;

----- house_owner associative table
GRANT SELECT
ON exercicio8.house_owner
TO sellers;
GRANT INSERT (owner_id, house_id)
ON exercicio8.house_owner
TO sellers;
GRANT UPDATE (deleted_at)
ON exercicio8.house_owner
TO sellers;