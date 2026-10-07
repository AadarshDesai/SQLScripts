/* 
SELECT 
	--DATEPART
	CreationTime,
	YEAR(CreationTime) AS Year,
	MONTH(CreationTime) AS Month,
	DAY(CreationTime) As Day,
	DATEPART(week, CreationTime) As Week,
	DATEPART(Quarter, CreationTime) As Quarter,
	DATEPART(Hour, CreationTime) As Hour,
	DATEPART(WEEKDAY, CreationTime) As Weekday,
	DATEPART(DY, CreationTime) As dyy,


	--DATENAME
	DATENAME(MONTH, CreationTime) AS DN_month,
	DATENAME(WEEKDAY, CreationTime) AS DN_day,

	--DATETRUNC
	--DATETRUNC(MINUTE, CreationTime) AS DT_min,
	--DATETRUNC(HOUR, CreationTime) AS DT_hr,
	--DATETRUNC(DAY, CreationTime) AS DT_day,
	--DATETRUNC(MONTH, CreationTime) AS DT_mon
	DATETRUNC(YEAR, CreationTime) AS DT_YR
FROM Sales.Orders
*/

--DATETRUNC
/*
SELECT
	DATETRUNC(MONTH, CreationTime),
	COUNT(*)
FROM Sales.Orders
GROUP BY DATETRUNC(MONTH, CreationTime)
*/

/*
--EOMONTH
SELECT
	OrderID,
	CreationTime,
	EOMONTH(CreationTime) AS EndOfMonth,
	CAST(DATETRUNC(MONTH, CreationTime) AS DATE) AS StartOfMonth
FROM Sales.Orders
*/

--How many orders were placed each month?
SELECT
	DATENAME(MONTH, OrderDate) AS Month,
	COUNT(*) AS totalOrders
FROM Sales.Orders
GROUP BY DATENAME(MONTH, OrderDate)
HAVING DATENAME(MONTH, OrderDate) = 'February'

/*
SELECT 
	*
FROM Sales.Orders
WHERE MONTH(OrderDate) = 2
*/