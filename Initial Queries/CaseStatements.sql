--CASE STATEMENTS

--Create a report showing total sales for each of the following categories: 
--High(sales over 50), Medium (sales 21-50), Low(sales 20 or less)
--Sort the categories from highest sales to lowest


SELECT
	Categories,
	SUM(Sales) AS Total_Sales
FROM (
	SELECT 
		OrderID,
		Sales,
		CASE WHEN Sales > 50 THEN 'High'
			 WHEN Sales > 20 THEN 'Medium'
			 ELSE 'Low'
		END AS Categories
	FROM Sales.Orders
)t
GROUP BY Categories
ORDER BY Total_Sales DESC


--ANother usecase MAPPING VALUES

SELECT
	EmployeeID,
	FirstName,
	LastName,
	CASE WHEN Gender = 'M' THEN 'Male'
		 WHEN Gender = 'F' THEN 'Female'
		 ELSE 'N/A'
	END Genders
FROM Sales.Employees

--Retrieve customers details with abbreviated country codes
SELECT
	CustomerID,
	FirstName,
	LastName, 
	CASE Country
		WHEN  'Germany' THEN 'DE'
		WHEN  'USA' THEN 'US'
		ELSE 'N/A'
	END Countries,
	Score
FROM Sales.Customers

--Another usecase is for handling NULLS

SELECT
	CustomerID,
	LastName,
	Score,
	CASE 
		WHEN Score IS NULL THEN 0
		ELSE Score
	END AS cleanScore,
	AVG(
	CASE 
		WHEN Score IS NULL THEN 0
		ELSE Score
	END) OVER() cleanAVGScore,

	AVG(Score) OVER() AvgScore
FROM Sales.Customers;

--Another use case is conditional aggregation

--Count how many times each customer has made an order with sales greater than 30 
SELECT
	CustomerID,
	SUM(CASE
			WHEN Sales > 30 THEN 1
			ELSE 0
		END) TotalOrders
FROM Sales.Orders
GROUP BY CustomerID

/*SELECT 
	CustomerID,
	COUNT(Sales) AS numberOfTimesSalesMoreThen30
FROM Sales.Orders
WHERE Sales > 30
GROUP BY CustomerID*/

