#CRIACAO DO BANCO E TABELAS
create database Desafio;
use desafio;

create table cadastros(
	id int primary key auto_increment,
    nome varchar(50) not null,
    documento bigint not null,
    cep int not null,
    estado varchar(50) not null,
    cidade varchar(50) not null,
    endereco varchar(50) not null
);
create table tags(
	id int primary key auto_increment,
    Titulo varchar(50) not null
);

create table Cadastros_tags(
	cadastro_id int,
    tag_id int,
    foreign key (cadastro_id) references cadastros(id),
    foreign key (tag_id) references tags(id)
);
create table categorias(
	id int primary key auto_increment,
    titulo varchar(50) not null
);
create table lancamentos(
	id int primary key auto_increment,
    tipo enum ('pagar', 'receber') not null,
    status enum('aberto', 'liquidado') not null,
    descricao varchar(100) not null,
    valor decimal(10,2),
    valor_liquidado decimal(10,2),
    vencimento date,
    liquidacao date,
    cadastro_id int,
    categoria_id int,
    foreign key (cadastro_id) references cadastros(id),
    foreign key (categoria_id) references categorias(id) 
);

#INSERÇÃO DE DADOS NAS TABELAS
    
DELIMITER $$
create procedure InserirCadastrosAleatórios()
begin
    declare i int default 0;
    while i < 100 do
        insert into  cadastros (Nome, Documento, Cep, Estado, Cidade, Endereco)
        values (
            concat('Cliente_', floor(rand() * 1000)),         
            floor(rand() * 1000000000),                     
            floor(10000000 + (rand() * 89999999)),          
            'MS',                                           
            'Fátima do Sul',                                   
            concat('Rua ', floor(rand() * 100))             
        );
        set i = i + 1; 
    end while;
end $$
DELIMITER ;
call InserirCadastrosAleatórios();

insert into tags (titulo) values
    ('Financeiro'),
    ('Contas a Pagar'),
    ('Contas a Receber'),
    ('Liquidadas'),
    ('Abertas'),
    ('Urgente'),
    ('Normal'),
    ('Pendente'),
    ('Parcelado'),
    ('À Vista');
    
insert into categorias (titulo) values
    ('Contas a Pagar'),
    ('Contas a Receber'),
    ('Impostos'),
    ('Despesas Fixas'),
    ('Despesas Variáveis'),
    ('Receitas Operacionais'),
    ('Receitas Não Operacionais'),
    ('Empréstimos'),
    ('Investimentos'),
    ('Salários');
DELIMITER $$
CREATE PROCEDURE InserirRelacoesAleatorias()
BEGIN
    DECLARE i INT DEFAULT 0;
    WHILE i < 100 DO
        INSERT INTO cadastros_tags (cadastro_id, tag_id)
        VALUES (
            (SELECT id FROM cadastros ORDER BY RAND() LIMIT 1),
            (SELECT id FROM categorias ORDER BY RAND() LIMIT 1)
        );
        SET i = i + 1;
    END WHILE;
END $$
DELIMITER ;
CALL InserirRelacoesAleatorias();
DELIMITER $$
create procedure InserirLancamentosAleatorios()
begin
    declare i int default 0;
    declare tipo enum('pagar', 'receber');
    declare status enum('aberto', 'liquidado');
    
    while i < 1000 do
        set tipo = if(RAND() < 0.5, 'pagar', 'receber');
        set status = if(RAND() < 0.5, 'aberto', 'liquidado');

        insert into lancamentos (
            tipo, status, descricao, valor, valor_liquidado, vencimento, liquidacao, cadastro_id, categoria_id
        )
		values(
            tipo, status, 
            concat('Lançamento_', floor(rand() * 10000)),  
            floor(100 + (rand() * 1000)),                   
            if(status = 'liquidado', floor((rand() * 1000)), null),
            curdate() + interval floor(rand() * 60) day,
            if(status = 'liquidado', curdate(), null),
            (SELECT id FROM cadastros ORDER BY RAND()LIMIT 1),
            (SELECT id FROM categorias ORDER BY RAND()LIMIT 1)
        );
        
        set i = i + 1;
    end while;
end $$
DELIMITER ;
call InserirLancamentosAleatorios();

#SELEÇÃO DE DADOS DAS TABELAS
#1
select c.nome, c.estado, c.cidade, t.titulo from cadastros c
join cadastros_tags ct on c.id = ct.cadastro_id 
join tags t on ct.tag_id = t.id;

#2
select c.nome,c.documento,l.descricao,l.liquidacao,l.valor_liquidado from lancamentos l
join cadastros c on l.cadastro_id = c.id
where l.tipo = 'receber' and status = 'liquidado' and l.liquidacao 
between '2024-01-01' and '2024-12-31';

#3
select DATE_FORMAT(l.liquidacao,'%Y-%m') as mes,
	   cat.titulo as categoria,
       SUM(l.valor_liquidado) as total_receitas
from lancamentos l join categorias cat on l.categoria_id = cat.id
where l.tipo = 'receber' and l.status = 'liquidado'
group by mes, categoria;

#4
select c.nome,c.documento,l.descricao,l.vencimento,l.valor from lancamentos l
join cadastros c on l.cadastro_id = c.id
where l.tipo = 'pagar' and l.status = 'aberto';

#5
select DATE_FORMAT(l.liquidacao,'%Y-%m') as mes,
	   cat.titulo as categoria,
       SUM(l.valor_liquidado) as total_despesas
from lancamentos l join categorias cat on l.categoria_id = cat.id
where l.tipo = 'pagar' and l.status = 'liquidado'
group by mes, categoria;











 






    



