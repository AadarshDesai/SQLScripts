--NULL Functions and Handling NULLs
SELECT
	CustomerID,
	Score,
	ISNULL(Score, 0) As Score2,
	AVG(Score) OVER() AvgScores,
	AVG(COALESCE(Score,0)) OVER() AvgScores2
FROM Sales.Customers

--USECASES
--Display full names of customers by merging them into 1 column
--add 10 extra points to each customer's score

SELECT
	COALESCE(FirstName, LastName, '')+' '+COALESCE(LastName, FirstName, '') AS fullName,
	COALESCE(Score,0)+10 AS newScores
FROM Sales.Customers

--Sort the customers from lowest to highest scores,
--With nulls appearing last
SELECT
	CustomerID,
	Score
FROM Sales.Customers
--ORDER BY COALESCE(Score, 9999999) --Lazy way
ORDER BY CASE WHEN Score IS NULL THEN 1 ELSE 0 END, Score

--NULLIF - Basically if the value matches in the nullif then it returns null. otherwise the firts value. 
--USE CASE OF NULLIF
-- Find the sales price for each order by dividing the sales by quantity. 
--Imagine if the quantity is 0, in that case we can get the divide by 0 error. 
SELECT 
	OrderID,
	Sales,
	Quantity,
	Sales/NULLIF(Quantity, 0) AS Price
FROM Sales.Orders

--IS NULL | IS NOT NULL
--USE CASE Filtering data
--Identify the customers who has no scores.

SELECT 
	*
FROM Sales.Customers
WHERE Score IS  NULL

--IS NULL is also used in advance type of joins called Anti joins
--Left Anti join = Left join + is null
--Right Anti Join = Right Join + is null

--List all details for customers who has not placed any orders
SELECT 
c.*,
o.orderID
FROM Sales.Customers c
LEFT JOIN Sales.Orders o
ON c.CustomerID = o.CustomerID
WHERE o.CustomerID IS NULL;

SELECT *
FROM Sales.Orders;

--NULL vs Empty Strings vs Blank Space
WITH Orders1 AS (
	SELECT 1 Id, 'A' Category UNION
	SELECT 2, NULL UNION --NULL
	SELECT 3, '' UNION --Empty String
	SELECT 4, '     ' --Blank spaces. 
)
SELECT 
*,
TRIM(Category) AS Policy1,
DATALENGTH(Category) AS Len,
DATALENGTH(TRIM(Category)) AS Policy1_len,
NULLIF(TRIM(Category), '') AS Policy2,
COALESCE(NULLIF(TRIM(Category), ''), 'unknown') AS Policy3
FROM Orders1