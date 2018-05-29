--Coloca todos os itens definindo o campo Sanear como "N"
ALTER TABLE produto DISABLE TRIGGER USER;
UPDATE produto SET sanear='N';
ALTER TABLE produto ENABLE TRIGGER USER;

--Habilita itens que estão com determinado periodo de vendas definido
ALTER TABLE produto DISABLE TRIGGER USER;
UPDATE produto SET sanear='S' WHERE codproduto IN (
SELECT DISTINCT produto.codproduto FROM produto INNER JOIN produtoestab ON (produto.codproduto = produtoestab.codproduto) 
WHERE produtoestab.disponivel = 'S' AND produtoestab.codestabelec = 1 AND produto.codproduto IN 
(SELECT DISTINCT codproduto FROM consvendadia 
WHERE consvendadia.codestabelec = 1 AND consvendadia.dtmovto >= '2001-01-01' AND consvendadia.dtmovto <= '2018-12-31')
)
ALTER TABLE produto ENABLE TRIGGER USER;
