-- criacao do banco
create database  LucasT;

-- criacao das tabelas

CREATE TABLE endereco(
	id serial primary key,
    rua varchar(30) not null,
    numero varchar(5) not null,
    bairro varchar(30) not null
);

create table cidade(
	id serial primary key,
    nome varchar(20),
	uf char(2) references estado(uf)
);

create table estado(
    uf char(2) primary key
);


CREATE TABLE cadastros (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(50),
    documento VARCHAR(14) UNIQUE,
    cep CHAR(8),
    estado CHAR(2),
    cidade VARCHAR(20) references cidade(id),
    endereco INT REFERENCES endereco(id)
);

CREATE TABLE tags (
    id SERIAL PRIMARY KEY,
    titulo VARCHAR(20)
);

CREATE TABLE cadastros_tags (
    cadastro_id INT REFERENCES cadastros(id),
    tag_id INT REFERENCES tags(id),
    PRIMARY KEY (cadastro_id, tag_id)
);

CREATE TABLE categorias (
    id SERIAL PRIMARY KEY,
    titulo VARCHAR(20)
);

CREATE TABLE lancamentos (
    id SERIAL PRIMARY KEY,
    tipo VARCHAR(7) CHECK (tipo IN ('pagar', 'receber')),
    status VARCHAR(10) CHECK (status IN ('aberto', 'liquidado')),
    descricao TEXT,
    valor DECIMAL(7,2),
    valor_liquidado DECIMAL(10,2),
    vencimento DATE,
    liquidacao DATE,
    cadastro_id INT REFERENCES cadastros(id),
    categoria_id INT REFERENCES categorias(id)
);

-- inserindo dados

INSERT INTO endereco (rua, numero, bairro)
SELECT rua, numero, bairro
FROM (SELECT 'Rua A' AS rua UNION SELECT 'Rua B' UNION SELECT 'Rua C' UNION SELECT 'Rua D' UNION SELECT 'Rua E') AS ruas,
     (SELECT '101' AS numero UNION SELECT '102' UNION SELECT '103' UNION SELECT '104' UNION SELECT '105') AS numeros,
     (SELECT 'Bairro I' AS bairro UNION SELECT 'Bairro J' UNION SELECT 'Bairro K' UNION SELECT 'Bairro L' UNION SELECT 'Bairro H') AS bairros;



INSERT INTO tags (titulo) VALUES
('Cliente'),
('Fornecedor'),
('Parceiro'),
('Empregado'),
('Investidor'),
('Prestador de Serviço'),
('Contador'),
('Consultor'),
('Agência'),
('Corporativo');



INSERT INTO estado (uf) VALUES
('AC'),
('AL'),
('AM'),
('BA'),
('CE'),
('DF'),
('ES'),
('GO'),
('MG'),
('RJ');

INSERT INTO cidade (nome, uf) VALUES

('Rio Branco', 'AC'),
('Cruzeiro do Sul', 'AC'),

('Maceió', 'AL'),
('Arapiraca', 'AL'),

('Manaus', 'AM'),
('Parintins', 'AM'),

('Salvador', 'BA'),
('Feira de Santana', 'BA'),

('Fortaleza', 'CE'),
('Juazeiro do Norte', 'CE'),

('Brasília', 'DF'),
('Ceilândia', 'DF'),

('Vitória', 'ES'),
('Vila Velha', 'ES'),

('Goiânia', 'GO'),
('Aparecida de Goiânia', 'GO'),

('Belo Horizonte', 'MG'),
('Uberlândia', 'MG'),

('Rio de Janeiro', 'RJ'),
('Niterói', 'RJ');



INSERT INTO categorias (titulo) VALUES
('Despesas Fixas'),
('Despesas Variáveis'),
('Receitas Fixas'),
('Receitas Variáveis'),
('Investimentos'),
('Salário'),
('Compras'),
('Educação'),
('Saúde'),
('Entretenimento');


INSERT INTO cadastros (nome, documento, cep, cidade, endereco)
SELECT 
    CONCAT(nomes.nome, ' ', sobrenomes.sobrenome, ' ', ultimos_nomes.ultimo_nome) AS nome_completo,
    LPAD(FLOOR(10000000000 + (RAND() * 89999999999)), 11, '0') AS documento,
    LPAD(FLOOR(10000000 + (RAND() * 8999999)), 8, '0') AS cep,
    (SELECT nome FROM cidade ORDER BY RAND() LIMIT 1) AS cidade,
    (SELECT id FROM endereco ORDER BY RAND() LIMIT 1) AS endereco
FROM 
    (SELECT 'Ana' AS nome UNION SELECT 'Carlos' UNION SELECT 'Maria' UNION SELECT 'João' UNION SELECT 'Pedro') AS nomes,
    (SELECT 'Silva' AS sobrenome UNION SELECT 'Oliveira' UNION SELECT 'Costa' UNION SELECT 'Santos' UNION SELECT 'Pereira') AS sobrenomes,
    (SELECT 'Júnior' AS ultimo_nome UNION SELECT 'Filho' UNION SELECT 'Neto' UNION SELECT 'Sobrinho') AS ultimos_nomes
LIMIT 100;

UPDATE cadastros
JOIN cidade ON cadastros.cidade = cidade.nome
SET cadastros.estado = cidade.uf;



