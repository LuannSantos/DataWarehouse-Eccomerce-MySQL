-- Com o usuário root
CREATE USER 'ecommecer'@'IP_CLIENT' IDENTIFIED BY 'SENHA';

-- Database OLTP
create database  ecommerce_db;

GRANT ALL PRIVILEGES ON ecommerce_db.* TO 'ecommecer'@'IP_CLIENT' WITH GRANT OPTION;

GRANT alter, alter routine, create routine, create, create temporary tables, create view, delete,
drop, event, execute, file, index, insert, lock tables, select, show databases, show view, trigger,
references, update
 ON *.* TO 'ecommecer'@'IP_CLIENT' WITH GRANT OPTION;

-- Database STAGE
create database ecommerce_db_stage;

GRANT ALL PRIVILEGES ON ecommerce_db_stage.* TO 'ecommecer'@'IP_CLIENT' WITH GRANT OPTION;

-- Database DW
create database ecommerce_db_dw;

GRANT ALL PRIVILEGES ON ecommerce_db_dw.* TO 'ecommecer'@'IP_CLIENT' WITH GRANT OPTION;


-- Para o usuário ecommecer. No MySQL Worbench ao criar a conexão, vá em Advanced e depois em outros e adicione o seguinte parâmetro
OPT_LOCAL_INFILE=1
SQL_SAFE_UPDATES = 0
