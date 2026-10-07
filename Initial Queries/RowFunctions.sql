SELECT
--Change the data or modify the data
--'123-456-7890' AS beforeReplace,
--REPLACE('123-456-7890', '-', '#') AS afterReplace

--Rename the file or a value
--'report.txt' AS old_fileName,
--REPLACE('report.txt', '.txt', '.csv') AS new_fileName

--FInd the length of the first_name
--first_name,
--LEN(first_name) AS lengthOfName

	--CONCAT(first_name, '--', country) AS NameWIthCountry
	--LOWER(first_name) AS lowName,
	--UPPER(first_name) AS upName
	--first_name,
	--LEN(first_name) AS lenFirstName,
	--LEN(TRIM(first_name)) AS trimFirstNameLen,
	--LEN(first_name) - LEN(TRIM(first_name)) AS flag

	--Extract 2 characters from start or end
	--first_name,
	--RIGHT(TRIM(first_name), 2) AS first_2_char

	--retrieve a list of customers first name after removing the first character
	SUBSTRING(TRIM(first_name), 2, LEN(first_name)) AS Result

FROM customers
--WHERE first_name != TRIM(first_name);