/* Criando uma TableSpace */
CREATE TABLESPACE
	RECURSOS_HUMANOS
DATAFILE 
	'C:/DATA/RH_01.DBF'
SIZE
	100M AUTOEXTEND
ON NEXT
	100M
MAXSIZE
	4096M;


/* Adicionando outra TableSpace */
ALTER TABLESPACE
	RECURSOS_HUMANOS
ADD DATAFILE
	'C:/DATA/RH_02.DBF'
SIZE
	200M AUTOEXTEND
ON NEXT
	100M
MAXSIZE
	4096M;


/* Verificando a TableSpace */
SELECT
	TABLESPACE_NAME,
	FILE_NAME
FROM
	DBA_DATA_FILES;


/* Preenchimento Sequencial */
CREATE SEQUENCE
	SEQ_GERAL
START WITH
	100
INCREMENT BY
	10;


/* Criando Tabela na TableSpace*/
CREATE TABLE FUNCIONARIOS (
	IDFUNCIONARIO INT PRIMARY KEY,
	NOME VARCHAR2(30)
) TABLESPACE RECURSOS_HUMANOS;


/* Inserindo Dados */
INSERT INTO
	FUNCIONARIOS
VALUES (
	SEQ_GERAL.NEXTVAL,
	'JOAO'
);


INSERT INTO
	FUNCIONARIOS
VALUES (
	SEQ_GERAL.NEXTVAL,
	'CLARA'
);


INSERT INTO
	FUNCIONARIOS
VALUES(
	SEQ_GERAL.NEXTVAL,
	'LILIAN'
);


/* Criando uma TableSpace de Marketing */
CREATE TABLESPACE 
	MARKETING
DATAFILE
	'C:/DATA/MKT_01.DBF'
SIZE
	100M AUTOEXTEND
ON NEXT
	100M
MAXSIZE
	4096M;


/* Criando Tabela */
CREATE TABLE CAMPANHA (
	IDCAMPANHA INT PRIMARY KEY,
	NOME VARCHAR2(30)
) TABLESPACE MARKETING;


/* Inserindo Dados na Tabela */
INSERT INTO
	CAMPANHA
VALUES (
	SEQ_GERAL.NEXTVAL,
	'PRIMAVERA'
);


INSERT INTO
	CAMPANHA
VALUES (
	SEQ_GERAL.NEXTVAL,
	'VERAO'
);


INSERT INTO
	CAMPANHA
VALUES(
	SEQ_GERAL.NEXTVAL,
	'INVERNO'
);


/* Colocando a TableSpace em OffLine */
ALTER TABLESPACE
	RECURSOS_HUMANOS
OFFLINE;


/* Apontar para o Dicionário de Dados */
ALTER TABLESPACE
	RECURSOS_HUMANOS
RENAME DATAFILE
	'C:/DATA/RH_01.DBF'
TO
	'C:/PRODUCAO/RH_01.DBF';


ALTER TABLESPACE
	RECURSOS_HUMANOS
RENAME DATAFILE
	'C:/DATA/RH_02.DBF'
TO
	'C:/PRODUCAO/RH_02.DBF';


/* Tornando à TableSpace OnLine */
ALTER TABLESPACE
	RECURSOS_HUMANOS
ONLINE;


/* Criando Tabela */
CREATE TABLE ALUNO (
	IDALUNO INT PRIMARY KEY,
	NOME VARCHAR2(30),
	EMAIL VARCHAR2(30),
	SALARIO NUMBER(10,2)
);


/* Criando uma Sequence */
CREATE SEQUENCE
	SEQ_EXEMPLO;


/* Inserindo Dados na Tabela */
INSERT INTO
	ALUNO
VALUES(
	SEQ_EXEMPLO.NEXTVAL,
	'JOAO',
	'JOAO@GMAIL.COM',
	1000.00
);


INSERT INTO
	ALUNO
VALUES(
	SEQ_EXEMPLO.NEXTVAL,
	'CLARA',
	'CALARA@GMAIL.COM',
	2000.00
);


INSERT INTO
	ALUNO
VALUES(
	SEQ_EXEMPLO.NEXTVAL,
	'CELIA',
	'CELIA@GMAIL.COM',
	3000.00
);


/* Criando uma Tabela */
CREATE TABLE ALUNO2 (
	IDALUNO INT PRIMARY KEY,
	NOME VARCHAR2(30),
	EMAIL VARCHAR2(30),
	SALARIO NUMBER(10,2)
);


/* Inserindo Dados na Tabela */
INSERT INTO
	ALUNO2
VALUES(
	SEQ_EXEMPLO.NEXTVAL,
	'JOAO',
	'JOAO@GMAIL.COM',
	1000.00
);


INSERT INTO
	ALUNO2
VALUES(
	SEQ_EXEMPLO.NEXTVAL,
	'CLARA',
	'CALARA@GMAIL.COM',
	2000.00
);


INSERT INTO
	ALUNO2
VALUES(
	SEQ_EXEMPLO.NEXTVAL,
	'CELIA',
	'CELIA@GMAIL.COM',
	3000.00
);


/* Rowid Rownum */
SELECT
	ROWID,
	IDALUNO,
	NOME,
	EMAIL
FROM
	ALUNO;


/* Página Registros */
SELECT
	ROWID,
	ROWNUM,
	IDALUNO,
	NOME,
	EMAIL
FROM
	ALUNO;


/* Criando uma Procedure */
CREATE OR REPLACE PROCEDURE
	BONUS(
		P_IDALUNO
		ALUNO.IDALUNO%TYPE,
		P_PERCENT NUMBER)
AS
	BEGIN
		UPDATE
			ALUNO
		SET
			SALARIO = SALARIO + (SALARIO * (P_PERCENT / 100))
		WHERE
			P_IDALUNO = P_IDALUNO;
	END;
	/


/* Chamando uma Procedure */
CALL
	AUMENTO (3, 10);


/* Criando uma Trigger de Validação com Erro */
CREATE OR REPLACE TRIGGER
	CHECK_SALARIO
BEFORE INSERT OR UPDATE ON
	ALUNO
FOR EACH ROW
BEGIN
	IF :NEW.SALARIO > 2000 THEN 
		RAISE_APPLICATION_ERROR (-2000, 'VALOR INCORRETO')
	END IF;
END;
/


/* Criando uma Trigger Correta */
CREATE OR REPLACE TRIGGER
	CHCK_SALARIO
BEFORE INSERT OR UPDATE ON
	ALUNO
FOR EACH ROW
BEGIN
	IF :NEW.SALARIO > 2000 THEN
		RAISE_APPLICATION_ERROR(-2000, 'VALOR INCORRETO');
	END IF;
END;
/


/* Inserindo Dados na Tabela */
INSERT INTO
	ALUNO
VALUES(
	SEQ_EXEMPLO.NEXTVAL,
	'MAFRA',
	'MAFRA@GMAIL.COM',
	100.00
);


/* Selecionando uma Trigger */
SELECT
	TRIGGER_NAME,
	TRIGGER_BODY
FROM
	USER_TRIGGERS;


/* Criando uma Tabela */
CREATE TABLE AUDITORIA(
	DATA_LOGIN DATE,
	LOGIN VARCHAR2(30)
);


/* Criando uma Trigger */
CREATE OR REPLACE PROCEDURE LOGPROC IS
BEGIN
	INSERT INTO AUDITORIA(DATA_LOGIN, LOGIN)
	VALUES(SYSDATE, USER);
END LOGPROC;
/


/* Trigger de Eventos */
CREATE OR REPLACE TRIGGER
	LOGTRIGGER
AFTER LOGON ON DATABASE
CALL
	LOGPROC
/


/* Falha de Logon */
CREATE OR REPLACE TRIGGER
	FALHA_LOGON
AFTER SERVERERROR
ON DATABASE
BEGIN
	IF (IS_SERVERERROR(1017)) THEN 
		INSERT INTO AUDITORIA(DATA_LOGIN, LOGIN)
		VALUES(SYSDATE,'ORA-1017');
	END IF;
END FALHA_LOGON;
/


/* Criando uma Tabela */
CREATE TABLE USUARIO(
	ID INT,
	NOME VARCHAR2(30)
);


CREATE TABLE BKP_USER(
	ID INT,
	NOME VARCHAR2(30)
);


/* Inserindo Dados na Tabela */
INSERT INTO
	USUARIO
VALUES(
	1,
	'JOAO'
);


INSERT INTO
	USUARIO
VALUES(
	2,
	'CLARA'
);


/* Criando um Trigger */
CREATE OR REPLACE TRIGGER
	LOG_USUARIO
BEFORE DELETE ON
	USUARIO
FOR EACH ROW
BEGIN
	INSERT INTO BKP_USER VALUES
	(:OLD.ID, :OLD.NOME);
END;
/


/* Deletando um Usuário da Tabela */
DELETE FROM
	USUARIO
WHERE
	ID = 1;


/* Criando Tabela */
CREATE TABLE CLIENTE(
	IDCLIENTE INT PRIMARY KEY,
	NOME VARCHAR2(30),
	SEXO CHAR(1)
);


/* Inserindo Dados na Tabela */
INSERT INTO
	CLIENTE
VALUES(
	1007,
	'MAFRA',
	'M'
);


/* Criando uma View */
CREATE OR REPLACE VIEW
	V_CLIENTE
AS
	SELECT
		IDCLIENTE,
		NOME,
		SEXO
	FROM
		CLIENTE;


/* Inserindo Dados na View */
INSERT INTO
	V_CLIENTE
VALUES(
	1008,
	'CLARA',
	'F'
);


/* Criando uma View */
CREATE OR REPLACE VIEW
	V_CLIENTE_RO
AS
	SELECT
		IDCLIENTE,
		NOME,
		SEXO
	FROM
		CLIENTE
	WITH READ ONLY;


/* View de Join */
CREATE OR REPLACE VIEW
	RELATORIO
AS
	SELECT
		NOME,
		SEXO,
		NUMERO
	FROM
		CLIENTE
	INNER JOIN
		TELEFONE
	ON
		IDCLIENTE = ID_CLIENTE;


/* Usando a Clausula Force */
CREATE OR REPLACE FORCE VIEW
	RELATORIO
AS
	SELECT
		NOME,
		SEXO,
		NUMERO
	FROM
		CLIENTE
	INNER JOIN
		TELEFONE
	ON
		IDCLIENTE = ID_CLIENTE;


/* Criando uma Tabela */
CREATE TABLE TELEFONE(
	IDTELEFONE INT PRIMARY KEY,
	NUMERO VARCHAR2(30),
	ID_CLIENTE INT
);


/* Criando Chave Estrangeira */
ALTER TABLE
	TELEFONE
ADD CONSTRAINT
	FK_CLIENTE_TELEFONE
FOREIGN KEY
	(ID_CLIENTE)
REFERENCES
	CLIENTE;


/* Inserindo Dados na Tabela */
INSERT INTO
	TELEFONE
VALUES(
	1,
	'34543355',
	1007
);


/* Criando Tabelas */
CREATE TABLE FUNCIONARIO(
	IDFUNCIONARIO INT CONSTRAINT PK_FUNCIONARIO PRIMARY KEY,
	NOME VARCHAR2(100)
);


/* Apagando uma Tabela */
DROP TABLE
	TELEFONE;


/* Criando uma Tabela */
CREATE TABLE TELEFONE(
	IDTELEFONE INT PRIMARY KEY,
	NUMERO VARCHAR2(30),
	ID_FUNCIONARIO INT
);


/* Criando a Chave Estrangeira */
ALTER TABLE
	TELEFONE
ADD CONSTRAINT
	FK_TELEFONE
FOREIGN KEY
	(ID_FUNCIONARIO)
REFERENCES
	FUNCIONARIO;


/* Inserindo Dados na Tabela */
INSERT INTO
	FUNCIONARIO
VALUES(
	1,
	'MAURICIO'
);


INSERT INTO
	TELEFONE
VALUES(
	10,
	'34342454',
	1
);


/* A Constraint de Integridade Referencial (FK) checa a Integridade logo após o Comando de DML
Insert / Delete / Update - Não Possibilitando assim a Inserção de Registros sem Referência */


/* Verificando o Estado das Constraints */
SELECT
	CONSTRAINT_NAME,
	DEFERRABLE,
	DEFERRED
FROM
	USER_CONSTRAINTS
WHERE
	TABLE_NAME
IN
	('FUNCIONARIO', 'TELEFONE');


/* Apagando uma Constraint */
ALTER TABLE
	TELEFONE
DROP CONSTRAINT
	FK_TELEFONE;


/* Recriando a Constraint */
ALTER TABLE
	TELEFONE
ADD CONSTRAINT
	FK_TELEFONE
FOREIGN KEY
	(ID_FUNCIONARIO)
REFERENCES
	FUNCIONARIO
DEFERRABLE;


/* Mudando para DTL */
SET CONSTRAINTS ALL DEFERRED;