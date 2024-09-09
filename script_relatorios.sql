--Criação relatórios--
--Lista de cadastros com tags
SELECT nome, estado, cidade, GROUP_CONCAT(t.titulo, ', ') AS tags
FROM cadastros c 
LEFT JOIN cadastros_tags ct ON c.id = ct.cadastro_id
LEFT JOIN tags t ON ct.tag_id = t.id
GROUP BY c.id;

--Lista de receitas liquidadas em um determinado período
SELECT c.nome, c.documento, l.descricao, l.liquidacao, l.valor_liquidado
FROM lancamentos l
LEFT JOIN cadastros c ON l.cadastro_id = c.id
WHERE l.status = 'liquidado' AND l.tipo = 'receber'
AND l.liquidacao BETWEEN '2024-09-01' AND '2024-09-15';

--Total de receitas liquidadas, por categoria mensal
SELECT DATE_FORMAT(l.liquidacao, '%Y-%M') AS Mes , SUM(l.valor_liquidado) AS totalReceita, c.titulo AS categoria
FROM lancamentos l
LEFT JOIN categorias c ON l.categoria_id = c.id
WHERE l.tipo = 'receber' AND l.status = 'liquidado'
GROUP BY mes, categoria
ORDER BY mes, categoria;

--Lista de despesas em aberto
SELECT c.nome, c.documento, l.descricao, l.vencimento, l.valor
FROM lancamentos l
LEFT JOIN cadastros c ON l.cadastro_id = c.id
WHERE l.status = 'aberto' AND l.tipo = 'pagar';

--Total de despesas liquidadas, por categoria mensal
SELECT DATE_FORMAT(l.liquidacao, '%Y-%M') AS Mes, c.titulo AS categoria, SUM(l.valor_liquidado) AS totalDespesa
FROM lancamentos l
LEFT JOIN categorias c ON l.categoria_id = c.id
WHERE l.tipo = 'pagar' AND l.status = 'liquidado'
GROUP BY mes, categoria
ORDER BY mes, categoria;