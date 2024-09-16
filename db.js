exports.getAllData = function(){
    // retorna todos os dados

    var mysql = require('mysql');
    var con = mysql.createConnection({
        host: "localhost",
        user: "root",
        password: "password",
        database: "Teste"
    });

    let promises = []
    let CADASTROS;
    let TAGS;
    let CADASTROS_TAGS;
    let CATEGORIAS;
    let LANCAMENTOS;
    let p = new Promise((res,rej)=>{
        con.connect(function(err) {
            if (err) throw err;
            console.log("Conectado para ler!");
    
            promises.push(new Promise((res,rej)=>{
                con.query("SELECT * FROM CADASTROS", function (err, result, fields) {
                    if (err) throw err;
                    CADASTROS = result
                    res(result)
                });
            }))
            promises.push(new Promise((res,rej)=>{
                con.query("SELECT * FROM TAGS", function (err, result, fields) {
                    if (err) throw err;
                    TAGS = result
                    res(result)
                });
            }))
            promises.push(new Promise((res,rej)=>{
                con.query("SELECT * FROM CADASTROS_TAGS", function (err, result, fields) {
                    if (err) throw err;
                    CADASTROS_TAGS = result
                    res(result)
                });
            }))
            promises.push(new Promise((res,rej)=>{
                con.query("SELECT * FROM CATEGORIAS", function (err, result, fields) {
                    if (err) throw err;
                    CATEGORIAS = result
                    res(result)
                });
            }))
            promises.push(new Promise((res,rej)=>{
                con.query("SELECT * FROM LANCAMENTOS", function (err, result, fields) {
                    if (err) throw err;
                    LANCAMENTOS = result
                    res(result)
                });
            }))
            // Só resolve depois de popular o vetor de promessas
            res(promises)
        });
    })
    // Esse código retorna uma promessa, para que o app.js espere apropriadamente
    // as requisições ao banco de dados.
    return p
}

exports.insertData = function(cadastros,cadastros_tags,lancamentos){
    // retorna todos os dados

    var mysql = require('mysql');
    var con = mysql.createConnection({
        host: "localhost",
        user: "root",
        password: "password",
        database: "Teste"
    });

    let promises = []

    let p = new Promise((res,rej)=>{
        con.connect(function(err) {
            if (err) throw err;
            console.log("Conectado para inserir!");
    
            promises.push(new Promise((res,rej)=>{
                var sql = "INSERT INTO cadastros VALUES ?";
                console.log(cadastros)
                con.query(sql, cadastros, function (err, result) {
                    if (err) throw err;
                    console.log("Number of records inserted: " + result.affectedRows);
                });
                res("Oie")
            }))
            
            // Só resolve depois de popular o vetor de promessas
            res(promises)
        });
    })
    // Esse código retorna uma promessa, para que o app.js espere apropriadamente
    // as requisições ao banco de dados.
    return p
}