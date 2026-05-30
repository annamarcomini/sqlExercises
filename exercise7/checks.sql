--cks chefs table
ALTER TABLE exercicio7.chefs
ADD CONSTRAINT exercicio7_chefs_ck_cpf
CHECK (
    exercicio7.fn_validate_cpf(cpf)
);

ALTER TABLE exercicio7.chefs
ADD CONSTRAINT exercicio7_chefs_ck_email
CHECK (
    exercicio7.fn_validate_email(email)
);

ALTER TABLE exercicio7.chefs
ADD CONSTRAINT exercicio7_chefs_ck_name
CHECK (
    exercicio7.fn_validate_strings(name)
);

--cks menus table
ALTER TABLE exercicio7.menus
ADD CONSTRAINT exercicio7_menus_ck_name
CHECK (
    exercicio7.fn_validate_strings(name)
);

--cks kitchens table
ALTER TABLE exercicio7.kitchens
ADD CONSTRAINT exercicio7_kitchens_ck_max_stations_number
CHECK (max_stations_number > 0);

ALTER TABLE exercicio7.kitchens
ADD CONSTRAINT exercicio7_kitchens_ck_name
CHECK (
    exercicio7.fn_validate_strings(name)
);

ALTER TABLE exercicio7.kitchens
ADD CONSTRAINT exercicio7_kitchens_ck_city
CHECK (
    exercicio7.fn_validate_strings(city)
);

--cks orders table
ALTER TABLE exercicio7.orders
ADD CONSTRAINT exercicio7_orders_ck_total_value_cents
CHECK (total_value_cents > 0);
