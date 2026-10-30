
--PARTITIONS

--Step1: Create a partition function
CREATE PARTITION FUNCTION PartitionByYear (DATE)
AS RANGE LEFT FOR VALUES ('2023-12-31', '2024-12-31', '2025-12-31')

--Step2: Create Filegroups
ALTER DATABASE SalesDB ADD FILEGROUP FG_2023;
ALTER DATABASE SalesDB ADD FILEGROUP FG_2024;
ALTER DATABASE SalesDB ADD FILEGROUP FG_2025;
ALTER DATABASE SalesDB ADD FILEGROUP FG_2026;


--Step3: Add .ndf files to each filegroup
ALTER DATABASE SalesDB ADD FILE 
(
	NAME = P_2023, --Logical name
	FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL17.SQLEXPRESS\MSSQL\DATA\P_2023.ndf'
) TO FILEGROUP FG_2023

ALTER DATABASE SalesDB ADD FILE 
(
	NAME = P_2024, --Logical name
	FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL17.SQLEXPRESS\MSSQL\DATA\P_2024.ndf'
) TO FILEGROUP FG_2024

ALTER DATABASE SalesDB ADD FILE 
(
	NAME = P_2025, --Logical name
	FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL17.SQLEXPRESS\MSSQL\DATA\P_2025.ndf'
) TO FILEGROUP FG_2025

ALTER DATABASE SalesDB ADD FILE 
(
	NAME = P_2026, --Logical name
	FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL17.SQLEXPRESS\MSSQL\DATA\P_2026.ndf'
) TO FILEGROUP FG_2026

--Step4: Create partition scheme

CREATE PARTITION SCHEME SchemePartitionByYear
AS PARTITION PartitionByYear
TO (FG_2023, FG_2024, FG_2025, FG_2026)

--Step5: Create Partitioned Table
CREATE TABLE Sales.Orders_Partitioned
(
	OrderID INT,
	OrderDate DATE,
	Sales INT
) ON SchemePartitionByYear (OrderDate)

--Step6: Insert Data into partitioned table
INSERT INTO Sales.Orders_Partitioned VALUES (1, '2023-05-16', 100)
INSERT INTO Sales.Orders_Partitioned VALUES (3, '2024-12-31', 50)
INSERT INTO Sales.Orders_Partitioned VALUES (4, '2025-09-19', 150),
											(5, '2026-01-01', 200)