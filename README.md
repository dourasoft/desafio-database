# Desafio Database Dourasoft
# Repositório: Sistema de Recrutamento

Este repositório contém scripts, ferramentas e relatórios relacionados ao desafio proposto pela Dourasoft.com base nas [instruções fornecidas](https://github.com/dourasoft/desafio-database)

## Estrutura do Repositório

### 1. db/
Este diretório contém os scripts SQL necessários para a criação, inserção e consulta de dados no banco de dados.

- **CREATE_TABLES.sql**: Script SQL responsável pela criação de todas as tabelas do banco de dados.
- **INSERT_SCRIPTS.sql**: Script SQL para inserção de dados iniciais nas tabelas criadas.
- **RELATORIOS_SCRIPTS.sql**: Contém consultas SQL para geração dos relatórios de acordo com os dados inseridos.

### 2. ferramentas/
Este diretório contém ferramentas auxiliares para o sistema de recrutamento.

- **Diagrama_RecrutamentoDB.pdf**: Diagrama do banco de dados que mostra a estrutura das tabelas e seus relacionamentos.
- **Gerar_Inserts.go**: Script em Go que automatiza a geração de comandos `INSERT INTO` para o banco de dados, facilitando a inserção de dados em massa.

### 3. relatorios/
Neste diretório estão os relatórios gerados com base nos dados do sistema de recrutamento.

- **relatorio-1-Cadastros_com_tag.pdf**: Relatório que mostra todos os cadastros realizados, categorizados por tags específicas.
- **relatorio-2-Receitas_liquidadas_em_2024.pdf**: Relatório financeiro das receitas liquidadas no ano de 2024.
- **relatorio-3-Total_de_receitas_liquidadas_por_categoria_mensal.pdf**: Total de receitas liquidadas, separadas por categoria e mês.
- **relatorio-4-despesas_em_aberto.pdf**: Relatório das despesas que ainda estão em aberto, ou seja, não foram liquidadas.
- **relatorio-5-Total_de_despesas_liquidadas_por_categoria_mensal.pdf**: Total de despesas liquidadas, categorizadas mensalmente.
- **relatorios_Dourasoft_Recrutamento.xlsx**: Relatório em formato Excel contendo informações consolidadas do sistema de recrutamento.


 # Autor
 Lucas Ribeiro Dal Vesco