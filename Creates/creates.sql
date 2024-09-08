CREATE TABLE Cadastros(
    id INT NOT NULL AUTO_INCREMENT,
    nome VARCHAR(50) NOT NULL,
    documento VARCHAR(15) NOT NULL,
    cep VARCHAR (15),
    estado VARCHAR (50),
    cidade VARCHAR (50),
    endereco VARCHAR (50),
    PRIMARY KEY(id)
);

CREATE TABLE Tagss(
    id INT NOT NULL AUTO_INCREMENT,
    titulo VARCHAR (50),
    PRIMARY KEY(id)
);

CREATE TABLE Cadastros_tags (
    cadastro_id INT NOT NULL,
    tags_id INT NOT NULL,
    PRIMARY KEY (cadastro_id, tags_id),
    FOREIGN KEY (cadastro_id) REFERENCES Cadastros(id),
    FOREIGN KEY (tags_id) REFERENCES Tagss(id)
);

CREATE TABLE Categorias(
    id INT NOT NULL AUTO_INCREMENT,
    titulo VARCHAR(50),
    PRIMARY KEY(id)
);
CREATE TABLE Lancamentos (
    id INT NOT NULL AUTO_INCREMENT,
    tipo VARCHAR(15),
    status VARCHAR(15),
    descricao TEXT,
    valor DECIMAL(10, 2),
    valor_liquidado DECIMAL(10, 2),
    vencimento DATE,
    liquidacao DATE,
    cadastro_id INT,
    categorias_id INT,
    FOREIGN KEY (cadastro_id) REFERENCES Cadastros(id),
    FOREIGN KEY (categorias_id) REFERENCES Categorias(id),
    PRIMARY KEY (id)
);
