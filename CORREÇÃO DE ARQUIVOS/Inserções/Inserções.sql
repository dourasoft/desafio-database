-- inserção de tags
INSERT INTO tags (titulo) VALUES 
('Cliente VIP'), ('Fornecedor'), ('Parceiro Estratégico'), 
('Inadimplente'), ('Internacional'), ('Recorrente'), 
('Novato'), ('Exclusivo'), ('Promoção'), ('Revendedor Autorizado');

-- inserção de categorias (despesas e receitas)
INSERT INTO categorias (titulo) VALUES 
-- categorias de despesas (ID 1 a 5)
('Despesas Fixas'), ('Despesas Variáveis'), ('Impostos'), 
('Serviços de Terceiros'), ('Marketing'),
-- categorias de receitas 
('Venda de Produtos'), ('Prestação de Serviços'), ('Juros Recebidos'),
('Receita de Investimentos'), ('Outras Receitas');

INSERT INTO cadastros_tags (cadastro_id, tag_id) -- Colocar cadastros_tags
SELECT 
    (floor(random() * 100) + 1)::int AS cadastro_id,
    (floor(random() * 10) + 1)::int AS tag_id
FROM generate_series(1, 150);

INSERT INTO lancamentos (tipo, status, descricao, valor, valor_liquidado, vencimento, liquidacao, cadastro_id, categoria_id)
SELECT 
    CASE WHEN random() < 0.5 THEN 'pagar' ELSE 'receber' END AS tipo,
    CASE WHEN random() < 0.5 THEN 'aberto' ELSE 'liquidado' END AS status,
    CASE
        WHEN random() < 0.17 THEN 'Pagamento de contas'
        WHEN random() < 0.33 THEN 'Pagamento de serviços'
        WHEN random() < 0.50 THEN 'Pagamento de consultoria'
        WHEN random() < 0.67 THEN 'Pagamento de recursos'
        WHEN random() < 0.83 THEN 'Pagamento de mão de obra'
        ELSE 'Pagamento de custos técnicos'
    END AS descricao,
    (random() * 1000 + 100)::numeric(15, 2) AS valor,
    NULL AS valor_liquidado,  -- Preencheremos isso mais tarde
    CURRENT_DATE + (floor(random() * 365))::int AS vencimento,
    NULL AS liquidacao,  -- Preencheremos isso mais tarde
    (floor(random() * 100) + 1)::int AS cadastro_id,
    
    -- Atribui categorias de 1 a 5 para 'pagar' e de 6 a 10 para 'receber'
    CASE 
        WHEN random() < 0.5 THEN (floor(random() * 5) + 1) 
        ELSE (floor(random() * 5) + 6) 
    END AS categoria_id

FROM generate_series(1, 1000);

-- !!!!!!!!!!!!!! Isso precisa ser atualizado DEPOIS da inserção para que tudo fique PERFEITO !!!!!!!!!!!!!!!!!!

UPDATE lancamentos
SET 
    valor_liquidado = (random() * 1000 + 100)::numeric(15, 2), -- Data de liquidação sempre no passado, além de GARANTIR que contas com status liquidado SEMPRE terão valores no valor_liquidado (mesmos deixando a coluna ser nula)
    liquidacao = CURRENT_DATE - (floor(random() * 365) + 1)::int
WHERE status = 'liquidado';

UPDATE lancamentos
SET categoria_id = (floor(random() * 5) + 6)  -- Aqui faz com que os lançamentos com tipo receber tenham as categorias relacionadas a recebimento
WHERE tipo = 'receber';

UPDATE lancamentos
SET categoria_id = (floor(random() * 5) + 1)  -- Aqui faz com que os lançamentos com tipo pagar tenham as categorias relacionadas a pagamento
WHERE tipo = 'pagar';


