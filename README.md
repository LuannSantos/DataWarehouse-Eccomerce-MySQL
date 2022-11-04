# Datawarehouse a partir de dados de um E-ccomerce
## Introdução
Criação de um datawarehouse a partir de dados extraídos de um e-ccomerce. Os dados vem do kaggle e estão em arquivos .csv.

Esses dados são salvos no MySQL que foi dividido em 3 databases: OLTP, STAGE, DW.

**Tecnologias Usadas**: MySQL, Docker

## Preparação e Execução do Projeto

### Dados

Os dados podem ser encontrados no seguinte link: https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce?resource=download. Os dados estão em arquivos .csv e são referentes ao período entre 2016 e 2018 de um e-ccomerce.

Pelo link indicado, há mais detalhes sobre como os dados estão distribuídos. O mais importante aqui, é como eles serão usados para montar um datawarehouse.

### Databases

O MSQL foi dividido em **3 databases**. O primeiro deles, é o database para os dados com modelagem OLTP. Aqui os dados são salvos em tabelas que seguirão a mesma estrutura dos arquivos .csv.

O segundo database são para os dados em uma modelagem intermediária entre o OLTP e o datawarehouse. Aqui, as tabelas já são divididas em tabelas fatos e dimensões. São 3 tabelas fatos: pagamentos, avaliações e items. Além disso, esse database possuirá 5 tabelas de dimensão: produtos, vendedores, clientes, tipos de pagamento e pedidos.

O terceiro e último database são para os dados com modelagem OLAP, o datawarehouse propriamente dito. Aqui, além das tabelas fatos e dimensões citadas, existirá mais uma tabela dimensão que é a dimensão tempo.

### Detalhes da Modelagem

Para o database com modelagem OLTP, todas as tabelas possuem chave primária e algumas tabelas usam chaves estrangeiras. Algumas tabelas, contudo, para formar a chave primária, precisam de mais de uma coluna. Para contornar isso, foram tomadas duas ações: criação de uma constraint que determina a combinação de colunas que deve ser única e criação de uma *surrogate key* para que a tabela use apenas uma coluna como chave primária.

Para o database STAGE nenhuma tabela, com exceção da tabela de tipo de pagamento, possui chave primária. O tipo de pagamento é uma tabela que foi montada especificamente para o datawarehouse e serve para normalizar uma coluna de dados da tabela de pagamentos.

Para o database DW, as tabelas voltam a possuir chaves primárias e estrangeiras. Aqui, o maior destaque vai para a dimensão de tempo que visa facilitar a criação de séries temporais. Além disso, as tabelas desse database usam *surrogate keys* (números inteiros que vão de 1 até n) como chave primária. Isso tem como objetivo, melhorar o acesso aos dados oriundos de junções das tabelas fatos e dimensão.

Há também tabelas de dimensão que se comportam como *slowly changing dimension*. Isso significa que se houver alguma mudança, em qualquer linha de dados dessas tabelas, o datawarehouse ainda manterá os dados antigos, mas com uma coluna "FIM" preenchida, que representa o horário da mudança. Os dados novos serão salvos em uma nova linha que possuirá o mesmo "ID" (puxados da modelagem OLTP), mas diferentes *surrogate keys*.

Os dados de tempo presentes na tabela fato serão chaves estrangeiras que apontam para a dimensão de tempo.

### Execução do projeto

#### Criação do Datawarehouse no MySQL

Primeiro é necessário instalar o MySQL. Isso pode ser feito através do script Docker presente no repositório.

Com o MySQL instalado, é possível criar o datawarehouse. Para isso basta seguir a sequência de scripts dentro da pasta SQl. Esses scripts estão com números que representam a ordem de execução.

Para garantir o carregamento dos dados, foi necessário alterar a linha 82209 do arquivo olist_order_reviews_dataset.csv. A alteração foi retirar os caracteres /". Além disso, foi necessário, acrescentar 3 linhas de dados ao arquivo product_category_name_translation.csv:

seguros_e_servicos,security_and_services

pc_gamer,pc_gamer

portateis_cozinha_e_preparadores_de_alimentos,portables_kitchen_and_food_preparers
