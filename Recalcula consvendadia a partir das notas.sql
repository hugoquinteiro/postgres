DO $$
DECLARE
	var_codestabelec integer;
	var_dtinicial date;
	var_dtfinal DATE;
	row_itnotafiscal record;
BEGIN
	var_codestabelec := 2;
	var_dtinicial := '2016-04-19';
	var_dtfinal := '2016-04-19';

	DELETE FROM consvendadia WHERE codestabelec = var_codestabelec AND dtmovto BETWEEN var_dtinicial AND var_dtfinal AND tipovenda = 'N';
	FOR row_itnotafiscal IN
		SELECT itnotafiscal.codproduto, SUM(itnotafiscal.quantidade) AS quantidade, SUM(itnotafiscal.totaldesconto) AS desconto, 
			SUM(itnotafiscal.totalacrescimo) AS acrescimo, SUM(itnotafiscal.custorep) AS custorep, SUM(itnotafiscal.totalliquido) AS valortotal,
			itnotafiscal.composicao, itnotafiscal.dtentrega
		FROM itnotafiscal 
		INNER JOIN notafiscal USING(idnotafiscal) 
		WHERE notafiscal.codestabelec = var_codestabelec
			AND notafiscal.operacao = 'VD' 
			AND itnotafiscal.dtentrega BETWEEN var_dtinicial AND var_dtfinal
			AND notafiscal.status = 'A'
			AND notafiscal.cupom IS NULL
		GROUP BY itnotafiscal.codproduto, itnotafiscal.composicao, itnotafiscal.dtentrega
	LOOP
		INSERT INTO consvendadia (
			codestabelec, dtmovto, codproduto, quantidade,
			venda, custo, desconto, acrescimo,
			composicao, tipovenda
		) VALUES (
			var_codestabelec, row_itnotafiscal.dtentrega, row_itnotafiscal.codproduto, row_itnotafiscal.quantidade,
			row_itnotafiscal.valortotal, row_itnotafiscal.custorep, row_itnotafiscal.desconto, row_itnotafiscal.acrescimo,
			row_itnotafiscal.composicao, 'N'
		);
	END LOOP;
END;
$$;
