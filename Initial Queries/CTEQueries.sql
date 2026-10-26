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