CREATE OR REPLACE FUNCTION senha(text) RETURNS text AS $$
	DECLARE a text;
	DECLARE b text;
	DECLARE i integer;
BEGIN
	a := $1;
	b := '';
	i := 1;
	WHILE i <= LENGTH(a) LOOP
		b := b || CHR(255 - ASCII(SUBSTR(a,i,1)));
		i := i + 1;
	END LOOP;
	RETURN b;
END;
$$ LANGUAGE plpgsql VOLATILE;

SELECT senha('œˆŒ');