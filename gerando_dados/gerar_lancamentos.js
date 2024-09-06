const { Client } = require('pg');
const { faker } = require('@faker-js/faker');

const client = new Client({
    user: 'postgres',
    host: 'localhost',
    database: 'desafio-database',
    password: 'maria0722',
    port: 5432,
});

client.connect();

const tipos = ['pagar', 'receber'];
const statusOpcao = ['aberto','liquidado'];

const gerarLancamentos = async () => {
    for (let i = 0; i < 1000; i++){
        const tipo = faker.helpers.arrayElement(tipos);
        const status = faker.helpers.arrayElement(statusOpcao);
        const descricao = faker.commerce.productDescription();
        const valor = parseFloat(faker.finance.amount(100, 10000, 2));
        const valorLiquidado = parseFloat(faker.finance.amount(100, 10000, 2));
        const vencimento = faker.date.between('2024-01-01', '2024-12-31');
        const liquidacao = status === 'liquidado' ? faker.date.between(vencimento, '2024-12-31') : null;
        const cadastro_id = faker.datatype.boolean() ? faker.datatype.number({ min: 1, max: 100 }) : null;
        const categoria_id = faker.datatype.boolean() ? faker.datatype.number({ min: 1, max: 10 }) : null;

        await client.query(
            'INSERT INTO lancamentos (tipo, status, descricao, valor, valor_liquidado, vencimento, liquidacao, cadastro_id, categoria_id) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9)',
            [tipo, status, descricao, valor, valorLiquidado, vencimento, liquidacao, cadastro_id, categoria_id]
        );
    }

    console.log('Laçamentos gerados com sucesso');
};

gerarLancamentos().then(() => client.end());