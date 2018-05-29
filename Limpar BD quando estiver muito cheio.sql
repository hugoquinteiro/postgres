CREATE OR REPLACE FUNCTION temporario() RETURNS void AS $$
DECLARE
	var_dtlimpeza DATE;
	var_tabela VARCHAR(100);
BEGIN
	--  Data inicial do processo (padrao: 5 anos)
	var_dtlimpeza := CURRENT_DATE - '5 years'::INTERVAL;

	-- Desabilita todas as triggers do sistema
	RAISE NOTICE 'Desabilitando triggers do banco de dados.';
	FOR var_tabela IN SELECT relname FROM pg_stat_user_tables WHERE schemaname = 'public' ORDER BY 1 LOOP
		EXECUTE('ALTER TABLE ' || var_tabela || ' DISABLE TRIGGER USER');
	END LOOP;

	-- Armazena o estoque dos produtos antes de iniciar a limpeza
	RAISE NOTICE 'Atualizando saldo inicial de estoque dos produtos.';
	UPDATE produtoestab SET sldinicio = saldo(codestabelec, codproduto, (var_dtlimpeza - '1 day'::INTERVAL)::DATE);

	-- Limpa os dados das tabelas
	RAISE NOTICE 'Limpando tabela consvendadia.';      DELETE FROM consvendadia WHERE dtmovto < var_dtlimpeza;
	RAISE NOTICE 'Limpando tabela consvendadiadep.';   DELETE FROM consvendadiadep WHERE dtmovto < var_dtlimpeza;
	RAISE NOTICE 'Limpando tabela consvendames.';      DELETE FROM consvendames WHERE ano < EXTRACT(YEAR FROM var_dtlimpeza) OR (ano = EXTRACT(YEAR FROM var_dtlimpeza) AND mes < EXTRACT(MONTH FROM var_dtlimpeza));
	RAISE NOTICE 'Limpando tabela cotacao.';           DELETE FROM cotacao WHERE datacriacao < var_dtlimpeza;
	RAISE NOTICE 'Limpando tabela cupom.';             DELETE FROM cupom WHERE dtmovto < var_dtlimpeza;
	RAISE NOTICE 'Limpando tabela datavalidade.';      DELETE FROM datavalidade WHERE data < var_dtlimpeza;
	RAISE NOTICE 'Limpando tabela diastrabalhados.';   DELETE FROM diastrabalhados WHERE data < var_dtlimpeza;
	RAISE NOTICE 'Limpando tabela historico.';         DELETE FROM historico WHERE dtcriacao < var_dtlimpeza;
	RAISE NOTICE 'Limpando tabela inventario.';        DELETE FROM inventario WHERE data < var_dtlimpeza;
	RAISE NOTICE 'Limpando tabela lancamento.';        DELETE FROM lancamento WHERE dtvencto < var_dtlimpeza AND status IN ('L', 'R');
	RAISE NOTICE 'Limpando tabela lancamentogru.';     DELETE FROM lancamentogru WHERE dtemissao < var_dtlimpeza;
	RAISE NOTICE 'Limpando tabela leitura_data.';      DELETE FROM leitura_data WHERE dtmovto < var_dtlimpeza;
	RAISE NOTICE 'Limpando tabela logetiqueta.';       DELETE FROM logetiqueta WHERE data < var_dtlimpeza;
	RAISE NOTICE 'Limpando tabela logpreco.';          DELETE FROM logpreco WHERE data < var_dtlimpeza;
	RAISE NOTICE 'Limpando tabela maparesumo.';        DELETE FROM maparesumo WHERE dtmovto < var_dtlimpeza;
	RAISE NOTICE 'Limpando tabela movimento.';         DELETE FROM movimento WHERE dtmovto < var_dtlimpeza;
	RAISE NOTICE 'Limpando tabela notacomplemento.';   DELETE FROM notacomplemento WHERE dtemissao < var_dtlimpeza OR idnotafiscal IN (SELECT idnotafiscal FROM notafiscal WHERE dtemissao < var_dtlimpeza);
	RAISE NOTICE 'Limpando tabela notadiversa.';       DELETE FROM notadiversa WHERE dtemissao < var_dtlimpeza;
	RAISE NOTICE 'Limpando tabela notafiscal.';        DELETE FROM notafiscal WHERE dtemissao < var_dtlimpeza OR (codestabelec, numpedido) IN (SELECT codestabelec, numpedido FROM pedido WHERE dtemissao < var_dtlimpeza);
	RAISE NOTICE 'Limpando tabela notafrete.';         DELETE FROM notafrete WHERE dtemissao < var_dtlimpeza;
	RAISE NOTICE 'Limpando tabela ocorrencia.';        DELETE FROM ocorrencia WHERE dtcriacao < var_dtlimpeza;
	RAISE NOTICE 'Limpando tabela oferta.';            DELETE FROM oferta WHERE datafinal < var_dtlimpeza;
	RAISE NOTICE 'Limpando tabela pedido.';            DELETE FROM pedido WHERE dtemissao < var_dtlimpeza;
	RAISE NOTICE 'Limpando tabela produtoestabsaldo.'; DELETE FROM produtoestabsaldo WHERE data < var_dtlimpeza;

	-- Corrige saldo de estoque dos produtos
	RAISE NOTICE 'Recalculando estoque dos produtos a partir das movimentacoes.';
	UPDATE produtoestab SET
		sldentrada = COALESCE((SELECT SUM(qtdeunidade * quantidade) FROM movimento WHERE tipo = 'E' AND codestabelec = produtoestab.codestabelec AND codproduto = produtoestab.codproduto), 0),
		sldsaida = COALESCE((SELECT SUM(qtdeunidade * quantidade) FROM movimento WHERE tipo = 'S' AND codestabelec = produtoestab.codestabelec AND codproduto = produtoestab.codproduto), 0);
	UPDATE produtoestab SET sldatual = sldinicio + sldentrada - sldsaida;

	-- Habilita todas as triggers do sistema
	RAISE NOTICE 'Habilitando triggers do banco de dados.';
	FOR var_tabela IN SELECT relname FROM pg_stat_user_tables WHERE schemaname = 'public' ORDER BY 1 LOOP
		EXECUTE('ALTER TABLE ' || var_tabela || ' ENABLE TRIGGER USER');
	END LOOP;

	-- Finaliza o processo
	RAISE NOTICE 'Processo finalizado com sucesso!';
END;
$$ LANGUAGE plpgsql VOLATILE;

SELECT temporario();