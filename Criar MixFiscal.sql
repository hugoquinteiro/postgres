DO $$
BEGIN
	IF (SELECT COUNT(*) FROM pg_catalog.pg_user WHERE usename = 'mixfiscal') = 0 THEN
		CREATE USER mixfiscal WITH password '$MIXfiscal$cws123';
		REVOKE ALL PRIVILEGES ON SCHEMA public FROM mixfiscal;
	END IF;
	GRANT ALL ON mxf_tmp_icms_entrada TO mixfiscal;		
	GRANT ALL ON mxf_tmp_icms_saida TO mixfiscal;
	GRANT ALL ON mxf_tmp_pis_cofins TO mixfiscal;
	GRANT SELECT ON mxf_vw_icms TO mixfiscal;
	GRANT SELECT ON mxf_vw_pis_cofins TO mixfiscal;
END $$;