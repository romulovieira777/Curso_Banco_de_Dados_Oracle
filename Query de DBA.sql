/* Verificando Usuário logado no Banco de Dados */
SHOW USER;


/* Dicionário de Dados */
SELECT
	*
FROM
	DICT;


/* Descobrindo a Instância Única ou Rac */
SELECT
	PARALLEL
FROM
	V$INSTANCE;


/* Estrutura de Memória */
SELECT
	COMPONENT,
	CURRENT_SIZE,
	MIN_SIZE,
	MAX_SIZE
FROM
	V$SGA_DYNAMIC_COMPONENTS;


/* Verificando o Nome do Banco de Dados */
SELECT
	NAME
FROM
	V$DATABASE;


/* Versão do Banco de Dados */
SELECT
	BANNER
FROM
	V$VERSION;


/* Verificar Privilégios dos Usuários */
SELECT
	*
FROM
	USER_SYS_PRIVS;


/* Verificando Tabelas do Usuário */
SELECT
	TABLE_NAME
FROM
	USER_TABLES;

/* Armazenamento
Lógico - TableSpaces -> Segmentos (Objetos) -> Extensões (Espaços) -> Blocos (Do Sistema Operacional)

Físico -> DataFiles */

/* Não Podemos Determinar em Qual Arquivo Físico um Objeto Ficará. */


/* Criando Tabelas */
CREATE TABLE CURSOS (
	IDCURSO INT PRIMARY KEY,
	NOME VARCHAR(30),
	CARGA INT
) TABLESPACE USERS;


CREATE TABLE TESTE(
	IDTESTE INT,
	NOME VARCHAR(30)
);


/* Dicionário de Dados */
SELECT
	TABLE_NAME,
	TABLESPACE_NAME
FROM
	USER_TABLES;


SELECT
	TABLE_NAME,
	TABLESPACE_NAME;
FROM
	USER_TABLES
WHERE
	TABLE_NAME = 'CURSOS';


SELECT
	TABLE_NAME,
	TABLESPACE_NAME
FROM
	USER_TABLES
WHERE
	TABLE_NAME = 'TESTE';


/* Todo Objeto é Criado por Padrão na TableSpace Users Exceto Quando se Está Logado como o Usuário System - 
Então o Objeto será Criado na TableSpace System */


SELECT
	SEGMENT_NAME,
	SEGMENT_TYPE,
	TABLESPACE_NAME,
	BYTES,
	BLOCKS,
	EXTENTS
FROM
	USER_SEGMENTS;


SELECT
	SEGMENT_NAME,
	SEGMENT_TYPE,
	TABLESPACE_NAME,
	BYTES,
	BLOCKS,
	EXTENTS
FROM
	USER_SEGMENTS
WHERE
	SEGMENT_NAME = 'CURSOS';