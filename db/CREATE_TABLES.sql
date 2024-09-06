CREATE TABLE  tags (
	tagID SERIAL NOT NULL PRIMARY KEY,
	titulo VARCHAR(50)
);

CREATE TABLE cadastros (
	cadastroID SERIAL NOT NULL PRIMARY KEY,
	nome VARCHAR(50),
	documento VARCHAR(20),
	cep VARCHAR(9),
	estado VARCHAR(30),
	cidade VARCHAR (30),
	endereco VARCHAR (50),
	CHECK (documento ~ '^\d{3}\.\d{3}\.\d{3}\-\d{2}$' OR documento ~ '^\d{2}\.\d{3}\.\d{3}/\d{4}\-\d{2}$')
);

CREATE TABLE cadastros_tags (
	fk_cadastro INT,
	CONSTRAINT fk_cadastro FOREIGN KEY (fk_cadastro) REFERENCES cadastros (cadastroID),
	fk_tag INT,
	CONSTRAINT fk_tag FOREIGN KEY (fk_tag) REFERENCES tags (tagID)
);

CREATE TABLE categorias (
	categoriaID SERIAL PRIMARY KEY NOT NULL,
	titulo VARCHAR(50)
);

CREATE TABLE lancamentos (
	lancamentoID SERIAL PRIMARY KEY NOT NULL,
	tipo VARCHAR (50),
	status VARCHAR(20),
	descricao VARCHAR (50),
	valor INT,
	valor_liquidado INT,
	vencimento DATE,
	liquidacao DATE,
	fk_cadastro INT DEFAULT NULL,
	CONSTRAINT fk_cadastro FOREIGN KEY (fk_cadastro) REFERENCES cadastros (cadastroID),
	fk_categoria int DEFAULT NULL,
	CONSTRAINT fk_categoria FOREIGN KEY (fk_categoria) REFERENCES categorias (categoriaID),
	CHECK (tipo = 'pagar' OR tipo = 'receber'),
	check (status = 'aberto' OR status = 'liquidado')
);
