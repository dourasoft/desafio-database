// importando a biblioteca faker
const { faker } = require('@faker-js/faker');
const fs = require('fs');

//array para armazenar os cadastros
const cadastros =[];

for (let i = 0; i < 100; i++) {
    const cadastro = {
        id: i + 1, 
        nome: faker.name.fullName(), 
        documento: faker.datatype.number({ min: 10000000000, max: 99999999999999 }).toString(),  
        cep: faker.address.zipCode('#####-###'), 
        estado: faker.address.stateAbbr(),
        cidade: faker.address.city(), 
        endereco: faker.address.streetAddress(), 
    };
    cadastros.push(cadastro);
}

fs.writeFileSync('cadastros.json',JSON.stringify(cadastros, null, 2));

console.log('Arquivo JSON gerado com sucesso');