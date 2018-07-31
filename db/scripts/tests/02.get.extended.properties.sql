/* Gets index extended properties */
SELECT EP.class_desc AS PropertyOn,
    DB_NAME() AS DatabaseName,
    EP.name AS ExtendedPropertyDescription,
    EP.VALUE AS ExtendedPropertyValue
FROM sys.extended_properties AS EP
WHERE /*EP.name <> 'MS_Description' 
  AND */EP.class = 7;
GO

/* Displaying all extended properties in a database */
SELECT class, class_desc, major_id, minor_id, name, value
FROM sys.extended_properties;
GO

/* Displaying extended properties for all indexes in a database */
SELECT class, class_desc, major_id, minor_id, ep.name, s.name AS [Index Name], value
FROM sys.extended_properties AS ep
    INNER JOIN sys.indexes AS s ON ep.major_id = s.object_id AND ep.minor_id = s.index_id
WHERE class = 7;
GO

/* Displaying extended properties for columns in a table */
SELECT major_id, minor_id, t.name AS [Table Name], c.name AS [Column Name], value AS [Extended Property]
FROM sys.extended_properties AS ep
    INNER JOIN sys.tables AS t ON ep.major_id = t.object_id
    INNER JOIN sys.columns AS c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
WHERE class = 1;
GO

/* Querying Extended Properties on SQL Server Columns */
SELECT
    SysTbls.name AS [Table Name]
    , SysCols.name AS [Column Name]
	, ExtProp.name AS [Extended Property Name]
    , ExtProp.value AS [Extended Property Value]
    , Systyp.name AS [Data Type]
    , CASE WHEN Systyp.name IN('nvarchar','nchar')
               THEN (SysCols.max_length / 2)
          WHEN Systyp.name IN('char')
               THEN SysCols.max_length
          ELSE NULL
          END AS 'Length of Column'
    , CASE WHEN SysCols.is_nullable = 0
               THEN 'No'
          WHEN SysCols.is_nullable = 1
               THEN 'Yes'
          ELSE NULL
          END AS 'Column is Nullable'   
    , SysObj.create_date AS [Table Create Date]
    , SysObj.modify_date AS [Table Modify Date]
FROM sys.tables AS SysTbls
    LEFT JOIN sys.extended_properties AS ExtProp
    ON ExtProp.major_id = SysTbls.[object_id]
    LEFT JOIN sys.columns AS SysCols
    ON ExtProp.major_id = SysCols.[object_id]
        AND ExtProp.minor_id = SysCols.column_id
    LEFT JOIN sys.objects as SysObj
    ON SysTbls.[object_id] = SysObj.[object_id]
    INNER JOIN sys.types AS SysTyp
    ON SysCols.user_type_id = SysTyp.user_type_id
WHERE class = 1 --Object or column
    AND SysTbls.name IS NOT NULL
    AND SysCols.name IS NOT NULL
GO

