--
-- PostgreSQL database dump
--

-- Started on 2011-07-06 12:32:39

SET client_encoding = 'WIN1252';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

SET search_path = public, pg_catalog;

--
-- TOC entry 2875 (class 0 OID 1813947)
-- Dependencies: 2395
-- Data for Name: etiqgondola; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO etiqgondola (codetiqgondola, descricao, altura, largura, temperatura, tipodescricao, show_estabelecimento, orie_estabelecimento, posx_estabelecimento, posy_estabelecimento, font_estabelecimento, larg_estabelecimento, altu_estabelecimento, show_descricao, orie_descricao, posx_descricao, posy_descricao, font_descricao, larg_descricao, altu_descricao, show_preco, orie_preco, posx_preco, posy_preco, font_preco, larg_preco, altu_preco, show_dtpreco, orie_dtpreco, posx_dtpreco, posy_dtpreco, font_dtpreco, larg_dtpreco, altu_dtpreco, show_moeda, orie_moeda, posx_moeda, posy_moeda, font_moeda, larg_moeda, altu_moeda, show_codean, orie_codean, posx_codean, posy_codean, font_codean, larg_codean, altu_codean, show_codproduto, orie_codproduto, posx_codproduto, posy_codproduto, font_codproduto, larg_codproduto, altu_codproduto, show_unidade, orie_unidade, posx_unidade, posy_unidade, font_unidade, larg_unidade, altu_unidade, numcarreiras, tipopreco, show_qtdeunidade, orie_qtdeunidade, posx_qtdeunidade, posy_qtdeunidade, font_qtdeunidade, larg_qtdeunidade, altu_qtdeunidade, precooferta, alturafolha, largurafolha, bordahorizontal, bordavertical) VALUES (1, 'GONDULA', 60, 220, 15, 'N', 'S', NULL, 5, 1, 1, 1, 2, 'S', NULL, 10, 65, 4, 1, 2, 'S', NULL, 120, 10, 4, 3, 3, 'N', NULL, NULL, NULL, NULL, NULL, NULL, 'S', NULL, 25, 15, 2, 1, 3, 'S', NULL, 280, 10, 1, 1, 30, 'N', NULL, NULL, NULL, NULL, NULL, NULL, 'N', NULL, NULL, NULL, NULL, NULL, NULL, 1, 'V', 'N', NULL, NULL, NULL, NULL, NULL, NULL, 'S', NULL, NULL, NULL, NULL);
INSERT INTO etiqgondola (codetiqgondola, descricao, altura, largura, temperatura, tipodescricao, show_estabelecimento, orie_estabelecimento, posx_estabelecimento, posy_estabelecimento, font_estabelecimento, larg_estabelecimento, altu_estabelecimento, show_descricao, orie_descricao, posx_descricao, posy_descricao, font_descricao, larg_descricao, altu_descricao, show_preco, orie_preco, posx_preco, posy_preco, font_preco, larg_preco, altu_preco, show_dtpreco, orie_dtpreco, posx_dtpreco, posy_dtpreco, font_dtpreco, larg_dtpreco, altu_dtpreco, show_moeda, orie_moeda, posx_moeda, posy_moeda, font_moeda, larg_moeda, altu_moeda, show_codean, orie_codean, posx_codean, posy_codean, font_codean, larg_codean, altu_codean, show_codproduto, orie_codproduto, posx_codproduto, posy_codproduto, font_codproduto, larg_codproduto, altu_codproduto, show_unidade, orie_unidade, posx_unidade, posy_unidade, font_unidade, larg_unidade, altu_unidade, numcarreiras, tipopreco, show_qtdeunidade, orie_qtdeunidade, posx_qtdeunidade, posy_qtdeunidade, font_qtdeunidade, larg_qtdeunidade, altu_qtdeunidade, precooferta, alturafolha, largurafolha, bordahorizontal, bordavertical) VALUES (2, 'PRODUTO', 20, 140, 15, 'R', 'N', NULL, NULL, NULL, NULL, NULL, NULL, 'S', NULL, 10, 70, 2, 1, 1, 'N', NULL, NULL, NULL, NULL, NULL, NULL, 'N', NULL, NULL, NULL, NULL, NULL, NULL, 'N', NULL, NULL, NULL, NULL, NULL, NULL, 'S', NULL, 16, 20, 1, 1, 30, 'N', NULL, NULL, NULL, NULL, NULL, NULL, 'N', NULL, NULL, NULL, NULL, NULL, NULL, 3, 'V', 'N', NULL, NULL, NULL, NULL, NULL, NULL, 'N', NULL, NULL, NULL, NULL);
INSERT INTO etiqgondola (codetiqgondola, descricao, altura, largura, temperatura, tipodescricao, show_estabelecimento, orie_estabelecimento, posx_estabelecimento, posy_estabelecimento, font_estabelecimento, larg_estabelecimento, altu_estabelecimento, show_descricao, orie_descricao, posx_descricao, posy_descricao, font_descricao, larg_descricao, altu_descricao, show_preco, orie_preco, posx_preco, posy_preco, font_preco, larg_preco, altu_preco, show_dtpreco, orie_dtpreco, posx_dtpreco, posy_dtpreco, font_dtpreco, larg_dtpreco, altu_dtpreco, show_moeda, orie_moeda, posx_moeda, posy_moeda, font_moeda, larg_moeda, altu_moeda, show_codean, orie_codean, posx_codean, posy_codean, font_codean, larg_codean, altu_codean, show_codproduto, orie_codproduto, posx_codproduto, posy_codproduto, font_codproduto, larg_codproduto, altu_codproduto, show_unidade, orie_unidade, posx_unidade, posy_unidade, font_unidade, larg_unidade, altu_unidade, numcarreiras, tipopreco, show_qtdeunidade, orie_qtdeunidade, posx_qtdeunidade, posy_qtdeunidade, font_qtdeunidade, larg_qtdeunidade, altu_qtdeunidade, precooferta, alturafolha, largurafolha, bordahorizontal, bordavertical) VALUES (3, 'IMPRESSAO EM A4', 31, 72, 0, 'N', 'S', NULL, 15, 27, 2, 4, 6, 'S', NULL, 3, 5, 3, 8, 10, 'S', NULL, 10, 20, 5, 8, 18, 'N', NULL, NULL, NULL, NULL, NULL, NULL, 'N', NULL, NULL, NULL, NULL, NULL, NULL, 'S', NULL, 28, 8, 8, 25, 7, 'N', NULL, NULL, NULL, NULL, NULL, NULL, 'N', NULL, NULL, NULL, NULL, NULL, NULL, 3, 'V', 'N', NULL, NULL, NULL, NULL, NULL, NULL, 'S', 280, 210, 0, 2);


-- Completed on 2011-07-06 12:32:39

--
-- PostgreSQL database dump complete
--

