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
	ProductID,
	SUM(Sales) OVER(PARTITION BY OrderStatus ORDER BY OrderDate ) AS TotalSales
	--Default frame with ORDER BY is - ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
	-- OR							 - ROWS UNBOUNDED PRECEDING
	-- Both are same. 
FROM Sales.Orders
WHERE ProductID IN (101,102)


--Rank customers based on their total sales. 
SELECT
	CustomerID,
	SUM(Sales) AS totalSales,
	RANK() OVER(ORDER BY SUM(Sales) DESC) AS Ranks
FROM Sales.Orders
GROUP BY CustomerID



--Find the total number of orders
--Find the total number of orders for each customer
--Additionally provide details such as orderID and orderDate
SELECT
	OrderID,
	OrderDate,
	CustomerID,
	COUNT(*) OVER() AS totalRecord,
	COUNT(*) OVER(PARTITION BY CustomerID) AS totalRecordByCustomer
FROM Sales.Orders;

--Find the total number of customers
--Additionally provide all customers details. 

SELECT
	*,
	COUNT(*) OVER() AS totalCustomers,
	COUNT(Score) OVER() AS totalScore,
	COUNT(Country) OVER() AS totalCountry
FROM Sales.Customers;

--Check whether the table Orders contains any duplicate rows
SELECT
	*
FROM (
	SELECT
		OrderID,
		COUNT(*) OVER(PARTITION BY OrderID) AS CheckPK
	FROM Sales.OrdersArchive
) t WHERE CheckPK > 1



--Find the total sales across all orders
--And the total sales for each product
--Additionally provide details such as OrderID and OrderDate. 
SELECT
	OrderID,
	OrderDate,
	ProductID,
	SUM(Sales) OVER(PARTITION BY ProductID) AS totalSalesByProd,
	SUM(Sales) OVER() AS totalSales
FROM Sales.Orders


--Find the percentage contribution of each product's sales to the total sales. 

SELECT
	OrderID,
	ProductID,
	Sales,
	SUM(Sales) OVER() AS totalSales,
	--In order to find the percentage we need to divide (sales/totalSales)*100
	ROUND(CAST(Sales AS FLOAT) / SUM(Sales) OVER() * 100, 2 ) AS percentageSales
FROM Sales.Orders

--Find the average sales for each prouct
SELECT
	ProductID,
	Sales,
	AVG(COALESCE(Sales, 0)) OVER(PARTITION BY ProductID) AS AvgSales
FROM Sales.Orders;

--Find the average sales accross all orders
--And find the average sales for each product
--Additionally provide details such as OrderId and OrderDate
SELECT
	OrderID,
	OrderDate,
	ProductID,
	Sales,
	AVG(COALESCE(Sales, 0)) OVER() AS avgSales, --COALESCE Handles the nulls here. 
	AVG(COALESCE(Sales, 0)) OVER(PARTITION BY ProductID) AS avgSalesByProd
FROM Sales.Orders;

--Find the average scores of customers
--Additionally provide details such as customerID and LastName

SELECT
	CustomerID,
	LastName,
	AVG(COALESCE(Score, 0)) OVER() AS AvgScore --COALESCE Is Handling NULLS here. 
FROM Sales.Customers;

--Find all orders where sales are higher than the average sales across all orders
/* --------------One Way----------
SELECT
	OrderID,
	ProductID,
	Sales
	--AVG(Sales) OVER() AS avgSales
FROM Sales.Orders
WHERE Sales > 
(SELECT
	AVG(Sales)
FROM Sales.Orders)
*/

--------------Another Way/Better Way-----------------
SELECT
	*
FROM
(SELECT
	OrderID,
	ProductID,
	Sales,
	AVG(Sales) OVER() AS AvgSales
FROM Sales.Orders
) t WHERE Sales > AvgSales

--Find the highest and lowest sales of all orders
--Find the highest and lowest sales for each product
--Addtionally provide detials such as orderID and orderDate

SELECT
	OrderID,
	OrderDate,
	ProductID,
	Sales,
	MAX(Sales) OVER() AS highestSales,
	MIN(Sales) OVER() AS lowestSales,
	MAX(Sales) OVER(PARTITION BY ProductID) AS highestSalesByProd,
	MIN(Sales) OVER(PARTITION BY ProductID) AS lowestSalesByProd
FROM Sales.Orders

--Show the employees who have the highest salaries 
SELECT 
	*
FROM
(SELECT 
	*,
	MAX(Salary) OVER() HighestSalary
FROM Sales.Employees
) t WHERE Salary = HighestSalary

/*---Without subquery or window function---
SELECT TOP 1
	*
FROM Sales.Employees
ORDER BY Salary DESC
*/

--Find the deviation of each sales from the minimum and maximum sales amount. 
SELECT
	OrderID,
	OrderDate,
	ProductID,
	Sales,
	MAX(Sales) OVER() AS highestSales,
	MIN(Sales) OVER() AS lowestSales,
	MAX(Sales) OVER(PARTITION BY ProductID) AS highestSalesByProd,
	MIN(Sales) OVER(PARTITION BY ProductID) AS lowestSalesByProd,
	Sales - MIN(Sales) OVER() AS deviationFromMin,
	MAX(Sales) OVER() - Sales AS deviationFromMax
FROM Sales.Orders

--Calculate moving average of sales for each product over time. 
SELECT 
	OrderID,
	ProductID,
	OrderDate,
	Sales,
	AVG(Sales) OVER(PARTITION BY ProductID ORDER BY OrderDate 
	ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS movingAvg
FROM Sales.Orders

--Calculate moving average of sales for each product over time, including only the next order
SELECT 
	OrderID,
	ProductID,
	OrderDate,
	Sales,
	AVG(Sales) OVER(PARTITION BY ProductID ORDER BY OrderDate) AS movingAvg,
	AVG(Sales) OVER(PARTITION BY ProductID ORDER BY OrderDate 
	ROWS BETWEEN CURRENT ROW AND 1 FOLLOWING) AS rollingAvg
FROM Sales.Orders



--Rank the orders based on their sales from highest to lowest 
SELECT
	OrderID,
	ProductID,
	Sales,
	ROW_NUMBER() OVER(ORDER BY Sales DESC) AS RowNumberRank,
	RANK() OVER(ORDER BY Sales DESC) AS RankRank,
	DENSE_RANK() OVER(ORDER BY Sales DESC) AS DenseRank
FROM Sales.Orders

--Find the top highest sales for each product
SELECT 
	*
FROM
(SELECT
	OrderID,
	ProductID,
	Sales,
	ROW_NUMBER() OVER(PARTITION BY ProductID ORDER BY Sales DESC) AS salesRank
FROM Sales.Orders
) t WHERE salesRank = 1

--Find the lowest two customers based on their total sales 
SELECT *
FROM
(SELECT
	CustomerID,
	SUM(Sales) AS TotalSales,
	ROW_NUMBER() OVER(ORDER BY SUM(Sales)) AS salesRank
FROM Sales.Orders
GROUP BY CustomerID
)t WHERE salesRank <= 2

SELECT
	ROW_NUMBER() OVER(ORDER BY OrderID, OrderDate) AS UniqueID,
	*
FROM Sales.OrdersArchive


--Identify duplicate rows in the table ordersArchive
--And return a clean result without any duplicates
SELECT
	*
FROM
(	SELECT
		ROW_NUMBER() OVER(PARTITION BY OrderID ORDER BY CreationTime DESC) AS rn,
		*
	FROM Sales.OrdersArchive
)t WHERE rn = 1

--NTILE()

SELECT
	OrderID,
	Sales,
	NTILE(5) OVER(ORDER BY Sales DESC) AS buckets
FROM Sales.Orders

--Segment all orders into 3 categories: high, medium and low sales. 


SELECT
	OrderID,
	Sales,
	--NTILE(3) OVER(ORDER BY Sales DESC) AS salesBucket,
	CASE NTILE(3) OVER(ORDER BY Sales DESC)
		WHEN 1 THEN 'High'
		WHEN 2 THEN 'Medium'
		WHEN 3 THEN 'Low'
		ELSE 'N/A'
	END AS category
FROM Sales.Orders

--In order to export the data divide the orders into 2 groups
SELECT
	NTILE(2) OVER(ORDER BY OrderID) AS bucket,
	*
FROM Sales.Orders;

--USE of CUME_DIST and PERCENT_RANK()
--FInd the products that fall within the highest 40% of prices
SELECT 
	Product,
	Price, 
	distRank * 100
FROM
(SELECT
	Product,
	Price,
	CUME_DIST() OVER(ORDER BY Price DESC) distRank
FROM Sales.Products
)t WHERE distRank <= 0.4


SELECT
	*
FROM Sales.Employees

SELECT
	*
FROM Sales.Customers

SELECT
	*
FROM Sales.Orders
