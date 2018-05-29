CREATE OR REPLACE FUNCTION temp() RETURNS void AS $$
DECLARE
	reg record;
BEGIN
	FOR reg IN SELECT * FROM information_schema.tables WHERE table_schema = 'public' AND table_type = 'BASE TABLE' LOOP
		EXECUTE 'ALTER TABLE ' || reg.table_name || ' DISABLE TRIGGER USER';
	END LOOP;
END;
$$ LANGUAGE plpgsql VOLATILE;
SELECT temp();

