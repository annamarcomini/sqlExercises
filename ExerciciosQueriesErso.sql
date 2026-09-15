DROP TABLE IF EXISTS itempedido CASCADE;
DROP TABLE IF EXISTS pedido CASCADE;
DROP TABLE IF EXISTS cardapio CASCADE;
DROP TABLE IF EXISTS categoria CASCADE;
DROP TABLE IF EXISTS cliente CASCADE;
DROP TABLE IF EXISTS formapagamento CASCADE;
DROP TABLE IF EXISTS garcom CASCADE;

CREATE TABLE categoria (
  cat_codigo INTEGER NOT NULL,
  cat_nome VARCHAR(50) DEFAULT NULL,
  CONSTRAINT pk_categoria PRIMARY KEY (cat_codigo),
  CONSTRAINT unq_cat_nome UNIQUE (cat_nome)
);

CREATE TABLE cardapio (
  car_codigo INTEGER NOT NULL,
  car_nome VARCHAR(50) DEFAULT NULL,
  car_preco NUMERIC(8,2) DEFAULT NULL,
  car_unidade INTEGER DEFAULT NULL,
  car_pesolitro INTEGER DEFAULT NULL,
  cat_codigo INTEGER DEFAULT NULL,
  CONSTRAINT pk_cardapio PRIMARY KEY (car_codigo),
  CONSTRAINT fk_cardapio_categoria FOREIGN KEY (cat_codigo) REFERENCES categoria(cat_codigo)
);

CREATE TABLE cliente (
  cli_codigo INTEGER NOT NULL,
  cli_cpf VARCHAR(14) DEFAULT NULL,
  cli_nome VARCHAR(60) DEFAULT NULL,
  cli_datanascimento DATE DEFAULT NULL,
  cli_email VARCHAR(60) DEFAULT NULL,
  cli_telefone VARCHAR(15) DEFAULT NULL,
  CONSTRAINT pk_cliente PRIMARY KEY (cli_codigo),
  CONSTRAINT unq_cliente_dados UNIQUE (cli_cpf, cli_email, cli_telefone)
);

CREATE TABLE formapagamento (
  fpg_codigo INTEGER NOT NULL,
  fpg_nome VARCHAR(50) DEFAULT NULL,
  CONSTRAINT pk_formapagamento PRIMARY KEY (fpg_codigo),
  CONSTRAINT unq_fpg_nome UNIQUE (fpg_nome)
);

CREATE TABLE garcom (
  gar_codigo INTEGER NOT NULL,
  gar_nome VARCHAR(60) DEFAULT NULL,
  gar_datanascimento DATE DEFAULT NULL,
  gar_horatrabalho VARCHAR(15) DEFAULT NULL,
  CONSTRAINT pk_garcom PRIMARY KEY (gar_codigo)
);

CREATE TABLE pedido (
  ped_numero INTEGER NOT NULL,
  ped_data DATE DEFAULT NULL,
  ped_valortotal NUMERIC(8,2) DEFAULT NULL,
  ped_numeropessoas INTEGER DEFAULT NULL,
  cli_codigo INTEGER DEFAULT NULL,
  fpg_codigo INTEGER DEFAULT NULL,
  CONSTRAINT pk_pedido PRIMARY KEY (ped_numero),
  CONSTRAINT fk_pedido_cliente FOREIGN KEY (cli_codigo) REFERENCES cliente(cli_codigo),
  CONSTRAINT fk_pedido_formapagamento FOREIGN KEY (fpg_codigo) REFERENCES formapagamento(fpg_codigo)
);

CREATE TABLE itempedido (
  itm_numero INTEGER NOT NULL,
  car_codigo INTEGER DEFAULT NULL,
  itm_quantidade INTEGER DEFAULT NULL,
  itm_valorunitario NUMERIC(8,2) DEFAULT NULL,
  itm_valortotal NUMERIC(8,2) DEFAULT NULL,
  ped_numero INTEGER DEFAULT NULL,
  gar_codigo INTEGER DEFAULT NULL,
  CONSTRAINT pk_itempedido PRIMARY KEY (itm_numero),
  CONSTRAINT fk_itempedido_cardapio FOREIGN KEY (car_codigo) REFERENCES cardapio(car_codigo),
  CONSTRAINT fk_itempedido_pedido FOREIGN KEY (ped_numero) REFERENCES pedido(ped_numero),
  CONSTRAINT fk_itempedido_garcom FOREIGN KEY (gar_codigo) REFERENCES garcom(gar_codigo)
);

-- ==========================================
-- INSERÇÃO DE DADOS COM DATAS NORMALIZADAS
-- ==========================================

INSERT INTO categoria (cat_codigo, cat_nome) VALUES
(10, 'Acompanhamento'), (3, 'Bebida'), (8, 'Entrada'), (11, 'Guloseima'),
(5, 'Guloseimas'), (9, 'Lanche'), (22, 'Massa'), (20, 'Massaaas'),
(16, 'Massassas'), (2, 'Prato Feito'), (1, 'Salgados'), (6, 'Sobremesa'),
(7, 'Sopa'), (4, 'Sorvetes');

INSERT INTO cardapio (car_codigo, car_nome, car_preco, car_unidade, car_pesolitro, cat_codigo) VALUES
(101, 'Coxinha', 3.50, 1, 200, 1), (102, 'Kibe', 3.50, 1, 200, 1), (103, 'Pastel', 10.00, 1, 200, 1),
(104, 'Hamburguer', 14.50, 1, 200, 9), (105, 'Bife acebolado', 21.99, 1, 200, 2), (106, 'Strogonoff de Frango', 20.99, 1, 200, 2),
(107, 'Strogonoff de Carne', 20.99, 1, 200, 10), (108, 'Batata Frita', 15.99, 1, 200, 10), (109, 'Batata Frita com cheddar e bacon', 17.99, 1, 200, 1),
(110, 'Empada', 3.50, 2, 200, 2), (111, 'Frango Frito', 42.99, 1, 2000, 10), (112, 'Arroz', 5.00, 1, 200, 10),
(113, 'Feijão', 5.00, 1, 200, 10), (114, 'Macarrão a bolonhesa', 17.99, 1, 200, 2), (115, 'Lasanha', 30.99, 1, 200, 2),
(116, 'Coca-Cola', 10.99, 1, 200, 3), (117, 'Coca-Cola', 15.99, 1, 200, 3), (118, 'Coca-Cola lata', 8.99, 1, 200, 3),
(119, 'Guarana', 14.99, 1, 200, 3), (120, 'Guarana lata', 7.99, 1, 200, 4), (121, 'Sorvete de Maracuja', 5.00, 1, 200, 4),
(122, 'Sorvete de Limão', 5.00, 1, 200, 4), (123, 'Sorvete de Baunilha', 5.00, 1, 200, 4), (124, 'Picole Magnum', 7.00, 1, 200, 4),
(125, 'Picole de Limão', 5.00, 1, 200, 5), (126, 'Dadinho', 0.25, 1, 200, 5), (127, 'Bala fine dentadura', 2.00, 1, 200, 5),
(128, 'Chiclete Babalu', 0.50, 1, 200, 5), (129, 'Chiclete Big-Big', 0.25, 1, 200, 5), (130, 'Bala 7 belo', 0.15, 1, 200, 5),
(131, 'Bala azedinho', 0.15, 1, 200, 5), (132, 'Suco de Maracuja', 12.99, 1, 200, 3), (133, 'Suco de Limão', 12.99, 1, 200, 3),
(134, 'Suco de Laranja', 12.99, 1, 200, 3), (135, 'Pepsi', 14.99, 1, 200, 3), (136, 'Pepsi Lata', 7.99, 1, 200, 3),
(137, 'Tubaina', 14.99, 1, 200, 3), (138, 'Água Mineral', 2.00, 1, 200, 3), (139, 'Água Mineral', 5.00, 1, 200, 3),
(140, 'Água com Gás', 2.70, 1, 200, 3), (141, 'Sopa de Cebola', 14.99, 1, 200, 7), (142, 'Cozido de Carne com Batata e Mandioca', 16.99, 1, 200, 7),
(143, 'Mandioca Frita', 15.99, 1, 200, 10), (144, 'Caudo de Cebolinha', 12.99, 1, 200, 7), (145, 'Batata Rustica', 16.99, 1, 200, 6),
(146, 'Bolo de Chocolate (Fatia)', 8.99, 1, 200, 6), (147, 'Pudim(Fatia)', 8.99, 1, 200, 6), (148, 'Bolo de Cenoura com Cobertura de Chocolate(Fatia)', 8.99, 1, 200, 6),
(149, 'Brownie(Fatia)', 8.99, 1, 200, 6), (150, 'Brownie com Sorvete(Fatia e bola)', 13.50, 1, 200, 6);

INSERT INTO cliente (cli_codigo, cli_cpf, cli_nome, cli_datanascimento, cli_email, cli_telefone) VALUES
(1, '11111111111111', 'Wingslonpson Silva', '0001-12-25', 'wing¬slompson@fmail.¢om', '11930412904'),
(12, '92584635478', 'Sandy', '2006-02-28', 'sannnndy@outlook.com', '(21)95832-2791'),
(24, '09876543211', 'Astolfo', '2006-06-06', 'astolfo@gmail.com', '11 40028922'),
(99, '39470605803', 'Beatriz Miranda', '2002-08-07', 'beatriz@gmail.com', '11982084823'),
(124, '47240374284', 'Cebolinha', '1840-10-11', 'cebolinha.cbf@yahoo.com', '11-9153-7723'),
(777, '47103774488', 'Yamal Barcelona', '1946-10-11', 'yamal.barcelona@yahoo.com', '11-9153-7723'),
(888, '423.907.987-23', 'Aurora Montenegro', '2006-09-23', 'auroramonte@gmail.com.br', '(22)981423-8569'),
(897, '908.123.745-98', 'Marina', '1990-09-07', 'marina@gmail.com', '(11)96782-9087'),
(1119, '123.456.789-10', 'Rafael', '1998-02-20', 'rafael@gmail.com', '(11) 95555-7777'),
(1234, '445.087.012-18', 'Kanye West', '1977-06-08', 'kanye.west@gmail.com', '(11)94785-7845'),
(1910, '12312312312', 'Memphis', '1994-02-13', 'memphispaidopalmeiras@bimundial.com', '11919101910'),
(1920, '12312312323', 'Memphis', '1994-02-13', 'memphispaidopalmeiras@bimundial.com', '11919101910'),
(2105, '654.654.645-05', 'Victor P', '2003-05-21', 'victor@gmail.com', '(11)95052-5848'),
(2142, '482.391.822-16', 'Raphael Fillipi', '2006-06-26', 'raphael214@gmail.com', '(11) 97253-6771'),
(3425, '520.996.738-98', 'João Pedro', '2005-04-26', 'joao.damasceno3@fatec.sp.gov.br', '(11) 94702-9978'),
(4545, '55552577630', 'Felipe Gabriel', '2001-09-11', 'felipegabriel@gmail.com', '11993537067'),
(6327, '589.458.963-80', 'Júlio', '2006-12-13', 'julio@gmail.com', '(11) 98596-8574'),
(6328, '654.236.786-20', 'Veronice', '1985-12-02', 'veronice@gmail.com', '(11) 96547-8963'),
(6329, '741.025.896-90', 'Rafaella', '2017-04-03', 'rafaella@gmail.com', '(11) 98855-7221'),
(6330, '458.963.210-70', 'Maria', '1959-02-26', 'maria@gmail.com', '(11) 97412-2154'),
(6332, '485.369.578-12', 'Lívia', '2004-05-31', 'livia@gmail.com', '(11)953348711'),
(6565, '515.959.868-77', 'Moisés Siqueira', '2001-02-05', 'moises@gmail.com', '(11) 98877-6655'),
(6666, '171.666.999-24', 'P. Diddy', '1969-11-04', 'diddy.man@gmail.com', '(11) 96868-6969'),
(6969, '475.598.345-34', 'Henry Calheiros', '2006-01-20', 'henry.farias@fatec.sp.gov.br', '(11)991486737'),
(7777, '478.042.088-13', 'Erick Willyan', '2006-05-21', 'erick.cruz2@fatec.sp.gov.br', '(11)93930-6886'),
(9128, '452.932.123-02', 'Labubu', '2002-08-30', 'labubu@gmail.com', '1140028922'),
(9999, '432.243.432-34', 'Matheus Ferreira', '2004-09-20', 'matheusferreira@gmail.com', '(21) 93422-1943'),
(10000, '88129452', 'Cássio Frangueiro', '1984-10-11', 'cassio.curintia@hotmart.com', '11-9153-7723');

INSERT INTO formapagamento (fpg_codigo, fpg_nome) VALUES
(6, 'Cheque'), (2, 'Crédito'), (1, 'Débito'), (3, 'Dinheiro'), (4, 'Pix'), (5, 'Vale Refeição');

INSERT INTO garcom (gar_codigo, gar_nome, gar_datanascimento, gar_horatrabalho) VALUES
(1, 'Claudio', '2006-12-13', '13:00 às 18:00'),
(2, 'Roberto', '1990-07-16', '07:00 às 12:00'),
(3, 'Jubisclay', '2000-06-20', '06:00 às 18:00'),
(4, 'Paulo Emílio dos Santos Rocha', '2006-04-17', '02:00 às 00:00'),
(5, 'Tommy Lepaul', '1967-01-01', '06:00 às 18:00'),
(6, 'cleiton rasta', '1980-12-27', '06:00 ás 06:01'),
(7, 'Mario', '2001-09-11', '18:00 às 06:00'),
(8, 'Mario', '2000-02-12', '13:00 às 12:00'),
(9, 'Zé Mario', '2020-05-20', '21:30-04-25'),
(10, 'Mario', '2001-09-11', '01:00 às 23:00'),
(11, 'Maria Mario', '2012-12-12', '12:00 às 00:00'),
(12, 'Mário Bros', '1999-04-20', '13:00 às 18:00'),
(13, 'Mário', '2025-08-15', '9:00 às 17:00'),
(14, 'Mario Rocha', '2000-06-09', '13:40 ás 22:00');

INSERT INTO pedido (ped_numero, ped_data, ped_valortotal, ped_numeropessoas, cli_codigo, fpg_codigo) VALUES
(6352, '2024-09-19', 81.97, 2, 6327, 1),
(6353, '2024-09-20', 59.49, 2, 6328, 4),
(6354, '2024-09-21', 528.26, 10, 6328, 4),
(6355, '2024-09-22', 58.97, 1, 6327, 3),
(6356, '2024-09-22', 12.00, 2, 6329, 5),
(6357, '2024-09-24', 12.00, 1, 6330, 3);

INSERT INTO itempedido (itm_numero, car_codigo, itm_quantidade, itm_valorunitario, itm_valortotal, ped_numero, gar_codigo) VALUES
(154174, 106, 2, 20.99, 41.98, 6352, 1),
(154175, 150, 2, 13.50, 27.00, 6352, 1),
(154176, 132, 1, 12.99, 12.99, 6352, 1),
(154177, 104, 3, 14.50, 43.50, 6353, 2),
(154178, 108, 1, 15.99, 15.99, 6353, 2),
(154179, 105, 2, 21.99, 43.98, 6354, 3),
(154180, 106, 3, 20.99, 62.97, 6354, 3),
(154181, 114, 3, 17.99, 53.97, 6354, 3),
(154182, 115, 1, 30.99, 30.99, 6354, 3),
(154183, 142, 1, 16.99, 16.99, 6354, 3),
(154184, 109, 5, 17.99, 89.95, 6354, 3),
(154185, 143, 3, 15.99, 47.97, 6354, 3),
(154186, 150, 7, 13.50, 94.50, 6354, 3),
(154187, 133, 3, 12.99, 38.97, 6354, 3),
(154188, 117, 3, 15.99, 47.97, 6354, 3),
(154189, 111, 1, 42.99, 42.99, 6355, 1),
(154190, 120, 2, 7.99, 15.98, 6355, 1),
(154191, 124, 1, 7.00, 7.00, 6356, 2),
(154192, 125, 1, 5.00, 5.00, 6356, 2),
(154193, 101, 2, 3.50, 7.00, 6357, 3);


-- ==========================================
-- LISTA DE EXERCÍCIOS DE SQL - BANCO RESTAURANTE
-- ==========================================

-- 1. Exibir todos os dados de todos os garçons registrados na base de dados.
-- 2. Exibir o nome e o preço de todos os itens do cardápio ordenados do mais barato para o mais caro.
-- 3. Listar todos os clientes que possuem e-mail com domínio '@gmail.com'.
-- 4. Exibir os itens do cardápio que custam mais de R$ 20,00.
-- 5. Listar as formas de pagamento cadastradas em ordem alfabética.
-- 6. Exibir todos os pedidos realizados entre as datas '2024-09-20' e '2024-09-23'.
-- 7. Listar os garçons cujo nome começa com a letra 'M'.
-- 8. Exibir os itens do cardápio que possuem a palavra "Batata" ou "Bolo" no nome.
-- 9. Exibir o número do pedido, a quantidade de pessoas na mesa, o valor total e o valor dividido por pessoa para todos os pedidos com mais de 2 pessoas.
-- 10. Exibir as categorias cujo código seja menor que 10 ou maior que 20.
-- 11. Exibir a quantidade total de clientes cadastrados no banco de dados.
-- 12. Calcular a média de preço dos itens registrados no cardápio.
-- 13. Exibir o código do pedido e a quantidade total de itens em cada um deles.
-- 14. Exibir o nome do item do cardápio e o nome de sua respectiva categoria (utilizando INNER JOIN).
-- 15. Contar quantos itens do cardápio existem em cada categoria, exibindo o nome da categoria.
-- 16. Exibir o número do pedido, a data do pedido e o nome do cliente que fez o pedido.
-- 17. Exibir o valor total gasto por cliente, trazendo o nome do cliente e o total acumulado de todos os seus pedidos.
-- 18. Exibir o número do pedido e a forma de pagamento descrita por extenso (ex: Pix, Crédito).
-- 19. Listar os pedidos e a quantidade de pessoas na mesa, apenas para pedidos em que o valor total ultrapassou R$ 50,00.
-- 20. Exibir a média de preço dos itens por categoria, apenas para categorias que possuem média de preço superior a R$ 10,00 (utilizando HAVING).
-- 21. Listar todas as categorias e seus itens do cardápio, garantindo que categorias sem nenhum item cadastrado também apareçam na consulta (LEFT JOIN).
-- 22. Exibir todas as formas de pagamento e a quantidade de pedidos associados a cada uma, incluindo formas de pagamento nunca utilizadas (LEFT JOIN).
-- 23. Listar o número do pedido, o nome do cliente, o nome do item do cardápio e o nome do garçom que atendeu aquele item.
-- 24. Exibir o nome de cada garçom e o valor total em vendas que ele realizou em itens de pedido.
-- 25. Exibir os pedidos realizados em um dia da semana específico (ex: aos sábados ou domingos), trazendo a data e o valor.
-- 26. Exibir os nomes dos clientes e o ano de nascimento de cada um, extraindo o ano da coluna de data de nascimento.
-- 27. Exibir todos os garçons registrados e os pedidos que eles atenderam, mostrando inclusive garçons que ainda não atenderam pedido algum (LEFT JOIN / RIGHT JOIN).
-- 28. Exibir quais clientes fizeram pedidos no mês de Setembro de 2024, mostrando nome do cliente, número do pedido e data.
-- 29. Listar todos os itens consumidos pela cliente "Veronice", exibindo o número do pedido, o nome do produto e a quantidade.
-- 30. Exibir o faturamento total acumulado do restaurante no mês de setembro de 2024.
-- 31. Exibir as categorias dos itens do cardápio que nunca foram vendidos (utilizando NOT IN ou NOT EXISTS).
-- 32. Exibir o nome dos clientes que nunca pediram produtos da categoria "Guloseimas".
-- 33. Listar os garçons que nunca atenderam pedidos de itens da categoria "Guloseimas".
-- 34. Exibir os itens do cardápio que possuem preço acima da média de todos os itens do cardápio.
-- 35. Exibir o cliente que fez o pedido de maior valor registrado no restaurante.
-- 36. Exibir os clientes que possuem data de aniversário no mesmo mês que o garçom "Cláudio".
-- 37. Exibir o nome dos clientes cujo valor total do pedido foi superior à média dos pedidos da cliente "Veronice".
-- 38. Listar os itens do cardápio que nunca foram incluídos em nenhum pedido.
-- 39. Exibir o nome do garçom e quantas mesas/pedidos diferentes ele atendeu, ordenando do garçom mais ativo para o menos ativo.
-- 40. Exibir o faturamento total de setembro/2024 detalhado por Forma de Pagamento (mostrar nome da forma e total faturado).
-- 41. Exibir o faturamento total do mês de setembro/2024 agrupado por categoria de item.
-- 42. Exibir os itens de pedidos dos clientes que comemoram aniversário exatamente no mesmo dia e mês em que o pedido foi realizado.
-- 43. Exibir o(s) nome(s) dos garçons que já atenderam a cliente "Veronice".
-- 44. Descobrir qual é o prato/item mais vendido (em quantidade total acumulada) nas quartas-feiras.
-- 45. Exibir o valor do maior pedido já realizado, trazendo também os detalhes completos: nome do cliente, número do pedido, data, itens pedidos, quantidade e garçom que atendeu cada item.
-- 46. Identificar se existem clientes duplicados com o mesmo CPF ou mesmo telefone, exibindo quais são e quantas vezes se repetem.
-- 47. Para cada cliente que realizou pedidos, exibir o nome do cliente, a quantidade de pedidos feitos, o total gasto e a média por pedido.
-- 48. Exibir a categoria que mais gerou receita (faturamento em R$) para o restaurante.
-- 49. Listar os garçons que atenderam pelo menos 2 clientes diferentes no mesmo dia.
-- 50. Exibir um relatório detalhado contendo: Nome do Cliente, Número do Pedido, Data do Pedido, Nome do Item do Cardápio, Nome da Categoria, Quantidade Pedida, Valor Unitário, Valor Total do Item, Nome do Garçom e Descrição da Forma de Pagamento, filtrando apenas para os pedidos feitos por clientes que nasceram após o ano de 2000.
