const DATA_SIZE = 10 // Se por algum acaso alguém queira aumentar a quantidade de dados criados, basta mudar essa variável.

const { fakerPT_BR } = require('@faker-js/faker') // permite que nós geremos mock data em português.
const {generate} = require('gerador-validador-cpf')

const db = require("./db.js")
const dataPromise = db.getAllData() // Assim que o código começa a executar, a gente já faz requisições ao banco de dados

const PORT = 3000;
const express = require('express');
const app = express();
app.set('view engine', 'ejs');
app.set('views','./')

dataPromise.then((promises)=>{
    // dataPromise, quando resolvida, recebe um vetor de promessas
    Promise.all(promises).then(
        // Depois de resolver todas essas promessas, podemos finalmente trabalhar com os dados resgatados
        (values)=>{

        console.log(values)
        const CADASTROS = values[0]

        if(CADASTROS.length > 0){
            // Se tivermos dados em CADASTROS, significa que já efetuamos a criação aleatória de dados
            const TAGS = values[1]
            const CADASTROS_TAGS = values[2]
            const CATEGORIAS = values[3]
            const LANCAMENTOS = values[4]
    
            app.get('/', (req, res) => {
                res.render('./index.ejs', {
                    cadastros: CADASTROS,
                    tags: TAGS,
                    cadastros_tags: CADASTROS_TAGS, // esse cara não tem tabela própria
                    categorias : CATEGORIAS,
                    lancamentos : LANCAMENTOS
                });
            });
            
            // Start the server
            const port = 3000;
            app.listen(port, () => {
                console.log(`Server is running on http://localhost:${port}`);
            });

        }else{
            // Senão, temos que faze-la.
            let cadastros = [];
            let cadastros_tags = [];
            let lancamentos = [];

            for (let i=0; i < DATA_SIZE; i++){
                 
                // Geramos primeiro os cadastros
                let obj = {}
                obj.id = i
                obj.nome = fakerPT_BR.person.fullName()
                obj.documento = generate({ format: true }) // Gera um CPF no formato 000.000.000-00
                obj.cep =  `${String(100000 + Math.floor(Math.random() * 90000))}-${String(100 + Math.floor(Math.random() * 900))}`
                obj.endereco = fakerPT_BR.location.streetAddress()
                cadastros.push(obj)

                // vamos determinar quantas tags o cadastro vai ter. (65% de chance de ter 1, 20% de ter 2, 10% de ter 3 e 5% de ter 4)
                
                let tagsAmmount = Math.floor(Math.random() * 101)
                
                if(tagsAmmount <= 65){
                    tagsAmmount = 1
                }else if(tagsAmmount <= 85){
                    tagsAmmount = 2
                }else if(tagsAmmount <= 95){
                    tagsAmmount = 3
                }else{
                    tagsAmmount = 4
                }

                // vamos inserir suas tags agora.

                const availableTags = [1,2,3,4,5,6,7,8,9,10]
                for(let j=1; j <= tagsAmmount; j++){
                    const randomIndex = Math.floor(Math.random() * availableTags.length + 1) // pegaremos um dos índices do vetor...
                    const tag = availableTags.splice(randomIndex,1) // ...e usaremos esse índice para determinar qual tag vai ser usada nesse cadastro em específico.
                    cadastros_tags.push({cadastro_id : i, tag_id : j}) 
                }
                // agora para os lançamentos, vou tomar liberdade para dizer que cada cadastro está em exatamente 10 lançamentos diferentes e que cada um desses lançamentos tem uma categoria distinta

                for(let j=0; j<10; j++){
                    let lancamento = []
                    lancamento.id = Number(String(i) + String(j)) 
                    lancamento.tipo = Math.random() < 0.5 ? "Pagar" : "Receber"
                    const liquidado = Math.random() < 0.5
                    lancamento.status = liquidado ? "Liquidado" : "Aberto"
                    lancamento.descricao = `${fakerPT_BR.word.words(10)}}`    
                    const max = Math.floor(Math.random() * 99999)
                    lancamento.valor = max
                    lancamento.valor_liquidado = liquidado ? max : Math.floor(Math.random() * max)
                    const maxDate = fakerPT_BR.date.between({ from: '2000-01-01', to: Date.now() });
                    lancamento.vencimento = maxDate
                    lancamento.liquidacao = fakerPT_BR.date.between({ from: '2000-01-01', to: maxDate });
                    lancamento.cadastro_id = i
                    lancamento.categoria_id = j

                    lancamentos.push(lancamento)
                }
            }
            
            // Com os vetores populados, basta mandarmos para o Model inserir no banco de dados
            let insertPromise = db.insertData(cadastros, cadastros_tags, lancamentos)
            insertPromise.then((promises)=>{
                Promise.all(promises).then((values)=>{
                    console.log(values)
                })
            })
        }
    })
})