--CET Queries

--STEP 1: Find the total sales per customer (Standalone CTE)
WITH CTE_TotalSales AS
(
SELECT 
	CustomerID,
	SUM(Sales) AS totalSales
FROM Sales.Orders
GROUP BY CustomerID
)
--STEP 2: Find the last order date for each customer (Standalone CTE)
, CTE_LastOrderDate AS
(
SELECT
	CustomerID, 
	MAX(OrderDate) AS LastOrderDate
FROM Sales.Orders
GROUP BY CustomerID
)

--STEP 3: Rank the customers based on total sales per customer
,CTE_Rank AS
(
SELECT
	CustomerID,
	RANK() OVER(ORDER BY totalSales DESC) AS salesRanking
FROM CTE_TotalSales
)

--STEP 4: Segment customers based on their total sales
, CTE_Segment AS 
(
SELECT
	CustomerID,
	CASE NTILE(3) OVER(ORDER BY totalSales DESC)
		WHEN 1 THEN 'VIP'
		WHEN 2 THEN 'Important'
	ELSE 'Good'
	END AS segmentation
FROM CTE_TotalSales
)

--Main Query
SELECT 
	c.CustomerID,
	c.FirstName,
	c.LastName,
	cts.totalSales,
	lod.LastOrderDate,
	cr.salesRanking,
	sgmt.segmentation
FROM Sales.Customers c
LEFT JOIN CTE_TotalSales cts
ON cts.CustomerID = c.CustomerID
LEFT JOIN CTE_LastOrderDate lod
ON lod.CustomerID = c.CustomerID
LEFT JOIN CTE_Rank cr
ON cr.CustomerID = c.CustomerID
LEFT JOIN CTE_Segment sgmt
ON sgmt.CustomerID = c.CustomerID
ORDER BY totalSales DESC


--Recursive CTE
--Generate a sequence of Number from 1 to 20

--CTE query
WITH Series AS 
(
	--Anchor query
	SELECT
	1 AS MyNumber
	UNION ALL
	--Recursive query
	SELECT
	MyNumber + 1
	FROM Series
	WHERE MyNumber < 150
)
--Main Query
SELECT *
FROM Series
OPTION (MAXRECURSION 200)

--TASK: Show the employee hierarchy by displaying each employee's level within the organization
WITH EmployeeHierarchy AS

(
	--Anchor query
	SELECT
		EmployeeID,
		FirstName,
		ManagerID,
		1 AS Level
	FROM Sales.Employees
	WHERE ManagerID IS NULL
	UNION ALL
	SELECT
		e.EmployeeID,
		e.FirstName,
		e.ManagerID,
		Level + 1
	FROM Sales.Employees e
	INNER JOIN EmployeeHierarchy eh
	ON e.ManagerID = eh.EmployeeID
)

SELECT *
FROM EmployeeHierarchy

SELECT *
FROM Sales.Employees
