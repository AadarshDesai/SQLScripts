--Stored Procedures

ALTER PROCEDURE GetCustomerSummary @Country NVARCHAR(50)='USA' --USA is a default value here
AS
BEGIN
	BEGIN TRY
		DECLARE @totalCustomers INT, @avgScore FLOAT;

		--================================
		--STEP1: Prepare and cleanup data.
		--================================
		IF EXISTS(SELECT 1 FROM Sales.Customers WHERE Score IS NULL AND Country = @Country)
			BEGIN
				PRINT('Updating NULL Scores to 0');
				UPDATE Sales.Customers
				SET Score = 0
				WHERE Score IS NULL AND Country = @Country;
			END

		ELSE
			BEGIN
				PRINT('No NULL Scores Found!')
			END;

		--=================================
		--STEP2: Generating Summary Reports
		--=================================

		--Calculate total customers and average scores for specific country
		SELECT 
			@totalCustomers = COUNT(*),
			@avgScore = AVG(Score)
		FROM Sales.Customers
		WHERE Country = @Country;

		PRINT 'Total Customers From ' +@Country + ': ' + CAST(@totalCustomers AS NVARCHAR);
		PRINT 'Average Score From ' +@Country + ': ' + CAST(@avgScore AS NVARCHAR);

		--Find the total number of orders and total sales
		SELECT
			COUNT(OrderID) AS totalOrders,
			SUM(Sales) AS totalSales
		FROM Sales.Orders o
		INNER JOIN Sales.Customers c
		ON c.CustomerID = o.CustomerID
		WHERE c.Country = @Country;
	END TRY

	--==============
	--ERROR Handling
	--==============
	BEGIN CATCH
		PRINT('An error occured!');
		PRINT('ERROR Message: '+ ERROR_MESSAGE());
		PRINT('ERROR Number: '+ CAST(ERROR_NUMBER() AS NVARCHAR));
		PRINT('ERROR Line: '+ CAST(ERROR_LINE() AS NVARCHAR));
		PRINT('ERROR Procedure: '+ ERROR_PROCEDURE());
	END CATCH

END
GO

--Execute stored procedure
EXEC GetCustomerSummary @Country = 'Germany';