CREATE OR REPLACE FUNCTION temp() RETURNS void AS $$
	DECLARE var_dtinicial date;
	DECLARE var_dtcorrente date;
	DECLARE var_saldo numeric(15,4);
	DECLARE var_quantidade numeric(15,4);
	DECLARE row_estabelecimento estabelecimento%ROWTYPE;
	DECLARE row_produto produto%ROWTYPE;
	DECLARE row_movimento movimento%ROWTYPE;
BEGIN
	var_dtinicial := CAST('2013-01-01' AS date);
	DELETE FROM produtoestabsaldo WHERE data >= var_dtinicial;
	FOR row_estabelecimento IN SELECT * FROM estabelecimento ORDER BY codestabelec LOOP
		FOR row_produto IN SELECT * FROM produto ORDER BY codproduto LOOP
			var_dtcorrente := var_dtinicial;
			var_saldo := saldo(row_estabelecimento.codestabelec,row_produto.codproduto,var_dtinicial);
			WHILE var_dtcorrente <= CURRENT_DATE LOOP
				var_quantidade := COALESCE((SELECT SUM(qtdeunidade * quantidade * (CASE WHEN tipo = 'E' THEN 1 ELSE -1 END)) FROM movimento WHERE codestabelec = row_estabelecimento.codestabelec AND codproduto = row_produto.codproduto AND dtmovto = var_dtcorrente),0);
				IF var_quantidade != 0 THEN
					var_saldo := var_saldo + var_quantidade;
					INSERT INTO produtoestabsaldo (data,codestabelec,codproduto,saldo) VALUES (var_dtcorrente,row_estabelecimento.codestabelec,row_produto.codproduto,var_saldo);
				END IF;
				var_dtcorrente := var_dtcorrente + 1;
			END LOOP;
		END LOOP;
	END LOOP;
END;
$$ LANGUAGE plpgsql VOLATILE;
SELECT temp();
DROP FUNCTION temp();