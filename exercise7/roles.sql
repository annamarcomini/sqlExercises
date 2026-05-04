------ admin role -------
CREATE ROLE admin;
GRANT USAGE ON SCHEMA exercicio7 TO admin;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA exercicio7 TO admin;

------ chef role -------
CREATE ROLE chef;
GRANT USAGE ON SCHEMA exercicio7 TO chef;

-- chefs table
GRANT SELECT, UPDATE ON exercicio7.chefs TO chef;

-- menus table
GRANT SELECT, INSERT, UPDATE ON exercicio7.menus TO chef;

-- reservations table
GRANT SELECT, INSERT ON exercicio7.reservations TO chef;

-- stations table
GRANT SELECT ON exercicio7.stations TO chef;

-- kitchens table
GRANT SELECT ON exercicio7.kitchens TO chef;

-- orders table
GRANT SELECT ON exercicio7.orders TO chef;

------- client role -------
CREATE ROLE client;
GRANT USAGE ON SCHEMA exercicio7 TO client;

-- menus table
GRANT SELECT ON exercicio7.menus TO client;

-- orders table
GRANT SELECT, INSERT ON exercicio7.orders TO client;

------ anonym role ------
CREATE ROLE anonym;
GRANT USAGE ON SCHEMA exercicio7 TO anonym;
