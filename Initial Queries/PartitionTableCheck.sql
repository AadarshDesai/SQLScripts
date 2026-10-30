
--This query lists all exisiting partition functions
SELECT
	name,
	function_id,
	type,
	type_desc,
	boundary_value_on_right
FROM sys.partition_functions;

--Check the existing filegroups
SELECT *
FROM sys.filegroups
WHERE type = 'FG';

--Checking the datafiles that we have created and assigned to filegroups
SELECT 
	fg.name AS FilegroupName,
	mf.name AS LogicalFileName,
	mf.physical_name AS PhysicalFilePath,
	mf.size / 128 AS SizeInMB
FROM sys.filegroups	fg
INNER JOIN sys.master_files mf
ON fg.data_space_id = mf.data_space_id
WHERE mf.database_id = DB_ID('SalesDB');

--Check all the parition schemes that we have created
SELECT 
	ps.name AS PartitionSchemeName,
	pf.name AS PartitionFunctionName,
	ds.destination_id AS PartitionNumber,
	fg.name AS FilegroupName
FROM sys.partition_schemes ps
INNER JOIN sys.partition_functions pf
ON ps.function_id = pf.function_id
INNER JOIN sys.destination_data_spaces ds
ON ps.data_space_id = ds.partition_scheme_id
INNER JOIN sys.filegroups fg
ON fg.data_space_id = ds.data_space_id

--Now we have created the partitioned table, assigned the partition function to id
--And inserted the data as well. 
--Now we want to check which partition this data went into.
SELECT 
	p.partition_number AS PartitionNumber,
	f.name AS PartitionFileGroup,
	p.rows AS NumberOfRows
FROM sys.partitions p
INNER JOIN sys.destination_data_spaces ds
ON p.partition_number = ds.destination_id
INNER JOIN sys.filegroups f
ON ds.data_space_id = f.data_space_id
WHERE OBJECT_NAME(p.object_id) = 'Orders_Partitioned'