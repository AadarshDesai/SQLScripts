/*
SELECT
	OrderID,
	CreationTime,
	FORMAT(CreationTime, 'MM-dd-yyyy') USA_Format,
	FORMAT(CreationTime, 'dd-MM-yyyy') Europe_Format,
	FORMAT(CreationTime, 'dd') DD,
	FORMAT(CreationTime, 'ddd') DDD,
	FORMAT(CreationTime, 'dddd') DDDD,
	FORMAT(CreationTime, 'MM') MM,
	FORMAT(CreationTime, 'MMM') MMM,
	FORMAT(CreationTime, 'MMMM') MMMM
FROM Sales.Orders
*/

--Show Creation Time using following format: 
--Day Wed Jan Q1 2025 12:34:56 PM

SELECT
	OrderID,
	CreationTime,
	'Day '+ 
	FORMAT(CreationTime, 'ddd MMM') +
	' Q'+DATENAME(Quarter, CreationTime)+ ' ' +
	FORMAT(CreationTime, 'yyyy hh:mm:ss	tt') + ' '
	 AS Result
FROM Sales.Orders;


SELECT 
	FORMAT(OrderDate, 'MMM yy'),
	COUNT(*)
FROM Sales.Orders
GROUP BY FORMAT(OrderDate, 'MMM yy')