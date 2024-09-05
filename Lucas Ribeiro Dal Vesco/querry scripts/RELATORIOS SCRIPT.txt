--primeiro relatorio
SELECT cadastros.nome, cadastros.estado, cadastros.cidade, tags.titulo AS tag
FROM cadastros_tags
INNER JOIN cadastros ON cadastros_tags.fk_cadastro = cadastroID
INNER JOIN tags ON cadastros_tags.fk_tag = tagID;

--segundo relatorio
Select cadastros.nome, cadastros.documento, lancamentos.descricao, lancamentos.liquidacao, lancamentos.valor_liquidado FROM lancamentos
LEFT JOIN cadastros ON lancamentos.fk_cadastro = cadastros.cadastroID
WHERE lancamentos.status = 'liquidado'
AND lancamentos.liquidacao BETWEEN '2023-01-01' AND '2023-12-31';

--terceiro relatorio
SELECT 
    TO_CHAR(lancamentos.liquidacao, 'YYYY-MM') AS mes,
    categorias.titulo AS categoria,
    SUM(lancamentos.valor_liquidado) AS total_receitas
FROM 
    lancamentos
INNER JOIN 
    categorias ON lancamentos.fk_categoria = categorias.categoriaID
WHERE 
    lancamentos.status = 'liquidado'
    AND lancamentos.tipo = 'receber'
GROUP BY 
    TO_CHAR(lancamentos.liquidacao, 'YYYY-MM'),
    categorias.titulo
ORDER BY 
    mes,
    categoria;

--quarto relatorio
SELECT 
    cadastros.nome,
    cadastros.documento,
    lancamentos.descricao,
    lancamentos.vencimento,
    lancamentos.valor
FROM 
    lancamentos
LEFT JOIN 
    cadastros ON lancamentos.fk_cadastro = cadastros.cadastroID
WHERE 
    lancamentos.status = 'aberto'
    AND lancamentos.tipo = 'pagar';
	
--quinto relatorio
SELECT 
    TO_CHAR(lancamentos.liquidacao, 'YYYY-MM') AS mes,
    categorias.titulo AS categoria,
    SUM(lancamentos.valor_liquidado) AS total_despesas
FROM 
    lancamentos
JOIN 
    categorias ON lancamentos.fk_categoria = categorias.categoriaID
WHERE 
    lancamentos.status = 'liquidado'
    AND lancamentos.tipo = 'pagar'
GROUP BY 
    TO_CHAR(lancamentos.liquidacao, 'YYYY-MM'),
    categorias.titulo
ORDER BY 
    mes,
    categoria;