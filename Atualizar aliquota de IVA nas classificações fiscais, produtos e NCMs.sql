CREATE OR REPLACE FUNCTION temp() RETURNS void AS $$
	DECLARE row_classfiscal RECORD;
BEGIN
	ALTER TABLE produto DISABLE TRIGGER ALL;
	UPDATE ncm SET aliqiva = (SELECT aliqiva FROM classfiscal WHERE codcf = ncm.codcfnfe);
	UPDATE produto SET aliqiva = (SELECT aliqiva FROM classfiscal WHERE codcf = produto.codcfnfe) WHERE atualizancm = 'N';
	FOR row_classfiscal IN SELECT DISTINCT aliqicms, aliqredicms, codcst, tptribicms, valorpauta, aliqii FROM classfiscal LOOP
		SELECT * INTO row_classfiscal FROM classfiscal WHERE aliqicms = row_classfiscal.aliqicms AND aliqredicms = row_classfiscal.aliqredicms AND codcst = row_classfiscal.codcst AND tptribicms = row_classfiscal.tptribicms AND valorpauta = row_classfiscal.valorpauta AND aliqii = row_classfiscal.aliqii LIMIT 1;
		UPDATE ncm SET codcfnfe = row_classfiscal.codcf WHERE codcfnfe IN (SELECT codcf FROM classfiscal WHERE aliqicms = row_classfiscal.aliqicms AND aliqredicms = row_classfiscal.aliqredicms AND codcst = row_classfiscal.codcst AND tptribicms = row_classfiscal.tptribicms AND valorpauta = row_classfiscal.valorpauta AND aliqii = row_classfiscal.aliqii);
		UPDATE ncm SET codcfnfs = row_classfiscal.codcf WHERE codcfnfs IN (SELECT codcf FROM classfiscal WHERE aliqicms = row_classfiscal.aliqicms AND aliqredicms = row_classfiscal.aliqredicms AND codcst = row_classfiscal.codcst AND tptribicms = row_classfiscal.tptribicms AND valorpauta = row_classfiscal.valorpauta AND aliqii = row_classfiscal.aliqii);
		UPDATE ncm SET codcfpdv = row_classfiscal.codcf WHERE codcfpdv IN (SELECT codcf FROM classfiscal WHERE aliqicms = row_classfiscal.aliqicms AND aliqredicms = row_classfiscal.aliqredicms AND codcst = row_classfiscal.codcst AND tptribicms = row_classfiscal.tptribicms AND valorpauta = row_classfiscal.valorpauta AND aliqii = row_classfiscal.aliqii);
		UPDATE produto SET codcfnfe = row_classfiscal.codcf WHERE codcfnfe IN (SELECT codcf FROM classfiscal WHERE aliqicms = row_classfiscal.aliqicms AND aliqredicms = row_classfiscal.aliqredicms AND codcst = row_classfiscal.codcst AND tptribicms = row_classfiscal.tptribicms AND valorpauta = row_classfiscal.valorpauta AND aliqii = row_classfiscal.aliqii) AND atualizancm = 'N';
		UPDATE produto SET codcfnfs = row_classfiscal.codcf WHERE codcfnfs IN (SELECT codcf FROM classfiscal WHERE aliqicms = row_classfiscal.aliqicms AND aliqredicms = row_classfiscal.aliqredicms AND codcst = row_classfiscal.codcst AND tptribicms = row_classfiscal.tptribicms AND valorpauta = row_classfiscal.valorpauta AND aliqii = row_classfiscal.aliqii) AND atualizancm = 'N';
		UPDATE produto SET codcfpdv = row_classfiscal.codcf WHERE codcfpdv IN (SELECT codcf FROM classfiscal WHERE aliqicms = row_classfiscal.aliqicms AND aliqredicms = row_classfiscal.aliqredicms AND codcst = row_classfiscal.codcst AND tptribicms = row_classfiscal.tptribicms AND valorpauta = row_classfiscal.valorpauta AND aliqii = row_classfiscal.aliqii) AND atualizancm = 'N';
		DELETE FROM classfiscal WHERE codcf != row_classfiscal.codcf AND aliqicms = row_classfiscal.aliqicms AND aliqredicms = row_classfiscal.aliqredicms AND codcst = row_classfiscal.codcst AND tptribicms = row_classfiscal.tptribicms AND valorpauta = row_classfiscal.valorpauta AND aliqii = row_classfiscal.aliqii;
	END LOOP;
	UPDATE classfiscal SET aliqiva = 0;
	ALTER TABLE produto ENABLE TRIGGER ALL;
END;
$$ LANGUAGE plpgsql VOLATILE;
SELECT temp();
DROP FUNCTION temp();