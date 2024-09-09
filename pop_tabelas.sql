--Populando todas as tabelas--

-- Criando novo procedimento
DELIMITER $$
CREATE PROCEDURE popular_cadastros()
BEGIN
    DECLARE i INT DEFAULT 1;
    WHILE i<=100 DO
        INSERT INTO cadastros (nome, documento, cep, estado, cidade, endereco)
        VALUES (
            CONCAT('Nome_', i),
            LPAD(ROUND(RAND()*99999999999), 11, '0'),
            CONCAT(LPAD(ROUND(RAND()*99999), 5, '0'), '-', LPAD(ROUND(RAND()*999), 3, '0')),
            CONCAT('Estado_', ROUND(RAND()*27)),
            CONCAT('Cidade_', ROUND(RAND()*100)),
            CONCAT('Endereco_', ROUND(RAND()*1000))
        );
        SET i=i+1;
    END WHILE;
END $$
DELIMITER ;

-- Chamando procedimento para popular a tabela cadastros
CALL popular_cadastros();

-- Criando novo procedimento
DELIMITER $$
CREATE PROCEDURE popular_tags()
BEGIN
    DECLARE i INT DEFAULT 1;
    WHILE i<=10 DO
        INSERT INTO tags (titulo)
        VALUES (CONCAT('Tag_', i));
        SET i=i+1;
    END WHILE;
END $$
DELIMITER ;

-- Chamando procedimento para popular a tabela tags
CALL popular_tags();

-- Criando novo procedimento
DELIMITER $$
CREATE PROCEDURE popular_cadastros_tags()
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE count_cadastro INT;
    DECLARE count_tag INT;
    DECLARE randm_cadastro_id INT;
    DECLARE rndm_tag_id INT;

    SELECT COUNT(*) INTO count_cadastro FROM cadastros;
    SELECT COUNT(*) INTO count_tag FROM tags;
    WHILE i<=100 DO
        SET randm_cadastro_id = ROUND(1 + RAND()*(count_cadastro - 1));
        SET rndm_tag_id = ROUND(1 + RAND()*(count_tag - 1));
        IF NOT EXISTS (
            SELECT 1 FROM cadastros_tags 
            WHERE cadastro_id = randm_cadastro_id AND tag_id = rndm_tag_id
        ) THEN
            INSERT INTO cadastros_tags (cadastro_id, tag_id)
            VALUES (randm_cadastro_id, rndm_tag_id);
            SET i=i+1;
        END IF;
    END WHILE;
END $$
DELIMITER ;

-- Chamando procedimento para popular a tabela cadastros_tags
CALL popular_cadastros_tags();

-- Criando novo procedimento
DELIMITER $$
CREATE PROCEDURE popular_categorias()
BEGIN
    DECLARE i INT DEFAULT 1;
    WHILE i<=10 DO
        INSERT INTO categorias (titulo)
        VALUES (CONCAT('Categoria_', i));
        SET i=i+1;
    END WHILE;
END $$
DELIMITER ;

-- Chamando procedimento para popular a tabela categorias
CALL popular_categorias();

-- Criando novo procedimento
DELIMITER $$
CREATE PROCEDURE popular_lancamentos()
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE max_cadastro_id INT;
    DECLARE max_categoria_id INT;
    DECLARE randm_cadastro_id INT;
    DECLARE randm_categoria_id INT;

    SELECT MAX(id) INTO max_cadastro_id FROM cadastros;
    SELECT MAX(id) INTO max_categoria_id FROM categorias;

    WHILE i <= 1000 DO
        SET randm_cadastro_id = IF(ROUND(RAND())=1, NULL, ROUND(1 + RAND()*(max_cadastro_id - 1)));
        SET randm_categoria_id = IF(ROUND(RAND())=1, NULL, ROUND(1 + RAND()*(max_categoria_id - 1)));
        INSERT INTO lancamentos (tipo, status, descricao, valor, valor_liquidado, vencimento, liquidacao, cadastro_id, categoria_id)
        VALUES (
            IF(ROUND(RAND())=1, 'pagar', 'receber'),
            IF(ROUND(RAND())=1, 'aberto', 'liquidado'),
            CONCAT('Descricao_', i),
            ROUND(RAND()*1000, 2),
            ROUND(RAND()*1000, 2),
            DATE_ADD('2024-01-01', INTERVAL ROUND(RAND()*365) DAY),
            DATE_ADD('2024-01-01', INTERVAL ROUND(RAND()*365) DAY),
            randm_cadastro_id,
            randm_categoria_id
        );
        SET i=i+1;
    END WHILE;
END $$
DELIMITER ;

-- Chamando procedimento para popular a tabela lancamentos
CALL popular_lancamentos();