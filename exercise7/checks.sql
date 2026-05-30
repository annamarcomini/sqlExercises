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
    exercicio7.fn_validate_strings(
      name,
      p_has_letters := TRUE,
      p_has_uppercase := TRUE,
      p_has_lowercase := TRUE,
      p_min_length := 3
    )
);

--cks menus table
ALTER TABLE exercicio7.menus
ADD CONSTRAINT exercicio7_menus_ck_name
CHECK (
    exercicio7.fn_validate_strings(
      name,
      p_has_letters := TRUE,
      p_has_uppercase := TRUE,
      p_has_lowercase := TRUE,
      p_min_length := 3
    )
);

--cks kitchens table
ALTER TABLE exercicio7.kitchens
ADD CONSTRAINT exercicio7_kitchens_ck_max_stations_number
CHECK (max_stations_number > 0);

ALTER TABLE exercicio7.kitchens
ADD CONSTRAINT exercicio7_kitchens_ck_name
CHECK (
    exercicio7.fn_validate_strings(
      name,
      p_has_letters := TRUE,
      p_has_uppercase := TRUE,
      p_has_lowercase := TRUE,
      p_min_length := 3  
    )
);

ALTER TABLE exercicio7.kitchens
ADD CONSTRAINT exercicio7_kitchens_ck_city
CHECK (
    exercicio7.fn_validate_strings(
      city,
      p_has_letters := TRUE,
      p_has_uppercase := TRUE,
      p_has_lowercase := TRUE,
      p_min_length := 3
    )
);

--cks orders table
ALTER TABLE exercicio7.orders
ADD CONSTRAINT exercicio7_orders_ck_total_value_cents
CHECK (total_value_cents > 0);
