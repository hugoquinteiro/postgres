CREATE OR REPLACE FUNCTION temp() RETURNS void AS $$
DECLARE
	var_codestabelec integer;
	var_dtmovto date;
	row_itcupom record;
BEGIN
	var_codestabelec := 1;
	var_dtmovto := '2015-06-03';

	DELETE FROM consvendadia WHERE codestabelec = var_codestabelec AND dtmovto = var_dtmovto AND tipovenda = 'C';

	FOR row_itcupom IN SELECT itcupom.codproduto, SUM(itcupom.quantidade) AS quantidade, SUM(itcupom.desconto) AS desconto, SUM(itcupom.acrescimo) AS acrescimo, SUM(itcupom.custorep*quantidade) AS custorep, SUM(itcupom.valortotal) AS valortotal, itcupom.composicao FROM itcupom INNER JOIN cupom USING(idcupom) WHERE cupom.codestabelec = var_codestabelec AND cupom.dtmovto = var_dtmovto AND cupom.status = 'A' AND itcupom.status = 'A' GROUP BY itcupom.codproduto, itcupom.composicao LOOP
		INSERT INTO consvendadia (
			codestabelec, dtmovto, codproduto, quantidade,
			venda, custo, desconto, acrescimo,
			composicao, tipovenda
		) VALUES (
			var_codestabelec, var_dtmovto, row_itcupom.codproduto, row_itcupom.quantidade,
			row_itcupom.valortotal, row_itcupom.custorep, row_itcupom.desconto, row_itcupom.acrescimo,
			row_itcupom.composicao, 'C'
		);
	END LOOP;
	
END;
$$ LANGUAGE plpgsql VOLATILE;
SELECT temp();
DROP FUNCTION temp();


-- [Hugo] Corrigi campo custorep*quantidade, porque sistema estava deixando custo maior que venda.
select * from CONSVENDADIA where  DTMOVTO='2015-06-03' and CODESTABELEC=1 and TIPOVENDA='C' and CUSTO>VENDA
select sum(quantidade) as qdt, SUM(valortotal) as vda, SUM(quantidade*custorep) AS custo FROM ITCUPOM INNER JOIN CUPOM using (IDCUPOM) where  DTMOVTO='2015-06-03' and CODESTABELEC=1 and CODPRODUTO=4

-- [Hugo] Verificar dias divergentes
SELECT dtmovto, SUM(cons) AS cons, SUM(cupom) AS cupom, SUM(cons)-SUM(cupom) AS dif FROM (
SELECT dtmovto, SUM(venda) AS cons, 0 AS cupom FROM consvendadia WHERE dtmovto>='2015-11-01' AND dtmovto<='2011-11-30' AND tipovenda='C' AND composicao<>'F' AND codestabelec=1 GROUP BY 1
UNION ALL
SELECT dtmovto, 0 AS cons, SUM(totalliquido) AS cupom FROM cupom WHERE dtmovto>='2015-11-01' AND dtmovto<='2015-11-30' AND status='A' AND codestabelec=1 GROUP BY 1
) AS temp
GROUP BY 1
ORDER BY 1
