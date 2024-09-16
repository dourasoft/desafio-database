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
                var sql = "INSERT INTO cadastros (id, nome, documento, cep, estado, cidade, endereco) VALUES ?";
                con.query(sql, [cadastros], function (err, result) {
                    if (err) throw err;
                    console.log("Cadastros inseridos: " + result.affectedRows);
                });
                res()
            }))

            promises.push(new Promise((res,rej)=>{
                var sql = "INSERT INTO cadastros_tags (cadastro_id, tag_id) VALUES ?";
                con.query(sql, [cadastros_tags], function (err, result) {
                    if (err) throw err;
                    console.log("Cadastros_tags inseridos: " + result.affectedRows);
                });
                res()
            }))

            promises.push(new Promise((res,rej)=>{
                var sql = "INSERT INTO lancamentos (id, tipo, status, descricao, valor, valor_liquidado, vencimento, liquidacao, cadastro_id, categoria_id) VALUES ?";
                con.query(sql, [lancamentos], function (err, result) {
                    if (err) throw err;
                    console.log("Lancamentos inseridos: " + result.affectedRows);
                });
                res()
            }))
            // Só resolve depois de popular o vetor de promessas
            res(promises)
        });
    })
    // Esse código retorna uma promessa, para que o app.js espere apropriadamente
    // as requisições ao banco de dados.
    return p
}


exports.deleteData = function(){
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
            console.log("Conectado para ler!");
    
            promises.push(new Promise((res,rej)=>{
                con.query("DELETE FROM LANCAMENTOS", function (err, result, fields) {
                    if (err) throw err;
                    res(result)
                });
            }))

            promises.push(new Promise((res,rej)=>{
                con.query("DELETE FROM CADASTROS_TAGS", function (err, result, fields) {
                    if (err) throw err;
                    res(result)
                });
            }))

            promises.push(new Promise((res,rej)=>{
                con.query("DELETE FROM CADASTROS", function (err, result, fields) {
                    if (err) throw err;
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
