-- 1º PROCEDIMENTO

create database Loja

CREATE TABLE produtos (
  idProduto INTEGER   NOT NULL ,
  nome VARCHAR(255)   NOT NULL ,
  quantidade INT   NOT NULL ,
  precoVenda FLOAT   NOT NULL   ,
PRIMARY KEY(idProduto));




CREATE TABLE pessoa (
  idPessoa INTEGER   NOT NULL ,
  nome VARCHAR(255)    ,
  logradouro VARCHAR(255)    ,
  cidade VARCHAR(255)    ,
  estado CHAR(2)    ,
  telefone VARCHAR(20)    ,
  email VARCHAR(255)      ,
PRIMARY KEY(idPessoa));




CREATE TABLE usuario (
  idUsuario INTEGER   NOT NULL ,
  login VARCHAR(255)    ,
  senha VARCHAR(255)      ,
PRIMARY KEY(idUsuario));




CREATE TABLE pessoa_juridica (
  idPessoa_juridica INT   NOT NULL ,
  pessoa_idPessoa INTEGER   NOT NULL ,
  cnpj VARCHAR(18)      ,
PRIMARY KEY(idPessoa_juridica)  ,
  FOREIGN KEY(pessoa_idPessoa)
    REFERENCES pessoa(idPessoa));


CREATE INDEX pessoa_juridica_FKIndex1 ON pessoa_juridica (pessoa_idPessoa);


CREATE INDEX IFK_Pode_ser ON pessoa_juridica (pessoa_idPessoa);


CREATE TABLE pessoa_fisica (
  idPessoa_fisica INT   NOT NULL ,
  pessoa_idPessoa INTEGER   NOT NULL ,
  cpf VARCHAR(11)   NOT NULL   ,
PRIMARY KEY(idPessoa_fisica)  ,
  FOREIGN KEY(pessoa_idPessoa)
    REFERENCES pessoa(idPessoa));


CREATE INDEX pessoa_fisica_FKIndex1 ON pessoa_fisica (pessoa_idPessoa);


CREATE INDEX IFK_Pode_ser ON pessoa_fisica (pessoa_idPessoa);


CREATE TABLE movimentos (
  idMovimento INTEGER   NOT NULL ,
  idPessoa_pessoa INTEGER   NOT NULL ,
  idProduto_produto INTEGER   NOT NULL ,
  idUsuario_usuario INTEGER   NOT NULL ,
  quantidade INT    ,
  tipo CHAR(1)    ,
  valorUnitario FLOAT      ,
PRIMARY KEY(idMovimento)      ,
  FOREIGN KEY(idUsuario_usuario)
    REFERENCES usuario(idUsuario),
  FOREIGN KEY(idProduto_produto)
    REFERENCES produtos(idProduto),
  FOREIGN KEY(idPessoa_pessoa)
    REFERENCES pessoa(idPessoa));


CREATE INDEX movimentos_FKIndex1 ON movimentos (idUsuario_usuario);
CREATE INDEX movimentos_FKIndex2 ON movimentos (idProduto_produto);
CREATE INDEX movimentos_FKIndex3 ON movimentos (idPessoa_pessoa);


CREATE INDEX IFK_Responsavel ON movimentos (idUsuario_usuario);
CREATE INDEX IFK_Relacionado ON movimentos (idProduto_produto);
CREATE INDEX IFK_Compra e Venda ON movimentos (idPessoa_pessoa);

-- 2º PROCEDIMENTO

select * from usuario

insert into usuario (idUsuario, login, senha)
values (1,'op1','op1'), 
(2, 'op2','op2');

select * from produtos

INSERT INTO produtos(idProduto, nome, quantidade, precoVenda) VALUES (1,'Banana',100, 5.00);
INSERT INTO produtos(idProduto, nome, quantidade, precoVenda) VALUES (2,'Laranja',500, 2.00);
INSERT INTO produtos(idProduto, nome, quantidade, precoVenda) VALUES (3,'Manga',800, 4.00);
INSERT INTO produtos(idProduto, nome, quantidade, precoVenda) VALUES (4,'Uva',200, 5.00);

CREATE SEQUENCE idPessoa
    START WITH 1
    INCREMENT BY 1;

select * from pessoa, pessoa_fisica

insert into pessoa (idPessoa, nome, logradouro, cidade, estado , telefone, email)
values
( '1' , 'Luan' , 'Rua José Lucio 1 ', 'Tanguá' , 'RJ', '11111111', 'Luan@estacio.br'),
( '2' , 'Lana' , 'Rua José Lucio 1 ', 'Tanguá' , 'RJ', '11111111', 'Lana@estacio.br'),
( '3' , 'Bandeira' , 'Rua José Lucio 1 ', 'Tanguá' , 'RJ', '11111111', 'Bandeira@estacio.br'),
( '4' , 'Gabriel' , 'Rua José Lucio 21 ', 'Tanguá' , 'RJ', '11111111', 'Gabriel@estacio.br'),
( '5' , 'Felipe' , 'Rua José Lucio 31 ', 'Tanguá' , 'RJ', '11111111', 'Felipe@estacio.br'),
( '6' , 'Fernando' , 'Rua José Lucio 41 ', 'Tanguá' , 'RJ', '11111111', 'Fernando@estacio.br'),
( '7' , 'Vieira' , 'Rua José Lucio 51 ', 'Tanguá' , 'RJ', '11111111', 'Vieira@estacio.br');


select * from pessoa_fisica, pessoa
insert into pessoa_fisica (idPessoa_fisica, pessoa_idPessoa, cpf)
values ( '1' , '1' , '1500447897'),
('2','2','1544861285'),
('3','3','1567489432'),
('4','4','4156489432');


select * from pessoa_juridica,pessoa
insert into pessoa_juridica (idPessoa_juridica, pessoa_idPessoa, cnpj)
values ('1','5', '156156894200019'),
('2','6','156894235400018'),
('3','7','98749842100019');

select * from movimentos
insert into movimentos (idMovimento, idPessoa_pessoa, idProduto_produto, idUsuario_usuario,quantidade,tipo,valorUnitario)
values (1,7,1,1,20,'S',4.00),
(4,7,3,1,15,'S',2.00),
(5,7,3,2,10,'S',3.00),
(7,6,3,1,15,'E',5),
(8,6,4,1,20,'E',4.00);

-- Dados completos de pessoas físicas:
SELECT * FROM pessoa_fisica;

--Dados completos de pessoas jurídicas:
SELECT * FROM pessoa_juridica;

--Movimentações de entrada (com detalhes do produto e fornecedor):
SELECT m.*, p.nome AS Produto, pf.nome AS Fornecedor, m.quantidade, m.valorUnitario, (m.quantidade * m.valorUnitario) AS ValorTotal
FROM movimentos m
JOIN produtos p ON m.idProduto_produto = p.idProduto
JOIN pessoa pf ON m.idPessoa_pessoa = pf.idPessoa
WHERE m.tipo = 'E';

--Movimentações de saída (com detalhes do produto e comprador):
SELECT m.*, p.nome AS Produto, pf.nome AS Comprador, m.quantidade, m.valorUnitario, (m.quantidade * m.valorUnitario) AS ValorTotal
FROM movimentos m
JOIN produtos p ON m.idProduto_produto = p.idProduto
JOIN pessoa pf ON m.idPessoa_pessoa = pf.idPessoa
WHERE m.tipo = 'S';

--Valor total das entradas agrupadas por produto:
SELECT p.nome AS Produto, SUM(m.quantidade * m.valorUnitario) AS ValorTotal
FROM movimentos m
JOIN produtos p ON m.idProduto_produto = p.idProduto
WHERE m.tipo = 'E'
GROUP BY p.nome;

--Valor total das saídas agrupadas por produto:

SELECT p.nome AS Produto, SUM(m.quantidade * m.valorUnitario) AS ValorTotal
FROM movimentos m
JOIN produtos p ON m.idProduto_produto = p.idProduto
WHERE m.tipo = 'S'
GROUP BY p.nome;

--Operadores que não efetuaram movimentações de entrada (compra):
SELECT u.*
FROM usuario u
WHERE NOT EXISTS (
    SELECT 1
    FROM movimentos m
    WHERE m.idUsuario_usuario = u.idUsuario AND m.tipo = 'E'
);

--Valor total de entrada, agrupado por operador:
SELECT u.idUsuario, u.login, SUM(m.quantidade * m.valorUnitario) AS ValorTotal
FROM movimentos m
JOIN usuario u ON m.idUsuario_usuario = u.idUsuario
WHERE m.tipo = 'E'
GROUP BY u.idUsuario, u.login;

--Valor total de saída, agrupado por operador:
SELECT u.idUsuario, u.login, SUM(m.quantidade * m.valorUnitario) AS ValorTotal
FROM movimentos m
JOIN usuario u ON m.idUsuario_usuario = u.idUsuario
WHERE m.tipo = 'S'
GROUP BY u.idUsuario, u.login;

--Valor médio de venda por produto, utilizando média ponderada:
SELECT p.nome AS Produto, SUM(m.quantidade * m.valorUnitario) / SUM(m.quantidade) AS ValorMedio
FROM movimentos m
JOIN produtos p ON m.idProduto_produto = p.idProduto
WHERE m.tipo = 'S'
GROUP BY p.nome;




