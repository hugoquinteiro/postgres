-- Apagar registros duplicados (Sem PK) no Postgres

--Criando a tabela
CREATE TABLE duplicados(
id integer, 
name CHARACTER VARYING(30)
);

--Inserindo registros duplicados de teste
INSERT INTO duplicados VALUES (99, 'VARIOS');
INSERT INTO duplicados VALUES (99, 'VARIOS');
INSERT INTO duplicados VALUES (2, 'DOIS');
INSERT INTO duplicados VALUES (3, 'TRES');
INSERT INTO duplicados VALUES (3, 'TRES');
INSERT INTO duplicados VALUES (3, 'TRES');
INSERT INTO duplicados VALUES (99, 'VARIOS');
INSERT INTO duplicados VALUES (99, 'VARIOS');
INSERT INTO duplicados VALUES (3, 'TRES');
INSERT INTO duplicados VALUES (3, 'TRES');
INSERT INTO duplicados VALUES (99, 'VARIOS');
INSERT INTO duplicados VALUES (99, 'VARIOS');
INSERT INTO duplicados VALUES (2, 'DOIS');

SELECT * FROM duplicados;
--A Dica é usar o ID iterno que toda tabela tem "CTID"


--Criando a procedure para limpar os duplicados
CREATE OR REPLACE PROCEDURE PRC_LIMPA_DPL()
LANGUAGE PLPGSQL
as $$
DECLARE
	xinfo record;
BEGIN	
	FOR xinfo IN SELECT MAX(ctid) newid, id, name, count(*) as conta FROM duplicados GROUP BY id, name ORDER BY 1 LOOP
		DELETE FROM DUPLICADOS WHERE name=xinfo.NAME AND CTID<>xinfo.NEWID;
	END LOOP;	
END;
$$;

--Executando a procedure
call PRC_LIMPA_DPL();

--Testando o resultado.
SELECT * FROM duplicados;