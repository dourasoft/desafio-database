CREATE TABLE CADASTROS (
    id serial PRIMARY KEY NOT NULL,
    nome varchar(100) NOT NULL,
    documento varchar(20) UNIQUE NOT NULL,
    cep varchar(9) NOT NULL,
    estado varchar(2) NOT NULL,
    cidade varchar(100) NOT NULL,
    endereco varchar(100) NOT NULL
);

CREATE TABLE TAGS (
	id serial PRIMARY KEY NOT NULL,
	titulo varchar(50) NOT NULL
);

CREATE TABLE CADASTROS_TAGS (
	id serial PRIMARY KEY NOT NULL,
	cadastrosId integer NOT NULL,
	tagsId integer NOT NULL,
	FOREIGN KEY (cadastrosId) REFERENCES CADASTROS(id),
	FOREIGN KEY (tagsId) REFERENCES TAGS(id)
);

CREATE TABLE categorias (
	id serial PRIMARY KEY NOT NULL,
	titulo varchar(50) NOT NULL
);

CREATE TABLE LANCAMENTOS (
	id serial PRIMARY KEY NOT NULL,
	tipo varchar(10) CHECK (tipo IN ('pagar', 'receber')) NOT NULL,
	status varchar(10) CHECK (status IN ('aberto', 'liquidado')) NOT NULL,
	descricao varchar(100) NOT NULL,
	valor decimal(10,2) NOT NULL,
	valorLiquidado decimal(10,2),
	vencimento date NOT NULL,
	liquidacao date,
	cadastrosId integer,
	categoriasId integer,
	FOREIGN KEY (cadastrosId) REFERENCES CADASTROS(id),
	FOREIGN KEY (categoriasId) REFERENCES CATEGORIAS(id)
);
