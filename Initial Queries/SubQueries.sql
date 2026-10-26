--Advance SQL Teachniques

--Subqueries

--find the products that have a price higher than the average price of all products

--Main Query
SELECT
	*
FROM
	--Subquery
	(SELECT
	ProductID,
	Product,
	Price,
	AVG(Price) OVER() AS avgPrice
	FROM Sales.Products)t 
WHERE Price > avgPrice

--Rank customers based on their total amount of sales

--MAin Query
SELECT
	*,
	RANK() OVER(ORDER BY totalSales DESC) AS customerRanking
FROM
	--SUB Query
	(SELECT
		CustomerID,
		SUM(Sales)  totalSales
	FROM Sales.Orders
	GROUP BY CustomerID)t

--Subquery in SELECT Query
--Show the productIDs, names, prices and total number of orders
--Main Query
SELECT
	ProductID,
	Product,
	Price,
	--Subquery
	(SELECT COUNT(*) FROM Sales.Orders) AS totalOrders
FROM Sales.Products

--Show all customer detsails and find the total orders of each customer
--Main Query
SELECT 
	c.*,
	t.totalOrders
FROM Sales.Customers c
LEFT JOIN 
	(
	--Sub Query
	SELECT 
	CustomerID,
	COUNT(*) totalOrders
	FROM Sales.Orders
	GROUP BY CustomerID
	)t 
ON c.CustomerID = t.CustomerID

--Subquery with WHERE clause
--Find the products that have a price higher than the average price of all products

--Main Query
SELECT *
FROM Sales.Products
WHERE Price > (
	--Sub Query
	SELECT 
	AVG(Price) 
	FROM Sales.Products
	)

--Show the details of orders made by customers in Germany

--Main Query
SELECT *
FROM Sales.Orders
WHERE CustomerID IN (
					--Sub Query
					SELECT CustomerID
					FROM Sales.Customers
					WHERE Country = 'Germany')

--Show the details of orders made by customers who are not from Germany
--Main Query
SELECT *
FROM Sales.Orders
WHERE CustomerID NOT IN (
					--Sub Query
					SELECT CustomerID
					FROM Sales.Customers
					WHERE Country = 'Germany')

-- Find female employees whose salaries are greater than the salaries of any male employees

--Main Query
SELECT *
FROM Sales.Employees
WHERE Gender = 'F' AND Salary > Any (
									 --Sub Query
									 SELECT Salary
									 FROM Sales.Employees
									 WHERE Gender = 'M')

-- Find female employees whose salaries are greater than the salaries of all male employees
SELECT *
FROM Sales.Employees
WHERE Gender = 'F' AND Salary > ALL (
									 --Sub Query
									 SELECT Salary
									 FROM Sales.Employees
									 WHERE Gender = 'M')
--Correlated sub queries
--Show all customer details and find the total orders for each customer

SELECT 
	*,
	(SELECT COUNT(*) FROM Sales.Orders o WHERE o.CustomerID = c.CustomerID) AS totalOrders
FROM Sales.Customers c

--EXISTS Clause - Dependent or Correlated subquery 
--Show the details of orders made by customers in Germany

SELECT *
FROM Sales.Orders o
WHERE EXISTS (
			  SELECT 1
			  FROM Sales.Customers c
			  WHERE o.CustomerID = c.CustomerID
			  AND c.Country = 'Germany')