CREATE ROLE dba NOLOGIN;

------ Dando privilégios totais para a role dba -----
GRANT ALL PRIVILEGES
ON SCHEMA exercicio8
TO dba;

GRANT ALL PRIVILEGES
ON ALL TABLES IN SCHEMA exercicio8
TO dba;

GRANT ALL PRIVILEGES
ON ALL FUNCTIONS IN SCHEMA exercicio8
TO dba;

----- Atribuindo a role dba aos usuários que podem alterar o banco  -----
GRANT dba TO anna;
GRANT dba TO gustavo;