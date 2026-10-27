IF OBJECT_ID('Sales.View_MonthlySummary', 'V') IS NOT NULL
	DROP VIEW Sales.View_MonthlySummary;
GO
CREATE VIEW Sales.View_MonthlySummary AS
(
	SELECT
	DATETRUNC(Month, OrderDate) AS OrderMonth,
	SUM(Sales) totalSales,
	COUNT(OrderID) numberOfOrders
	--SUM(Quantity) totalQuantity
	FROM Sales.Orders
	GROUP BY DATETRUNC(Month, OrderDate)
);