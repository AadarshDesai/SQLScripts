--INDEXES


--The default is Rowstore Index. 

--Clustered Index
CREATE CLUSTERED INDEX idx_DBCustomers_CustomerID
ON Sales.DBCustomers (CustomerID)

--Index [idx_DBCustomers_CountryScore] is being used here.
SELECT *
FROM Sales.DBCustomers
WHERE Country = 'USA' AND Score > 500

--Index [idx_DBCustomers_CountryScore] is being used here.
SELECT *
FROM Sales.DBCustomers
WHERE Country = 'USA'

--Index [idx_DBCustomers_CountryScore] is not being used here. 
SELECT *
FROM Sales.DBCustomers
WHERE Score > 500


--Nonclustered Index
CREATE NONCLUSTERED INDEX idx_DBCustomers_LastName
ON Sales.DBCustomers (LastName)

CREATE INDEX idx_DBCustomers_FirstName
ON Sales.DBCustomers (FirstName)

--Composite Indexes
CREATE INDEX idx_DBCustomers_CountryScore
ON Sales.DBCustomers (Country, Score) --While creating composite index, make sure that
									  --The order of the columns are matching with the query
--if you alter the order of the columns while querying it won't be useful as indexing
--won't work in that case. 



DROP INDEX idx_DBCustomers_CustomerID ON Sales.DBCustomers

--INDEXES A,B,C,D

--Index will be used
--A
--A,B
--A,B,C
--A,B,C,D


--Index won't be used
--B,
--A,C
--A,D
--A,C,D
--A,B,D


--Columnstore Index
CREATE CLUSTERED COLUMNSTORE INDEX idx_DBCustomers_CS
ON Sales.DBCustomers

DROP INDEX idx_DBCustomers_CS
ON Sales.DBCustomers

CREATE NONCLUSTERED COLUMNSTORE INDEX idx_DBCustomers_CS_FirstName
ON Sales.DBCustomers(FirstName)