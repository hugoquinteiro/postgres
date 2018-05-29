ALTER TABLE itpedido DISABLE TRIGGER USER;
ALTER TABLE produtoestab DISABLE TRIGGER USER;
UPDATE itpedido SET qtdeatendida = quantidade WHERE qtdeatendida > quantidade;
UPDATE produtoestab SET preventrada = COALESCE((SELECT SUM(qtdeunidade * (quantidade - qtdeatendida)) FROM itpedido WHERE codestabelec = produtoestab.codestabelec AND codproduto = produtoestab.codproduto AND status IN ('A','P') AND operacao IN (SELECT operacao FROM operacaonota WHERE tipo = 'E')),0);
ALTER TABLE produtoestab ENABLE TRIGGER USER;
ALTER TABLE itpedido ENABLE TRIGGER USER;