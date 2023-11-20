-- As queries foram geradas tendo como base um Banco de Dados PostgreSQL criado a partir do Modelo de dados disponível em https://bit.ly/refera-dados-da .
-- Os nomes de todas as colunas foram mantidos. Assim como o nome da cada planilha do arquivo Dimensoes_DadosModelagem.xlsx.
-- Cada planilha de Dimensoes_DadosModelagem.xlsx virou uma tabela.
-- O arquivo FatoCabecalho_DadosModelagem.txt virou a tabela 'Vendas'
-- O arquivo FatoDetalhes_DadosModelagem.csv virou a tabela 'Cupons'.

-- Valor total das vendas por produto
SELECT Produto, sum(Valor) valor_total FROM Cupons
JOIN Produtos USING(ProdutoID)
GROUP BY Produto
ORDER BY Produto;

-- Valor total (Produtos + Frete) por ordem de venda
SELECT CupomID, sum(Valor) valor_produtos, ValorFrete, (sum(Valor) + ValorFrete) valor_total 
FROM Vendas JOIN Cupons USING (CupomID) 
GROUP BY CupomID
ORDER BY CupomID;


-- Valor total das vendas por tipo de produto
SELECT Categoria, sum(Valor) valor_total FROM Cupons
JOIN Produtos USING(ProdutoID)
JOIN Categoria USING(CategoriaID)
GROUP BY CategoriaID, Categoria
ORDER BY valor_total DESC;

-- Quantidade e valor das vendas por Dia
SELECT Data, count(CupomID) vendas, sum(Valor) valor_total FROM Cupons
JOIN Vendas USING(CupomID)
GROUP BY Data
ORDER BY Data;

-- Quantidade e valor das vendas por Mês
SELECT to_char(Data, 'YYYY/mm') mes, count(CupomID) vendas, sum(Valor) valor_total FROM Cupons
JOIN Vendas USING(CupomID)
GROUP BY mes
ORDER BY mes;

-- Quantidade e valor das vendas por Ano
SELECT to_char(Data, 'YYYY') ano, count(CupomID) vendas, sum(Valor) valor_total FROM Cupons
JOIN Vendas USING(CupomID)
GROUP BY ano
ORDER BY ano;

-- Lucro dos Meses
SELECT to_char(Data, 'YYYY/mm') mes, sum(ValorLiquido-Desconto) lucro FROM Cupons
JOIN Vendas USING(CupomID)
GROUP BY mes
ORDER BY mes;

-- Vendas por produto
SELECT Produto, sum(Quantidade) total
FROM Cupons JOIN Produtos USING (ProdutoID)
GROUP BY Produto
ORDER BY Produto;

-- Vendas por Cliente
SELECT Cliente, count(CupomID) total_vendas
FROM Vendas JOIN Clientes USING (ClienteID)
GROUP BY Cliente
ORDER BY Cliente;

-- Vendas por Cidade
SELECT Cidade, count(CupomID) total_vendas
FROM Vendas JOIN Clientes USING (ClienteID)
GROUP BY Cidade
ORDER BY Cidade;

-- Media de produtos vendidos por compra
SELECT AVG(produtos_vendidos) FROM 
(SELECT CupomID, sum(Quantidade) produtos_vendidos
FROM Cupons JOIN Vendas USING (CupomID)
GROUP BY CupomID);

-- Média de compras por Cliente
SELECT AVG(vendas) media_vendas_cliente FROM 
(SELECT ClienteID, count(CupomID) vendas
FROM Vendas
GROUP BY ClienteID);