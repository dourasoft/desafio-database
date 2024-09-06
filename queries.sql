--Lista de cadastros com tags
SELECT CADASTROS.nome, CADASTROS.estado, CADASTROS.cidade, TAGS.titulo
FROM cadastros
INNER JOIN CADASTROS_TAGS ON CADASTROS.id = CADASTROS_TAGS.cadastrosId
INNER JOIN TAGS ON CADASTROS_TAGS.tagsId = TAGS.id;

--Lista de receitas liquidadas em um determinado período
SELECT CADASTROS.nome, CADASTROS.documento, LANCAMENTOS.descricao, LANCAMENTOS.liquidacao, LANCAMENTOS.valorLiquidado
FROM LANCAMENTOS
LEFT JOIN CADASTROS ON CADASTROS.id = LANCAMENTOS.cadastrosId
WHERE LANCAMENTOS.tipo = 'receber' AND LANCAMENTOS.status = 'liquidado' AND LANCAMENTOS.liquidacao BETWEEN '2022-11-03' AND '2023-04-12'; 

--Total de receitas liquidadas, por categoria mensal
SELECT TO_CHAR(LANCAMENTOS.liquidacao, 'YYYY-MM') AS mes, SUM(LANCAMENTOS.valorLiquidado), CATEGORIAS.titulo
FROM LANCAMENTOS
LEFT JOIN CATEGORIAS ON LANCAMENTOS.categoriasId = CATEGORIAS.id
WHERE LANCAMENTOS.tipo = 'receber' AND LANCAMENTOS.status = 'liquidado'
GROUP BY mes, CATEGORIAS.titulo
ORDER BY mes;

--Lista de despesas em aberto
SELECT CADASTROS.nome, CADASTROS.documento, LANCAMENTOS.descricao, LANCAMENTOS.vencimento, LANCAMENTOS.valor
FROM LANCAMENTOS
LEFT JOIN CADASTROS ON LANCAMENTOS.cadastrosId = CADASTROS.id
WHERE LANCAMENTOS.tipo = 'pagar' AND LANCAMENTOS.status = 'aberto';

--Total de despesas liquidadas, por categoria mensal
SELECT TO_CHAR(LANCAMENTOS.liquidacao, 'YYYY-MM') AS mes, SUM(LANCAMENTOS.valorLiquidado), CATEGORIAS.titulo
FROM LANCAMENTOS
LEFT JOIN CATEGORIAS ON LANCAMENTOS.categoriasId = CATEGORIAS.id
WHERE LANCAMENTOS.tipo = 'pagar' AND LANCAMENTOS.status = 'liquidado'
GROUP BY mes, CATEGORIAS.titulo
ORDER BY mes;