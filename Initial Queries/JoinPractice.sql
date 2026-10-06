/*
Task: Using salesDB, retrieve a list of all orders, along with the related customer, product, and
Employee details. For each order display: 
Order ID, Customer's Name, Prodcut Name, Sales, Price, Sales person's name
*/

SELECT *
FROM Sales.Orders;

SELECT *
FROM Sales.Customers;

SELECT *
FROM Sales.Products;

SELECT *
FROM Sales.Employees;

SELECT *
FROM Sales.OrdersArchive;

SELECT 
	o.OrderID,
	c.FirstName+' '+c.LastName AS Customer_name,
	p.Product AS ProductName,
	o.Sales,
	p.Price,
	e.FirstName+' '+e.LastName AS Sales_person
FROM Sales.Orders AS o
LEFT JOIN Sales.Customers AS c
ON o.CustomerID = c.CustomerID
LEFT JOIN Sales.Products AS p
ON o.ProductID = p.ProductID
LEFT JOIN Sales.Employees AS e
ON o.SalesPersonID = e.EmployeeID