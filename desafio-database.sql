--- Criando a tabela cadastro ---
CREATE TABLE cadastros (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    documento VARCHAR(14) NOT NULL UNIQUE,
    cep VARCHAR(9) NOT NULL,
    estado VARCHAR(2) NOT NULL,
    cidade VARCHAR(100) NOT NULL,
    endereco VARCHAR(255) NOT NULL
);
--------------------------------------
SELECT * FROM CADASTROS;
--------------------------------------
-- Criando Tabela tags --
CREATE TABLE tags (
    id SERIAL PRIMARY KEY,
    titulo VARCHAR(100) NOT NULL
);
-------------------------------------
SELECT * FROM TAGS;
-------------------------------------
-- Criando Tabela cadastro_tags --
CREATE TABLE cadastros_tags (
	cadastro_id int not null REFERENCES cadastro(id) ON DELETE CASCADE,
	tag_id int not null REFERENCES tags(id) ON DELETE CASCADE,
	PRIMARY KEY (cadastro_id, tag_id),
);
--------------------------------------
select * from cadastros_tags;
---------------------------------------
-- Inserindo valores na tabela tags --
INSERT INTO tags (titulo) VALUES
('Ativo'),
('Inativo'),
('Urgente'),
('Regular'),
('Pendente'),
('Verificado'),
('Não Verificado'),
('CPF'),
('CNPJ'),
('Prioritário');
-------------------------------------------------------
--Pegando o id de cada tabela e inserindo valores na tabela cadastro_tags
INSERT INTO cadastros_tags (cadastro_id, tag_id) VALUES
(1,1),  
(1,3),  
(2,8),  
(3,9);
(4,1),
(5,4),
(6,7),
(7,4),
(8,9),
(9,2);
-----------------------------------
-- Criando a tabela categorias --
CREATE TABLE categorias (
	id SERIAL PRIMARY KEY,
	titulo VARCHAR(100) NOT NULL
);
----------------------------------
--Criando tabela lancamentos --
CREATE TABLE lancamentos (
	id SERIAL PRIMARY KEY,
	tipo VARCHAR(10) CHECK (tipo IN ('pagar','receber')) NOT NULL,
	status VARCHAR(10) CHECK (status IN ('aberto','liquidado')) NOT NULL,
	descricao TEXT NOT NULL,
	valor NUMERIC(10, 2) NOT NULL,
	valor_liquidado NUMERIC(10, 2) NOT NULL,
	vencimento DATE,
	liquidacao DATE,
	cadastro_id INT REFERENCES cadastroS(id) ON DELETE SET NULL,
	categoria_id INT REFERENCES categoriaS(id) ON DELETE SET NULL
);
----------------------------------------------------------------------------------
SELECT * FROM categorias;
----------------------------------------------------------------------------------
-- Inserindo valores na tabela categoria --
INSERT INTO categorias (titulo) VALUES 
('Inovacao'),
('Sustentabilidade'),
('Ciência'),
('Marketing'),
('Arte'),
('Literatura'),
('Música'),
('Engenharia'),
('Negócios'),
('História');
--------------------------------------------------------------------------------
-- Lista de cadastros com tags --
SELECT 
	c.nome,
	c.estado,
	c.cidade,
	STRING_AGG(tg.titulo, ', ') tags
FROM
	cadastros c
LEFT JOIN 
	cadastros_tags ct ON c.id = cadastro_id
LEFT JOIN 
	tags tg ON tg.id = ct.tag_id
GROUP BY
	c.id;
----------------------------------------------------------------------
-- Lista de receitas liquidadas em um determinado período --
SELECT 
	c.nome,
	c.documento,
	l.descricao,
	l.status,
	l.liquidacao,
	l.valor_liquidado
FROM 
	lancamentos l
LEFT JOIN 
	cadastros c on l.cadastro_id = c.id
WHERE 
	l.status = 'liquidado'
AND l.liquidacao BETWEEN '2024-08-01' and '2024-09-01';
--------------------------------------------------------------
-- total de receitas liquidadas, por categoria mensal --
SELECT 
    EXTRACT(MONTH FROM l.liquidacao) AS mes,
    c.titulo AS categoria,
    SUM(l.valor_liquidado) AS total_receitas
FROM 
    lancamentos AS l
JOIN 
    categorias AS c ON l.categoria_id = c.id
WHERE 
    l.status = 'liquidado'
GROUP BY 
    mes, c.titulo
ORDER BY 
     mes, c.titulo;
------------------------------------------------------------------
-- Lista de despesas em aberto --
SELECT 
	c.nome,
	c.documento,
	l.descricao,
	l.vencimento,
	l.valor,
	l.tipo,
	l.status
FROM
	lancamentos l
LEFT JOIN	
	cadastros c on l.cadastro_id = c.id
WHERE
	l.tipo = 'pagar' AND l.status = 'aberto';
----------------------------------------------------------------------
-- Total de despesas liquidadas, por categoria mensal --
SELECT 
    EXTRACT(MONTH FROM l.liquidacao) AS mes,
    c.titulo AS categoria,
    SUM(l.valor_liquidado) AS total_receitas
FROM 
    lancamentos AS l
JOIN 
    categorias AS c ON l.categoria_id = c.id
WHERE 
    l.tipo = 'pagar'
GROUP BY 
    mes, c.titulo
ORDER BY 
     mes, c.titulo;



