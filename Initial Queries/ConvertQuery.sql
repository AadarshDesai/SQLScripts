SELECT
	CONVERT (INT, '123') AS [String To INT Convert],
	CONVERT (DATE, '2025-08-20') AS [String To Date Convert],
	CONVERT (DATE, CreationTime) AS [DateTime To Date Convert]
FROM Sales.Orders