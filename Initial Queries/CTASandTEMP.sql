--CTAS And TEMP tables.

--CTAS Table
IF OBJECT_ID('Sales.MonthlyOrderCount', 'U') IS NOT NULL
	DROP TABLE Sales.MonthlyOrderCount;
GO
SELECT
	DATENAME(Month, OrderDate) AS OrderMonth,
	COUNT(OrderID) AS TotalOrders
INTO Sales.MonthlyOrderCount
FROM Sales.Orders
GROUP BY DATENAME(Month, OrderDate)

--TEMP Table
SELECT
	*
INTO #OrdersTemp
FROM Sales.Orders


DELETE FROM #OrdersTemp
WHERE OrderStatus = 'Delivered'

SELECT * 
INTO Sales.OrdersTemp
FROM #OrdersTemp