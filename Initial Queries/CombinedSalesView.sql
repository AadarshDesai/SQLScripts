IF OBJECT_ID ('Sales.View_CombinedData', 'V') IS NOT NULL
	DROP VIEW Sales.View_CombinedData;
GO
CREATE VIEW Sales.View_CombinedData AS
(
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
)