CREATE OR REPLACE FUNCTION temp() RETURNS void AS $$
	DECLARE var_exibiriva boolean;
	DECLARE var_descricao classfiscal.descricao%TYPE;
	DECLARE row_classfiscal classfiscal%ROWTYPE;
BEGIN
	var_exibiriva := ((SELECT COUNT(*) FROM classfiscal WHERE tptribicms = 'F' AND aliqiva > 0) > 0);
	FOR row_classfiscal IN SELECT * FROM classfiscal LOOP
		var_descricao := row_classfiscal.tptribicms;
		IF row_classfiscal.tptribicms NOT IN ('I','N') THEN
			var_descricao := var_descricao || ' ' || FLOOR(row_classfiscal.aliqicms) || '%';
		END IF;
		IF row_classfiscal.aliqredicms > 0 THEN
			var_descricao := var_descricao || ' red ' || formatar(row_classfiscal.aliqredicms,2) || '%';
		END IF;
		IF var_exibiriva AND row_classfiscal.tptribicms = 'F' THEN
			var_descricao := var_descricao || ' iva ' || formatar(row_classfiscal.aliqiva,4) || '%';
		END IF;
		UPDATE classfiscal SET descricao = var_descricao WHERE codcf = row_classfiscal.codcf;
	END LOOP;
END;
$$ LANGUAGE plpgsql VOLATILE;
SELECT temp();
DROP FUNCTION temp();