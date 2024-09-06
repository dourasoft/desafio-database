-- Lista de cadastros com tags
SELECT cad.nome, cad.estado, cad.cidade, STRING_AGG(t.titulo, ', ') AS tags
FROM cadastros cad
LEFT JOIN cadastros_tags ct ON cad.id = ct.cadastro_id
LEFT JOIN tags t ON ct.tag_id = t.id
GROUP BY cad.nome, cad.estado, cad.cidade;

-- Lista de receitas liquidadas em um determinado período
SELECT cad.nome, cad.documento, l.descricao, l.liquidacao, l.valor_liquidado
FROM lancamentos l
LEFT JOIN cadastros cad ON l.cadastro_id = cad.id
WHERE l.tipo = 'receber'
AND l.status = 'liquidado'
AND l.liquidacao BETWEEN '2024-01-01' AND '2024-12-31';

-- Total de receitas liquidadas, por categoria mensal
SELECT TO_CHAR(l.liquidacao, 'YYYY-MM') AS mes,
       cat.titulo AS categoria,
       SUM(l.valor_liquidado) AS total_receitas
FROM lancamentos l
LEFT JOIN categorias cat ON l.categoria_id = cat.id
WHERE l.tipo = 'receber'
AND l.status = 'liquidado'
GROUP BY mes, cat.titulo
ORDER BY mes, cat.titulo;

-- Lista de despesas em aberto
SELECT cad.nome, cad.documento, l.descricao, l.vencimento, l.valor
FROM lancamentos l
LEFT JOIN cadastros cad ON l.cadastro_id = cad.id
WHERE l.tipo = 'pagar'
AND l.status = 'aberto';

-- Total de despesas liquidadas, por categoria mensal
SELECT TO_CHAR(l.liquidacao, 'YYYY-MM') AS mes,
       cat.titulo AS categoria,
       SUM(l.valor_liquidado) AS total_despesas
FROM lancamentos l
LEFT JOIN categorias cat ON l.categoria_id = cat.id
WHERE l.tipo = 'pagar'
AND l.status = 'liquidado'
AND l.categoria_id BETWEEN 1 AND 5
GROUP BY mes, cat.titulo
ORDER BY mes, cat.titulo;
