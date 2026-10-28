--TRIGGERS

--==========================
--Create Logging Table Query
--==========================
CREATE TABLE Sales.EmployeeLogs (
	LogID INT IDENTITY(1,1) PRIMARY KEY,
	EmployeeID INT,
	LogMessage VARCHAR(255),
	LogDate DATE
);

--===================
--Trigger Defination
--===================
CREATE TRIGGER trg_AfterInsertEmployee ON Sales.Employees
AFTER INSERT
AS
BEGIN
	INSERT INTO Sales.EmployeeLogs (EmployeeID, LogMessage, LogDate)
	SELECT
		EmployeeID,
		'New Employee Added: ' + CAST(EmployeeID AS VARCHAR),
		GETDATE()
	FROM INSERTED
END

--=================================
--Insert Data into Employees table
--=================================
INSERT INTO Sales.Employees
VALUES 
	(6, 'Aadarsh', 'Desai', 'Data Engineer', '1997-09-19', 'M', 89000, 1)

SELECT * FROM Sales.Employees
SELECT * FROM Sales.EmployeeLogs
