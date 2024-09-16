const DATA_SIZE = 100 // Se por algum acaso alguém queira aumentar a quantidade de dados criados, basta mudar essa variável.

const path = require("path")
const { fakerPT_BR } = require('@faker-js/faker') // permite que nós geremos mock data em português.
const {generate} = require('gerador-validador-cpf')
const bodyParser = require('body-parser');

const db = require("./db.js")
const dataPromise = db.getAllData() // Assim que o código começa a executar, a gente já faz requisições ao banco de dados

const port = 3000;
const express = require('express');
const app = express();
app.set('view engine', 'ejs');
app.set('views','./')
app.use(express.static(path.join(__dirname, "static")));
app.use(bodyParser.urlencoded({extended:true}));
app.use(bodyParser.json())

function setupServer(values){
    console.log("Iniciando servidor...")

    // pequena adaptação de dados antes de usá-los:


    let cadastros = values [0]
    const cadastros_tags = values[2]
    const categorias = values[3]
    let lancamentos = values[4]
    // vamos varrer a tabela cadastro_tags para traduzir os dados e maneira fácil de serem usados pelo EJS
    for(let i = 0; i < cadastros_tags.length; i++){
        const cadastro_id = cadastros_tags[i].cadastro_id // id do cadastro atual.
        if(!cadastros[cadastro_id-1].tags){
            // se ainda não foi inicializado o vetor, inicialize
            cadastros[cadastro_id-1].tags = []
        }
        cadastros[cadastro_id-1].tags.push(cadastros_tags[i].tag_id)
    }
    
    // inserir os dados das chaves estrangeiras nos objetos
    for(let i = 0; i < lancamentos.length; i++){
        // transformar o cadastro_id em nome
        lancamentos[i].cadastro = cadastros[lancamentos[i].cadastro_id - 1].nome
        // transformar o categoria_id em titulo

        lancamentos[i].categoria =  categorias[lancamentos[i].categoria_id - 1].titulo
    }
    app.get('/', (req, res) => {
        res.render('./index.ejs');
    });
    app.get('/tables', (req, res) => {
        res.render('./tables.ejs', {
            cadastros: cadastros,
            tags: values[1],
            categorias : categorias,
            lancamentos : lancamentos
        });
    });
    // Vamos fazer agora os vetores que vão alimentar o relatório 2 , partindo de 2000.
    let data = [] // cada valor nesse vetor vale um ano, que é um array de 12 vetores, cada um desses vetores tem um vetor de 10 posições, uma pra cada categoria
    
    for(let i=0;i<=24;i++){
        data.push([])
        for(let j=0; j<12; j++){
            data[i].push([])
            for(let k=0; k<10; k++){
                data[i][j].push(0)
            }
        }
    }
    // Exemplo da estrutura:
    

    // Com o vetor pronto, só precisamos populá-lo com todos os dados de lancamento.

    for(let i = 0; i<lancamentos.length; i++){
        const lancamento = lancamentos[i]
        if(lancamento.status == "Liquidado" && lancamento.tipo == "Receber"){
            let yearIndex = lancamento.liquidacao.getUTCFullYear() - 2000
            let monthIndex = lancamento.liquidacao.getUTCMonth()
            let categoriaIndex = lancamento.categoria_id - 1
            data[yearIndex][monthIndex][categoriaIndex] = data[yearIndex][monthIndex][categoriaIndex] + lancamento.valor_liquidado
        }
    }

    // Vamos fazer agora os vetores que vão alimentar o relatório 5, partindo de 2000.
    let data2 = [] // cada valor nesse vetor vale um ano, que é um array de 12 vetores, cada um desses vetores tem um vetor de 10 posições, uma pra cada categoria
    
    for(let i=0;i<=24;i++){
        data2.push([])
        for(let j=0; j<12; j++){
            data2[i].push([])
            for(let k=0; k<10; k++){
                data2[i][j].push(0)
            }
        }
    }
    // Com o vetor pronto, só precisamos populá-lo com todos os dados de lancamento.

    for(let i = 0; i<lancamentos.length; i++){
        const lancamento = lancamentos[i]
        if(lancamento.status == "Liquidado" && lancamento.tipo == "Pagar"){
            let yearIndex = lancamento.liquidacao.getUTCFullYear() - 2000
            let monthIndex = lancamento.liquidacao.getUTCMonth()
            let categoriaIndex = lancamento.categoria_id - 1
            data2[yearIndex][monthIndex][categoriaIndex] = data2[yearIndex][monthIndex][categoriaIndex] + lancamento.valor_liquidado
        }
    }

    app.get('/relatorios', (req, res) => {
        res.render('./relatorios.ejs', {
            cadastros: cadastros,
            tags: values[1],
            categorias : categorias,
            lancamentos : lancamentos,
            filtrados : [],
            data : data,
            data2 : data2
        });
    });
    app.post('/relatorios', (req, res) => {
        const data_comeco = req.body.data_comeco
        const data_fim = req.body.data_fim
        const filtrados = lancamentos.filter((lancamento)=>{
            return(Date.parse(lancamento.liquidacao)  > Date.parse(data_comeco)  && Date.parse(lancamento.liquidacao)  < Date.parse(data_fim) && lancamento.status == "Liquidado" && lancamento.tipo == "Receber")
        })
        res.render('./relatorios.ejs',{
            cadastros: cadastros,
            tags: values[1],
            categorias : categorias,
            lancamentos : lancamentos,
            filtrados : filtrados,
            data : data,
            data2: data2
        });
    });
    app.listen(port, () => {
        console.log(`Servidor rodando em http://localhost:${port}`);
    });

}

function generateDataAndStart(){
    console.log("Gerando dados...")
    let cadastros = [];
    let cadastros_tags = [];
    let lancamentos = [];

    for (let i=1; i <= DATA_SIZE; i++){
            
        // Geramos primeiro os cadastros
        let obj = []
        obj.push(i)
        obj.push(fakerPT_BR.person.fullName()) 
        obj.push(generate({ format: true })) // Gera um CPF no formato 000.000.000-00
        obj.push(`${String(100000 + Math.floor(Math.random() * 90000))}-${String(100 + Math.floor(Math.random() * 900))}`)
        obj.push(fakerPT_BR.location.state({abbreviated : true}))
        obj.push(fakerPT_BR.location.city())
        obj.push(fakerPT_BR.location.streetAddress())
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

        let availableTags = [1,2,3,4,5,6,7,8,9,10]
        for(let j=1; j <= tagsAmmount; j++){
            let cadastro_tag = []
            const randomIndex = Math.floor(Math.random() * availableTags.length + 1) // pegaremos um dos índices do vetor...
            const tag = availableTags.splice(randomIndex,1) // ...e usaremos esse índice para determinar qual tag vai ser usada nesse cadastro em específico.
            cadastro_tag.push(i)
            cadastro_tag.push(j)
            cadastros_tags.push(cadastro_tag)
        }
        // agora para os lançamentos, vou tomar liberdade para dizer que cada cadastro está em exatamente 10 lançamentos diferentes e que cada um desses lançamentos tem uma categoria distinta

        for(let j=1; j<=10; j++){
            let lancamento = []
            lancamento.push(DATA_SIZE * 10 * i + j) 
            lancamento.push(Math.random() < 0.5 ? "Pagar" : "Receber")
            const liquidado = Math.random() < 0.5
            lancamento.push(liquidado ? "Liquidado" : "Aberto")
            lancamento.push(`${fakerPT_BR.word.words(10)}`)    
            const max = Math.floor(Math.random() * 99999)
            lancamento.push(max)
            lancamento.push(liquidado ? max : Math.floor(Math.random() * max))
            const maxDate = fakerPT_BR.date.between({ from: '2000-01-01', to: Date.now()})
            lancamento.push(maxDate)
            lancamento.push(fakerPT_BR.date.between({ from: '2000-01-01', to: maxDate }))
            lancamento.push(i)
            lancamento.push(j%10 + 1)

            lancamentos.push(lancamento)
        }
    }
    
    // Com os vetores populados, basta mandarmos para o Model inserir no banco de dados
    let insertPromise = db.insertData(cadastros, cadastros_tags, lancamentos)
    insertPromise.then((promises)=>{
        Promise.all(promises).then((values)=>{
            // Depois de inserirmos os dados, vamos querer resgatá-los e iniciar o servidor.
            const dataP = db.getAllData()
            dataP.then((promises)=>{

                Promise.all(promises).then((values)=>{
                    console.log("Dados gerados.")
                    setupServer(values)
                })

            })
        })
    })
}

dataPromise.then((promises)=>{
    // dataPromise, quando resolvida, recebe um vetor de promessas
    Promise.all(promises).then(
        // Depois de resolver todas essas promessas, podemos finalmente trabalhar com os dados resgatados
        (values)=>{
            const CADASTROS = values[0]
            if(CADASTROS.length > 0){
                // Se tivermos dados em CADASTROS temos 2 casos possíveis:
                console.log("Dados já existentes.")

                if(CADASTROS.length != DATA_SIZE){
                // temos dados, mas eles não estão de acordo com DATA_SIZE, provavelmente porque alguém acabou de mudá-lo
                    console.log("Mas em quantidade incorreta. Apagando dados...")
                    let deletePromise = db.deleteData()
                    deletePromise.then((promises)=>{
                        Promise.all(promises).then((values)=>{
                            // Efetuamos as exclusões, agora vamos efetuar as inserções e iniciar o servidor.
                            console.log("Exclusão concluída.")
                            generateDataAndStart()
                        })
                    })
                }else{
                    // temos dados em quantidade certa, o que significa que já efetuamos a criação aleatória de dados e podemos executar o servidor.
                    console.log("E em quantidade correta.")
                    setupServer(values)
                }

            }else{
                // Se NÃO tivermos dados em CADASTROS, temos que gerar esses dados.
                generateDataAndStart()
            }
    
        })
})