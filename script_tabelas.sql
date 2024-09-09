--Criação banco de dados--

--Apaga banco com mesmo nome, se já existir
DROP DATABASE IF EXISTS alziroDB;

--Cria o banco de dados
CREATE DATABASE alziroDB;

--Seleciona banco de dados
USE alziroDB;

--Criação tabelas--

--Tabela Cadastros
CREATE TABLE cadastros(
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100),
    documento VARCHAR(20),
    cep VARCHAR(10),
    estado VARCHAR(10),
    cidade VARCHAR(100),
    endereco VARCHAR(200)
);

--Tabela Tags
CREATE TABLE tags(
    id INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(100)
);

--Tabela Cadastros_Tags (relação muitos para muitos)
CREATE TABLE cadastros_tags(
    cadastro_id INT,
    tag_id INT,
    PRIMARY KEY (cadastro_id, tag_id),
    FOREIGN KEY (cadastro_id) REFERENCES cadastros(id),
    FOREIGN KEY (tag_id) REFERENCES tags(id)
);

--Tabela Categorias
CREATE TABLE categorias(
    id INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(100)
);

--Tabela Laçamentos
CREATE TABLE lancamentos(
    id INT AUTO_INCREMENT PRIMARY KEY,
    tipo VARCHAR(10),
    status VARCHAR(10),
    descricao VARCHAR(300),
    valor DECIMAL(10,2),
    valor_liquidado DECIMAL(10,2),
    vencimento DATE,
    liquidacao DATE,
    cadastro_id INT NULL,
    categoria_id INT NULL,
    FOREIGN KEY (cadastro_id) REFERENCES cadastros(id),
    FOREIGN KEY (categoria_id) REFERENCES categorias(id)
);