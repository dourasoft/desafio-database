
-- 1-Lista de cadastros com tags:
SELECT
    cadastros.nome,
    cadastros.estado,
    cadastros.cidade,
    GROUP_CONCAT(tags.titulo SEPARATOR ', ') AS tags
FROM
    cadastros
JOIN
    cadastros_tags ON cadastros.id = cadastros_tags.cadastro_id
JOIN
    tags ON cadastros_tags.tag_id = tags.id
GROUP BY
    cadastros.id, cadastros.nome, cadastros.estado, cadastros.cidade;

-- 2-Lista de receitas liquidadas em um determinado período:
SELECT
    cadastros.nome,
    cadastros.documento,
    lancamentos.descricao,
    lancamentos.liquidacao,
    lancamentos.valor_liquidado
FROM
    lancamentos
JOIN
    cadastros ON lancamentos.cadastro_id = cadastros.id
WHERE
    lancamentos.tipo = 'receber'        
    AND lacamentos.status = 'liquidado'
    AND lancamentos.liquidacao BETWEEN '2023-01-01' AND '2023-12-28';  

-- 3-Total de receitas liquidadas, por categoria mensal:
SELECT
    EXTRACT(MONTH FROM lancamentos.liquidacao) AS mes,
    categorias.titulo AS categoria,
    SUM(lancamentos.valor_liquidado) AS total_receitas
FROM
    lancamentos
JOIN
    categorias  ON lancamentos.categoria_id = categorias.id
WHERE
    lancamentos.tipo = 'receber'
    AND lancamentos.status = 'liquidado'
GROUP BY
	mes, categorias.titulo
ORDER BY
    mes, categorias.titulo;

-- 4-Lista de despesas em aberto:
SELECT
    cadastros.nome,
    cadastros.documento,
    lancamentos.descricao,
    lancamentos.vencimento,
    lancamentos.valor
FROM
    lancamentos 
LEFT JOIN
    cadastros  ON lancamentos.cadastro_id = cadastros.id
WHERE
    lancamentos.tipo = 'pagar'
    AND lancamentos.status = 'aberto';

-- 5-Total de despesas liquidadas, por categoria mensal:
SELECT
    EXTRACT(MONTH FROM lancamentos.liquidacao) AS mes,
    categorias.titulo AS categoria,
    SUM(lancamentos.valor_liquidado) AS total_receitas
FROM
    lancamentos
JOIN
    categorias  ON lancamentos.categoria_id = categorias.id
WHERE
    lancamentos.tipo = 'pagar'
    AND lancamentos.status = 'liquidado'
GROUP BY
	mes, categorias.titulo
ORDER BY
    mes, categorias.titulo;