
sp_helpindex 'Sales.DBCustomers'

--Monitoring Index Usage
SELECT 
	idx.object_id,
	idx.name AS IndexName,
	idx.type_desc AS IndexType,
	idx.is_primary_key AS IsPrimaryKey,
	idx.is_unique AS IsUnique,
	idx.is_disabled AS IsDisabled,
	tbl.name AS TableName,
	dmv.user_seeks,
	dmv.user_scans,
	dmv.user_lookups,
	dmv.user_updates,
	COALESCE(dmv.last_user_seek, dmv.last_user_scan) AS LastUpdate
FROM sys.indexes idx
INNER JOIN sys.tables tbl
ON tbl.object_id = idx.object_id
LEFT JOIN sys.dm_db_index_usage_stats dmv
ON dmv.object_id = idx.object_id
ORDER BY tbl.name, idx.name

SELECT *
FROM sys.dm_db_index_usage_stats

SELECT *
FROM sys.tables

SELECT *
FROM Sales.DBCustomers
WHERE Country = 'USA' AND Score > 500

--Monitoring Missing Indexes
--Suggestions from SQL 

SELECT * 
FROM sys.dm_db_missing_index_details

--Monitoring duplicate indexes
SELECT
	tbl.name AS tableName,
	col.name AS indexColumn,
	idx.name AS indexName,
	idx.type_desc AS indexType,
	COUNT(*) OVER(PARTITION BY tbl.name, col.name) AS ColumnCount
FROM sys.indexes idx
INNER JOIN sys.tables tbl
ON idx.object_id = tbl.object_id
INNER JOIN sys.index_columns ic
ON idx.object_id = ic.object_id AND idx.index_id = ic.index_id
INNER JOIN sys.columns col
ON ic.object_id = col.object_id AND ic.column_id = col.column_id
ORDER BY ColumnCount DESC

--Check the statistics of the indexes/tables
SELECT
	SCHEMA_NAME(t.schema_id) AS SchemaName,
	t.name AS TableName,
	s.name AS StatisticsName,
	sp.last_updated AS LastUpdated,
	DATEDIFF(day, sp.last_updated, GETDATE()) AS LastUpdatedDay,
	sp.rows AS Rowss,
	sp.modification_counter AS ModificationsSinceLastUpdated
FROM sys.stats AS s
JOIN sys.tables AS t
ON s.object_id = t.object_id
CROSS APPLY sys.dm_db_stats_properties(s.object_id, s.stats_id) AS sp
ORDER BY sp.modification_counter DESC

UPDATE STATISTICS Sales.DBCustomers _WA_Sys_00000005_2739D489

EXEC sp_updatestats

SELECT *
FROM sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, 'LIMITED')

--How to reorganize the indexes. 

ALTER INDEX idx_Customers_Country 
ON Sales.Customers REORGANIZE

--How to rebuild the indexes from scratch? 

ALTER INDEX idx_Customers_Country 
ON Sales.Customers REBUILD