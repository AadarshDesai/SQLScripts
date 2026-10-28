--Views

--Find the running total of sales for each month
WITH CTE_MonthlySummary AS
(
	SELECT
	DATETRUNC(Month, OrderDate) AS OrderMonth,
	SUM(Sales) totalSales,
	COUNT(OrderID) numberOfOrders,
	SUM(Quantity) totalQuantity
	FROM Sales.Orders
	GROUP BY DATETRUNC(Month, OrderDate)
)
SELECT
OrderMonth,
totalSales,
SUM(totalSales) OVER(ORDER BY OrderMonth) AS RunningTotal
FROM CTE_MonthlySummary;


--What if we use the result of CTE into multiple queries outside of this query?
--In that case we will end up writing the same logic everywhere! 
--Insted of that we can create a view and use the view as a reference table for each of those queries.
--We have to run this query seperately as an individual query. 
--View_MonthlySummary.SQL

/*
CREATE VIEW View_MonthlySummary AS
(
	SELECT
	DATETRUNC(Month, OrderDate) AS OrderMonth,
	SUM(Sales) totalSales,
	COUNT(OrderID) numberOfOrders,
	SUM(Quantity) totalQuantity
	FROM Sales.Orders
	GROUP BY DATETRUNC(Month, OrderDate)
)
*/

SELECT *
FROM Sales.View_MonthlySummary;

--TASK: Provide a view that combines details from orders, products, customers and employees

SELECT 
	o.OrderID,
	o.OrderDate,
	p.Product,
	p.Category,
	COALESCE(c.FirstName, '') + ' ' + COALESCE(c.LastName, '') AS CustomerName,
	c.Country,
	COALESCE(e.FirstName, '') + ' ' + COALESCE(e.LastName, '') AS EmployeeName,
	e.Department,
	o.Quantity,
	o.Sales
FROM Sales.Orders o
LEFT JOIN Sales.Products p
ON p.ProductID = o.ProductID
LEFT JOIN Sales.Customers c
ON c.CustomerID = o.CustomerID
LEFT JOIN Sales.Employees e
ON e.EmployeeID = o.SalesPersonID
WHERE c.Country != 'USA'

SELECT *
FROM Sales.View_CombinedData

SELECT *
FROM Sales.View_EUSalesTeam