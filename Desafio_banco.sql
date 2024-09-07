create database definitivo ;
use definitivo;
show databases;
show tables;

drop table cadastro;
-- 100 cadastros
create table cadastro(
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    documento VARCHAR(25) UNIQUE null, --  UNIQUE para garantir que não haja documentos duplicados
    cep VARCHAR(10) NOT NULL, -- Tamanho ajustado para o padrão de CEP brasileiro
    estado CHAR(2) NOT NULL,
    cidade VARCHAR(70) NOT NULL, 
    endereco VARCHAR(255) NOT NULL -- Tamanho para permitir endereços mais longos
);
-- minimo 10
drop table tag;
create table tag(
id int not null auto_increment primary key,
titulo varchar(100)not null
);
drop table cadastros_tags;
CREATE TABLE cadastros_tags (
    cadastro_id INT,
    tag_id INT,
    PRIMARY KEY (cadastro_id, tag_id),
    FOREIGN KEY (cadastro_id) REFERENCES cadastro(id),-- chave estrangeira que faz referencia ao id no cadastro
    FOREIGN KEY (tag_id) REFERENCES tag(id)
);
-- minimo 10 
drop table categoria;
create table categoria(
   id int not null auto_increment primary key,
   titulo varchar(100) 
);
drop table lançamento;
-- Criação da tabela lançamento 1000
CREATE TABLE lançamento (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY, -- Identificador único para lançamentos
    tipo ENUM('pagar', 'receber') NOT NULL, --  ENUM para valores específicos
    estado ENUM('aberto', 'liquidado') NOT NULL, 
    descricao VARCHAR(100),
    valor DECIMAL(10,2),
    valor_liquidado DECIMAL(10,2),
    vencimento DATE,
    liquidacao DATE,
    cadastro_id INT, -- Definido para chave estrangeira
    categoria_id INT, -- Definido para chave estrangeira
    FOREIGN KEY (cadastro_id) REFERENCES cadastro(id), 
    FOREIGN KEY (categoria_id) REFERENCES categoria(id) 
);

-- Certifica que a tabela não existe antes de criar a procedure
DROP PROCEDURE IF EXISTS insert_random_cadastros;

-- Define o delimitador para evitar conflitos com os pontos e vírgulas no código da procedure
DELIMITER //

CREATE PROCEDURE insert_random_cadastros()
BEGIN
    DECLARE v_max INT DEFAULT 100; -- Número de registros a serem inseridos
    DECLARE v_counter INT DEFAULT 0; -- Contador para o loop

    -- Inicia uma transação para garantir a consistência dos dados
    START TRANSACTION;

    -- Loop para os 100 registros
    WHILE v_counter < v_max DO
        INSERT INTO cadastro (nome, documento, cep, estado, cidade, endereco)
        VALUES (
            CONCAT('Nome', FLOOR(1 + (RAND() * 10000))), -- Nome aleatório
            CONCAT('DOC', FLOOR(1000000000 + (RAND() * 9000000000))), -- Documento aleatório
            CONCAT(FLOOR(10000 + (RAND() * 90000))), -- CEP aleatório (não totalmente realista, mas funcional para exemplo)
            ELT(FLOOR(1 + (RAND() * 27)), 'AC', 'AL', 'AP', 'AM', 'BA', 'CE', 'DF', 'ES', 'GO', 'MA', 'MT', 'MS', 'MG', 'PA', 'PB', 'PR', 'PE', 'PI', 'RJ', 'RN', 'RS', 'RO', 'RR', 'SC', 'SP', 'SE', 'TO'), -- Estado aleatório
            CONCAT('Cidade', FLOOR(1 + (RAND() * 1000))), -- Cidade aleatória
            CONCAT(FLOOR(1 + (RAND() * 1000)), ' Rua Exemplo') -- Endereço aleatório
        );
        
        SET v_counter = v_counter + 1; -- Incrementa o contador
    END WHILE;

    -- Comita a transação para persistir os dados
    COMMIT;
END //

-- Restaura o delimitador para o padrão
DELIMITER ;
CALL insert_random_cadastros();
select*from cadastro;

DROP PROCEDURE IF EXISTS insert_random_lancamentos;
DELIMITER //

CREATE PROCEDURE insert_random_lancamentos()
BEGIN
    DECLARE v_max INT DEFAULT 1000; -- Número de registros a serem inseridos
    DECLARE v_counter INT DEFAULT 0; -- Contador para o loop
    DECLARE v_max_cadastro_id INT;
    DECLARE v_max_categoria_id INT;

    -- Obtenha o número máximo de IDs válidos nas tabelas referenciadas
    SELECT MAX(id) INTO v_max_cadastro_id FROM cadastro;
    SELECT MAX(id) INTO v_max_categoria_id FROM categoria;

    -- Inicia uma transação para garantir a consistência dos dados
    START TRANSACTION;

    -- Loop para os 1000 registros
    WHILE v_counter < v_max DO
        INSERT INTO lançamento (tipo, estado, descricao, valor, valor_liquidado, vencimento, liquidacao, cadastro_id, categoria_id)
        VALUES (
            ELT(FLOOR(1 + (RAND() * 2)), 'pagar', 'receber'), -- Tipo aleatório
            ELT(FLOOR(1 + (RAND() * 2)), 'aberto', 'liquidado'), -- Estado aleatório
            CONCAT('Descrição ', FLOOR(1 + (RAND() * 1000))), -- Descrição aleatória
            ROUND(RAND() * 1000, 2), -- Valor aleatório entre 0 e 1000 round arredonda p/2 casas decimais
            ROUND(RAND() * 1000, 2), -- Valor liquidado aleatório entre 0 e 1000
            CURDATE() + INTERVAL FLOOR(RAND() * 365) DAY, -- Data de vencimento aleatória dentro do próximo ano/floor arredonda p/baixo
            -- curdate retorna a data atual
            CURDATE() + INTERVAL FLOOR(RAND() * 365) DAY, -- Data de liquidação aleatória dentro do próximo ano
            FLOOR(1 + (RAND() * v_max_cadastro_id)), -- ID de cadastro aleatório dentro do intervalo válido
            FLOOR(1 + (RAND() * v_max_categoria_id)) -- ID de categoria aleatório dentro do intervalo válido
        );
        
        SET v_counter = v_counter + 1; -- Incrementa o contador SET atribui o valor a variavel
    END WHILE;

    COMMIT;-- torna permanente no banco de dados
END //
-- Restaura o delimitador para o padrão
DELIMITER ;

CALL insert_random_lancamentos();
select*from lançamento;

-- Verifique o número de registros na tabela cadastro
SELECT COUNT(*) FROM cadastro;
-- Verifique o número de registros na tabela categoria
SELECT COUNT(*) FROM categoria;

DROP PROCEDURE IF EXISTS insert_random_tags;

-- Define o delimitador para evitar conflitos com os pontos e vírgulas no código da procedure
DELIMITER //

CREATE PROCEDURE insert_random_tags()
BEGIN
    DECLARE v_max INT DEFAULT 10; -- Número de registros a serem inseridos
    DECLARE v_counter INT DEFAULT 0; -- Contador para o loop

    -- Inicia uma transação para garantir a consistência dos dados
    START TRANSACTION;

    -- Loop para os 10 registros
    WHILE v_counter < v_max DO
        INSERT INTO tag (titulo)
        VALUES (CONCAT('Tag ', FLOOR(1 + (RAND() * 1000)))); -- Título aleatório

        SET v_counter = v_counter + 1; -- Incrementa o contador
    END WHILE;

    -- Comita a transação para persistir os dados
    COMMIT;
END //

-- Restaura o delimitador para o padrão
DELIMITER ;
CALL insert_random_tags();
select*from tag;

DROP PROCEDURE IF EXISTS insert_random_cadastros_tags;

DELIMITER //

CREATE PROCEDURE insert_random_cadastros_tags()
BEGIN
    DECLARE v_max INT DEFAULT 10; -- Número de registros a serem inseridos
    DECLARE v_counter INT DEFAULT 0; -- Contador para o loop
    DECLARE v_max_cadastro_id INT;
    DECLARE v_max_tag_id INT;

    -- Obtenha o número máximo de IDs válidos nas tabelas referenciadas
    SELECT MAX(id) INTO v_max_cadastro_id FROM cadastro;
    SELECT MAX(id) INTO v_max_tag_id FROM tag;

    -- Inicia uma transação para garantir a consistência dos dados
    START TRANSACTION;

    -- Loop para os 10 associações
    WHILE v_counter < v_max DO
        INSERT INTO cadastros_tags (cadastro_id, tag_id)
        VALUES (
            FLOOR(1 + (RAND() * v_max_cadastro_id)), -- ID de cadastro aleatório dentro do intervalo válido
            FLOOR(1 + (RAND() * v_max_tag_id)) -- ID de tag aleatório dentro do intervalo válido
        );

        SET v_counter = v_counter + 1; -- Incrementa o contador
    END WHILE;

    -- Comita a transação para persistir os dados
    COMMIT;
END //

-- Restaura o delimitador para o padrão
DELIMITER ;
CALL insert_random_cadastros_tags();
select*from cadastros_tags;

DROP PROCEDURE IF EXISTS insert_random_categorias;

-- Defina o delimitador para evitar conflitos com os pontos e vírgulas no código da procedure
DELIMITER //

CREATE PROCEDURE insert_random_categorias()
BEGIN
    DECLARE v_max INT DEFAULT 10; -- Número de registros a serem inseridos
    DECLARE v_counter INT DEFAULT 0; -- Contador para o loop

    -- Inicia uma transação para garantir a consistência dos dados
    START TRANSACTION;

    -- Loop para os 10 registros
    WHILE v_counter < v_max DO
        INSERT INTO categoria (titulo)
        VALUES (CONCAT('Categoria ', FLOOR(1 + (RAND() * 1000)))); -- Título aleatório

        SET v_counter = v_counter + 1; -- Incrementa o contador
    END WHILE;

    -- Comita a transação para persistir os dados
    COMMIT;
END //

-- Restaura o delimitador para o padrão
DELIMITER ;
CALL insert_random_categorias();
select*from categoria;
CALL insert_random_cadastros_tags();
select*from cadastros_tags;

-- RELATÓRIO--
-- Lista de cadastros com tags--
SELECT -- concatenar os títulos das tags associadas a cada cadastro, separando-os por vírgulas e ordenando-os por título
    c.nome,
    c.estado,
    c.cidade,
    GROUP_CONCAT(t.titulo ORDER BY t.titulo SEPARATOR ', ') AS tags
FROM 
    cadastro c -- define a tabela cadastro como c
    LEFT JOIN cadastros_tags ct ON c.id = ct.cadastro_id
    LEFT JOIN tag t ON ct.tag_id = t.id
    -- A junção à esquerda garante que todos os cadastros serão listados, mesmo aqueles que não possuem tags associadas.
GROUP BY
    c.id, c.nome, c.estado, c.cidade;
    
    -- Lista de receitas liquidadas em um determinado período--
    SELECT
    c.nome,
    c.documento,-- O documento associado ao cadastro.
    l.descricao,
    l.liquidacao,-- A data de liquidação do lançamento.
    l.valor_liquidado
FROM
    lançamento l
LEFT JOIN -- A junção à esquerda garante que todos os registros da tabela lançamento sejam retornados, mesmo sem correspondência no cadastro.
    cadastro c ON l.cadastro_id = c.id
WHERE
    l.tipo = 'receber'
    AND l.estado = 'liquidado'
    AND l.liquidacao BETWEEN '2024-01-01' AND '2024-12-31';
    
 -- total de receitas liquidadas, por categoria mensal  --
    SELECT
    DATE_FORMAT(l.liquidacao, '%Y-%m') AS mes,-- formata a data para ano e mes
    c.titulo AS categoria,
    SUM(l.valor_liquidado) AS total_liquidado
FROM
    lançamento l
JOIN
    categoria c ON l.categoria_id = c.id
WHERE
    l.tipo = 'receber'
    AND l.estado = 'liquidado'
GROUP BY
    mes, c.titulo
ORDER BY
    mes, c.titulo;
    
 -- Lista de despesas em aberto  --
    SELECT
    c.nome,
    c.documento,
    l.descricao,
    l.vencimento,
    l.valor
FROM
    lançamento l
LEFT JOIN
    cadastro c ON l.cadastro_id = c.id
WHERE
    l.tipo = 'pagar'
    AND l.estado = 'aberto';

-- Total de despesas liquidadas, por categoria mensal --
SELECT
    DATE_FORMAT(l.liquidacao, '%Y-%m') AS mes,
    c.titulo AS categoria,
    SUM(l.valor_liquidado) AS total_liquidado
FROM
    lançamento l
JOIN
    categoria c ON l.categoria_id = c.id
WHERE
    l.tipo = 'pagar'
    AND l.estado = 'liquidado'
GROUP BY
    mes, c.titulo
ORDER BY
    mes, c.titulo;


