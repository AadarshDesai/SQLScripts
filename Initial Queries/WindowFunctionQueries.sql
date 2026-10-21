--WINDOW FUNCTIONS

--Find the total sales for each product
SELECT 
	ProductID,
	SUM(sales) AS Total_Sales
FROM Sales.Orders
GROUP BY ProductID

--Find the total sales for each product
--Additionally Provide orderID and OrderDate as well. 

SELECT 
	OrderID,
	OrderDate,
	ProductID,
	SUM(sales) OVER(PARTITION BY ProductID) AS Total_Sales
FROM Sales.Orders

--Find the total sales accross all orders
--Additionally provide details such as OrderID, OrderDate

SELECT
	OrderId,
	OrderDate,
	SUM(sales) OVER() AS Total_Sales
FROM Sales.Orders


--Find the total sales for each product
--Find the total sales accross all orders
--Additionally provide details such as OrderID, OrderDate

SELECT
	OrderId,
	OrderDate,
	Sales,
	SUM(sales) OVER() AS Total_Sales,
	ProductID,
	SUM(sales) OVER(PARTITION BY ProductID) AS TotalSalesByProduct
FROM Sales.Orders


--Find the total sales for each product
--Find the total sales accross all orders
--Additionally provide details such as OrderID, OrderDate
--Find the total sales for each combination of product and order status

SELECT
	OrderID,
	OrderDate,
	Sales,
	ProductID,
	SUM(Sales) OVER() AS TotalSales,
	SUM(Sales) OVER(PARTITION BY ProductID) AS TotalSalesByProduct,
	SUM(Sales) OVER(PARTITION BY ProductID, OrderStatus) AS CombinedResult
FROM Sales.Orders


--Rank each order based on their sales from highest to lowest
--Additionally provide details such as orderID and orderDate

SELECT
	OrderID,
	OrderDate,
	Sales,
	RANK() OVER(ORDER BY Sales DESC) SalesRank
FROM Sales.Orders


--FRAME Clause

SELECT
	OrderID,
	OrderDate,
	OrderStatus,
	Sales,
	SUM(Sales) OVER(PARTITION BY OrderStatus ORDER BY OrderDate 
	ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING) AS TotalSales
FROM Sales.Orders

SELECT
	*
FROM Sales.Orders
