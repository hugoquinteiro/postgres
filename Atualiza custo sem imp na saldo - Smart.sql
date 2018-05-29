SELECT codestabelec, codproduto, custorep, custosemimp FROM produtoestab WHERE codproduto=47677 ORDER BY 1
SELECT codestabelec, codproduto, custorep, custosemimp, saldo, data FROM produtoestabsaldo WHERE codproduto=47677 AND codestabelec=3 ORDER BY 6


SELECT codestabelec, COUNT(codproduto), custorep, custosemimp, saldo, data FROM produtoestabsaldo
WHERE codproduto=14741 AND codestabelec=3 AND data<'2017-01-01'
ORDER BY 6 DESC LIMIT 1

SELECT * FROM (
SELECT codestabelec, codproduto, MAX(data) AS data, custosemimp FROM produtoestabsaldo
WHERE codestabelec=3  AND custosemimp=0 --codproduto=14741 AND
AND data<'2017-01-01'
GROUP BY codestabelec, codproduto, custosemimp

) AS tmp WHERE custosemimp=0
ORDER BY 2


SELECT codestabelec, codproduto FROM produtoestabsaldo
WHERE codproduto=14741 AND codestabelec=3 
GROUP BY 1
HAVING MAX(data)<'2017-01-01'


-- Function: saldocustototal(integer, integer, date)

-- DROP FUNCTION saldocustototal(integer, integer, date);

CREATE OR REPLACE FUNCTION atualiza_custoseimp_produtoestabsaldo(
    var_codestabelec integer,
    var_operacao CHARACTER(2),
    var_data date)
  RETURNS numeric AS
$BODY$

DECLARE
	row_buscaitens record;
	var_saldocustototal DECIMAL(12, 4);
BEGIN
	FOR row_buscaitens IN SELECT codestabelec, codproduto, MAX(data) AS data, custosemimp FROM produtoestabsaldo 
		WHERE codestabelec= var_codestabelec  AND custosemimp=0 AND data< var_data
		GROUP BY codestabelec, codproduto, custosemimp
	LOOP
	UPDATE produtoestabsaldo SET custosemimp=(SELECT
	(itnotafiscal.totalliquido * (1-(CASE WHEN cfent.tptribicms IN ('T','R') THEN cfent.aliqicms * (1 - cfent.aliqredicms / 100) ELSE 0 END) / 100 - pcent.aliqpis / 100 - pcent.aliqcofins / 100))
	FROM itnotafiscal 
	INNER JOIN produto ON (itnotafiscal.codproduto = produto.codproduto)
	INNER JOIN classfiscal ON (produto.codcfnfs = classfiscal.codcf)
	INNER JOIN classfiscal AS cfent ON (produto.codcfnfe = cfent.codcf)
	INNER JOIN piscofins ON (produto.codpiscofinssai = piscofins.codpiscofins)
	INNER JOIN piscofins AS pcent ON (produto.codpiscofinsent = pcent.codpiscofins)
	WHERE itnotafiscal.codproduto = produtoestabsaldo.codproduto AND itnotafiscal.codestabelec = produtoestabsaldo.codestabelec AND itnotafiscal.operacao=var_operacao AND itnotafiscal.dtentrega<=var_data ORDER BY itnotafiscal.dtentrega DESC LIMIT 1)

		WHERE codproduto=row_buscaitens.codproduto AND codestabelec=row_buscaitens.codestabelec AND data=row_buscaitens.data;
	RAISE NOTICE 'Atualizando item %',row_buscaitens.codproduto;
	END LOOP;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION atualiza_custoseimp_produtoestabsaldo(integer, CHARACTER(2), date)
  OWNER TO postgres;
  
  
  -- Function: atualiza_custoseimp_igual_precovenda(integer, character, date)

-- DROP FUNCTION atualiza_custoseimp_igual_precovenda(integer, character, date);

CREATE OR REPLACE FUNCTION atualiza_custoseimp_igual_precovenda(var_codestabelec integer, var_operacao character, var_data date)
  RETURNS void AS
$BODY$

DECLARE
	row_buscaitens record;
	var_saldocustototal DECIMAL(12, 4);
BEGIN
	FOR row_buscaitens IN SELECT codestabelec, codproduto, MAX(data) AS data, custosemimp FROM produtoestabsaldo 
		WHERE codestabelec= var_codestabelec  AND custosemimp>=(SELECT precovrj FROM produtoestab WHERE codestabelec= var_codestabelec AND codproduto=produtoestabsaldo.codproduto )
		 AND saldo>0 AND data<= var_data 
		GROUP BY codestabelec, codproduto, custosemimp
	LOOP
	UPDATE produtoestabsaldo SET custosemimp=COALESCE((SELECT
	(totalliquido/(quantidade*qtdeunidade) * (1-(CASE WHEN cfent.tptribicms IN ('T','R') THEN cfent.aliqicms * (1 - cfent.aliqredicms / 100) ELSE 0 END) / 100 - pcent.aliqpis / 100 - pcent.aliqcofins / 100))
	FROM itnotafiscal 
	INNER JOIN produto ON (itnotafiscal.codproduto = produto.codproduto)
	INNER JOIN classfiscal ON (produto.codcfnfs = classfiscal.codcf)
	INNER JOIN classfiscal AS cfent ON (produto.codcfnfe = cfent.codcf)
	INNER JOIN piscofins ON (produto.codpiscofinssai = piscofins.codpiscofins)
	INNER JOIN piscofins AS pcent ON (produto.codpiscofinsent = pcent.codpiscofins)
	WHERE itnotafiscal.codproduto = produtoestabsaldo.codproduto AND itnotafiscal.codestabelec = produtoestabsaldo.codestabelec AND itnotafiscal.operacao=var_operacao 
		AND itnotafiscal.dtentrega<=var_data AND SUBSTR(itnotafiscal.natoperacao,1,5) IN ('1.409','1.152')
		ORDER BY itnotafiscal.dtentrega DESC LIMIT 1)
	,0)

		WHERE codproduto=row_buscaitens.codproduto AND codestabelec=row_buscaitens.codestabelec AND data=row_buscaitens.data;
	RAISE NOTICE 'Atualizando item %',row_buscaitens.codproduto;
	END LOOP;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION atualiza_custoseimp_igual_precovenda(integer, character, date)
  OWNER TO postgres;


