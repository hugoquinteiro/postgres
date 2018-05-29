ALTER TABLE cliente DISABLE TRIGGER ALL;
UPDATE cliente SET
	debito1 = COALESCE((SELECT SUM(valorliquido) FROM lancamento WHERE pagrec = 'R' AND status = 'A' AND tipoparceiro = 'C' AND codparceiro = cliente.codcliente AND codespecie IN (SELECT codespecie FROM especie WHERE limitecliente = 1)),0),
	debito2 = COALESCE((SELECT SUM(valorliquido) FROM lancamento WHERE pagrec = 'R' AND status = 'A' AND tipoparceiro = 'C' AND codparceiro = cliente.codcliente AND codespecie IN (SELECT codespecie FROM especie WHERE limitecliente = 2)),0);
ALTER TABLE cliente ENABLE TRIGGER ALL;