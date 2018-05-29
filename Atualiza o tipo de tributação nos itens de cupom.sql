CREATE OR REPLACE FUNCTION temp() RETURNS void AS $$
	DECLARE row_classfiscal classfiscal%ROWTYPE;
BEGIN
	ALTER TABLE itcupom DISABLE TRIGGER ALL;
	FOR row_classfiscal IN SELECT * FROM classfiscal LOOP
		UPDATE itcupom SET tptribicms = (CASE WHEN row_classfiscal.tptribicms = 'R' THEN 'T' ELSE row_classfiscal.tptribicms END) WHERE codproduto IN (SELECT codproduto FROM produto WHERE codcfpdv = row_classfiscal.codcf);
	END LOOP;
	ALTER TABLE itcupom ENABLE TRIGGER ALL;
END;
$$ LANGUAGE plpgsql VOLATILE;
SELECT temp();