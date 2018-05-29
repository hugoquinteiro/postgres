ALTER TABLE itpedido DISABLE TRIGGER USER;
ALTER TABLE produtoestab DISABLE TRIGGER USER;
UPDATE itpedido SET qtdeatendida = quantidade WHERE qtdeatendida > quantidade;
UPDATE produtoestab SET prevsaida = COALESCE((SELECT SUM(qtdeunidade * (quantidade - qtdeatendida)) FROM itpedido WHERE codestabelec = produtoestab.codestabelec AND codproduto = produtoestab.codproduto AND status IN ('A','P') AND operacao IN (SELECT operacao FROM operacaonota WHERE tipo = 'S')),0) WHERE codestabelec=1; 
ALTER TABLE produtoestab ENABLE TRIGGER USER;
ALTER TABLE itpedido ENABLE TRIGGER USER;


select idnotafiscal, status, numpedido, codestabelec, operacao FROM notafiscal WHERE numnotafis=5848
select * FROM itnotafiscal WHERE idnotafiscal=5632
SELECT * FROM itpedido WHERE numpedido=6304

UPDATE itpedido SET status='A', qtdeatendida=quantidade WHERE numpedido=6304


SELECT pedido.numpedido, itpedido.numpedido 
FROM pedido INNER JOIN itpedido ON (pedido.codestabelec=itpedido.codestabelec AND pedido.operacao=itpedido.operacao AND pedido.numpedido=itpedido.numpedido)
WHERE itpedido.status='P' AND pedido.status='A' AND pedido.codestabelec=1 AND pedido.operacao='VD'