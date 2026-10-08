
--DATEADD
SELECT
	OrderID,
	OrderDate,
	DATEADD(month, 3, OrderDate) AS ThreeMonthsLater,
	DATEADD(day, -4, OrderDate) AS FourDaysBefore,
	DATEADD(year, 2, OrderDate) AS TwoYearsLater
FROM Sales.Orders


--DATEDIFF
SELECT
	EmployeeID,
	FirstName+' '+LastName AS FullName,
	DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age
FROM Sales.Employees

--Find the average shipping duration in days for each month
SELECT
	DATENAME(MONTH, ShipDate) AS Month,
	AVG(DATEDIFF(DAY, OrderDate, ShipDate)) AS DurationInDays
FROM Sales.Orders
GROUP BY DATENAME(MONTH, ShipDate)

--Find the number of days between each order and previous order
SELECT
	OrderID,
	OrderDate CurrentOrderDate,
	LAG(OrderDate) OVER (ORDER BY OrderDate) PreviousOrderDate,
	DATEDIFF(DAY, LAG(OrderDate) OVER (ORDER BY OrderDate), OrderDate) NumOfDays
FROM Sales.Orders

--ISDATE()
SELECT 
	ISDATE('123') DATECHECK1, --0
	ISDATE('2025-08-20') DATECHECK2, --1
	ISDATE('20-08-2025') DATECHECK3, --0 Not a standard date format
	ISDATE('2026') DATECHECK4, --1
	ISDATE('08') DATECHECK5 --0	

--USE CASE OF ISDATE


SELECT
	OrderDate,
	CASE WHEN ISDATE(OrderDate) = 1 
	THEN CAST(OrderDate AS DATE)
	ELSE '9999-01-01'
	END OrderDate
FROM 
	(
		SELECT '2025-08-20' AS OrderDate UNION
		SELECT '2025-08-21' UNION
		SELECT '2025-08-23' UNION
		SELECT '2025-08'
	)t
WHERE ISDATE(OrderDate) = 0