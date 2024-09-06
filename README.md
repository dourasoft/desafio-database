# Desafio de Banco de Dados

Este desafio consiste na criação de um banco de dados com os seguintes requisitos:

1. **Cadastros:**
    - Mínimo de 100 cadastros aleatórios.
    - Cada cadastro deve conter as seguintes informações:
        - `id` (primary key)
        - `nome`
        - `documento` (cpf ou cnpj)
        - `cep`
        - `estado`
        - `cidade`
        - `endereco`

2. **Tags:**
    - Mínimo de 10 tags.
    - Quase todos os cadastros devem possuir tags e alguns mais do que uma tag.
    - Estrutura da tabela `tags`:
        - `id`
        - `titulo`
    - Estrutura da tabela `cadastros_tags` (relação muitos para muitos entre cadastros e tags):
        - `cadastro_id`
        - `tag_id`

3. **Categorias:**
    - Mínimo de 10 categorias.
    - Estrutura da tabela `categorias`:
        - `id`
        - `titulo`

4. **Lançamentos:**
    - Mínimo de 1000 lançamentos entre contas a pagar e receber, liquidadas e abertas.
    - Estrutura da tabela `lancamentos`:
        - `id` (primary key)
        - `tipo` (pagar, receber)
        - `status` (aberto, liquidado)
        - `descricao`
        - `valor`
        - `valor_liquidado`
        - `vencimento`
        - `liquidacao`
        - `cadastro_id` (foreign key para `cadastros`, pode ser nulo)
        - `categoria_id` (foreign key para `categorias`, pode ser nulo)

## Relatórios

1. **Lista de cadastros com tags:**
    - Colunas: `nome`, `estado`, `cidade`, `tags` (string com as tags).

2. **Lista de receitas liquidadas em um determinado período:**
    - Colunas: `nome`, `documento`, `descricao`, `liquidacao`, `valor_liquidado`.
    - Observação: trazer os valores mesmo se o `cadastro_id` estiver nulo.

3. **Total de receitas liquidadas, por categoria mensal:**
    - Relatório mês a mês com o total de receitas por categoria.

4. **Lista de despesas em aberto:**
    - Colunas: `nome`, `documento`, `descricao`, `vencimento`, `valor`.
    - Observação: trazer os valores mesmo se o `cadastro_id` estiver nulo.

5. **Total de despesas liquidadas, por categoria mensal:**
    - Relatório mês a mês com o total de despesas por categoria.

## Requisitos Técnicos

- Utilização de scripts para a criação do banco de dados.
- Uso de versionamento de código com Git.

## Contribuição

1. Faça um fork do projeto.
2. Crie uma branch com seu nome.
3. Abra um novo Pull Request com seu código.

---

Este desafio é uma excelente oportunidade para demonstrar habilidades em criação e gerenciamento de bancos de dados, bem como na geração de relatórios a partir dos dados armazenados. 
Boa sorte!
