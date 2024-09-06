package main

import (
	"fmt"
	"math/rand"
	"os"

	//"os"
	"strconv"
)

// cadastros

func GerarNome() string {
	nomes := []string{"Lucas", "Maria", "João", "Ana", "Pedro", "Fernanda", "Bruno", "Camila", "Gustavo", "Isabela"}
	sobrenomes := []string{"Silva", "Oliveira", "Souza", "Pereira", "Costa", "Gomes", "Martins", "Almeida", "Barbosa", "Ferreira"}
	return nomes[rand.Intn(len(nomes))] + " " + sobrenomes[rand.Intn(len(sobrenomes))]
}

func GerarCNPJ() string { // gera um cnpj seguindo a regra de validação
	chaveValidadoraUm := []int{5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2}
	chaveValidadoraDois := []int{6, 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3}
	numeros := [][]int{
		{rand.Intn(9), rand.Intn(9), rand.Intn(9), rand.Intn(9), rand.Intn(9), rand.Intn(9), rand.Intn(9), rand.Intn(9), 0, 0, 0, 1},
		{rand.Intn(9), rand.Intn(9), rand.Intn(9), rand.Intn(9), rand.Intn(9), rand.Intn(9), rand.Intn(9), rand.Intn(9), 0, 0, 0, 2},
	}
	valorCNPJ := numeros[rand.Intn(len(numeros))]
	validaum := 0
	validadois := 0
	// primeiro numero validador
	for i := 0; i < len(chaveValidadoraUm); i++ {
		validaum += valorCNPJ[i] + chaveValidadoraUm[i]
	}
	validaum = validaum % 11
	if validaum > 1 {
		validaum = 11 - validaum
	} else {
		validaum = 0
	}
	//segundo numero validador
	for i := 0; i < len(chaveValidadoraDois); i++ {
		validadois += valorCNPJ[i] + chaveValidadoraDois[i]
	}
	validadois += validaum * 2
	validadois = validadois % 11
	if validadois > 1 {
		validadois = 11 - validadois
	} else {
		validadois = 0
	}
	return strconv.Itoa(valorCNPJ[0]) + strconv.Itoa(valorCNPJ[1]) + "." +
		strconv.Itoa(valorCNPJ[2]) + strconv.Itoa(valorCNPJ[3]) + strconv.Itoa(valorCNPJ[4]) + "." +
		strconv.Itoa(valorCNPJ[5]) + strconv.Itoa(valorCNPJ[6]) + strconv.Itoa(valorCNPJ[7]) + "/" +
		strconv.Itoa(valorCNPJ[8]) + strconv.Itoa(valorCNPJ[9]) + strconv.Itoa(valorCNPJ[10]) + strconv.Itoa(valorCNPJ[11]) + "-" +
		strconv.Itoa(validaum) + strconv.Itoa(validadois)
}

func GerarCPF() string { //gera um cpf seguindo a regra de validação
	numeros := []int{rand.Intn(9), rand.Intn(9), rand.Intn(9), rand.Intn(9), rand.Intn(9), rand.Intn(9), rand.Intn(9), rand.Intn(9), rand.Intn(9)}
	var validaum int
	var validadois int
	// primeiro numero validador
	for i := 0; i < 9; i++ {
		validaum += numeros[i] * (10 - i)
	}
	validaum = (validaum * 10) % 11
	if validaum == 10 {
		validaum = 0
	}
	// segundo numero validador
	for i := 0; i < 9; i++ {
		validadois += numeros[i] * (11 - i)
	}
	validadois += validaum * 2
	validadois = (validadois * 10) % 11
	if validadois == 10 {
		validadois = 0
	}
	return strconv.Itoa(numeros[0]) + strconv.Itoa(numeros[1]) + strconv.Itoa(numeros[2]) + "." +
		strconv.Itoa(numeros[3]) + strconv.Itoa(numeros[4]) + strconv.Itoa(numeros[5]) + "." +
		strconv.Itoa(6) + strconv.Itoa(7) + strconv.Itoa(8) + "-" +
		strconv.Itoa(validaum) + strconv.Itoa(validadois)
}

func GerarDocumento() string {
	if rand.Intn(99) < 50 {
		return GerarCPF()
	} else {
		return GerarCNPJ()
	}
}

func GerarCep() string {
	cincoNumeros := []string{
		"12345", "67890", "54321", "98765", "11223", "33445", "55667", "77889", "99000", "11122",
		"22334", "44556", "66778", "88990", "10101", "20202", "30303", "40404", "50505", "60606",
		"70707", "80808", "90909", "12121", "23232", "34343", "45454", "56565", "67676", "78787",
		"89898", "91919", "92929", "93939", "94949", "95959", "96969", "97979", "98989", "99999",
	}
	tresNumeros := []string{
		"001", "002", "003", "004", "005", "006", "007", "008", "009", "010",
		"011", "012", "013", "014", "015", "016", "017", "018", "019", "020",
		"021", "022", "023", "024", "025", "026", "027", "028", "029", "030",
		"031", "032", "033", "034", "035", "036", "037", "038", "039", "040",
	}
	return cincoNumeros[rand.Intn(len(cincoNumeros))] + "-" + tresNumeros[rand.Intn(len(tresNumeros))]
}

func GerarCidade() string {
	//somente cidades do MS
	cidadesMS := []string{
		"Água Clara", "Alcinópolis", "Amambai", "Anastácio", "Anaurilândia", "Angélica",
		"Antônio João", "Aparecida do Taboado", "Aquidauana", "Aral Moreira", "Bandeirantes",
		"Bataguassu", "Bataiporã", "Bela Vista", "Bodoquena", "Bonito", "Brasilândia",
		"Caarapó", "Camapuã", "Campo Grande", "Caracol", "Cassilândia", "Chapadão do Sul",
		"Corguinho", "Coronel Sapucaia", "Corumbá", "Costa Rica", "Coxim", "Deodápolis",
		"Dois Irmãos do Buriti", "Douradina", "Dourados", "Eldorado", "Fátima do Sul",
		"Figueirão", "Glória de Dourados", "Guia Lopes da Laguna", "Iguatemi", "Inocência",
		"Itaporã", "Itaquiraí", "Ivinhema", "Japorã", "Jaraguari", "Jardim", "Jateí",
		"Juti", "Ladário", "Laguna Carapã", "Maracaju", "Miranda", "Mundo Novo", "Naviraí",
		"Nioaque", "Nova Alvorada do Sul", "Nova Andradina", "Novo Horizonte do Sul",
		"Paranaíba", "Paranhos", "Pedro Gomes", "Ponta Porã", "Porto Murtinho", "Ribas do Rio Pardo",
		"Rio Brilhante", "Rio Negro", "Rio Verde de Mato Grosso", "Rochedo", "Santa Rita do Pardo",
		"São Gabriel do Oeste", "Selvíria", "Sete Quedas", "Sidrolândia", "Sonora",
		"Tacuru", "Taquarussu", "Terenos", "Três Lagoas", "Vicentina",
	}
	return cidadesMS[rand.Intn(len(cidadesMS))]
}

func GerarEndereco() string {
	ruas := []string{
		"Rua das Flores", "Rua do Sol", "Avenida Central", "Rua das Palmeiras", "Rua Primavera",
		"Avenida dos Ipês", "Rua do Campo", "Rua São José", "Rua Santa Maria", "Rua Bela Vista",
		"Avenida Paulista", "Rua Dom Pedro", "Rua Marechal Deodoro", "Rua Nova Esperança", "Rua das Acácias",
		"Avenida Brasil", "Rua dos Girassóis", "Rua da Paz", "Rua Santos Dumont", "Rua da Liberdade",
		"Rua da Independência", "Avenida Boa Vista", "Rua São João", "Rua Rio Branco", "Rua Getúlio Vargas",
		"Rua Presidente Kennedy", "Rua Tiradentes", "Rua 7 de Setembro", "Avenida Atlântica", "Rua São Paulo",
		"Rua Paraná", "Rua Minas Gerais", "Rua Rio de Janeiro", "Rua Bahia", "Rua Goiás", "Avenida Afonso Pena",
		"Rua Mato Grosso", "Rua Ceará", "Rua Pernambuco", "Rua Amazonas", "Rua Espírito Santo", "Rua Maranhão",
		"Rua Piauí", "Avenida Santa Catarina", "Rua Paraná", "Rua do Comércio", "Rua do Limoeiro",
		"Rua Esperança", "Rua Francisco Alves", "Avenida das Nações", "Rua dos Jacarandás", "Rua Projetada",
	}
	numeros := []string{
		"1234", "5678", "9101", "1122", "3344", "5566", "7788", "9900", "1023", "4356",
		"7890", "2468", "1357", "9876", "5432", "1098", "7654", "3210", "1111", "2222",
		"3333", "4444", "5555", "6666", "7777", "8888", "9999", "1010", "2020", "3030",
		"4040", "5050", "6060", "7070", "8080", "9090", "1230", "4321", "8765", "3456",
		"7891", "2345", "6789", "9870", "6543", "3219", "1920", "8745", "9087", "7689",
	}
	return ruas[rand.Intn(len(ruas))] + ", " + numeros[rand.Intn(len(numeros))]
}

func GerarCadastroInsert() string {
	return "insert into cadastros (nome, documento, cep, estado, cidade, endereco) " +
		"VALUES ('" + GerarNome() + "', '" + GerarDocumento() + "', '" + GerarCep() + "', 'Mato Grosso do Sul', '" +
		GerarCidade() + "', '" + GerarEndereco() + "');"
}

// tags

func GerarTagInsert(i int) string {
	tags := []string{
		"Cliente VIP", "Cliente Regular", "Cliente Inadimplente",
		"Cliente Preferencial", "Em Negociação", "Potencial Cliente",
		"Cliente Recorrente", "Cliente Novo", "Conta Encerrada",
		"Cliente Premium",
	}
	return "insert into tags (titulo) values ( '" + tags[i] + "');"
}

// categorias

func GerarCategoriaInsert(i int) string {
	categorias := []string{
		"Transferência Entre Contas", "Pagamento de Boletos", "Transferência Internacional",
		"Pagamento de Fatura", "Depósito em Conta", "Saque em Dinheiro",
		"Transferência via PIX", "Recebimento de Salário", "Pagamento de Empréstimo",
		"Envio de Remessa",
	}
	return "insert into categorias (titulo) values ( '" + categorias[i] + "');"
}

// cadastros_tags

func GerarCadastro_tagInsert(cadastroid string) string {
	return "insert into cadastros_tags (fk_cadastro, fk_tag) values ('" + cadastroid + "', '" + strconv.Itoa(rand.Intn(9)+1) + "');"
}

// transferencias

func GerarTipo() string {
	tipos := []string{
		"pagar", "receber", "receber", "receber",
	}
	return tipos[rand.Intn(len(tipos))]
}

func GerarStatus() string {
	status := []string{"aberto", "liquidado"}
	return status[rand.Intn(len(status))]
}

func GerarDescricaoPagar() string {
	descricoesPagar := []string{
		"Compra de materiais de escritório", "Pagamento de fornecedor", "Salário de funcionários",
		"Despesa com manutenção de equipamentos", "Pagamento de aluguel", "Taxa de serviço bancário",
		"Reembolso de despesas de viagem", "Pagamento de imposto sobre vendas", "Adiantamento para fornecedor",
		"Pagamento de seguro", "Despesas com consultoria externa", "Pagamento de taxas administrativas",
		"Despesas com marketing e publicidade", "Compra de equipamentos de TI", "Despesas com treinamento e desenvolvimento",
		"Pagamento de energia elétrica", "Despesas com transporte e logística", "Pagamento de honorários",
		"Compra de software", "Pagamento de taxas de licença", "Despesas com telefone e comunicação",
		"Pagamento de taxas de serviço", "Compra de suprimentos de escritório", "Pagamento de juros sobre empréstimos",
		"Despesas com eventos corporativos", "Pagamento de serviços de consultoria", "Compra de materiais de construção",
		"Pagamento de impostos municipais", "Despesas com serviços de terceiros", "Compra de bens de capital",
		"Pagamento de despesas médicas", "Pagamento de taxas de registro",
	}

	return descricoesPagar[rand.Intn(len(descricoesPagar))]
}

func GerarDescricaoReceber() string {
	descricoesReceber := []string{
		"Recebimento de cliente", "Receita de venda de produto", "Recebimento de comissão",
		"Desconto concedido em fatura", "Receita de investimento", "Recebimento de royalties",
		"Recebimento de dividendos", "Recebimento de alugueis", "Recebimento de patrocínios",
		"Recebimento de subsídios", "Recebimento de adiantamento de cliente", "Recebimento de contratos de prestação de serviços",
		"Recebimento de doações", "Recebimento de bonificações",
	}

	return descricoesReceber[rand.Intn(len(descricoesReceber))]
}

func GerarData() string {
	meses := map[string]int{
		"01": 31,
		"02": 28,
		"03": 31,
		"04": 30,
		"05": 31,
		"06": 30,
		"07": 31,
		"08": 31,
		"09": 30,
		"10": 31,
		"11": 30,
		"12": 31,
	}
	mesIndex := rand.Intn(len(meses))
	mes := fmt.Sprintf("%02d", mesIndex+1)
	diasNoMes := meses[mes]
	dia := fmt.Sprintf("%02d", rand.Intn(diasNoMes)+1)
	return "2023-" + mes + "-" + dia
}

func GerarLancamentosInput() string {
	tipo := GerarTipo()
	status := GerarStatus()
	var descricao string
	if tipo == "pagar" {
		descricao = GerarDescricaoPagar()
	} else {
		descricao = GerarDescricaoReceber()
	}
	valor := (rand.Intn(1000) + 100) * 10
	valor_liquidado := rand.Intn(valor)
	liquidacao := "null"
	if status == "liquidado" {
		valor_liquidado = valor
		liquidacao = "'" + GerarData() + "'"
	}
	fk_cadastro := rand.Intn(99) + 1
	fk_categoria := rand.Intn(9) + 1
	vencimento := GerarData()
	if rand.Intn(99) < 75 {
		if tipo == "pagar" {
			return "insert into lancamentos (tipo, status, descricao, valor, valor_liquidado, vencimento, liquidacao, fk_categoria)" +
				" values ('" + tipo + "', '" + status + "', '" + descricao + "', '" + strconv.Itoa(valor) +
				"', '" + strconv.Itoa(valor_liquidado) + "', '" + vencimento + "', " + liquidacao + ", '" +
				strconv.Itoa(fk_categoria) + "');"
		} else {
			return "insert into lancamentos (tipo, status, descricao, valor, valor_liquidado, vencimento, liquidacao, fk_cadastro, fk_categoria)" +
				" values ('" + tipo + "', '" + status + "', '" + descricao + "', '" + strconv.Itoa(valor) +
				"', '" + strconv.Itoa(valor_liquidado) + "', '" + vencimento + "', " + liquidacao + ", '" +
				strconv.Itoa(fk_cadastro) + "', '" + strconv.Itoa(fk_categoria) + "');"
		}
	} else {
		if tipo == "pagar" {
			return "insert into lancamentos (tipo, status, descricao, valor, valor_liquidado, vencimento, liquidacao)" +
				" values ('" + tipo + "', '" + status + "', '" + descricao + "', '" + strconv.Itoa(valor) +
				"', '" + strconv.Itoa(valor_liquidado) + "', '" + vencimento + "', " + liquidacao + ");"
		} else {
			return "insert into lancamentos (tipo, status, descricao, valor, valor_liquidado, vencimento, liquidacao, fk_cadastro)" +
				" values ('" + tipo + "', '" + status + "', '" + descricao + "', '" + strconv.Itoa(valor) +
				"', '" + strconv.Itoa(valor_liquidado) + "', '" + vencimento + "', " + liquidacao + ", '" +
				strconv.Itoa(fk_cadastro) + "');"
		}
	}

}

// main
func main() {
	fileName := "" +
		"INSERT_SCRIPTS.sql"
	file, err := os.Create(fileName)
	if err != nil {
		fmt.Println("Erro ao criar o arquivo:", err)
		return
	}
	defer file.Close()

	//cadastros

	for i := 0; i < 100; i++ {
		_, err = file.WriteString(GerarCadastroInsert() + "\n")
		if err != nil {
			fmt.Println("Erro ao escrever no arquivo:", err)
			return
		}
	}
	_, err = file.WriteString("\n\n\n")
	if err != nil {
		fmt.Println("Erro ao escrever no arquivo:", err)
		return
	}

	//tags

	for i := 0; i < 10; i++ {
		_, err = file.WriteString(GerarTagInsert(i) + "\n")
		if err != nil {
			fmt.Println("Erro ao escrever no arquivo:", err)
			return
		}
	}
	_, err = file.WriteString("\n\n\n")
	if err != nil {
		fmt.Println("Erro ao escrever no arquivo:", err)
		return
	}

	//cadastros_tag

	for i := 0; i < 120; i++ {
		_, err = file.WriteString(GerarCadastro_tagInsert(strconv.Itoa(rand.Intn(99)+1)) + "\n")
		if err != nil {
			fmt.Println("Erro ao escrever no arquivo:", err)
			return
		}
	}
	_, err = file.WriteString("\n\n\n")
	if err != nil {
		fmt.Println("Erro ao escrever no arquivo:", err)
		return
	}

	for i := 0; i < 10; i++ {
		_, err = file.WriteString((GerarCategoriaInsert(i)) + "\n")
		if err != nil {
			fmt.Println("Erro ao escrever no arquivo:", err)
			return
		}
	}
	_, err = file.WriteString("\n\n\n")
	if err != nil {
		fmt.Println("Erro ao escrever no arquivo:", err)
		return
	}

	// transferencias

	for i := 0; i < 1000; i++ {
		_, err = file.WriteString(GerarLancamentosInput() + "\n")
		if err != nil {
			fmt.Println("Erro ao escrever no arquivo:", err)
			return
		}
	}
	_, err = file.WriteString("\n\n\n")
	if err != nil {
		fmt.Println("Erro ao escrever no arquivo:", err)
		return
	}
}
