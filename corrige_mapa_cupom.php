<?php
require_once("../support/require_php.php");

$codestabelec = 1;
$dataini = "2013-04-11";
$datafin = "2013-04-11";

$diferenca_maxima = 0;
$arr_tributacao = array(array("I",0),array("F",0),array("N",0),array("T",0),array("T",7),array("T",8.4),array("T",12),array("T",18),array("T",25));

$con = new Connection();
$con->start_transaction();

// Carrega os mapa resumos
$res_maparesumo = $con->query("SELECT * FROM maparesumo WHERE codestabelec = ".$codestabelec." AND dtmovto BETWEEN '".$dataini."' AND '".$datafin."' ORDER BY dtmovto, caixa");
$arr_maparesumo = $res_maparesumo->fetchAll(2);
foreach($arr_maparesumo as $row_maparesumo){

	// Carrega o total dos cupons relacionados ao mapa resumo
	$res_totalliquido = $con->query("SELECT SUM(itcupom.valortotal) FROM itcupom INNER JOIN cupom USING (idcupom) WHERE cupom.codestabelec = ".$row_maparesumo["codestabelec"]." AND cupom.dtmovto = '".$row_maparesumo["dtmovto"]."' AND cupom.caixa = ".$row_maparesumo["caixa"]." AND cupom.status = 'A' AND itcupom.status = 'A' AND itcupom.composicao IN ('N','P')");
	$cupom_totalliquido = $res_totalliquido->fetchColumn();

	echo $row_maparesumo["caixa"]." => ".$row_maparesumo["totalliquido"]." - ".$cupom_totalliquido." = ".round(abs($row_maparesumo["totalliquido"] - $cupom_totalliquido),2)."<br>";

	// Verifica se os totais de cupom e igual ao total do mapa resumo
	if(abs($row_maparesumo["totalliquido"] - $cupom_totalliquido) >= $diferenca_maxima){

		$arr_diferenca = capturar_diferencas($row_maparesumo);

		// Migra de uma tributacao para outra, afim de tentar balancear o maximo possivel
		foreach($arr_diferenca as $tributacao_1 => $total_1){
			$arr_tributacao_1 = explode(";",$tributacao_1);
			$diferenca = $total_1[0] - $total_1[1];
			$n = 0;
			while($diferenca > 0 && $n++ < 500){
				foreach($arr_diferenca as $tributacao_2 => $total_2){
					$arr_tributacao_2 = explode(";",$tributacao_2);
					if($total_2[0] < $total_2[1] && abs($total_2[0] - $total_2[1]) > 0){
						// Procura por um item de cupom que se encaixe na diferenca
						$res_itcupom = $con->query("SELECT itcupom.* FROM itcupom INNER JOIN cupom USING (idcupom) WHERE cupom.codestabelec = ".$row_maparesumo["codestabelec"]." AND cupom.dtmovto = '".$row_maparesumo["dtmovto"]."' AND cupom.caixa = ".$row_maparesumo["caixa"]." AND cupom.status = 'A' AND itcupom.composicao IN ('N','P') AND itcupom.status = 'A' AND itcupom.tptribicms = '".$arr_tributacao_2[0]."' AND itcupom.aliqicms = ".$arr_tributacao_2[1]." AND valortotal <= ".abs($diferenca)." ORDER BY valortotal DESC LIMIT 1");
						$arr_itcupom = $res_itcupom->fetchAll(2);
						if(sizeof($arr_itcupom) > 0){
							$row_itcupom = reset($arr_itcupom);
							$arr_diferenca[$tributacao_1][1] += $row_itcupom["valortotal"];
							$arr_diferenca[$tributacao_2][1] -= $row_itcupom["valortotal"];
							$con->exec("UPDATE itcupom SET tptribicms = '".$arr_tributacao_1[0]."', aliqicms = ".$arr_tributacao_1[1]." WHERE idcupom = ".$row_itcupom["idcupom"]." AND codproduto = ".$row_itcupom["codproduto"]." AND codprodutopai = ".$row_itcupom["codprodutopai"]);
						}else{
							break;
						}
					}
				}
				$diferenca = $arr_diferenca[$tributacao_1][0] - $arr_diferenca[$tributacao_1][1];
			}
		}

		$arr_diferenca = capturar_diferencas($row_maparesumo);

		// Percorre as tributacoes que nao devem ter itens nenhum
		foreach($arr_diferenca as $tributacao_1 => $total_1){
			$arr_tributacao_1 = explode(";",$tributacao_1);
			if($total_1[0] == 0){
				// Identifica a tributacao que esta com a maior diferenca para migrar o produto da tributacao zerada
				$tributacao_migrar = NULL; //  Indice da tributacao que o produto sera migrado
				$diferenca_migrar = NULL; // Total da diferenca da tributacao que o produto sera migrado
				foreach($arr_diferenca as $tributacao_2 => $total_2){
					$arr_tributacao_2 = explode(";",$tributacao_2);
					if(is_null($tributacao_migrar) || $total_2[0] - $total_2[1] > $diferenca_migrar){
						$tributacao_migrar = $tributacao_2;
						$diferenca_migrar = $total_2[0] - $total_2[1];
					}
				}
				if(!is_null($tributacao_migrar)){
					$arr_tributacao_2 = explode(";",$tributacao_migrar);
					$res_itcupom = $con->query("SELECT itcupom.* FROM itcupom INNER JOIN cupom USING (idcupom) WHERE cupom.codestabelec = ".$row_maparesumo["codestabelec"]." AND cupom.dtmovto = '".$row_maparesumo["dtmovto"]."' AND cupom.caixa = ".$row_maparesumo["caixa"]." AND cupom.status = 'A' AND itcupom.composicao IN ('N','P') AND itcupom.status = 'A' AND itcupom.tptribicms = '".$arr_tributacao_1[0]."' AND itcupom.aliqicms = ".$arr_tributacao_1[1]);
					$arr_itcupom = $res_itcupom->fetchAll(2);
					$row_itcupom = reset($arr_itcupom);
					$arr_diferenca[$tributacao_1][1] -= $row_itcupom["valortotal"];
					$arr_diferenca[$tributacao_migrar][1] += $row_itcupom["valortotal"];
					$con->exec("UPDATE itcupom SET tptribicms = '".$arr_tributacao_2[0]."', aliqicms = ".$arr_tributacao_2[1]." WHERE idcupom = ".$row_itcupom["idcupom"]." AND codproduto = ".$row_itcupom["codproduto"]." AND codprodutopai = ".$row_itcupom["codprodutopai"]);
				}
			}
		}

		$arr_diferenca = capturar_diferencas($row_maparesumo);

		// Verifica as tributacoes que ainda ficaram com diferenca e ajusta o preco dos produtos
		foreach($arr_diferenca as $tributacao => $total){
			$diferenca = $total[0] - $total[1];
			$arr_tributacao_1 = explode(";",$tributacao);
			$res_itcupom = $con->query("SELECT itcupom.* FROM itcupom INNER JOIN cupom USING (idcupom) WHERE cupom.codestabelec = ".$row_maparesumo["codestabelec"]." AND cupom.dtmovto = '".$row_maparesumo["dtmovto"]."' AND cupom.caixa = ".$row_maparesumo["caixa"]." AND cupom.status = 'A' AND itcupom.composicao IN ('N','P') AND itcupom.status = 'A' AND itcupom.tptribicms = '".$arr_tributacao_1[0]."' AND itcupom.aliqicms = ".$arr_tributacao_1[1]." AND desconto = 0 AND acrescimo = 0 ORDER BY valortotal DESC");
			$arr_itcupom = $res_itcupom->fetchAll(2);
			foreach($arr_itcupom as $row_itcupom){
				if($row_itcupom["valortotal"] > $diferenca){
					$con->exec("UPDATE itcupom SET preco = ".($row_itcupom["preco"] + ($diferenca / $row_itcupom["quantidade"])).", valortotal = 0 WHERE idcupom = ".$row_itcupom["idcupom"]." AND codproduto = ".$row_itcupom["codproduto"]." AND codprodutopai = ".$row_itcupom["codprodutopai"]);
					$diferenca = 0;
				}else{
					$con->exec("UPDATE itcupom SET preco = 0.01, valortotal = 0 WHERE idcupom = ".$row_itcupom["idcupom"]." AND codproduto = ".$row_itcupom["codproduto"]." AND codprodutopai = ".$row_itcupom["codprodutopai"]);
					$diferenca -= ($row_itcupom["preco"] - 0.01);
				}
				if($diferenca == 0){
					break;
				}
			}
		}

		$arr_diferenca = capturar_diferencas($row_maparesumo);

		if(sizeof($arr_diferenca) > 0){
			var_dump($arr_diferenca);
		}
	}
}

$con->commit();


function capturar_diferencas($row_maparesumo){
	global $con, $arr_tributacao;

	$arr_diferenca = array();
	foreach($arr_tributacao as $tributacao){
		// Carrega os impostos do mapa resumo
		$res_maparesumoimposto = $con->query("SELECT * FROM maparesumoimposto WHERE codmaparesumo = ".$row_maparesumo["codmaparesumo"]." AND tptribicms = '".$tributacao[0]."' AND aliqicms = ".$tributacao[1]);
		$arr_maparesumoimposto = $res_maparesumoimposto->fetchAll(2);
		$row_maparesumoimposto = reset($arr_maparesumoimposto);

		// Carrega os itens de cupom
		$res_itcupom = $con->query("SELECT itcupom.* FROM itcupom INNER JOIN cupom USING (idcupom) WHERE cupom.codestabelec = ".$row_maparesumo["codestabelec"]." AND cupom.dtmovto = '".$row_maparesumo["dtmovto"]."' AND cupom.caixa = ".$row_maparesumo["caixa"]." AND cupom.status = 'A' AND itcupom.composicao IN ('N','P') AND itcupom.status = 'A' AND itcupom.tptribicms = '".$tributacao[0]."' AND itcupom.aliqicms = ".$tributacao[1]);
		$arr_itcupom = $res_itcupom->fetchAll(2);

		$totalliquido_itcupom = 0;
		foreach($arr_itcupom as $row_itcupom){
			$totalliquido_itcupom += round($row_itcupom["valortotal"],2);
		}

		$totalliquido_maparesumoimposto = number_format($row_maparesumoimposto["totalliquido"],2,".","");
		$totalliquido_itcupom = number_format($totalliquido_itcupom,2,".","");

		if(abs(round($totalliquido_maparesumoimposto,2) - round($totalliquido_itcupom,2)) > 0){
			$arr_diferenca[$tributacao[0].";".$tributacao[1]] = array((float)$totalliquido_maparesumoimposto,(float)$totalliquido_itcupom);
		}
	}

	return verificar_diferencas($arr_diferenca);
}

function verificar_diferencas($arr_diferenca){
	$arr_diferenca_aux = array();
	foreach($arr_diferenca as $tributacao => $total){
		if(abs($total[0] - $total[1]) > 0){
			$arr_diferenca_aux[$tributacao] = $total;
		}
	}
	return $arr_diferenca_aux;
}
?>