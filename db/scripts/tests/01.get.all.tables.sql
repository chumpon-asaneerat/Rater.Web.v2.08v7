-- Get a list of tables and views in the current database
SELECT table_name name, table_type type
FROM INFORMATION_SCHEMA.TABLES
WHERE table_catalog = 'TestDb7x3'
GO