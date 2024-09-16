create database Teste;
use Teste;

create table Cadastros (
id int primary key,
nome varchar(255),
documento char(14),
cep char(10),
estado char(2),
cidade varchar(55),
endereco varchar(255)
);

create table Tags (
id int primary key,
titulo varchar(255)
);

Insert into Tags Values (1,"Azul");
Insert into Tags Values (2,"Rosa");
Insert into Tags Values (3,"Vermelha");
Insert into Tags Values (4,"Roxa");
Insert into Tags Values (5,"Verde");
Insert into Tags Values (6,"Amarela");
Insert into Tags Values (7,"Cinza");
Insert into Tags Values (8,"Branca");
Insert into Tags Values (9,"Preta");
Insert into Tags Values (10,"Marrom");

create table Cadastros_Tags (
cadastro_id int,
tag_id int,
foreign key (cadastro_id) references Cadastros(id),
foreign key (tag_id) references Tags(id)
);

create table Categorias (
id int primary key,
titulo varchar(255)
);

Insert into Categorias Values (1,"Categoria 1");
Insert into Categorias Values (2,"Categoria 2");
Insert into Categorias Values (3,"Categoria 3");
Insert into Categorias Values (4,"Categoria 4");
Insert into Categorias Values (5,"Categoria 5");
Insert into Categorias Values (6,"Categoria 6");
Insert into Categorias Values (7,"Categoria 7");
Insert into Categorias Values (8,"Categoria 8");
Insert into Categorias Values (9,"Categoria 9");
Insert into Categorias Values (10,"Categoria 10");


create table Lancamentos (
id int primary key,
tipo ENUM('Pagar','Receber'),
status ENUM('Aberto','Liquidado'),
descricao char(255),
valor float,
valor_liquidado float,
vencimento date,
liquidacao date,
cadastro_id int,
categoria_id int,
foreign key (cadastro_id) references Cadastros(id),
foreign key (categoria_id) references Categorias(id)
);
