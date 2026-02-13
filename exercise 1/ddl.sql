-- Cria a tabela se não existe
CREATE TABLE IF NOT EXISTS users.user(
name VARCHAR(40) NOT NULL, 
email VARCHAR(50) TEXT NOT NULL UNIQUE, 
password_hash VARCHAR(200) TEXT NOT NULL );

--Novos campos
ALTER TABLE users.user
ADD COLUMN id INTEGER GENERATED ALWAYS AS IDENTITY;

--Exemplo de alterando os tipos de campos
ALTER TABLE users.user
ALTER COLUMN name TYPE VARCHAR(40) NOT NULL;

-- Checks

ALTER TABLE users.user
ADD CONSTRAINT name
CHECK (
char_length(name) BETWEEN 10 AND 100
-- ~: operador regex, A-Za-z: letras latinas normais, À-ÿ: letras latinas ascentuadas, +: pelo menos um caractere, ^$ para permitir só aquilo no campo, o + exige pelo menos um cararctere e não aceita string vazia
AND name ~ '^[A-Za-zÀ-ÿ]+( [A-Za-zÀ-ÿ]+)*$'
);
ALTER TABLE users.user
ADD CONSTRAINT email
CHECK (
char_length(email) BETWEEN 10 AND 100
AND email ~ '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'
)