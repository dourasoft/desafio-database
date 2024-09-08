-- Lista de cadastros com tags: --

select c.nome, c.estado, c.cidade, t.titulo
from Cadastros AS c JOIN cadastros_tags as ct ON c.id = ct.cadastro_id JOIN tagss AS t ON ct.tags_id = t.id
ORDER BY c.nome;

-- Lista de receitas liquidadas em um determinado período: --

select c.nome, c.documento, l.descricao, l.liquidacao, l.valor_liquidado
from lancamentos as l LEFT JOIN Cadastros as c ON l.cadastro_id = c.id
;

-- Total de receitas liquidadas, por categoria mensal: --

SELECT c.titulo AS categoria, DATE_FORMAT(l.vencimento, '%Y-%m') AS mes,
    SUM(l.valor) AS total
FROM lancamentos AS l JOIN categorias AS c ON l.categorias_id = c.id
WHERE l.vencimento IS NOT NULL
GROUP BY c.titulo, DATE_FORMAT(l.vencimento, '%Y-%m')
ORDER BY mes, categoria;

-- Lista de despesas em aberto: --

select c.nome, c.documento, l.descricao, l.vencimento, l.valor
from lancamentos as l LEFT JOIN Cadastros as c ON l.cadastro_id = c.id;

-- Total de despesas liquidadas, por categoria mensal: --

select c.titulo as categoria, DATE_FORMAT(l.vencimento, '%Y-%m') AS mes, SUM(l.valor) AS total
from lancamentos as l JOIN categorias as c ON l.categorias_id = c.id
WHERE l.vencimento IS NOT NULL AND l.status = 'Pago'
GROUP BY l.status, DATE_FORMAT(l.vencimento, '%Y-%m')
ORDER BY mes, categoria;
