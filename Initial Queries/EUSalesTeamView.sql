--TASK: Provide a view for EU sales team
--That combines detials from all tables
--And excludes data related to the USA

IF OBJECT_ID('Sales.View_EUSalesTeam', 'V') IS NOT NULL
	DROP VIEW Sales.View_EUSalesTeam;
GO
CREATE VIEW Sales.View_EUSalesTeam AS
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
	WHERE c.Country != 'USA'
)