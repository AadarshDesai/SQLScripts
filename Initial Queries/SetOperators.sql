SELECT 
	FIrstName,
	LastName
FROM Sales.Employees
 INTERSECT --EXCEPT| --UNION | --UNION ALL
SELECT 
	FirstName,
	LastName
FROM Sales.Customers;