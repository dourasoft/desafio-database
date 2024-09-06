const fs = require('fs');
const { Client } = require('pg');

// Configuração do cliente PostgreSQL
const client = new Client({
    user: 'postgres',
    host: 'localhost',
    database: 'desafio-database',
    password: 'maria0722',
    port: 5432,
});

client.connect();

const importarCadastros = async () => {
    const cadastros = JSON.parse(fs.readFileSync('cadastros.json', 'utf8'));

    for (const cadastro of cadastros) {
        const query = `
            INSERT INTO cadastros (id, nome, documento, cep, estado, cidade, endereco)
            VALUES ($1, $2, $3, $4, $5, $6, $7)
        `;
        const values = [
            cadastro.id,
            cadastro.nome,
            cadastro.documento,
            cadastro.cep,
            cadastro.estado,
            cadastro.cidade,
            cadastro.endereco,
        ];

        await client.query(query, values);
    }

    console.log('Dados do JSON importados com sucesso.');
    client.end();
};

importarCadastros();
