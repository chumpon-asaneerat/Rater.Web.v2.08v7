/*********** Script Update Date: 2018-04-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: dboView.
-- Description:	Listing out extended properties.
-- [== History ==]
-- <2018-04-16> :
--	- View Created.
--
-- [== Example ==]
--
-- =============================================
CREATE VIEW [dbo].[dboView]
AS
SELECT CASE 
		WHEN ob.parent_object_id > 0
			THEN OBJECT_SCHEMA_NAME(ob.parent_object_id) + '.' + OBJECT_NAME(ob.parent_object_id) + '.' + ob.name
		ELSE OBJECT_SCHEMA_NAME(ob.object_id) + '.' + ob.name
		END + CASE 
		WHEN ep.minor_id > 0
			THEN '.' + col.name
		ELSE ''
		END AS ObjectName,
	'schema' + CASE 
		WHEN ob.parent_object_id > 0
			THEN '/table'
		ELSE ''
		END + '/' + CASE 
		WHEN ob.type IN ('TF', 'FN', 'IF', 'FS', 'FT')
			THEN 'function'
		WHEN ob.type IN ('P', 'PC', 'RF', 'X')
			THEN 'procedure'
		WHEN ob.type IN ('U', 'IT')
			THEN 'table'
		WHEN ob.type = 'SQ'
			THEN 'queue'
		ELSE LOWER(ob.type_desc)
		END + CASE 
		WHEN col.column_id IS NULL
			THEN ''
		ELSE '/column'
		END AS ObjectType,
	ep.name AS EPName,
	ep.value AS EPValue
FROM sys.extended_properties AS ep
INNER JOIN sys.objects AS ob ON ep.major_id = ob.object_id
	AND ep.class = 1
LEFT OUTER JOIN sys.columns AS col ON ep.major_id = col.object_id
	AND ep.class = 1
	AND ep.minor_id = col.column_id

UNION ALL

--indexes
SELECT OBJECT_SCHEMA_NAME(ob.object_id) + '.' + OBJECT_NAME(ob.object_id) + '.' + ix.name,
	'schema/' + LOWER(ob.type_desc) + '/index',
	ep.name,
	value
FROM sys.extended_properties ep
INNER JOIN sys.objects ob ON ep.major_id = ob.OBJECT_ID
	AND class = 7
INNER JOIN sys.indexes ix ON ep.major_id = ix.Object_id
	AND class = 7
	AND ep.minor_id = ix.index_id

UNION ALL

--Parameters
SELECT OBJECT_SCHEMA_NAME(ob.object_id) + '.' + OBJECT_NAME(ob.object_id) + '.' + par.name,
	'schema/' + LOWER(ob.type_desc) + '/parameter',
	ep.name,
	value
FROM sys.extended_properties ep
INNER JOIN sys.objects ob ON ep.major_id = ob.OBJECT_ID
	AND class = 2
INNER JOIN sys.parameters par ON ep.major_id = par.Object_id
	AND class = 2
	AND ep.minor_id = par.parameter_id

UNION ALL

--schemas
SELECT sch.name,
	'schema',
	ep.name,
	value
FROM sys.extended_properties ep
INNER JOIN sys.schemas sch ON class = 3
	AND ep.major_id = SCHEMA_ID

UNION ALL

--Database 
SELECT DB_NAME(),
	'',
	ep.name,
	value
FROM sys.extended_properties ep
WHERE class = 0

UNION ALL

--XML Schema Collections
SELECT SCHEMA_NAME(SCHEMA_ID) + '.' + XC.name,
	'schema/xml_Schema_collection',
	ep.name,
	value
FROM sys.extended_properties ep
INNER JOIN sys.xml_schema_collections xc ON class = 10
	AND ep.major_id = xml_collection_id

UNION ALL

--Database Files
SELECT df.name,
	'database_file',
	ep.name,
	value
FROM sys.extended_properties ep
INNER JOIN sys.database_files df ON class = 22
	AND ep.major_id = file_id

UNION ALL

--Data Spaces
SELECT ds.name,
	'dataspace',
	ep.name,
	value
FROM sys.extended_properties ep
INNER JOIN sys.data_spaces ds ON class = 20
	AND ep.major_id = data_space_id

UNION ALL

--USER
SELECT dp.name,
	'database_principal',
	ep.name,
	value
FROM sys.extended_properties ep
INNER JOIN sys.database_principals dp ON class = 4
	AND ep.major_id = dp.principal_id

UNION ALL

--PARTITION FUNCTION
SELECT pf.name,
	'partition_function',
	ep.name,
	value
FROM sys.extended_properties ep
INNER JOIN sys.partition_functions pf ON class = 21
	AND ep.major_id = pf.function_id

UNION ALL

--REMOTE SERVICE BINDING
SELECT rsb.name,
	'remote service binding',
	ep.name,
	value
FROM sys.extended_properties ep
INNER JOIN sys.remote_service_bindings rsb ON class = 18
	AND ep.major_id = rsb.remote_service_binding_id

UNION ALL

--Route
SELECT rt.name,
	'route',
	ep.name,
	value
FROM sys.extended_properties ep
INNER JOIN sys.routes rt ON class = 19
	AND ep.major_id = rt.route_id

UNION ALL

--Service
SELECT sv.name COLLATE DATABASE_DEFAULT,
	'service',
	ep.name,
	value
FROM sys.extended_properties ep
INNER JOIN sys.services sv ON class = 17
	AND ep.major_id = sv.service_id

UNION ALL

-- 'CONTRACT'
SELECT svc.name,
	'service_contract',
	ep.name,
	value
FROM sys.service_contracts svc
INNER JOIN sys.extended_properties ep ON class = 16
	AND ep.major_id = svc.service_contract_id

UNION ALL

-- 'MESSAGE TYPE'
SELECT smt.name,
	'message_type',
	ep.name,
	value
FROM sys.service_message_types smt
INNER JOIN sys.extended_properties ep ON class = 15
	AND ep.major_id = smt.message_type_id

UNION ALL

-- 'assembly'
SELECT asy.name,
	'assembly',
	ep.name,
	value
FROM sys.assemblies asy
INNER JOIN sys.extended_properties ep ON class = 5
	AND ep.major_id = asy.assembly_id

UNION ALL

-- 'PLAN GUIDE' 
SELECT pg.name,
	'plan_guide',
	ep.name,
	value
FROM sys.plan_guides pg
INNER JOIN sys.extended_properties ep ON class = 27
	AND ep.major_id = pg.plan_guide_id
GO




/*********** Script Update Date: 2018-04-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: ErrorMessage.
-- Description:	The Error Message Table.
-- [== History ==]
-- <2018-04-16> :
--	- Table Created.
--
-- [== Example ==]
--
-- =============================================
CREATE TABLE [dbo].[ErrorMessage](
	[ErrCode] [int] NOT NULL,
	[ErrMsg] [nvarchar](max) NOT NULL,
 CONSTRAINT [PK_ErrorMessage] PRIMARY KEY CLUSTERED 
(
	[ErrCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Error Code.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ErrorMessage', @level2type=N'COLUMN',@level2name=N'ErrCode'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Error Message.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ErrorMessage', @level2type=N'COLUMN',@level2name=N'ErrMsg'
GO



/*********** Script Update Date: 2018-04-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: Language.
-- Description:	The Language Table.
-- [== History ==]
-- <2018-04-16> :
--	- Table Created.
--	  - LangId is used ISO 639-1 alpha 2 code.
--	  - FlagId is used ISO 3166-1 alpha 2 code.
--
-- [== Example ==]
--
-- =============================================
CREATE TABLE [dbo].[Language]
(
    [LangId] [nvarchar](3) NOT NULL,
    [FlagId] [nvarchar](3) NOT NULL,
    [DescriptionEN] [nvarchar](50) NOT NULL,
    [DescriptionNative] [nvarchar](50) NULL,
    [SortOrder] [int] NOT NULL,
    [Enabled] [bit] NOT NULL,
    CONSTRAINT [PK_Language] PRIMARY KEY CLUSTERED 
(
	[LangId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING ON

GO

/****** Object:  Index [IX_Language_FlagId]    Script Date: 4/20/2018 14:22:48 ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_Language_FlagId] ON [dbo].[Language]
(
	[FlagId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Language] ADD  CONSTRAINT [DF_Language_SortOrder]  DEFAULT ((1)) FOR [SortOrder]
GO

ALTER TABLE [dbo].[Language] ADD  CONSTRAINT [DF_Language_Enabled]  DEFAULT ((1)) FOR [Enabled]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The ISO 639-1 alpha 2 code.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Language', @level2type=N'COLUMN',@level2name=N'LangId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The ISO 3166-1-alpha-2 code.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Language', @level2type=N'COLUMN',@level2name=N'FlagId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The English Description.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Language', @level2type=N'COLUMN',@level2name=N'DescriptionEN'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Native description.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Language', @level2type=N'COLUMN',@level2name=N'DescriptionNative'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Enable Lanugage to used.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Language', @level2type=N'COLUMN',@level2name=N'Enabled'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Unique index for FlagId' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Language', @level2type=N'INDEX',@level2name=N'IX_Language_FlagId'
GO


/*********** Script Update Date: 2018-04-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: LanguageView.
-- Description:	The Language View.
-- [== History ==]
-- <2018-04-16> :
--	- View Created.
--
-- [== Example ==]
--
-- =============================================
CREATE VIEW [dbo].[LanguageView]
AS
	SELECT LangId
		 , FlagId
	     , DescriptionEN
		 , CASE 
			 WHEN DescriptionNative IS NULL THEN 
				DescriptionEN 
			  ELSE 
				DescriptionNative 
		   END AS DescriptionNative
		 , SortOrder
		 , Enabled
    FROM dbo.Language

GO


/*********** Script Update Date: 2018-04-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: MasterPK.
-- Description:	The Master Primary key Table.
-- [== History ==]
-- <2018-04-16> :
--	- Table Created.
--
-- [== Example ==]
--
-- =============================================
CREATE TABLE [dbo].[MasterPK](
	[TableName] [nvarchar](50) NOT NULL,
	[SeedResetMode] [tinyint] NOT NULL,
	[LastSeed] [int] NOT NULL,
	[Prefix] [nvarchar](10) NULL,
	[SeedDigits] [tinyint] NOT NULL,
	[LastUpdated] [datetime] NOT NULL,
 CONSTRAINT [PK_MasterPK] PRIMARY KEY CLUSTERED 
(
	[TableName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[MasterPK] ADD  CONSTRAINT [DF_MasterPK_SeedResetMode]  DEFAULT ((1)) FOR [SeedResetMode]
GO

ALTER TABLE [dbo].[MasterPK] ADD  CONSTRAINT [DF_MasterPK_LastSeed]  DEFAULT ((1)) FOR [LastSeed]
GO

ALTER TABLE [dbo].[MasterPK] ADD  CONSTRAINT [DF_MasterPK_SeedDigits]  DEFAULT ((4)) FOR [SeedDigits]
GO

ALTER TABLE [dbo].[MasterPK]  WITH CHECK ADD  CONSTRAINT [CK_MasterPK_SeedDigits] CHECK  (([SeedDigits]>=(1) AND [SeedDigits]<=(9)))
GO

ALTER TABLE [dbo].[MasterPK] CHECK CONSTRAINT [CK_MasterPK_SeedDigits]
GO

ALTER TABLE [dbo].[MasterPK]  WITH CHECK ADD  CONSTRAINT [CK_MasterPK_SeedResetMode] CHECK  (([SeedResetMode]=(3) OR [SeedResetMode]=(2) OR [SeedResetMode]=(1)))
GO

ALTER TABLE [dbo].[MasterPK] CHECK CONSTRAINT [CK_MasterPK_SeedResetMode]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Reset Mode : 1: daily, 2 : monthly, 3: yearly' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MasterPK', @level2type=N'COLUMN',@level2name=N'SeedResetMode'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Last Seed Number (integer) - value cannot be negative' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MasterPK', @level2type=N'COLUMN',@level2name=N'LastSeed'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Number of digit for seed (default is 4)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MasterPK', @level2type=N'COLUMN',@level2name=N'SeedDigits'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Checks number of seed digits between 1 - 9' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MasterPK', @level2type=N'CONSTRAINT',@level2name=N'CK_MasterPK_SeedDigits'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Checks seed reset mode can only in range 1 - 3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MasterPK', @level2type=N'CONSTRAINT',@level2name=N'CK_MasterPK_SeedResetMode'
GO


/*********** Script Update Date: 2018-04-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: PeriodUnit.
-- Description:	The Period Unit Table.
-- [== History ==]
-- <2018-04-16> :
--	- Table Created.
--
-- [== Example ==]
--
-- =============================================
CREATE TABLE [dbo].[PeriodUnit](
	[PeriodUnitId] [int] NOT NULL,
	[Description] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_PeriodUnit] PRIMARY KEY CLUSTERED 
(
	[PeriodUnitId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Default Description For Period Unit' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PeriodUnit', @level2type=N'COLUMN',@level2name=N'Description'
GO


/*********** Script Update Date: 2018-04-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: PeriodUnitML.
-- Description:	The Period Unit ML Table.
-- [== History ==]
-- <2018-04-16> :
--	- Table Created.
--	  - LangId is used ISO 639-1 alpha 2 code.
--
-- [== Example ==]
--
-- =============================================
CREATE TABLE [dbo].[PeriodUnitML](
	[PeriodUnitId] [int] NOT NULL,
	[LangId] [nvarchar](3) NOT NULL,
	[Description] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_PeriodUnitML] PRIMARY KEY CLUSTERED 
(
	[PeriodUnitId] ASC,
	[LangId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Description For Period Unit by specificed language' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PeriodUnitML', @level2type=N'COLUMN',@level2name=N'Description'
GO


/*********** Script Update Date: 2018-04-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: PeriodUnitView.
-- Description:	The Period Unit View.
-- [== History ==]
-- <2018-04-16> :
--	- View Created.
--
-- [== Example ==]
--
-- =============================================
CREATE VIEW [dbo].[PeriodUnitView]
AS
	SELECT LanguageView.LangId
		 --, LanguageView.FlagId
	     --, LanguageView.DescriptionEN
		 --, LanguageView.DescriptionNative
		 , LanguageView.Enabled
		 , LanguageView.SortOrder
	     , PeriodUnit.PeriodUnitId
		 , PeriodUnit.Description AS PeriodUnitDescriptionEN
	  FROM LanguageView CROSS JOIN dbo.PeriodUnit
GO


/*********** Script Update Date: 2018-04-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: PeriodUnitMLView.
-- Description:	The Period Unit ML View.
-- [== History ==]
-- <2018-04-16> :
--	- View Created.
--
-- [== Example ==]
--
-- =============================================
CREATE VIEW [dbo].[PeriodUnitMLView]
AS
	SELECT PUV.LangId
		 , PUV.PeriodUnitId
		 , PUV.PeriodUnitDescriptionEN
		 , CASE 
			WHEN PUML.Description IS NULL THEN 
				PUV.PeriodUnitDescriptionEN 
			ELSE 
				PUML.Description 
		   END AS PeriodUnitDescriptionNative
		 , PUV.SortOrder
		 , PUV.Enabled
		FROM dbo.PeriodUnitML AS PUML RIGHT OUTER JOIN PeriodUnitView AS PUV
		  ON (PUML.LangId = PUV.LangId AND PUML.PeriodUnitId = PUV.PeriodUnitId)
GO


/*********** Script Update Date: 2018-04-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: LimitUnit.
-- Description:	The Limit Unit Table.
-- [== History ==]
-- <2018-04-16> :
--	- Table Created.
--
-- [== Example ==]
--
-- =============================================
CREATE TABLE [dbo].[LimitUnit](
	[LimitUnitId] [int] NOT NULL,
	[Description] [nvarchar](100) NOT NULL,
	[UnitText] [nvarchar](20) NULL,
 CONSTRAINT [PK_LimitUnit] PRIMARY KEY CLUSTERED 
(
	[LimitUnitId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The LimitUnitId.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LimitUnit', @level2type=N'COLUMN',@level2name=N'LimitUnitId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The English Description for LimitUnit.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LimitUnit', @level2type=N'COLUMN',@level2name=N'Description'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The English limit unit text.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LimitUnit', @level2type=N'COLUMN',@level2name=N'UnitText'
GO


/*********** Script Update Date: 2018-04-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: LimitUnitML.
-- Description:	The Limit Unit ML Table.
-- [== History ==]
-- <2018-04-16> :
--	- Table Created.
--	  - LangId is used ISO 639-1 alpha 2 code.
--
-- [== Example ==]
--
-- =============================================
CREATE TABLE [dbo].[LimitUnitML](
	[LimitUnitId] [int] NOT NULL,
	[LangId] [nvarchar](3) NOT NULL,
	[Description] [nvarchar](100) NOT NULL,
	[UnitText] [nvarchar](20) NULL,
 CONSTRAINT [PK_LimitUnitML] PRIMARY KEY CLUSTERED 
(
	[LimitUnitId] ASC,
	[LangId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The LimitUnit Id.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LimitUnitML', @level2type=N'COLUMN',@level2name=N'LimitUnitId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Language Id.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LimitUnitML', @level2type=N'COLUMN',@level2name=N'LangId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The description by specificed language id.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LimitUnitML', @level2type=N'COLUMN',@level2name=N'Description'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The limit unit text for specificed language id.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LimitUnitML', @level2type=N'COLUMN',@level2name=N'UnitText'
GO


/*********** Script Update Date: 2018-04-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: LimitUnitView.
-- Description:	The Limit Unit View.
-- [== History ==]
-- <2018-04-16> :
--	- View Created.
--
-- [== Example ==]
--
-- =============================================
CREATE VIEW [dbo].[LimitUnitView]
AS
	SELECT LanguageView.LangId
		 --, LanguageView.FlagId
	     --, LanguageView.DescriptionEN
		 --, LanguageView.DescriptionNative
		 , LanguageView.Enabled
		 , LanguageView.SortOrder
	     , LimitUnit.LimitUnitId
		 , LimitUnit.Description AS LimitUnitDescriptionEN
		 , LimitUnit.UnitText AS LimitUnitTextEN
	  FROM LanguageView CROSS JOIN dbo.LimitUnit

GO


/*********** Script Update Date: 2018-04-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: LimitUnitMLView.
-- Description:	The Limit Unit ML View.
-- [== History ==]
-- <2018-04-16> :
--	- View Created.
--
-- [== Example ==]
--
-- =============================================
CREATE VIEW [dbo].[LimitUnitMLView]
AS
	SELECT LUV.LangId
		 , LUV.LimitUnitId
		 , LUV.LimitUnitDescriptionEN
		 , CASE 
			WHEN LMML.Description IS NULL THEN 
				LUV.LimitUnitDescriptionEN 
			ELSE 
				LMML.Description 
		   END AS LimitUnitDescriptionNative
		 , LUV.LimitUnitTextEN
		 , CASE 
			WHEN LMML.UnitText IS NULL THEN 
				LUV.LimitUnitTextEN 
			ELSE 
				LMML.UnitText 
		   END AS LimitUnitTextNative
		 , LUV.Enabled
		 , LUV.SortOrder
		FROM dbo.LimitUnitML AS LMML RIGHT OUTER JOIN LimitUnitView AS LUV
		  ON (LMML.LangId = LUV.LangId AND LMML.LimitUnitId = LUV.LimitUnitId)

GO


/*********** Script Update Date: 2018-04-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: MemberType.
-- Description:	The MemberType Table.
-- [== History ==]
-- <2018-04-16> :
--	- Table Created.
--
-- [== Example ==]
--
-- =============================================
CREATE TABLE [dbo].[MemberType](
	[MemberTypeId] [int] NOT NULL,
	[Description] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_MemberType] PRIMARY KEY CLUSTERED 
(
	[MemberTypeId] ASC,
	[Description] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

/*********** Script Update Date: 2018-04-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: MemberTypeML.
-- Description:	The MemberType ML Table.
-- [== History ==]
-- <2018-04-16> :
--	- Table Created.
--	  - LangId is used ISO 639-1 alpha 2 code.
--
-- [== Example ==]
--
-- =============================================
CREATE TABLE [dbo].[MemberTypeML](
	[MemberTypeId] [int] NOT NULL,
	[LangId] [nvarchar](3) NOT NULL,
	[Description] [nvarchar](50) NULL,
 CONSTRAINT [PK_MemberTypeML] PRIMARY KEY CLUSTERED 
(
	[MemberTypeId] ASC,
	[LangId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

/*********** Script Update Date: 2018-04-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[MemberTypeView]
AS
    SELECT LanguageView.LangId
		 --, LanguageView.FlagId
	     --, LanguageView.DescriptionEN
		 --, LanguageView.DescriptionNative
		 , LanguageView.Enabled
		 , LanguageView.SortOrder
	     , MemberType.MemberTypeId
		 , MemberType.Description AS MemberTypeDescriptionEN
    FROM LanguageView CROSS JOIN dbo.MemberType

GO


/*********** Script Update Date: 2018-04-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[MemberTypeMLView]
AS
    SELECT MTV.LangId
		 , MTV.MemberTypeId
		 , MTV.MemberTypeDescriptionEN
		 , CASE 
			WHEN MTML.Description IS NULL THEN 
				MTV.MemberTypeDescriptionEN 
			ELSE 
				MTML.Description 
		   END AS MemberTypeDescriptionNavive
		 , MTV.Enabled
		 , MTV.SortOrder
    FROM dbo.MemberTypeML AS MTML RIGHT OUTER JOIN MemberTypeView AS MTV
        ON (MTML.LangId = MTV.LangId AND MTML.MemberTypeId = MTV.MemberTypeId)

GO


/*********** Script Update Date: 2018-04-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[UserInfo](
	[UserId] [nvarchar](30) NOT NULL,
	[MemberType] [int] NOT NULL,
	[Prefix] [nvarchar](10) NULL,
	[FirstName] [nvarchar](40) NOT NULL,
	[LastName] [nvarchar](50) NULL,
	[UserName] [nvarchar](50) NOT NULL,
	[Password] [nvarchar](20) NOT NULL,
	[ObjectStatus] [int] NOT NULL,
 CONSTRAINT [PK_UserInfo] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[UserInfo] ADD  CONSTRAINT [DF_UserInfo_ObjectStatus]  DEFAULT ((1)) FOR [ObjectStatus]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The User Id' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'UserInfo', @level2type=N'COLUMN',@level2name=N'UserId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'100 - EDL Admin, 110 - EDL PowerUser, 180 - EDL Staff' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'UserInfo', @level2type=N'COLUMN',@level2name=N'MemberType'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Default Prefix' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'UserInfo', @level2type=N'COLUMN',@level2name=N'Prefix'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Default First Name' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'UserInfo', @level2type=N'COLUMN',@level2name=N'FirstName'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Default Last Name' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'UserInfo', @level2type=N'COLUMN',@level2name=N'LastName'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The LogIn User Name' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'UserInfo', @level2type=N'COLUMN',@level2name=N'UserName'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The LogIn Password' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'UserInfo', @level2type=N'COLUMN',@level2name=N'Password'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 - Inactive, 1 - Active' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'UserInfo', @level2type=N'COLUMN',@level2name=N'ObjectStatus'
GO



/*********** Script Update Date: 2018-04-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[UserInfoML](
	[UserId] [nvarchar](30) NOT NULL,
	[LangId] [nvarchar](3) NOT NULL,
	[Prefix] [nvarchar](10) NULL,
	[FirstName] [nvarchar](40) NOT NULL,
	[LastName] [nvarchar](50) NULL,
 CONSTRAINT [PK_UserInfoML] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC,
	[LangId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The User Id' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'UserInfoML', @level2type=N'COLUMN',@level2name=N'UserId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The language id' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'UserInfoML', @level2type=N'COLUMN',@level2name=N'LangId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Native Prefix' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'UserInfoML', @level2type=N'COLUMN',@level2name=N'Prefix'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Native First Name' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'UserInfoML', @level2type=N'COLUMN',@level2name=N'FirstName'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Native Last Name' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'UserInfoML', @level2type=N'COLUMN',@level2name=N'LastName'
GO



/*********** Script Update Date: 2018-04-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[UserInfoView]
AS
	SELECT LanguageView.LangId
		 --, LanguageView.FlagId
	     --, LanguageView.DescriptionEN
		 --, LanguageView.DescriptionNative
		 , LanguageView.Enabled
		 , LanguageView.SortOrder
	     , UserInfo.UserId
		 , UserInfo.MemberType
		 , UserInfo.UserName
		 , UserInfo.Password
		 , UserInfo.ObjectStatus
		 , UserInfo.Prefix AS PrefixEN
		 , UserInfo.FirstName AS FirstNameEN
		 , UserInfo.LastName AS LastNameEN
	  FROM LanguageView CROSS JOIN dbo.UserInfo

GO


/*********** Script Update Date: 2018-04-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[UserInfoMLView]
AS
	SELECT UIV.LangId
	     , UIV.UserId
		 , UIV.MemberType
		 , UIV.PrefixEN
		 , UIV.FirstNameEn
		 , UIV.LastNameEn
	     , RTRIM(LTRIM(RTRIM(LTRIM(ISNULL(UIV.PrefixEN, N''))) + N' ' +
		               RTRIM(LTRIM(UIV.FirstNameEN)) + N' ' +
		               RTRIM(LTRIM(ISNULL(UIV.LastNameEN, N''))))) AS FullNameEN
		 , CASE 
			WHEN UIML.FirstName IS NULL THEN /* Use FirstName to check for used Native data */
				UIV.PrefixEN 
			ELSE 
				UIML.Prefix 
		   END AS PrefixNative
		 , CASE 
			WHEN UIML.FirstName IS NULL THEN 
				UIV.FirstNameEN 
			ELSE 
				UIML.FirstName 
		   END AS FirstNameNative
		 , CASE 
			WHEN UIML.FirstName IS NULL THEN /* Use FirstName to check for used Native data */
				UIV.LastNameEN 
			ELSE 
				UIML.LastName
		   END AS LastNameNative
		 , CASE 
			WHEN UIML.FirstName IS NULL THEN /* Use FirstName to check for used Native data */
				RTRIM(LTRIM(RTRIM(LTRIM(ISNULL(UIV.PrefixEN, N''))) + N' ' +
				            RTRIM(LTRIM(UIV.FirstNameEN)) + N' ' +
				            RTRIM(LTRIM(ISNULL(UIV.LastNameEN, N'')))))
			ELSE 
				RTRIM(LTRIM(RTRIM(LTRIM(ISNULL(UIML.Prefix, N''))) + N' ' +
				            RTRIM(LTRIM(UIML.FirstName)) + N' ' +
				            RTRIM(LTRIM(ISNULL(UIML.LastName, N'')))))
		   END AS FullNameNative
	     , UIV.UserName
	     , UIV.Password
		 , UIV.ObjectStatus
		 , UIV.Enabled
		 , UIV.SortOrder
		FROM dbo.UserInfoML AS UIML RIGHT OUTER JOIN UserInfoView AS UIV
		  ON (UIML.LangId = UIV.LangId AND UIML.UserId = UIV.UserId)

GO


/*********** Script Update Date: 2018-04-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[LicenseType](
	[LicenseTypeId] [int] NOT NULL,
	[Description] [nvarchar](100) NOT NULL,
	[AdText] [nvarchar](max) NOT NULL,
	[PeriodUnitId] [int] NOT NULL,
	[NumberOfUnit] [int] NOT NULL,
	[Price] [decimal](18, 2) NOT NULL,
	[CurrencySymbol] [nvarchar](5) NOT NULL,
	[CurrencyText] [nvarchar](20) NOT NULL,
 CONSTRAINT [PK_LicenseType_1] PRIMARY KEY CLUSTERED 
(
	[LicenseTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

ALTER TABLE [dbo].[LicenseType] ADD  CONSTRAINT [DF_LicenseType_PeriodDays]  DEFAULT ((30)) FOR [NumberOfUnit]
GO

ALTER TABLE [dbo].[LicenseType] ADD  CONSTRAINT [DF_LicenseType_Price]  DEFAULT ((0.00)) FOR [Price]
GO

ALTER TABLE [dbo].[LicenseType] ADD  CONSTRAINT [DF_LicenseType_CurrencySymbol]  DEFAULT (N'$') FOR [CurrencySymbol]
GO

ALTER TABLE [dbo].[LicenseType] ADD  CONSTRAINT [DF_LicenseType_CurrencyEN]  DEFAULT (N'USD') FOR [CurrencyText]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The default description.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LicenseType', @level2type=N'COLUMN',@level2name=N'Description'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Default Advertise Text.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LicenseType', @level2type=N'COLUMN',@level2name=N'AdText'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The period unit id.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LicenseType', @level2type=N'COLUMN',@level2name=N'PeriodUnitId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The default number of period unit' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LicenseType', @level2type=N'COLUMN',@level2name=N'NumberOfUnit'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The default price' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LicenseType', @level2type=N'COLUMN',@level2name=N'Price'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Default Currency Symbol' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LicenseType', @level2type=N'COLUMN',@level2name=N'CurrencySymbol'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Default Currency Unit Text' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LicenseType', @level2type=N'COLUMN',@level2name=N'CurrencyText'
GO


/*********** Script Update Date: 2018-04-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[LicenseTypeML](
	[LicenseTypeId] [int] NOT NULL,
	[LangId] [nvarchar](3) NOT NULL,
	[Description] [nvarchar](100) NULL,
	[AdText] [nvarchar](max) NULL,
	[Price] [decimal](18, 2) NULL,
	[CurrencySymbol] [nvarchar](5) NULL,
	[CurrencyText] [nvarchar](20) NULL,
 CONSTRAINT [PK_LicenseTypeML] PRIMARY KEY CLUSTERED 
(
	[LicenseTypeId] ASC,
	[LangId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

ALTER TABLE [dbo].[LicenseTypeML] ADD  CONSTRAINT [DF_LicenseTypeML_CurrencySymbol]  DEFAULT (N'$') FOR [CurrencySymbol]
GO

ALTER TABLE [dbo].[LicenseTypeML] ADD  CONSTRAINT [DF_LicenseTypeML_CurrencyText]  DEFAULT (N'USD') FOR [CurrencyText]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The default price' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LicenseTypeML', @level2type=N'COLUMN',@level2name=N'Price'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Currency Symbol' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LicenseTypeML', @level2type=N'COLUMN',@level2name=N'CurrencySymbol'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Currency Unit Text' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LicenseTypeML', @level2type=N'COLUMN',@level2name=N'CurrencyText'
GO


/*********** Script Update Date: 2018-04-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[LicenseTypeView]
AS
	SELECT LanguageView.LangId
		 --, LanguageView.FlagId
	     --, LanguageView.DescriptionEN
		 --, LanguageView.DescriptionNative
		 , LanguageView.Enabled
		 , LanguageView.SortOrder
	     , LicenseType.LicenseTypeId
	     , LicenseType.Description AS LicenseTypeDescriptionEN
	     , LicenseType.AdText AS AdTextEN
	     , LicenseType.PeriodUnitId
	     , LicenseType.NumberOfUnit
	     , LicenseType.Price
		 , LicenseType.CurrencySymbol
		 , LicenseType.CurrencyText
	  FROM LanguageView CROSS JOIN dbo.LicenseType

GO


/*********** Script Update Date: 2018-04-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[LicenseTypeMLView]
AS
	SELECT LTV.LangId
		 , LTV.LicenseTypeId
		 , LTV.LicenseTypeDescriptionEn
		 , CASE WHEN LTML.Description IS NULL 
		 	THEN
				LTV.LicenseTypeDescriptionEn
			ELSE 
				LTML.Description
		  END AS LicenseTypeDescriptionNative
		 , LTV.AdTextEN
		 , CASE 
			WHEN LTML.AdText IS NULL 
			THEN
				LTV.AdTextEn
			ELSE 
				LTML.AdText
		  END AS AdTextNative
		 , LTV.PeriodUnitId
		 , LTV.NumberOfUnit
		 , CASE 
			WHEN LTML.Price IS NULL 
			THEN CONVERT(bit, 1)
			ELSE CONVERT(bit, 0) 
		  END AS UseDefaultPrice
		 , CASE WHEN LTML.Price IS NULL 
			THEN
				LTV.Price
			ELSE
				LTML.Price
		  END AS Price
			, CASE WHEN LTML.CurrencySymbol IS NULL
			 THEN
			 	LTV.CurrencySymbol
			 ELSE
			 	LTML.CurrencySymbol
			 END AS CurrencySymbol
			, CASE WHEN LTML.CurrencyText IS NULL
			 THEN
			 	LTV.CurrencyText
			 ELSE
			 	LTML.CurrencyText
			 END AS CurrencyText
		 , LTV.Enabled
		 , LTV.SortOrder
		FROM dbo.LicenseTypeML AS LTML RIGHT OUTER JOIN LicenseTypeView AS LTV
		  ON (LTML.LangId = LTV.LangId AND LTML.LicenseTypeId = LTV.LicenseTypeId)

GO


/*********** Script Update Date: 2018-04-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[LicenseFeature](
	[LicenseTypeId] [int] NOT NULL,
	[Seq] [int] NOT NULL,
	[LimitUnitId] [int] NOT NULL,
	[NoOfLimit] [int] NOT NULL,
 CONSTRAINT [PK_LicenseFeature] PRIMARY KEY CLUSTERED 
(
	[LicenseTypeId] ASC,
	[Seq] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[LicenseFeature] ADD  CONSTRAINT [DF_LicenseFeature_NoOfLimit]  DEFAULT ((0)) FOR [NoOfLimit]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The LicenseTypeId.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LicenseFeature', @level2type=N'COLUMN',@level2name=N'LicenseTypeId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Feature Sequence.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LicenseFeature', @level2type=N'COLUMN',@level2name=N'Seq'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Limit Unit Id.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LicenseFeature', @level2type=N'COLUMN',@level2name=N'LimitUnitId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Number of Limit Unit (<= 0 = Unlimited).' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LicenseFeature', @level2type=N'COLUMN',@level2name=N'NoOfLimit'
GO


/*********** Script Update Date: 2018-04-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[LicenseFeatureMLView]
AS
	SELECT LanguageView.LangId
		 --, LanguageView.FlagId
	     --, LanguageView.DescriptionEN
		 --, LanguageView.DescriptionNative
	     , LF.LicenseTypeId
	     , LF.Seq
		 , LF.LimitUnitId
		 , LF.LimitUnitDescriptionEN
		 , LF.LimitUnitDescriptionNative
		 , LF.NoOfLimit
		 , LF.LimitUnitTextEN
		 , LF.LimitUnitTextNative
		 , LanguageView.Enabled
		 , LanguageView.SortOrder
	  FROM LanguageView RIGHT OUTER JOIN 
	  (
	    SELECT dbo.LimitUnitMLView.LangId
			 , dbo.LicenseFeature.*
		     , dbo.LimitUnitMLView.LimitUnitDescriptionEN
		     , dbo.LimitUnitMLView.LimitUnitTextEN
		     , dbo.LimitUnitMLView.LimitUnitDescriptionNative
		     , dbo.LimitUnitMLView.LimitUnitTextNative
		  FROM dbo.LicenseFeature, dbo.LimitUnitMLView
		 WHERE dbo.LicenseFeature.LimitUnitId = dbo.LimitUnitMLView.LimitUnitId
	  ) AS LF ON (LanguageView.LangId = LF.LangId)

GO


/*********** Script Update Date: 2018-04-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[CustomerPK](
	[CustomerId] [nvarchar](30) NOT NULL,
	[TableName] [nvarchar](50) NOT NULL,
	[SeedResetMode] [tinyint] NOT NULL,
	[LastSeed] [int] NOT NULL,
	[Prefix] [nvarchar](10) NULL,
	[SeedDigits] [tinyint] NOT NULL,
	[LastUpdated] [datetime] NOT NULL,
 CONSTRAINT [PK_CustomerPK] PRIMARY KEY CLUSTERED 
(
	[CustomerId] ASC,
	[TableName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[CustomerPK] ADD  CONSTRAINT [DF_CustomerPK_SeedResetMode]  DEFAULT ((1)) FOR [SeedResetMode]
GO

ALTER TABLE [dbo].[CustomerPK] ADD  CONSTRAINT [DF_CustomerPK_LastSeed]  DEFAULT ((1)) FOR [LastSeed]
GO

ALTER TABLE [dbo].[CustomerPK] ADD  CONSTRAINT [DF_CustomerPK_SeedDigits]  DEFAULT ((4)) FOR [SeedDigits]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Reset Mode : 1: daily, 2 : monthly, 3: yearly, 4: IgnoreDate' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CustomerPK', @level2type=N'COLUMN',@level2name=N'SeedResetMode'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Last Seed Number (integer) - value cannot be negative' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CustomerPK', @level2type=N'COLUMN',@level2name=N'LastSeed'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Number of digit for seed (default is 4)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CustomerPK', @level2type=N'COLUMN',@level2name=N'SeedDigits'
GO


/*********** Script Update Date: 2018-04-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Customer](
	[CustomerId] [nvarchar](30) NOT NULL,
	[CustomerName] [nvarchar](50) NOT NULL,
	[TaxCode] [nvarchar](30) NULL,
	[Address1] [nvarchar](80) NULL,
	[Address2] [nvarchar](80) NULL,
	[City] [nvarchar](50) NULL,
	[Province] [nvarchar](50) NULL,
	[PostalCode] [nvarchar](8) NULL,
	[Phone] [nvarchar](80) NULL,
	[Mobile] [nvarchar](80) NULL,
	[Fax] [nvarchar](80) NULL,
	[Email] [nvarchar](80) NULL,
	[ObjectStatus] [int] NOT NULL,
 CONSTRAINT [PK_Customer] PRIMARY KEY CLUSTERED 
(
	[CustomerId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING ON

GO

/****** Object:  Index [IX_CustomerName]    Script Date: 4/23/2018 02:02:36 ******/
CREATE NONCLUSTERED INDEX [IX_CustomerName] ON [dbo].[Customer]
(
	[CustomerName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Customer] ADD  CONSTRAINT [DF_Customer_ObjectStatus]  DEFAULT ((1)) FOR [ObjectStatus]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Default Customer Name' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Customer', @level2type=N'COLUMN',@level2name=N'CustomerName'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Default TaxCode' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Customer', @level2type=N'COLUMN',@level2name=N'TaxCode'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Default Address1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Customer', @level2type=N'COLUMN',@level2name=N'Address1'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Default Address2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Customer', @level2type=N'COLUMN',@level2name=N'Address2'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Default City' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Customer', @level2type=N'COLUMN',@level2name=N'City'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Default Province' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Customer', @level2type=N'COLUMN',@level2name=N'Province'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Default PostalCode' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Customer', @level2type=N'COLUMN',@level2name=N'PostalCode'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Default Phone Number(s)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Customer', @level2type=N'COLUMN',@level2name=N'Phone'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Default Mobile Number(s)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Customer', @level2type=N'COLUMN',@level2name=N'Mobile'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Default Fax Number(s)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Customer', @level2type=N'COLUMN',@level2name=N'Fax'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Default Email Address (For Company)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Customer', @level2type=N'COLUMN',@level2name=N'Email'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 - Inactive, 1 - Active' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Customer', @level2type=N'COLUMN',@level2name=N'ObjectStatus'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Customer Name Index' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Customer', @level2type=N'INDEX',@level2name=N'IX_CustomerName'
GO


/*********** Script Update Date: 2018-04-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[CustomerML](
	[CustomerId] [nvarchar](30) NOT NULL,
	[LangId] [nvarchar](3) NOT NULL,
	[CustomerName] [nvarchar](50) NULL,
	[TaxCode] [nvarchar](30) NULL,
	[Address1] [nvarchar](80) NULL,
	[Address2] [nvarchar](80) NULL,
	[City] [nvarchar](50) NULL,
	[Province] [nvarchar](50) NULL,
	[PostalCode] [nvarchar](8) NULL,
 CONSTRAINT [PK_CustomerML] PRIMARY KEY CLUSTERED 
(
	[CustomerId] ASC,
	[LangId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Customer Id' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CustomerML', @level2type=N'COLUMN',@level2name=N'CustomerId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Language Id' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CustomerML', @level2type=N'COLUMN',@level2name=N'LangId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Customer Name by specificed language' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CustomerML', @level2type=N'COLUMN',@level2name=N'CustomerName'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The TaxCode by specificed language' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CustomerML', @level2type=N'COLUMN',@level2name=N'TaxCode'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Address1 by specificed language' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CustomerML', @level2type=N'COLUMN',@level2name=N'Address1'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Address2 by specificed language' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CustomerML', @level2type=N'COLUMN',@level2name=N'Address2'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The City by specificed language' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CustomerML', @level2type=N'COLUMN',@level2name=N'City'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Province by specificed language' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CustomerML', @level2type=N'COLUMN',@level2name=N'Province'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The PostalCode by specificed language' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CustomerML', @level2type=N'COLUMN',@level2name=N'PostalCode'
GO


/*********** Script Update Date: 2018-04-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[CustomerView]
AS
	SELECT LanguageView.LangId
		 --, LanguageView.FlagId
	     --, LanguageView.DescriptionEN
		 --, LanguageView.DescriptionNative
		 , LanguageView.Enabled
		 , LanguageView.SortOrder
	     , Customer.CustomerId
		 , Customer.CustomerName AS CustomerNameEN
		 , Customer.TaxCode AS TaxCodeEN
		 , Customer.Address1 AS Address1EN
		 , Customer.Address2 AS Address2EN
		 , Customer.City AS CityEN
		 , Customer.Province AS ProvinceEN
		 , Customer.PostalCode AS PostalCodeEN
		 , Customer.Phone
		 , Customer.Mobile
		 , Customer.Fax
		 , Customer.Email
		 , Customer.ObjectStatus
	  FROM LanguageView CROSS JOIN dbo.Customer

GO


/*********** Script Update Date: 2018-04-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[CustomerMLView]
AS
	SELECT CUV.LangId
	     , CUV.CustomerId
		 , CUV.CustomerNameEN
		 , CUV.TaxCodeEN
		 , CUV.Address1EN
		 , CUV.Address2EN
		 , CUV.CityEN
		 , CUV.ProvinceEN
		 , CUV.PostalCodeEN
		 , CASE 
			WHEN CUML.CustomerName IS NULL THEN 
				CUV.CustomerNameEN 
			ELSE 
				CUML.CustomerName 
		   END AS CustomerNameNative
		 , CASE 
			WHEN CUML.CustomerName IS NULL THEN 
				CUV.TaxCodeEN 
			ELSE 
				CUML.TaxCode 
		   END AS TaxCodeNative
		 , CASE 
			WHEN CUML.CustomerName IS NULL THEN 
				CUV.Address1EN 
			ELSE 
				CUML.Address1 
		   END AS Address1Native
		 , CASE 
			WHEN CUML.CustomerName IS NULL THEN 
				CUV.Address2EN 
			ELSE 
				CUML.Address2 
		   END AS Address2Native
		 , CASE 
			WHEN CUML.CustomerName IS NULL THEN 
				CUV.CityEN 
			ELSE 
				CUML.City 
		   END AS CityNative
		 , CASE 
			WHEN CUML.CustomerName IS NULL THEN 
				CUV.ProvinceEN 
			ELSE 
				CUML.Province 
		   END AS ProvinceNative
		 , CASE 
			WHEN CUML.CustomerName IS NULL THEN 
				CUV.PostalCodeEN 
			ELSE 
				CUML.PostalCode 
		   END AS PostalCodeNative
		 , CUV.Phone
		 , CUV.Mobile
		 , CUV.Fax
		 , CUV.Email
		 , CUV.ObjectStatus
		 , CUV.Enabled
		 , CUV.SortOrder
		FROM dbo.CustomerML AS CUML RIGHT OUTER JOIN CustomerView AS CUV
		  ON (CUML.LangId = CUV.LangId AND CUML.CustomerId = CUV.CustomerId)

GO


/*********** Script Update Date: 2018-04-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Branch](
	[CustomerId] [nvarchar](30) NOT NULL,
	[BranchId] [nvarchar](30) NOT NULL,
	[BranchName] [nvarchar](80) NOT NULL,
	[ObjectStatus] [int] NOT NULL,
 CONSTRAINT [PK_Branch] PRIMARY KEY CLUSTERED 
(
	[CustomerId] ASC,
	[BranchId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[Branch] ADD  CONSTRAINT [DF_Branch_ObjectStatus]  DEFAULT ((1)) FOR [ObjectStatus]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Customer Id' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Branch', @level2type=N'COLUMN',@level2name=N'CustomerId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Branch Id' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Branch', @level2type=N'COLUMN',@level2name=N'BranchId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Default Branch Name' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Branch', @level2type=N'COLUMN',@level2name=N'BranchName'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 - Inactive, 1 - Active' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Branch', @level2type=N'COLUMN',@level2name=N'ObjectStatus'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Branch Primary Key' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Branch', @level2type=N'CONSTRAINT',@level2name=N'PK_Branch'
GO


/*********** Script Update Date: 2018-04-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[BranchML](
	[CustomerId] [nvarchar](30) NOT NULL,
	[BranchId] [nvarchar](30) NOT NULL,
	[LangId] [nvarchar](3) NOT NULL,
	[BranchName] [nvarchar](80) NULL,
 CONSTRAINT [PK_BranchML] PRIMARY KEY CLUSTERED 
(
	[CustomerId] ASC,
	[BranchId] ASC,
	[LangId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Customer Id' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BranchML', @level2type=N'COLUMN',@level2name=N'CustomerId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Branch Id' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BranchML', @level2type=N'COLUMN',@level2name=N'BranchId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Language Id' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BranchML', @level2type=N'COLUMN',@level2name=N'LangId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Native Branch Name' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'BranchML', @level2type=N'COLUMN',@level2name=N'BranchName'
GO


/*********** Script Update Date: 2018-04-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[BranchView]
AS
	SELECT LanguageView.LangId
		 --, LanguageView.FlagId
	     --, LanguageView.DescriptionEN
		 --, LanguageView.DescriptionNative
		 , LanguageView.Enabled
		 , LanguageView.SortOrder
		 , Branch.CustomerId
		 , Branch.BranchId
	     , Branch.BranchName AS BranchNameEN
		 , Branch.ObjectStatus
	  FROM LanguageView CROSS JOIN dbo.Branch

GO


/*********** Script Update Date: 2018-04-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[BranchMLView]
AS
	SELECT BRV.LangId
	     , BRV.CustomerId
	     , BRV.BranchId
	     , BRV.BranchNameEN
		 , CASE 
			WHEN BRML.BranchName IS NULL THEN 
				BRV.BranchNameEN 
			ELSE 
				BRML.BranchName 
		   END AS BranchNameNative
	     , BRV.ObjectStatus
	     , BRV.Enabled
	     , BRV.SortOrder
		FROM dbo.BranchML AS BRML RIGHT OUTER JOIN BranchView AS BRV
		  ON (    BRML.LangId = BRV.LangId 
		      AND BRML.CustomerId = BRV.CustomerId
		      AND BRML.BranchId = BRV.BranchId
			 )

GO


/*********** Script Update Date: 2018-04-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[MemberInfo](
	[MemberId] [nvarchar](30) NOT NULL,
	[CustomerId] [nvarchar](30) NOT NULL,
	[TagId] [nvarchar](30) NULL,
	[IDCard] [nvarchar](30) NULL,
	[EmployeeCode] [nvarchar](30) NULL,
	[Prefix] [nvarchar](10) NULL,
	[FirstName] [nvarchar](40) NOT NULL,
	[LastName] [nvarchar](50) NULL,
	[UserName] [nvarchar](50) NOT NULL,
	[Password] [nvarchar](20) NOT NULL,
	[MemberType] [int] NOT NULL,
	[ObjectStatus] [int] NOT NULL,
 CONSTRAINT [PK_MemberInfo] PRIMARY KEY CLUSTERED 
(
	[MemberId] ASC,
	[CustomerId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[MemberInfo] ADD  CONSTRAINT [DF_MemberInfo_MemberType]  DEFAULT ((280)) FOR [MemberType]
GO

ALTER TABLE [dbo].[MemberInfo] ADD  CONSTRAINT [DF_MemberInfo_ObjectStatus]  DEFAULT ((1)) FOR [ObjectStatus]
GO

ALTER TABLE [dbo].[MemberInfo]  WITH CHECK ADD  CONSTRAINT [CK_MemberInfo_MemberType] CHECK  (([MemberType]=(290) OR [MemberType]=(280) OR [MemberType]=(210) OR [MemberType]=(200)))
GO

ALTER TABLE [dbo].[MemberInfo] CHECK CONSTRAINT [CK_MemberInfo_MemberType]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Member Id' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MemberInfo', @level2type=N'COLUMN',@level2name=N'MemberId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Customer Id' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MemberInfo', @level2type=N'COLUMN',@level2name=N'CustomerId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Employee Smartcard TagId' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MemberInfo', @level2type=N'COLUMN',@level2name=N'TagId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Employee IDCard' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MemberInfo', @level2type=N'COLUMN',@level2name=N'IDCard'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Employee Code (assigned by customer company)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MemberInfo', @level2type=N'COLUMN',@level2name=N'EmployeeCode'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Default Prefix' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MemberInfo', @level2type=N'COLUMN',@level2name=N'Prefix'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Default First Name' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MemberInfo', @level2type=N'COLUMN',@level2name=N'FirstName'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Default Last Name' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MemberInfo', @level2type=N'COLUMN',@level2name=N'LastName'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The LogIn Member UserName' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MemberInfo', @level2type=N'COLUMN',@level2name=N'UserName'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The LogIn Member Password' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MemberInfo', @level2type=N'COLUMN',@level2name=N'Password'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'200 admin, 210 exclusive, 280 staff, 290 Device' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MemberInfo', @level2type=N'COLUMN',@level2name=N'MemberType'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 - InActive, 1 - Active' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MemberInfo', @level2type=N'COLUMN',@level2name=N'ObjectStatus'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Prevent Enter Invalid Member Type' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MemberInfo', @level2type=N'CONSTRAINT',@level2name=N'CK_MemberInfo_MemberType'
GO


/*********** Script Update Date: 2018-04-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[MemberInfoML](
	[MemberId] [nvarchar](30) NOT NULL,
	[CustomerId] [nvarchar](30) NOT NULL,
	[LangId] [nvarchar](3) NOT NULL,
	[Prefix] [nvarchar](10) NULL,
	[FirstName] [nvarchar](40) NOT NULL,
	[LastName] [nvarchar](50) NULL,
 CONSTRAINT [PK_MemberInfoML] PRIMARY KEY CLUSTERED 
(
	[MemberId] ASC,
	[CustomerId] ASC,
	[LangId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Member Id' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MemberInfoML', @level2type=N'COLUMN',@level2name=N'MemberId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Customer Id' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MemberInfoML', @level2type=N'COLUMN',@level2name=N'CustomerId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Language Id' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MemberInfoML', @level2type=N'COLUMN',@level2name=N'LangId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Native Prefix' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MemberInfoML', @level2type=N'COLUMN',@level2name=N'Prefix'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Native First Name' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MemberInfoML', @level2type=N'COLUMN',@level2name=N'FirstName'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Native Last Name' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MemberInfoML', @level2type=N'COLUMN',@level2name=N'LastName'
GO


/*********** Script Update Date: 2018-04-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[MemberInfoView]
AS
	SELECT LanguageView.LangId
		 --, LanguageView.FlagId
	     --, LanguageView.DescriptionEN
		 --, LanguageView.DescriptionNative
		 , LanguageView.Enabled
		 , LanguageView.SortOrder
		 , MemberInfo.CustomerId
		 , MemberInfo.MemberId
		 , MemberInfo.TagId
		 , MemberInfo.IDCard
		 , MemberInfo.EmployeeCode
	     , MemberInfo.Prefix AS PrefixEN
	     , MemberInfo.FirstName AS FirstNameEN
	     , MemberInfo.LastName AS LastNameEN
		 , MemberInfo.UserName
		 , MemberInfo.Password
		 , MemberInfo.MemberType
		 , MemberInfo.ObjectStatus
	  FROM LanguageView CROSS JOIN dbo.MemberInfo

GO


/*********** Script Update Date: 2018-04-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[MemberInfoMLView]
AS
	SELECT MIV.LangId
	     , MIV.CustomerId
	     , MIV.MemberId
	     , MIV.MemberType
	     , MIV.PrefixEN
	     , MIV.FirstNameEN
	     , MIV.LastNameEN
		 , CASE 
			WHEN MIML.FirstName IS NULL THEN 
				MIV.PrefixEN 
			ELSE 
				MIML.Prefix 
		   END AS PrefixNative
		 , CASE 
			WHEN MIML.FirstName IS NULL THEN 
				MIV.FirstNameEN 
			ELSE 
				MIML.FirstName 
		   END AS FirstNameNative
		 , CASE 
			WHEN MIML.FirstName IS NULL THEN 
				MIV.LastNameEN 
			ELSE 
				MIML.LastName 
		   END AS LastNameNative
	     , RTRIM(LTRIM(RTRIM(LTRIM(ISNULL(MIV.PrefixEN, N''))) + N' ' +
		               RTRIM(LTRIM(MIV.FirstNameEN)) + N' ' +
		               RTRIM(LTRIM(ISNULL(MIV.LastNameEN, N''))))) AS FullNameEN
		 , CASE 
			WHEN MIML.FirstName IS NULL THEN /* Use FirstName to check for used Native data */
				RTRIM(LTRIM(RTRIM(LTRIM(ISNULL(MIV.PrefixEN, N''))) + N' ' +
				            RTRIM(LTRIM(MIV.FirstNameEN)) + N' ' +
				            RTRIM(LTRIM(ISNULL(MIV.LastNameEN, N'')))))
			ELSE 
				RTRIM(LTRIM(RTRIM(LTRIM(ISNULL(MIML.Prefix, N''))) + N' ' +
				            RTRIM(LTRIM(MIML.FirstName)) + N' ' +
				            RTRIM(LTRIM(ISNULL(MIML.LastName, N'')))))
		   END AS FullNameNative
	     , MIV.IDCard
	     , MIV.TagId
	     , MIV.EmployeeCode
	     , MIV.UserName
	     , MIV.Password
	     , MIV.ObjectStatus
	     , MIV.Enabled
	     , MIV.SortOrder
		FROM dbo.MemberInfoML AS MIML RIGHT OUTER JOIN MemberInfoView AS MIV
		  ON (    MIML.LangId = MIV.LangId 
		      AND MIML.CustomerId = MIV.CustomerId
		      AND MIML.MemberId = MIV.MemberId
			 )

GO


/*********** Script Update Date: 2018-04-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Org](
	[CustomerId] [nvarchar](30) NOT NULL,
	[OrgId] [nvarchar](30) NOT NULL,
	[BranchId] [nvarchar](30) NULL,
	[ParentId] [nvarchar](30) NULL,
	[OrgName] [nvarchar](80) NOT NULL,
	[ObjectStatus] [int] NOT NULL,
 CONSTRAINT [PK_Org] PRIMARY KEY CLUSTERED 
(
	[CustomerId] ASC,
	[OrgId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[Org] ADD  CONSTRAINT [DF_Org_ObjectStatus]  DEFAULT ((1)) FOR [ObjectStatus]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Customer Id' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Org', @level2type=N'COLUMN',@level2name=N'CustomerId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Org Id' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Org', @level2type=N'COLUMN',@level2name=N'OrgId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Branch Id' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Org', @level2type=N'COLUMN',@level2name=N'BranchId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Parent Org Id' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Org', @level2type=N'COLUMN',@level2name=N'ParentId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Default Org Name' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Org', @level2type=N'COLUMN',@level2name=N'OrgName'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 - Inactive, 1 - Active' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Org', @level2type=N'COLUMN',@level2name=N'ObjectStatus'
GO


/*********** Script Update Date: 2018-04-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[OrgML](
	[CustomerId] [nvarchar](30) NOT NULL,
	[OrgId] [nvarchar](30) NOT NULL,
	[LangId] [nvarchar](3) NOT NULL,
	[OrgName] [nvarchar](80) NOT NULL,
 CONSTRAINT [PK_OrgML] PRIMARY KEY CLUSTERED 
(
	[CustomerId] ASC,
	[OrgId] ASC,
	[LangId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Customer Id' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'OrgML', @level2type=N'COLUMN',@level2name=N'CustomerId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Org Id' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'OrgML', @level2type=N'COLUMN',@level2name=N'OrgId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Language Id' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'OrgML', @level2type=N'COLUMN',@level2name=N'LangId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Native Org Name' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'OrgML', @level2type=N'COLUMN',@level2name=N'OrgName'
GO


/*********** Script Update Date: 2018-04-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[OrgView]
AS
	SELECT LanguageView.LangId
		 --, LanguageView.FlagId
	     --, LanguageView.DescriptionEN
		 --, LanguageView.DescriptionNative
		 , LanguageView.Enabled
		 , LanguageView.SortOrder
		 , dbo.Org.CustomerId
		 , dbo.Org.OrgId
		 , dbo.Org.BranchId
		 , dbo.Org.ParentId
	     , dbo.Org.OrgName AS OrgNameEN
		 , dbo.Org.ObjectStatus
	  FROM LanguageView CROSS JOIN dbo.Org

GO


/*********** Script Update Date: 2018-04-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[OrgMLView]
AS
   SELECT ORMLV.LangId
        , ORMLV.CustomerId
        , ORMLV.OrgId
        , ORMLV.BranchId
		, BMLV.BranchNameEN
		, BMLV.BranchNameNative
        , ORMLV.ParentId
        , ORMLV.OrgNameEN
        , ORMLV.OrgNameNative
        , ORMLV.ObjectStatus AS OrgStatus
		, BMLV.ObjectStatus AS BranchStatus
        , ORMLV.Enabled
        , ORMLV.SortOrder
     FROM (
			SELECT ORV.LangId
				 , ORV.CustomerId
				 , ORV.OrgId
				 , ORV.BranchId
				 , ORV.ParentId
				 , ORV.OrgNameEN
				 , CASE 
					WHEN ORML.OrgName IS NULL THEN 
						ORV.OrgNameEN 
					ELSE 
						ORML.OrgName 
				   END AS OrgNameNative
				 , ORV.ObjectStatus
				 , ORV.Enabled
				 , ORV.SortOrder
				FROM dbo.OrgML AS ORML RIGHT OUTER JOIN OrgView AS ORV
				  ON (    ORML.LangId = ORV.LangId 
					  AND ORML.CustomerId = ORV.CustomerId
					  AND ORML.OrgId = ORV.OrgId
					 )
	      ) AS ORMLV LEFT JOIN BranchMLView AS BMLV
		          ON (    ORMLV.LangId = BMLV.LangId
				      AND ORMLV.CustomerId = BMLV.CustomerId
				      AND ORMLV.BranchId = BMLV.BranchId)

GO


/*********** Script Update Date: 2018-04-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[QSet](
	[QSetId] [nvarchar](30) NOT NULL,
	[CustomerId] [nvarchar](30) NOT NULL,
	[Description] [nvarchar](max) NOT NULL,
	[HasRemark] [bit] NOT NULL,
	[DisplayMode] [tinyint] NOT NULL,
	[BeginDate] [datetime] NOT NULL,
	[EndDate] [datetime] NOT NULL,
	[ObjectStatus] [int] NOT NULL,
 CONSTRAINT [PK_QSet] PRIMARY KEY CLUSTERED 
(
	[QSetId] ASC,
	[CustomerId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

ALTER TABLE [dbo].[QSet] ADD  CONSTRAINT [DF_QSet_HasRemark]  DEFAULT ((0)) FOR [HasRemark]
GO

ALTER TABLE [dbo].[QSet] ADD  CONSTRAINT [DF_QSet_DisplayMode]  DEFAULT ((0)) FOR [DisplayMode]
GO

ALTER TABLE [dbo].[QSet] ADD  CONSTRAINT [DF_QSet_ObjectStatus]  DEFAULT ((1)) FOR [ObjectStatus]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Question Set Id.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'QSet', @level2type=N'COLUMN',@level2name=N'QSetId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Customer Id.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'QSet', @level2type=N'COLUMN',@level2name=N'CustomerId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Question Set Description.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'QSet', @level2type=N'COLUMN',@level2name=N'Description'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Is Question Set allow to enter remark.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'QSet', @level2type=N'COLUMN',@level2name=N'HasRemark'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 - One slide per page, 1 Continuous slide' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'QSet', @level2type=N'COLUMN',@level2name=N'DisplayMode'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The begin date.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'QSet', @level2type=N'COLUMN',@level2name=N'BeginDate'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The end date.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'QSet', @level2type=N'COLUMN',@level2name=N'EndDate'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 - Inactive, 1 - Active' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'QSet', @level2type=N'COLUMN',@level2name=N'ObjectStatus'
GO


/*********** Script Update Date: 2018-04-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[QSetML](
	[QSetId] [nvarchar](30) NOT NULL,
	[CustomerId] [nvarchar](30) NOT NULL,
	[LangId] [nvarchar](3) NOT NULL,
	[Description] [nvarchar](max) NOT NULL,
 CONSTRAINT [PK_QSetML] PRIMARY KEY CLUSTERED 
(
	[QSetId] ASC,
	[CustomerId] ASC,
	[LangId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Question Set Id.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'QSetML', @level2type=N'COLUMN',@level2name=N'QSetId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Customer Id.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'QSetML', @level2type=N'COLUMN',@level2name=N'CustomerId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Question Set Description.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'QSetML', @level2type=N'COLUMN',@level2name=N'Description'
GO


/*********** Script Update Date: 2018-04-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[QSlide](
	[CustomerId] [nvarchar](30) NOT NULL,
	[QSetId] [nvarchar](30) NOT NULL,
	[QSeq] [int] NOT NULL,
	[QText] [nvarchar](max) NOT NULL,
	[HasRemark] [bit] NOT NULL,
	[SortOrder] [int] NOT NULL,
	[ObjectStatus] [int] NOT NULL,
 CONSTRAINT [PK_QSlide] PRIMARY KEY CLUSTERED 
(
	[CustomerId] ASC,
	[QSetId] ASC,
	[QSeq] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

ALTER TABLE [dbo].[QSlide] ADD  CONSTRAINT [DF_QSlide_HasRemark]  DEFAULT ((0)) FOR [HasRemark]
GO

ALTER TABLE [dbo].[QSlide] ADD  CONSTRAINT [DF_QSlide_SortOrder]  DEFAULT ((0)) FOR [SortOrder]
GO

ALTER TABLE [dbo].[QSlide] ADD  CONSTRAINT [DF_QSlide_ObjectStatus]  DEFAULT ((1)) FOR [ObjectStatus]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Customer Id.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'QSlide', @level2type=N'COLUMN',@level2name=N'CustomerId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The QSet Id.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'QSlide', @level2type=N'COLUMN',@level2name=N'QSetId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Question Sequence (Unique).' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'QSlide', @level2type=N'COLUMN',@level2name=N'QSeq'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Question Text.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'QSlide', @level2type=N'COLUMN',@level2name=N'QText'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Is Question Slide Has remark (0 - No Remark, 1 - Has Remark).' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'QSlide', @level2type=N'COLUMN',@level2name=N'HasRemark'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Sort Order.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'QSlide', @level2type=N'COLUMN',@level2name=N'SortOrder'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 - Inactive, 1 - Active' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'QSlide', @level2type=N'COLUMN',@level2name=N'ObjectStatus'
GO


/*********** Script Update Date: 2018-04-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[QSlideML](
	[CustomerId] [nvarchar](30) NOT NULL,
	[QSetId] [nvarchar](30) NOT NULL,
	[QSeq] [int] NOT NULL,
	[LangId] [nvarchar](3) NOT NULL,
	[QText] [nvarchar](max) NOT NULL,
 CONSTRAINT [PK_QSlideML] PRIMARY KEY CLUSTERED 
(
	[CustomerId] ASC,
	[QSetId] ASC,
	[QSeq] ASC,
	[LangId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Customer Id.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'QSlideML', @level2type=N'COLUMN',@level2name=N'CustomerId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The QSet Id.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'QSlideML', @level2type=N'COLUMN',@level2name=N'QSetId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Question Sequence (Unique).' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'QSlideML', @level2type=N'COLUMN',@level2name=N'QSeq'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Language Id.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'QSlideML', @level2type=N'COLUMN',@level2name=N'LangId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Question Text in specificed language.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'QSlideML', @level2type=N'COLUMN',@level2name=N'QText'
GO


/*********** Script Update Date: 2018-04-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[QSlideItem](
	[CustomerId] [nvarchar](30) NOT NULL,
	[QSetId] [nvarchar](30) NOT NULL,
	[QSeq] [int] NOT NULL,
	[QSSeq] [int] NOT NULL,
	[QText] [nvarchar](max) NOT NULL,
	[IsRemark] [bit] NOT NULL,
	[SortOrder] [int] NOT NULL,
	[ObjectStatus] [int] NOT NULL,
 CONSTRAINT [PK_QSlideItem] PRIMARY KEY CLUSTERED 
(
	[CustomerId] ASC,
	[QSetId] ASC,
	[QSeq] ASC,
	[QSSeq] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

ALTER TABLE [dbo].[QSlideItem] ADD  CONSTRAINT [DF_QSlideItem_IsRemark]  DEFAULT ((0)) FOR [IsRemark]
GO

ALTER TABLE [dbo].[QSlideItem] ADD  CONSTRAINT [DF_QSlideItem_SortOrder]  DEFAULT ((0)) FOR [SortOrder]
GO

ALTER TABLE [dbo].[QSlideItem] ADD  CONSTRAINT [DF_QSlideItem_ObjectStatus]  DEFAULT ((1)) FOR [ObjectStatus]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Customer Id.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'QSlideItem', @level2type=N'COLUMN',@level2name=N'CustomerId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Question Set Id.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'QSlideItem', @level2type=N'COLUMN',@level2name=N'QSetId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Question Slide Seq.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'QSlideItem', @level2type=N'COLUMN',@level2name=N'QSeq'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Question Item Seq.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'QSlideItem', @level2type=N'COLUMN',@level2name=N'QSSeq'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Question Item Text.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'QSlideItem', @level2type=N'COLUMN',@level2name=N'QText'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Is Remark Item.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'QSlideItem', @level2type=N'COLUMN',@level2name=N'IsRemark'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Question Item Sort Order.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'QSlideItem', @level2type=N'COLUMN',@level2name=N'SortOrder'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 - Inactive, 1 - Active' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'QSlideItem', @level2type=N'COLUMN',@level2name=N'ObjectStatus'
GO


/*********** Script Update Date: 2018-04-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[QSlideItemML](
	[CustomerId] [nvarchar](30) NOT NULL,
	[QSetId] [nvarchar](30) NOT NULL,
	[QSeq] [int] NOT NULL,
	[QSSeq] [int] NOT NULL,
	[LangId] [nvarchar](3) NOT NULL,
	[QText] [nvarchar](max) NOT NULL,
 CONSTRAINT [PK_QSlideItemML] PRIMARY KEY CLUSTERED 
(
	[CustomerId] ASC,
	[QSetId] ASC,
	[QSeq] ASC,
	[QSSeq] ASC,
	[LangId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Customer Id.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'QSlideItemML', @level2type=N'COLUMN',@level2name=N'CustomerId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Question Set Id.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'QSlideItemML', @level2type=N'COLUMN',@level2name=N'QSetId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Question Slide Seq.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'QSlideItemML', @level2type=N'COLUMN',@level2name=N'QSeq'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Question Item Seq.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'QSlideItemML', @level2type=N'COLUMN',@level2name=N'QSSeq'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Language Id.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'QSlideItemML', @level2type=N'COLUMN',@level2name=N'LangId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Question Item Text.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'QSlideItemML', @level2type=N'COLUMN',@level2name=N'QText'
GO


/*********** Script Update Date: 2018-04-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Vote](
	[CustomerId] [nvarchar](30) NOT NULL,
	[OrgId] [nvarchar](30) NOT NULL,
	[BranchId] [nvarchar](30) NOT NULL,
	[DeviceId] [nvarchar](50) NOT NULL,
	[QSetId] [nvarchar](30) NOT NULL,
	[QSeq] [int] NOT NULL,
	[VoteSeq] [int] NOT NULL,
	[UserId] [nvarchar](30) NULL,
	[VoteDate] [datetime] NOT NULL,
	[VoteValue] [int] NOT NULL,
	[Remark] [nvarchar](100) NULL,
	[ObjectStatus] [int] NOT NULL,
 CONSTRAINT [PK_Vote] PRIMARY KEY CLUSTERED 
(
	[CustomerId] ASC,
	[OrgId] ASC,
	[BranchId] ASC,
	[DeviceId] ASC,
	[QSetId] ASC,
	[QSeq] ASC,
	[VoteSeq] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING ON

GO

/****** Object:  Index [IX_UserId]    Script Date: 4/23/2018 04:32:54 ******/
CREATE NONCLUSTERED INDEX [IX_UserId] ON [dbo].[Vote]
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

/****** Object:  Index [IX_VoteDate]    Script Date: 4/23/2018 04:32:54 ******/
CREATE NONCLUSTERED INDEX [IX_VoteDate] ON [dbo].[Vote]
(
	[VoteDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

/****** Object:  Index [IX_VoteValue]    Script Date: 4/23/2018 04:32:54 ******/
CREATE NONCLUSTERED INDEX [IX_VoteValue] ON [dbo].[Vote]
(
	[VoteValue] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Vote] ADD  CONSTRAINT [DF_Vote_ObjectStatus]  DEFAULT ((1)) FOR [ObjectStatus]
GO


/*********** Script Update Date: 2018-04-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[LogInView]
AS
SELECT UV.LangId
     , NULL AS CustomerId
     , UV.UserId AS MemberId, MemberType, IsEDLUser = Convert(bit, 1)
     , UV.PrefixEN, UV.FirstNameEN, UV.LastNameEN, UV.FullNameEN
     , UV.PrefixNative, UV.FirstNameNative, UV.LastNameNative, UV.FullNameNative
	 , UV.UserName, UV.Password, UV.ObjectStatus
	 , UV.Enabled, UV.SortOrder
  FROM UserInfoMLView UV
UNION
SELECT MV.LangId
     , MV.CustomerId
     , MV.MemberId, MemberType, IsEDLUser = Convert(bit, 0)
     , MV.PrefixEN, MV.FirstNameEN, MV.LastNameEN, MV.FullNameEN
     , MV.PrefixNative, MV.FirstNameNative, MV.LastNameNative, MV.FullNameNative
	 , MV.UserName, MV.Password, MV.ObjectStatus
	 , MV.Enabled, MV.SortOrder
  FROM MemberInfoMLView MV

GO


/*********** Script Update Date: 2018-04-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: IsSameDate.
-- Description:	IsSameDate is function to check is data is in same date
--              returns 1 if same date otherwise returns 0
-- [== History ==]
-- <2016-10-30> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- =============================================
CREATE FUNCTION IsSameDate(@date1 datetime, @date2 datetime)
RETURNS bit
AS
BEGIN
DECLARE @diff int;
DECLARE @result bit;
    SELECT @diff = DATEDIFF(day, @date1, @date2);
    -- Return the result of the function
    IF @diff = 0
		SET @result = 1;
	ELSE SET @result = 0;
    RETURN @result;
END
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: IsSameMonth.
-- Description:	IsSameMonth is function to check is data is in same month
--              returns 1 if same month otherwise returns 0
-- [== History ==]
-- <2016-10-30> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- =============================================
CREATE FUNCTION IsSameMonth(@date1 datetime, @date2 datetime)
RETURNS bit
AS
BEGIN
DECLARE @diff int;
DECLARE @result bit;
    SELECT @diff = DATEDIFF(month, @date1, @date2);
    -- Return the result of the function
    IF @diff = 0
		SET @result = 1;
	ELSE SET @result = 0;
    RETURN @result;
END
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: IsSameYear.
-- Description:	IsSameYear is function to check is data is in same year
--              returns 1 if same year otherwise returns 0
-- [== History ==]
-- <2016-10-30> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- =============================================
CREATE FUNCTION IsSameYear(@date1 datetime, @date2 datetime)
RETURNS bit
AS
BEGIN
DECLARE @diff int;
DECLARE @result bit;
    SELECT @diff = DATEDIFF(year, @date1, @date2);
    -- Return the result of the function
    IF @diff = 0
		SET @result = 1;
	ELSE SET @result = 0;
    RETURN @result;
END
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: IsNullOrEmpty.
-- Description:	IsNullOrEmpty is function to check is string is in null or empty
--              returns 1 if string is null or empty string otherwise return 0.
-- [== History ==]
-- <2016-11-02> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- =============================================
CREATE FUNCTION IsNullOrEmpty(@str nvarchar)
RETURNS bit
AS
BEGIN
DECLARE @diff int;
DECLARE @result bit;
    IF @str IS NULL OR RTRIM(LTRIM(@str)) = N''
		SET @result = 1
	ELSE SET @result = 0

    RETURN @result;
END

GO


/*********** Script Update Date: 2018-04-26  ***********/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author: Chumpon Asaneerat
-- Name: GetRandomHexCode.
-- Description:	GetRandomHexCode is generate random hex code with specificed length max 20.
-- [== History ==]
-- <2016-11-02> :
--	- Stored Procedure Created.
--
-- [== Example ==]
-- /* execute */
-- exec GetRandomHexCode; -- generate 6 digit code.
-- exec GetRandomHexCode 4; -- generate 4 digit code.
-- /* use out parameter */
-- declare @code nvarchar(20);
-- exec dbo.GetRandomHexCode 6, @code out;
-- select @code;
-- =============================================
CREATE PROCEDURE GetRandomHexCode(@length int = 6,
    @RandomString nvarchar(20) = null out)
AS
BEGIN
DECLARE @PoolLength int;
DECLARE @CharPool nvarchar(40);
    -- define allowable character explicitly
    SET @CharPool = N'ABCDEFGHIJKLMNPQRSTUVWXYZ1234567890';
    SET @PoolLength = Len(@CharPool);
    SET @RandomString = '';

    WHILE (LEN(@RandomString) < @Length) BEGIN
        SET @RandomString = @RandomString +  SUBSTRING(@Charpool, CONVERT(int, RAND() * @PoolLength), 1)
    END

    SELECT @RandomString as Code;
END

GO


/*********** Script Update Date: 2018-04-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: DeleteAll.
-- Description:	Remove all data in all tables.
-- [== History ==]
-- <2017-02-04> :
--	- Stored Procedure Created.
-- <2018-04-16> :
--	- Add code to count deleted row(s) and show output.
--
-- [== Example ==]
--
--exec DeleteAll
-- =============================================
CREATE PROCEDURE DeleteAll
AS
BEGIN
CREATE TABLE #TABLE_NAMES
(
    TableName nvarchar(100)
);
DECLARE @sql nvarchar(MAX);
DECLARE @countSql nvarchar(MAX);
DECLARE @paramDefs nvarchar(MAX);
DECLARE @tableName nvarchar(100);
DECLARE @delTableCursor CURSOR;
DECLARE @oCnt int;
DECLARE @nCnt int;

    INSERT INTO #TABLE_NAMES
        (TableName)
    SELECT TABLE_NAME
    FROM INFORMATION_SCHEMA.TABLES
    WHERE TABLE_TYPE = N'BASE TABLE';

    SET @delTableCursor = CURSOR LOCAL FAST_FORWARD 
	    FOR SELECT TableName
    FROM #TABLE_NAMES;

    OPEN @delTableCursor;
    FETCH NEXT FROM @delTableCursor INTO @tableName;
    WHILE @@FETCH_STATUS = 0
	BEGIN
        -- Prepare count statement.
        SET @countSql = 'SELECT @iCnt = COUNT(*) FROM ' + @tableName;
        SET @paramDefs = N'@iCnt int OUTPUT';

        -- Gets exists rows before delete.
        SET @oCnt = 0;
        EXECUTE SP_EXECUTESQL @countSql, @paramDefs, @iCnt = @oCnt OUTPUT;
        
        -- delete all data in table.
        SET @sql = 'DELETE FROM ' + @tableName;
        EXECUTE SP_EXECUTESQL @sql;
        
        -- Gets exists rows after deleted.
        SET @nCnt = 0;
        EXECUTE SP_EXECUTESQL @countSql, @paramDefs, @iCnt = @nCnt OUTPUT;

        -- Show output
        SELECT @tableName AS TableName, (@oCnt - @nCnt) AS Deleted;
        
        FETCH NEXT FROM @delTableCursor INTO @tableName;
    END
    CLOSE @delTableCursor;
    DEALLOCATE @delTableCursor;

    DROP TABLE #TABLE_NAMES;
END

GO


/*********** Script Update Date: 2018-04-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: SaveErrorMsg.
-- Description:	Save Error Message.
-- [== History ==]
-- <2018-04-16> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
--EXEC SaveErrorMsg 0, N'Success.';
--EXEC SaveErrorMsg 101, N'Language Id cannot be null or empty string.';
-- =============================================
CREATE PROCEDURE SaveErrorMsg(
  @errNum as int
, @errMsg as nvarchar(MAX))
AS
BEGIN
DECLARE @iCnt int = 0;
    SELECT @iCnt = COUNT(*)
      FROM ErrorMessage
     WHERE ErrCode = @errNum;

    IF @iCnt = 0
    BEGIN
        -- INSERT
        INSERT INTO ErrorMessage
        (
              ErrCode
            , ErrMsg
        )
        VALUES
        (
              @errNum
            , @errMsg
        );
    END
    ELSE
    BEGIN
        -- UPDATE
        UPDATE ErrorMessage
           SET ErrMsg = COALESCE(@errMsg, ErrMsg)
         WHERE ErrCode = @errNum;
    END 
END

GO


/*********** Script Update Date: 2018-04-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: GetErrorMsg.
-- Description:	Get Error Message.
-- [== History ==]
-- <2018-04-16> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
--EXEC GetErrorMsg 101 @errNum out, @errMsg out
-- =============================================
CREATE PROCEDURE GetErrorMsg(
  @errCode as int
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
DECLARE @iCnt int = 0;
	SELECT @iCnt = COUNT(*)
	  FROM ErrorMessage
	 WHERE ErrCode = @errCode;

	IF @iCnt = 0
	BEGIN
	-- Not Found.
	SET @errNum = @errCode;
	SET @errMsg = 'Error Code Not Found.';
	END
	ELSE
	BEGIN
		SELECT @errNum = ErrCode
			 , @errMsg = ErrMsg
		  FROM ErrorMessage
		 WHERE ErrCode = @errCode;
	END 
END

GO


/*********** Script Update Date: 2018-04-26  ***********/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: GetErrorMsgs.
-- Description:	Gets error messages
-- [== History ==]
-- <2017-05-31> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
--exec GetErrorMsgs; -- gets all error messages.
-- =============================================
CREATE PROCEDURE [dbo].[GetErrorMsgs]
AS
BEGIN
    SELECT *
    FROM [dbo].[ErrorMessage]
    ORDER BY ErrCode
END

GO


/*********** Script Update Date: 2018-04-26  ***********/
/****** Object:  StoredProcedure [dbo].[SaveLanguage]    Script Date: 6/12/2017 9:21:06 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: SaveLanguage.
-- Description:	Save Language.
-- [== History ==]
-- <2017-05-31> :
--	- Stored Procedure Created.
-- <2017-06-06> :
--	- Update parameters for match change table structure.
--	- Add logic to allow to change DescriptionEN if in Update Mode.
-- <2017-06-08> :
--  - The @errMsg set as nvarchar(MAX).
-- <2017-06-12> :
-- - Fixed all checks logic.
-- <2018-04-16> :
-- - Remove Currency.
-- - Replace FlagIconCss with FlagId.
-- - Replace Error Message code.
--
-- [== Example ==]
--
--exec SaveLanguage N'EN', N'US', N'English', N'English', 1, 1
--exec SaveLanguage N'JP', N'JA', N'Chinese', N'中文', 2, 1
--exec SaveLanguage N'CN', N'ZH', N'Japanese', N'中文', 3, 1
-- =============================================
CREATE PROCEDURE [dbo].[SaveLanguage] (
  @langId as nvarchar(3) = null
, @flagId as nvarchar(3) = null
, @descriptionEN as nvarchar(50) = null
, @descriptionNative as nvarchar(50) = null
, @sortOrder as int = null
, @enabled as bit = null
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
DECLARE @iLangCnt int = 0;
DECLARE @iDescCnt int = 0;
DECLARE @iSortOrder int = 0;
DECLARE @bEnabled bit = 0;

	-- Error Code:
	--   0 : Success
	-- 101 : Language Id cannot be null or empty string.
	-- 102 : Description(EN) cannot be null or empty string.
	-- 103 : Language Description (EN) is duplicated.
	-- OTHER : SQL Error Number & Error Message.
	BEGIN TRY
		IF (dbo.IsNullOrEmpty(@langId) = 1)
		BEGIN
			EXEC GetErrorMsg 101, @errNum out, @errMsg out
			RETURN
		END

		IF (dbo.IsNullOrEmpty(@descriptionEN) = 1)
		BEGIN
			EXEC GetErrorMsg 102, @errNum out, @errMsg out
			RETURN
		END

		-- Check INSERT OR UPDATE?.
		SELECT @iLangCnt = COUNT(*)
		  FROM [dbo].[Language]
		 WHERE LOWER(RTRIM(LTRIM([LangId]))) = LOWER(RTRIM(LTRIM(@langId)))

		IF (@iLangCnt = 0)
		BEGIN
			-- Detected language not exists so need to check duplicate description.
			-- Check is description is duplicated?.
			SELECT @iDescCnt = COUNT(*)
				FROM [dbo].[Language]
				WHERE UPPER(RTRIM(LTRIM([DescriptionEN]))) = UPPER(RTRIM(LTRIM(@descriptionEN))) COLLATE SQL_Latin1_General_CP1_CS_AS

			IF (@iDescCnt <> 0)
			BEGIN
				EXEC GetErrorMsg 103, @errNum out, @errMsg out
				RETURN
			END
		END

		IF @iLangCnt = 0
		BEGIN
			-- Auto set sort order if required.
			IF (@sortOrder IS NULL)
			BEGIN
				SELECT @iSortOrder = MAX([SortOrder])
				  FROM [dbo].[Language];
				IF (@iSortOrder IS NULL)
				BEGIN
					SET @iSortOrder = 1;
				END
				ELSE
				BEGIN
					SET @iSortOrder = @iSortOrder + 1;
				END
			END
			ELSE
			BEGIN
				SET @iSortOrder = @sortOrder;
			END
			-- Check enabled flag.
			IF (@enabled IS NULL)
			BEGIN
				SET @bEnabled = 0; -- default mode is disabled.
			END
			ELSE
			BEGIN
				SET @bEnabled = @enabled; -- change mode.
			END

			-- INSERT
			INSERT INTO [dbo].[Language]
			(
				  [LangId]
				, [FlagId]
				, [DescriptionEN]
				, [DescriptionNative]
				, [SortOrder]
				, [Enabled]
			)
			VALUES
			(
				  UPPER(RTRIM(LTRIM(@langId)))
				, COALESCE(UPPER(RTRIM(LTRIM(@flagId))), UPPER(RTRIM(LTRIM(@langId))))
				, RTRIM(LTRIM(@descriptionEN))
				, RTRIM(LTRIM(@descriptionNative))
				, @iSortOrder
				, @bEnabled
			);
		END
		ELSE
		BEGIN
			-- UPDATE
			UPDATE [dbo].[Language]
			   SET [FlagId] =  COALESCE(UPPER(RTRIM(LTRIM(@flagId))), [FlagId])
			     , [DescriptionEN] = RTRIM(LTRIM(@descriptionEN))
			     , [DescriptionNative] =  COALESCE(@descriptionNative, [DescriptionNative])
			     , [SortOrder] = COALESCE(@sortOrder, [SortOrder])
			     , [Enabled] =  COALESCE(@enabled, [Enabled])
			 WHERE LOWER(RTRIM(LTRIM([LangId]))) = LOWER(RTRIM(LTRIM(@langId)));
		END
		EXEC GetErrorMsg 0, @errNum out, @errMsg out
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO


/*********** Script Update Date: 2018-04-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: DisableLanguage.
-- Description:	Disable Language.
-- [== History ==]
-- <2017-05-31> :
--	- Stored Procedure Created.
-- <2018-04-16> :
--	- Change langId type from nvarchar(10) to nvarchar(3).
--
-- [== Example ==]
--
--exec DisableLanguage N'ES' -- Disable Language.
-- =============================================
CREATE PROCEDURE [dbo].[DisableLanguage]
(
    @langId nvarchar(3) = null
)
AS
BEGIN
    UPDATE [dbo].[Language]
	   SET [ENABLED] = 0
	 WHERE UPPER(LTRIM(RTRIM(LangId))) = UPPER(LTRIM(RTRIM(@langId)));
END

GO


/*********** Script Update Date: 2018-04-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: EnagleLanguage.
-- Description:	Enable Language.
-- [== History ==]
-- <2017-05-31> :
--	- Stored Procedure Created.
-- <2018-04-16> :
--	- Change langId type from nvarchar(10) to nvarchar(3).
--
-- [== Example ==]
--
--exec EnagleLanguage N'ES' -- Enable Language.
-- =============================================
CREATE PROCEDURE [dbo].[EnableLanguage]
(
    @langId nvarchar(3) = null
)
AS
BEGIN
    UPDATE [dbo].[Language]
	   SET [ENABLED] = 1
	 WHERE UPPER(LTRIM(RTRIM(LangId))) = UPPER(LTRIM(RTRIM(@langId)));
END

GO


/*********** Script Update Date: 2018-04-26  ***********/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: GetLanguages.
-- Description:	Gets languages.
-- [== History ==]
-- <2017-05-31> :
--	- Stored Procedure Created.
-- <2018-04-16> :
--	- The @enabled parameter default value is NULL.
--
-- [== Example ==]
--
--exec GetLanguages; -- for get all.
--exec GetLanguages 1; -- for only enabled language.
--exec GetLanguages 0; -- for only disabled language.
-- =============================================
CREATE PROCEDURE [dbo].[GetLanguages]
(
    @enabled bit = null
)
AS
BEGIN
    SELECT *
      FROM [dbo].[LanguageView]
     WHERE [ENABLED] = COALESCE(@enabled, [ENABLED])
     ORDER BY SortOrder
END

GO

/*********** Script Update Date: 2018-04-26  ***********/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author: Chumpon Asaneerat
-- Name: NextMasterPK.
-- Description:	SetMasterPK (master)
-- [== History ==]
-- <2016-10-30> :
--	- Stored Procedure Created.
-- <2016-11-02> :
--	- Change Size of @prefix from nvarchar(5) to nvarchar(10) due to table MasterPK changed.
--	- Add checks parameter code.
-- <2018-04-16> :
--	- change code(s).
--
-- [== Example ==]
--
--exec SetMasterPK N'Customer', 1, 'EDL', 5
-- =============================================
CREATE PROCEDURE [dbo].[SetMasterPK] (
  @tableName nvarchar(50)
, @seedResetMode int = 1
, @prefix nvarchar(10)
, @seedDigits tinyint
, @errNum int = 0 out
, @errMsg nvarchar(MAX) = N'' out
)
AS
BEGIN
DECLARE @iTblCnt tinyint;
	-- Error Code:
	--   0 : Success
	-- 201 : Table Name is null or empty string.
	-- 202 : Seed Reset Mode should be number 1-3.
	-- 203 : Seed Digits should be number 1-9.
	-- OTHER : SQL Error Number & Error Message.
	BEGIN TRY
		IF @tableName is null OR RTRIM(LTRIM(@tableName)) = N''
		BEGIN
			EXEC GetErrorMsg 201, @errNum out, @errMsg out
			RETURN;
		END
		
		IF @seedResetMode is null OR @seedResetMode <= 0 OR @seedResetMode > 3
		BEGIN
			EXEC GetErrorMsg 202, @errNum out, @errMsg out
			RETURN;
		END
		
		IF @seedDigits is null OR @seedDigits <= 0 OR @seedDigits > 9
		BEGIN
			EXEC GetErrorMsg 203, @errNum out, @errMsg out
			RETURN;
		END

		SELECT @iTblCnt = COUNT(*)
		  FROM MasterPK
		 WHERE LOWER([TableName]) = LOWER(RTRIM(LTRIM(@tableName)))
		IF @iTblCnt IS NULL OR @iTblCnt = 0
		BEGIN
			INSERT INTO MasterPK(
			        [TableName]
				  , SeedResetMode
				  , LastSeed
				  , [Prefix]
				  , SeedDigits
				  , LastUpdated
				 )
			     VALUES (
				    RTRIM(LTRIM(@tableName))
				  , @seedResetMode
				  , 0
				  , COALESCE(@prefix, N'')
				  , @seedDigits
				  , GETDATE()
				 );
		END
		ELSE
		BEGIN
			UPDATE MasterPK
			   SET [TableName] = RTRIM(LTRIM(@tableName))
			     , SeedResetMode = @seedResetMode
				 , LastSeed = 0
				 , [Prefix] = COALESCE(@prefix, N'')
				 , SeedDigits = @seedDigits
				 , LastUpdated = GETDATE()
			 WHERE LOWER([TableName]) = LOWER(RTRIM(LTRIM(@tableName)));
		END

		EXEC GetErrorMsg 0, @errNum out, @errMsg out
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO


/*********** Script Update Date: 2018-04-26  ***********/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author: Chumpon Asaneerat
-- Name: NextMasterPK.
-- Description:	NextMasterPK (master)
-- [== History ==]
-- <2016-10-30> :
--	- Stored Procedure Created.
-- <2016-11-02> :
--	- Change Size of @prefix from nvarchar(5) to nvarchar(10) due to table MasterPK changed.
--	- Add checks parameter code.
-- <2018-04-16> :
--	- change code(s).
--   
-- [== Example ==]
--
-- <Simple>
--exec NextMasterPK N'Customer';
--
-- <Complex>
--declare @seedNo as nvarchar(30);
--declare @errNum as int;
--declare @errMsg as nvarchar(max);
--exec NextMasterPK N'Customer'
--				, @seedNo out
--				, @errNum out
--				, @errMsg out;
--select @seedNo as seedcode
--     , @errNum as ErrNumber
--     , @errMsg as ErrMessage;
--select * from MasterPK;
-- =============================================
CREATE PROCEDURE [dbo].[NextMasterPK] 
(
  @tableName as nvarchar(50)
, @seedcode nvarchar(MAX) = N'' out  -- prefix(max:10) + date(max:10) + seedi(max:10) = 30
, @errNum int = 0 out
, @errMsg nvarchar(MAX) = N'' out
)
AS
BEGIN
DECLARE @lastSeedId int;
DECLARE @resetMode tinyint;
DECLARE @prefix nvarchar(10);
DECLARE @seedDigits tinyint;
DECLARE @lastDate datetime;
DECLARE @now datetime;
DECLARE @isSameDate bit;
DECLARE @iTblCnt tinyint;
	-- Error Code:
	--   0 : Success
	-- 201 : Table name cannot be null or empty string.
	-- 204 : Table name is not exists in MasterPK table.
	-- 205 : Not supports reset mode.
	-- 206 : Cannot generate seed code major cause should be 
	--		 seed reset mode is not supports.
	-- OTHER : SQL Error Number & Error Message.
	BEGIN TRY
		IF @tableName is null OR RTRIM(LTRIM(@tableName)) = N''
		BEGIN
			EXEC GetErrorMsg 201, @errNum out, @errMsg out
			RETURN;
		END

		SELECT @iTblCnt = COUNT(*)
		  FROM MasterPK
		 WHERE LOWER([TableName]) = LOWER(RTRIM(LTRIM(@tableName)))
		IF @iTblCnt IS NULL OR @iTblCnt = 0
		BEGIN
            EXEC GetErrorMsg 204, @errNum out, @errMsg out
			RETURN;
		END

		SET @now = GETDATE();
		-- for testing
		--SET @now = CONVERT(datetime, '2017-12-03 23:55:11:123', 121);
		SELECT @lastSeedId = LastSeed
			 , @resetMode = SeedResetMode
			 , @prefix = [prefix]
			 , @seedDigits = SeedDigits
			 , @lastDate = LastUpdated
			FROM MasterPK
			WHERE LOWER([TableName]) = LOWER(@tableName)
		-- for testing
		--SELECT @lastDate = CONVERT(datetime, '2016-11-03 23:55:11:123', 121);

		IF @lastSeedId IS NOT NULL OR @lastSeedId >= 0
		BEGIN
			-- format code
			SET @seedcode = @prefix;

			IF @resetMode = 1
			BEGIN
				SELECT @isSameDate = dbo.IsSameDate(@now, @lastDate)
				IF (@isSameDate = 0)
					SET @lastSeedId = 1;
				ELSE SET @lastSeedId = @lastSeedId + 1;
				-- daily
				SET @seedcode = @seedcode + 
					CONVERT(nvarchar(4), DATEPART(yyyy, @now)) +
					RIGHT('00' + CONVERT(nvarchar(2), DATEPART(mm, @now)), 2) +
					RIGHT('00' + CONVERT(nvarchar(2), DATEPART(dd, @now)), 2) +
					RIGHT(REPLICATE('0', @seedDigits) + RTRIM(CONVERT(nvarchar, @lastSeedId)), @seedDigits);
			END
			ELSE IF @resetMode = 2
			BEGIN
				SELECT @isSameDate = dbo.IsSameMonth(@now, @lastDate)
				IF (@isSameDate = 0)
					SET @lastSeedId = 1;
				ELSE SET @lastSeedId = @lastSeedId + 1;
				-- monthly
				SET @seedcode = @seedcode + 
					CONVERT(nvarchar(4), DATEPART(yyyy, @now)) +
					RIGHT('00' + CONVERT(nvarchar(2), DATEPART(mm, @now)), 2) +
					RIGHT(REPLICATE('0', @seedDigits) + RTRIM(CONVERT(nvarchar, @lastSeedId)), @seedDigits);
			END
			ELSE IF @resetMode = 3
			BEGIN
				SELECT @isSameDate = dbo.IsSameYear(@now, @lastDate)
				IF (@isSameDate = 0)
					SET @lastSeedId = 1;
				ELSE SET @lastSeedId = @lastSeedId + 1;
				-- yearly
				SET @seedcode = @seedcode + 
					CONVERT(nvarchar(4), DATEPART(yyyy, @now)) +
					RIGHT(REPLICATE('0', @seedDigits) + RTRIM(CONVERT(nvarchar, @lastSeedId)), @seedDigits);
			END
			ELSE
			BEGIN
				-- not supports
                EXEC GetErrorMsg 205, @errNum out, @errMsg out
				RETURN;
			END

			IF @seedcode IS NOT NULL OR @seedcode <> N''
			BEGIN
				-- update nexvalue and stamp last updated date.
				UPDATE MasterPK
					SET LastSeed = @lastSeedId
					  , LastUpdated = @now
					WHERE LOWER([TableName]) = LOWER(@tableName)
				
				EXEC GetErrorMsg 0, @errNum out, @errMsg out
			END
			ELSE
			BEGIN
                EXEC GetErrorMsg 206, @errNum out, @errMsg out
                SET @errMsg = ' ' + @errMsg + '.'
			END
		END
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO


/*********** Script Update Date: 2018-04-26  ***********/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: GetMasterPK.
-- Description:	GetUniquePK (master)
-- [== History ==]
-- <2016-10-30> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
--exec GetMasterPK N'Customer'; -- for get match by name
--exec GetMasterPK; -- for get all
-- =============================================
CREATE PROCEDURE [dbo].[GetMasterPK] 
(
  @tableName nvarchar(50) = null
)
AS
BEGIN
	SELECT LastSeed
		 , SeedResetMode
		 , CASE SeedResetMode
			 WHEN 1 THEN N'Daily'
			 WHEN 2 THEN N'Monthly'
			 WHEN 3 THEN N'Yearly'
		   END AS ResetMode
		 , [prefix]
		 , SeedDigits
		 , LastUpdated
		FROM MasterPK
		WHERE LOWER([TableName]) = LOWER(COALESCE(@tableName, [TableName]));
END

GO


/*********** Script Update Date: 2018-04-26  ***********/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: SavePeriodUnit.
-- Description:	Save PeriodUnit.
-- [== History ==]
-- <2017-06-12> :
--	- Stored Procedure Created.
-- <2018-04-16> :
--	- change error code(s).
--
-- [== Example ==]
--
--exec SavePeriodUnit 4, N'quarter'
-- =============================================
CREATE PROCEDURE [dbo].[SavePeriodUnit] (
  @periodUnitId as int = null
, @descriptionEN as nvarchar(50) = null
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
DECLARE @iPeriodCnt int = 0;
DECLARE @iDescCnt int = 0;
	-- Error Code:
	--   0 : Success
	-- 301 : PeriodUnit Id cannot be null.
	-- 302 : Description (default) cannot be null or empty string.
	-- 303 : Description (default) is duplicated.
	-- OTHER : SQL Error Number & Error Message.
	BEGIN TRY
		IF (@periodUnitId IS NULL)
		BEGIN
            EXEC GetErrorMsg 301, @errNum out, @errMsg out
			RETURN
		END

		IF (dbo.IsNullOrEmpty(@descriptionEN) = 1)
		BEGIN
            EXEC GetErrorMsg 302, @errNum out, @errMsg out
			RETURN
		END

		-- Check INSERT OR UPDATE?.
		SELECT @iPeriodCnt = COUNT(*)
		  FROM PeriodUnit
		 WHERE PeriodUnitId = @periodUnitId

		IF (@iPeriodCnt = 0)
		BEGIN
			-- Detected PeriodUnit not exists so need to check duplicate description.
			-- Check is description is duplicated?.
			SELECT @iDescCnt = COUNT(*)
				FROM PeriodUnit
				WHERE UPPER(RTRIM(LTRIM([Description]))) = UPPER(RTRIM(LTRIM(@descriptionEN))) COLLATE SQL_Latin1_General_CP1_CS_AS

			IF (@iDescCnt <> 0)
			BEGIN
                EXEC GetErrorMsg 303, @errNum out, @errMsg out
				RETURN
			END
		END

		IF @iPeriodCnt = 0
		BEGIN
			-- INSERT
			INSERT INTO PeriodUnit
			(
				  [PeriodUnitId]
				, [Description]
			)
			VALUES
			(
				  @periodUnitId
				, RTRIM(LTRIM(@descriptionEN))
			);
		END
		ELSE
		BEGIN
			-- UPDATE
			UPDATE PeriodUnit
			   SET [Description] = RTRIM(LTRIM(@descriptionEN))
			 WHERE [PeriodUnitId] = @periodUnitId;
		END

        EXEC GetErrorMsg 0, @errNum out, @errMsg out
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO


/*********** Script Update Date: 2018-04-26  ***********/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: SavePeriodUnitML.
-- Description:	Save PeriodUnit ML.
-- [== History ==]
-- <2017-06-12> :
--	- Stored Procedure Created.
-- <2018-04-16> :
--	- change language id from nvarchar(10) to nvarchar(3).
--	- change error code(s).
--
-- [== Example ==]
--
--exec SavePeriodUnitML 4, N'EN', N'quarter'
--exec SavePeriodUnitML 4, N'TH', N'ไตรมาส'
-- =============================================
CREATE PROCEDURE [dbo].[SavePeriodUnitML] (
  @periodUnitId as int = null
, @langId as nvarchar(3) = null
, @description as nvarchar(50) = null
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
DECLARE @iLangCnt int = 0;
DECLARE @iPeriodCnt int = 0;
DECLARE @iDescCnt int = 0;
	-- Error Code:
	--   0 : Success
	-- 101 : Language Id cannot be null or empty string.
	-- 104 : Language Id not found.
	-- 301 : PeriodUnit Id cannot be null.
	-- 304 : Description (ML) cannot be null or empty string.
	-- 305 : Cannot add new Description (ML) that already exists.
	-- 306 : Cannot change Description (ML) that alreadt exists.
	-- OTHER : SQL Error Number & Error Message.
	BEGIN TRY
		IF (@periodUnitId IS NULL)
		BEGIN
			-- Check Null Or Empty Period Unit Id.
            EXEC GetErrorMsg 301, @errNum out, @errMsg out
			RETURN
		END

		IF (dbo.IsNullOrEmpty(@langId) = 1)
		BEGIN
			-- Check Null Or Empty Language Id.
            EXEC GetErrorMsg 101, @errNum out, @errMsg out
			RETURN
		END

		SELECT @iLangCnt = COUNT(*)
		  FROM Language
		 WHERE UPPER(LTRIM(RTRIM(LangId))) = UPPER(LTRIM(RTRIM(@langId)));
		IF (@iLangCnt = 0)
		BEGIN
			-- Language not found.
            EXEC GetErrorMsg 104, @errNum out, @errMsg out
			RETURN
		END
		
		IF (dbo.IsNullOrEmpty(@description) = 1)
		BEGIN
			-- Check Null Or Empty description.
            EXEC GetErrorMsg 304, @errNum out, @errMsg out
			RETURN
		END

		-- Check INSERT OR UPDATE?.
		SELECT @iPeriodCnt = COUNT(*)
		  FROM PeriodUnitML
		 WHERE PeriodUnitId = @periodUnitId
		   AND UPPER(LTRIM(RTRIM(LangId))) = UPPER(LTRIM(RTRIM(@langId)));

		IF (@iPeriodCnt = 0)
		BEGIN
			-- Detected data not exists so need to check duplicate description in same language.
			-- Check is description is duplicated?.
			SELECT @iDescCnt = COUNT(*)
				FROM PeriodUnitML
				WHERE UPPER(RTRIM(LTRIM([Description]))) = UPPER(RTRIM(LTRIM(@description)))
				  AND UPPER(LTRIM(RTRIM(LangId))) = UPPER(LTRIM(RTRIM(@langId)))

			IF (@iDescCnt <> 0)
			BEGIN
				-- Cannot add new Description (ML) because the Description (ML) in same Language Id is already exists.
                EXEC GetErrorMsg 305, @errNum out, @errMsg out
				RETURN
			END
		END
		ELSE
		BEGIN
			-- Detected data is exists so need to check duplicate description in same language.
			-- Check is description is duplicated?.
			SELECT @iDescCnt = COUNT(*)
				FROM PeriodUnitML
				WHERE PeriodUnitId <> @periodUnitId
				  AND UPPER(RTRIM(LTRIM([Description]))) = UPPER(RTRIM(LTRIM(@description)))
				  AND UPPER(LTRIM(RTRIM(LangId))) = UPPER(LTRIM(RTRIM(@langId)))

			IF (@iDescCnt <> 0)
			BEGIN
				-- Cannot change Description (ML) because the Description (ML) in same Language Id is already exists.
                EXEC GetErrorMsg 306, @errNum out, @errMsg out
				RETURN
			END
		END

		IF @iPeriodCnt = 0
		BEGIN
			-- INSERT
			INSERT INTO PeriodUnitML
			(
				  [PeriodUnitId]
				, [LangId]
				, [Description]
			)
			VALUES
			(
				  @periodUnitId
				, UPPER(RTRIM(LTRIM(@langId)))
				, RTRIM(LTRIM(@description))
			);
		END
		ELSE
		BEGIN
			-- UPDATE
			UPDATE PeriodUnitML
			   SET [Description] = RTRIM(LTRIM(@description))
			 WHERE [PeriodUnitId] = @periodUnitId
			   AND UPPER(RTRIM(LTRIM([LangId]))) = UPPER(RTRIM(LTRIM(@langId)));
		END

        EXEC GetErrorMsg 0, @errNum out, @errMsg out
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO


/*********** Script Update Date: 2018-04-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: GetPeriodUnits.
-- Description:	Get Period Units.
-- [== History ==]
-- <2017-05-31> :
--	- Stored Procedure Created.
-- <2018-04-16> :
--	- change language id from nvarchar(10) to nvarchar(3).
--
-- [== Example ==]
--
--exec GetPeriodUnits NULL, 1;  -- for only enabled languages.
--exec GetPeriodUnits;          -- for get all.
--exec GetPeriodUnits N'EN';    -- for get PeriodUnit for EN language.
-- =============================================
CREATE PROCEDURE [dbo].[GetPeriodUnits] 
(
  @langId nvarchar(3) = NULL
, @enabled bit = NULL
)
AS
BEGIN
	SELECT * 
	  FROM PeriodUnitMLView
	 WHERE [ENABLED] = COALESCE(@enabled, [ENABLED])
	   AND UPPER(LTRIM(RTRIM(LangId))) = UPPER(LTRIM(RTRIM(COALESCE(@langId,LangId))))
	 ORDER BY SortOrder, PeriodUnitId
END

GO


/*********** Script Update Date: 2018-04-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: SaveLimitUnit.
-- Description:	Save Limit Unit.
-- [== History ==]
-- <2017-06-12> :
--	- Stored Procedure Created.
-- <2018-04-16> :
--	- change error code(s).
--
-- [== Example ==]
--
--exec SaveLimitUnit 4, N'Number Of Connection', N'connection(s)'
-- =============================================
CREATE PROCEDURE [dbo].[SaveLimitUnit] (
  @limitUnitId as int = null
, @descriptionEN as nvarchar(50) = null
, @unitTextEN as nvarchar(20) = null
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
DECLARE @iLimitCnt int = 0;
DECLARE @iDescCnt int = 0;
	-- Error Code:
	--   0 : Success
	-- 401 : LimitUnit Id cannot be null.
	-- 402 : Description (default) cannot be null or empty string.
	-- 403 : Description (default) is duplicated.
	-- 404 : UnitText (default) cannot be null or empty string.
	-- OTHER : SQL Error Number & Error Message.
	BEGIN TRY
		IF (@limitUnitId IS NULL)
		BEGIN
            EXEC GetErrorMsg 401, @errNum out, @errMsg out
			RETURN
		END

		IF (dbo.IsNullOrEmpty(@descriptionEN) = 1)
		BEGIN
            EXEC GetErrorMsg 402, @errNum out, @errMsg out
			RETURN
		END

		-- Check INSERT OR UPDATE?.
		SELECT @iLimitCnt = COUNT(*)
		  FROM LimitUnit
		 WHERE LimitUnitId = @limitUnitId

		IF (@iLimitCnt = 0)
		BEGIN
			-- Detected PeriodUnit not exists so need to check duplicate description.
			-- Check is description is duplicated?.
			SELECT @iDescCnt = COUNT(*)
				FROM LimitUnit
				WHERE UPPER(RTRIM(LTRIM([Description]))) = UPPER(RTRIM(LTRIM(@descriptionEN))) COLLATE SQL_Latin1_General_CP1_CS_AS

			IF (@iDescCnt <> 0)
			BEGIN
                EXEC GetErrorMsg 403, @errNum out, @errMsg out
				RETURN
			END
		END

		IF (dbo.IsNullOrEmpty(@unitTextEN) = 1)
		BEGIN
            EXEC GetErrorMsg 404, @errNum out, @errMsg out
			RETURN
		END

		IF @iLimitCnt = 0
		BEGIN
			-- INSERT
			INSERT INTO LimitUnit
			(
				  [LimitUnitId]
				, [Description]
				, [UnitText]
			)
			VALUES
			(
				  @limitUnitId
				, RTRIM(LTRIM(@descriptionEN))
				, RTRIM(LTRIM(@unitTextEN))
			);
		END
		ELSE
		BEGIN
			-- UPDATE
			UPDATE LimitUnit
			   SET [Description] = RTRIM(LTRIM(@descriptionEN))
			     , [UnitText] = RTRIM(LTRIM(COALESCE(@unitTextEN, [UnitText])))
			 WHERE [LimitUnitId] = @limitUnitId;
		END

        EXEC GetErrorMsg 0, @errNum out, @errMsg out
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO


/*********** Script Update Date: 2018-04-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: SaveLimitUnitML.
-- Description:	Save LimitUnit ML.
-- [== History ==]
-- <2017-06-12> :
--	- Stored Procedure Created.
-- <2018-04-16> :
--	- change language id from nvarchar(10) to nvarchar(3).
--	- change error code(s).
--
-- [== Example ==]
--
--exec SaveLimitUnitML 4, N'EN', N'Number Of Connection', N'connection(s)'
--exec SaveLimitUnitML 4, N'TH', N'จำนวนการเชื่อมต่อ', N'จุด'
-- =============================================
CREATE PROCEDURE [dbo].[SaveLimitUnitML] (
  @limitUnitId as int = null
, @langId as nvarchar(3) = null
, @description as nvarchar(50) = null
, @unitText as nvarchar(20) = null
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
DECLARE @iLangCnt int = 0;
DECLARE @iLimitCnt int = 0;
DECLARE @iDescCnt int = 0;
	-- Error Code:
	--   0 : Success
	-- 401 : LimitUnit Id cannot be null.
	-- 405 : Language Id cannot be null or empty string.
	-- 406 : Language Id not found.
	-- 407 : Description (ML) cannot be null or empty string.
	-- 408 : Cannot add new Description (ML) because the Description (ML) in same Language Id is already exists.
	-- 409 : Cannot change Description (ML) because the Description (ML) in same Language Id is already exists.
	-- OTHER : SQL Error Number & Error Message.
	BEGIN TRY
		IF (@limitUnitId IS NULL)
		BEGIN
            -- LimitUnit Id cannot be null.
            EXEC GetErrorMsg 401, @errNum out, @errMsg out
			RETURN
		END

		IF (dbo.IsNullOrEmpty(@langId) = 1)
		BEGIN
            -- Language Id cannot be null or empty string.
            EXEC GetErrorMsg 405, @errNum out, @errMsg out
			RETURN
		END

		SELECT @iLangCnt = COUNT(*)
		  FROM Language
		 WHERE UPPER(LTRIM(RTRIM(LangId))) = UPPER(LTRIM(RTRIM(@langId)));
		IF (@iLangCnt = 0)
		BEGIN
            -- Language Id not found.
            EXEC GetErrorMsg 406, @errNum out, @errMsg out
			RETURN
		END

		IF (dbo.IsNullOrEmpty(@description) = 1)
		BEGIN
            -- Description (ML) cannot be null or empty string.
            EXEC GetErrorMsg 407, @errNum out, @errMsg out
			RETURN
		END

		-- Check INSERT OR UPDATE?.
		SELECT @iLimitCnt = COUNT(*)
		  FROM LimitUnitML
		 WHERE LimitUnitId = @limitUnitId
		   AND UPPER(LTRIM(RTRIM(LangId))) = UPPER(LTRIM(RTRIM(@langId)));

		IF (@iLimitCnt = 0)
		BEGIN
			-- Detected data not exists so need to check duplicate description in same language.
			-- Check is description is duplicated?.
			SELECT @iDescCnt = COUNT(*)
				FROM LimitUnitML
				WHERE UPPER(RTRIM(LTRIM([Description]))) = UPPER(RTRIM(LTRIM(@description)))
				  AND UPPER(LTRIM(RTRIM(LangId))) = UPPER(LTRIM(RTRIM(@langId)))

			IF (@iDescCnt <> 0)
			BEGIN
				-- Cannot add new Description (ML) because the Description (ML) in same Language Id is already exists.
                EXEC GetErrorMsg 408, @errNum out, @errMsg out
				RETURN
			END
		END
		ELSE
		BEGIN
			-- Detected data is exists so need to check duplicate description in same language.
			-- Check is description is duplicated?.
			SELECT @iDescCnt = COUNT(*)
				FROM LimitUnitML
				WHERE LimitUnitId <> @limitUnitId
				  AND UPPER(RTRIM(LTRIM([Description]))) = UPPER(RTRIM(LTRIM(@description)))
				  AND UPPER(LTRIM(RTRIM(LangId))) = UPPER(LTRIM(RTRIM(@langId)))

			IF (@iDescCnt <> 0)
			BEGIN
				-- Cannot change Description (ML) because the Description (ML) in same Language Id is already exists.
                EXEC GetErrorMsg 409, @errNum out, @errMsg out
				RETURN
			END
		END

		IF @iLimitCnt = 0
		BEGIN
			-- INSERT
			INSERT INTO LimitUnitML
			(
				  [LimitUnitId]
				, [LangId]
				, [Description]
				, [UnitText]
			)
			VALUES
			(
				  @limitUnitId
				, UPPER(RTRIM(LTRIM(@langId)))
				, RTRIM(LTRIM(@description))
				, RTRIM(LTRIM(@unitText))
			);
		END
		ELSE
		BEGIN
			-- UPDATE
			UPDATE LimitUnitML
			   SET [Description] = RTRIM(LTRIM(@description))
			     , [UnitText] = RTRIM(LTRIM(COALESCE(@unitText, [UnitText])))
			 WHERE [LimitUnitId] = @limitUnitId
			   AND UPPER(RTRIM(LTRIM([LangId]))) = UPPER(RTRIM(LTRIM(@langId)));
		END

        EXEC GetErrorMsg 0, @errNum out, @errMsg out
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO


/*********** Script Update Date: 2018-04-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: GetLimitUnits.
-- Description:	Get Limit Units.
-- [== History ==]
-- <2017-05-31> :
--	- Stored Procedure Created.
-- <2018-04-16> :
--	- change language id from nvarchar(10) to nvarchar(3).
--
-- [== Example ==]
--
--exec GetLimitUnits NULL, 1;  -- for only enabled languages.
--exec GetLimitUnits;          -- for get all.
--exec GetLimitUnits N'EN';    -- for get LimitUnit for EN language.
-- =============================================
CREATE PROCEDURE [dbo].[GetLimitUnits] 
(
  @langId nvarchar(3) = NULL
, @enabled bit = NULL
)
AS
BEGIN
	SELECT * 
	  FROM LimitUnitMLView
	 WHERE [ENABLED] = COALESCE(@enabled, [ENABLED])
	   AND UPPER(LTRIM(RTRIM(LangId))) = UPPER(LTRIM(RTRIM(COALESCE(@langId,LangId))))
	 ORDER BY SortOrder, LimitUnitId
END

GO


/*********** Script Update Date: 2018-04-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetMemberTypes
-- [== History ==]
-- <2017-05-31> :
--	- Stored Procedure Created.
-- <2018-04-16> :
--	- change language id from nvarchar(10) to nvarchar(3).
--
-- [== Example ==]
--
--exec GetMemberTypes NULL, 1;  -- for only enabled languages.
--exec GetMemberTypes;          -- for get all.
--exec GetMemberTypes N'EN';    -- for get MemberType for EN language.
--exec GetMemberTypes N'TH';    -- for get MemberType for TH language.
-- =============================================
CREATE PROCEDURE [dbo].[GetMemberTypes] 
(
  @langId nvarchar(3) = NULL
, @enabled bit = NULL
)
AS
BEGIN
	SELECT * 
	  FROM MemberTypeMLView
	 WHERE [ENABLED] = COALESCE(@enabled, [ENABLED])
	   AND UPPER(LTRIM(RTRIM(LangId))) = UPPER(LTRIM(RTRIM(COALESCE(@langId,LangId))))
	 ORDER BY SortOrder, MemberTypeId
END

GO


/*********** Script Update Date: 2018-04-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: SaveUserInfo.
-- Description:	Save User Information.
-- [== History ==]
-- <2016-11-02> :
--	- Stored Procedure Created.
-- <2017-06-07> :
--	- Fixed Logic to check duplicated Prefix - FirstName- LastName.
--	- Fixed Logic to check duplicated UserName.
-- <2017-06-08> :
--  - The @errMsg set as nvarchar(MAX).
-- <2018-04-16> :
--	- change error code(s).
--
-- [== Example ==]
--
--exec SaveUserInfo N'The', N'EDL', N'Administrator', N'raterweb2-admin@edl.co.th', N'1234', 100
--exec SaveUserInfo N'Mr.', N'Chumpon', N'Asaneerat', N'chumpon@edl.co.th', N'1234', 100
-- =============================================
CREATE PROCEDURE [dbo].[SaveUserInfo] (
  @prefix as nvarchar(10)
, @firstName as nvarchar(40)
, @lastName as nvarchar(50)
, @userName as nvarchar(50)
, @passWord as nvarchar(20)
, @memberType as int = 100
, @userId as nvarchar(30) = null out
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
DECLARE @iUsrCnt int = 0;
	-- Error Code:
	--   0 : Success
	-- 501 : FirstName (default) cannot be null or empty string.
	-- 502 : UserName cannot be null or empty string.
	-- 503 : Password cannot be null or empty string.
	-- 504 : User Full Name (default) already exists.
	-- 505 : UserName already exists.
	-- OTHER : SQL Error Number & Error Message.
	BEGIN TRY
		IF (dbo.IsNullOrEmpty(@firstName) = 1)
		BEGIN
            -- FirstName (default) cannot be null or empty string.
            EXEC GetErrorMsg 501, @errNum out, @errMsg out
			RETURN
		END

		IF (dbo.IsNullOrEmpty(@userName) = 1)
		BEGIN
			-- UserName cannot be null or empty string.
            EXEC GetErrorMsg 502, @errNum out, @errMsg out
			RETURN
		END

		IF (dbo.IsNullOrEmpty(@passWord) = 1)
		BEGIN
			-- Password cannot be null or empty string.
            EXEC GetErrorMsg 503, @errNum out, @errMsg out
			RETURN
		END

		/* Check Prefix, FirstName, LastName exists */
		IF (@userId IS NOT NULL)
		BEGIN
			SELECT @iUsrCnt = COUNT(*)
				FROM UserInfo
				WHERE LOWER(UserId) <> LOWER(RTRIM(LTRIM(@userId)))
				  AND LOWER(RTRIM(LTRIM(Prefix))) = LOWER(RTRIM(LTRIM(@prefix)))
				  AND LOWER(RTRIM(LTRIM(FirstName))) = LOWER(RTRIM(LTRIM(@firstName)))
				  AND LOWER(RTRIM(LTRIM(LastName))) = LOWER(RTRIM(LTRIM(@lastName)))
		END
		ELSE
		BEGIN
			SELECT @iUsrCnt = COUNT(*)
				FROM UserInfo
				WHERE LOWER(RTRIM(LTRIM(Prefix))) = LOWER(RTRIM(LTRIM(@prefix)))
				  AND LOWER(RTRIM(LTRIM(FirstName))) = LOWER(RTRIM(LTRIM(@firstName)))
				  AND LOWER(RTRIM(LTRIM(LastName))) = LOWER(RTRIM(LTRIM(@lastName)))
		END

		IF @iUsrCnt <> 0
		BEGIN
            -- User Full Name (default) already exists.
			EXEC GetErrorMsg 504, @errNum out, @errMsg out
			RETURN;
		END

		SET @iUsrCnt = 0; -- Reset Counter.

		/* Check UserName exists */
		IF (@userId IS NOT NULL)
		BEGIN
			SELECT @iUsrCnt = COUNT(*)
				FROM UserInfo
				WHERE LOWER(UserId) <> LOWER(RTRIM(LTRIM(@userId)))
				  AND LOWER(RTRIM(LTRIM(UserName))) = LOWER(RTRIM(LTRIM(@userName)))
		END
		ELSE
		BEGIN
			SELECT @iUsrCnt = COUNT(*)
				FROM UserInfo
				WHERE LOWER(RTRIM(LTRIM(UserName))) = LOWER(RTRIM(LTRIM(@userName)))
		END

		IF @iUsrCnt <> 0
		BEGIN
			-- UserName already exists.
            EXEC GetErrorMsg 505, @errNum out, @errMsg out
			RETURN;
		END

		SET @iUsrCnt = 0; -- Reset Counter.

		IF dbo.IsNullOrEmpty(@userId) = 1
		BEGIN
			EXEC NextMasterPK N'UserInfo'
							, @userId out
							, @errNum out
							, @errMsg out;
			IF @errNum <> 0
			BEGIN
				RETURN;
			END	
		END
		ELSE
		BEGIN
			SELECT @iUsrCnt = COUNT(*)
			  FROM UserInfo
			 WHERE LOWER(UserId) = LOWER(RTRIM(LTRIM(@userId)))
		END

		IF @iUsrCnt = 0
		BEGIN
			INSERT INTO USERINFO
			(
				  UserId
				, MemberType
				, Prefix
				, FirstName
				, LastName
				, UserName
				, [Password]
				, ObjectStatus
			)
			VALUES
			(
				  RTRIM(LTRIM(@userId))
				, @memberType
				, RTRIM(LTRIM(@prefix))
				, RTRIM(LTRIM(@firstName))
				, RTRIM(LTRIM(@lastName))
				, RTRIM(LTRIM(@userName))
				, RTRIM(LTRIM(@passWord))
				, 1
			);
		END
		ELSE
		BEGIN
			UPDATE UserInfo
			   SET Prefix = RTRIM(LTRIM(@prefix))
			     , FirstName = RTRIM(LTRIM(@firstName))
				 , LastName = RTRIM(LTRIM(@lastName))
				 , UserName = RTRIM(LTRIM(@userName))
				 , [Password] = RTRIM(LTRIM(@passWord))
				 , MemberType = @memberType
			 WHERE LOWER(UserId) = LOWER(RTRIM(LTRIM(@userId)))
		END

        EXEC GetErrorMsg 0, @errNum out, @errMsg out
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO


/*********** Script Update Date: 2018-04-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	SaveUserInfo.
-- [== History ==]
-- <2016-11-02> :
--	- Stored Procedure Created.
-- <2017-06-08> :
--  - The @errMsg set as nvarchar(MAX).
-- <2018-04-16> :
--	- change error code(s).
--	- change language id from nvarchar(10) to nvarchar(3).
--
-- [== Example ==]
--
--exec SaveUserInfoML N'EDL-U20170607001', N'TH', N'The', N'EDL', N'Administrator'
-- =============================================
CREATE PROCEDURE [dbo].[SaveUserInfoML] (
  @userId as nvarchar(30)
, @langId as nvarchar(3)
, @prefix as nvarchar(10)
, @firstName as nvarchar(40)
, @lastName as nvarchar(50)
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
DECLARE @iLangCnt int = 0;
DECLARE @iUsrCnt int = 0;
	-- Error Code:
	--   0 : Success
	-- 506 : Language Id cannot be null or empty string.
	-- 507 : The Language Id not exist.
	-- 508 : User Id cannot be null or empty string.
	-- 509 : FirstName (ML) cannot be null or empty string.
	-- 510 : No User match UserId.
	-- 511 : User Full Name (ML) already exists.
	-- OTHER : SQL Error Number & Error Message.
	BEGIN TRY
		/* Check if lang id is not null. */
		IF (dbo.IsNullOrEmpty(@langId) = 1)
		BEGIN
			-- Language Id cannot be null or empty string.
            EXEC GetErrorMsg 506, @errNum out, @errMsg out
			RETURN
		END
		/* Check if language exists. */
		SELECT @iLangCnt = COUNT(LangId)
		  FROM Language
		 WHERE UPPER(RTRIM(LTRIM(LangId))) = UPPER(RTRIM(LTRIM(@langId)));
		IF (@iLangCnt IS NULL OR @iLangCnt = 0) 
		BEGIN
			-- The Language Id not exist.
            EXEC GetErrorMsg 507, @errNum out, @errMsg out
			RETURN
		END

		/* Check if user id is not null. */
		IF (dbo.IsNullOrEmpty(@userId) = 1)
		BEGIN
			-- User Id cannot be null or empty string.
            EXEC GetErrorMsg 508, @errNum out, @errMsg out
			RETURN
		END

		/* Check has first name (required by table constrain). */
		IF (dbo.IsNullOrEmpty(@firstName) = 1)
		BEGIN
			-- FirstName (ML) cannot be null or empty string.
            EXEC GetErrorMsg 509, @errNum out, @errMsg out
			RETURN
		END
		/* Check UserId is in UserInfo table */ 
		SELECT @iUsrCnt = COUNT(*)
			FROM UserInfo
		   WHERE UPPER(RTRIM(LTRIM(UserId))) = UPPER(RTRIM(LTRIM(@userId)))
		IF @iUsrCnt = 0
		BEGIN
			-- No User match UserId.
            EXEC GetErrorMsg 510, @errNum out, @errMsg out
			RETURN
		END

		/* Check Prefix, FirstName, LastName exists */
		SELECT @iUsrCnt = COUNT(*)
			FROM UserInfoML
			WHERE UPPER(LangId) = UPPER(RTRIM(LTRIM(@langId)))
			  AND LOWER(UserId) <> LOWER(RTRIM(LTRIM(@userId)))
			  AND LOWER(RTRIM(LTRIM(Prefix))) = LOWER(RTRIM(LTRIM(@prefix)))
			  AND LOWER(RTRIM(LTRIM(FirstName))) = LOWER(RTRIM(LTRIM(@firstName)))
			  AND LOWER(RTRIM(LTRIM(LastName))) = LOWER(RTRIM(LTRIM(@lastName)))

		IF @iUsrCnt <> 0
		BEGIN
			-- User Full Name (ML) already exists.
            EXEC GetErrorMsg 511, @errNum out, @errMsg out
			RETURN;
		END

		SET @iUsrCnt = 0; -- Reset Counter.

		/* check is need to insert or update? */
		SELECT @iUsrCnt = COUNT(*)
			FROM UserInfoML
		   WHERE UPPER(RTRIM(LTRIM(UserId))) = UPPER(RTRIM(LTRIM(@userId)))
			 AND UPPER(RTRIM(LTRIM(LangId))) = UPPER(RTRIM(LTRIM(@langId)));

		IF @iUsrCnt = 0
		BEGIN
			INSERT INTO UserInfoML
			(
				  UserId
				, LangId
				, Prefix
				, FirstName
				, LastName
			)
			VALUES
			(
				  UPPER(RTRIM(LTRIM(@userId)))
				, UPPER(RTRIM(LTRIM(@langId)))
				, RTRIM(LTRIM(@prefix))
				, RTRIM(LTRIM(@firstName))
				, RTRIM(LTRIM(@lastName))
			);
		END
		ELSE
		BEGIN
			UPDATE UserInfoML
			   SET Prefix = RTRIM(LTRIM(@prefix))
			     , FirstName = RTRIM(LTRIM(@firstName))
				 , LastName = RTRIM(LTRIM(@lastName))
		     WHERE UPPER(RTRIM(LTRIM(UserId))) = UPPER(RTRIM(LTRIM(@userId)))
			   AND UPPER(RTRIM(LTRIM(LangId))) = UPPER(RTRIM(LTRIM(@langId)));
		END

        EXEC GetErrorMsg 0, @errNum out, @errMsg out
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO


/*********** Script Update Date: 2018-04-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetUserInfos
-- [== History ==]
-- <2017-05-31> :
--	- Stored Procedure Created.
-- <2018-04-16> :
--	- change language id from nvarchar(10) to nvarchar(3).
--
-- [== Example ==]
--
--exec GetUserInfos NULL, NULL, 1;  -- for only enabled languages.
--exec GetUserInfos;                -- for get all.
--exec GetUserInfos N'EN', NULL;    -- for get UserInfo for EN language all member type.
--exec GetUserInfos N'TH', NULL;    -- for get UserInfo for TH language all member type.
--exec GetUserInfos N'EN', 100;     -- for get UserInfo for EN language member type = 100.
--exec GetUserInfos N'TH', 180;     -- for get UserInfo for TH language member type = 180.
-- =============================================
CREATE PROCEDURE [dbo].[GetUserInfos] 
(
  @langId nvarchar(3) = NULL
, @memberType int = NULL
, @enabled bit = NULL
)
AS
BEGIN
	SELECT * 
	  FROM UserInfoMLView
	 WHERE [ENABLED] = COALESCE(@enabled, [ENABLED])
	   AND [MemberType] = COALESCE(@memberType, [MemberType])
	   AND UPPER(LTRIM(RTRIM(LangId))) = UPPER(LTRIM(RTRIM(COALESCE(@langId,LangId))))
	 ORDER BY SortOrder, UserId
END

GO


/*********** Script Update Date: 2018-04-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: SaveLicenseType.
-- Description:	Save License Type.
-- [== History ==]
-- <2017-05-31> :
--	- Stored Procedure Created.
-- <2017-06-08> :
--  - The @errMsg set as nvarchar(MAX).
-- <2018-04-16> :
--	- change error code(s).
--
-- [== Example ==]
--
--exec SaveLicenseType N'3 Months', N'Save 40%', 2, 3, 50000, N'$', N'USD'
-- =============================================
CREATE PROCEDURE [dbo].[SaveLicenseType] (
  @description as nvarchar(100) = null
, @adText as nvarchar(MAX) = null
, @periodUnitId as int = null
, @numberOfUnit as int = null
, @price as decimal(18, 2) = null
, @currSymbol as nvarchar(5)
, @currText as nvarchar(20)
, @licenseTypeId as int = null out
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
DECLARE @vlicenseTypeId int;
DECLARE @iCnt int;
	-- Error Code:
	--   0 : Success
	-- 601 : Description (default) cannot be null or empty string.
	-- 602 : Advertise Text (default) cannot be null or empty string.
	-- 603 : PeriodUnitId cannot be null.
	-- 604 : PeriodUnitId not found.
	-- 605 : Number of Period cannot be null.
	-- 606 : Price cannot be null.
	-- 607 : Cannot add new item description because the description (default) is duplicated.
	-- 608 : Cannot change item description because the description (default) is duplicated.
	-- 609 : Cannot add new item because the period and number of period is duplicated.
    -- 610 : Cannot change item because the period and number of period is duplicated.
	-- OTHER : SQL Error Number & Error Message.
	BEGIN TRY
		IF (dbo.IsNullOrEmpty(@description) = 1)
		BEGIN
			-- Description (default) cannot be null or empty string.
            EXEC GetErrorMsg 601, @errNum out, @errMsg out
			RETURN
		END

		IF (dbo.IsNullOrEmpty(@adText) = 1)
		BEGIN
			-- Advertise Text (default) cannot be null or empty string.
            EXEC GetErrorMsg 602, @errNum out, @errMsg out
			RETURN
		END

		IF (@periodUnitId IS NULL)
		BEGIN
			-- PeriodUnitId cannot be null.
            EXEC GetErrorMsg 603, @errNum out, @errMsg out
			RETURN
		END

		SELECT @iCnt = COUNT(*)
		  FROM PeriodUnit
		 WHERE PeriodUnitId = @periodUnitId;
		IF (@iCnt = 0)
		BEGIN
			-- PeriodUnitId not found.
            EXEC GetErrorMsg 604, @errNum out, @errMsg out
			RETURN
		END

		IF (@numberOfUnit IS NULL)
		BEGIN
			-- Number of Period cannot be null.
            EXEC GetErrorMsg 605, @errNum out, @errMsg out
			RETURN
		END

		IF (@price IS NULL)
		BEGIN
			-- Price cannot be null.
            EXEC GetErrorMsg 606, @errNum out, @errMsg out
			RETURN
		END

		IF (@licenseTypeId IS NULL)
		BEGIN
			-- Detected Data not exists so need to check duplicate description.
			-- Check is description is duplicated?.
			SELECT @iCnt = COUNT(*)
			  FROM [dbo].[LicenseType]
			 WHERE UPPER(RTRIM(LTRIM([Description]))) = UPPER(RTRIM(LTRIM(@description))) COLLATE SQL_Latin1_General_CP1_CS_AS

			IF (@iCnt <> 0)
			BEGIN
				-- Cannot add new item description because the description (default) is duplicated.
                EXEC GetErrorMsg 607, @errNum out, @errMsg out
				RETURN
			END
			/*
			-- Check is PeriodUnitId and NumberOfUnit is duplicated?.
			SELECT @iCnt = COUNT(*)
			  FROM [dbo].[LicenseType]
			 WHERE PeriodUnitId = @periodUnitId
			   AND NumberOfUnit = @numberOfUnit;

			IF (@iCnt >= 1)
			BEGIN
				-- Cannot add new item because the period and number of period is duplicated.
                EXEC GetErrorMsg 609, @errNum out, @errMsg out
				RETURN
			END
			*/
		END
		ELSE
		BEGIN
			-- Detected Data is exists so need to check duplicate description.
			-- Check is description is duplicated?.
			SELECT @iCnt = COUNT(*)
			  FROM [dbo].[LicenseType]
			 WHERE UPPER(RTRIM(LTRIM([Description]))) = UPPER(RTRIM(LTRIM(@description))) COLLATE SQL_Latin1_General_CP1_CS_AS
			   AND LicenseTypeId <> @licenseTypeId;

			IF (@iCnt <> 0)
			BEGIN
				-- Cannot change item description because the description (default) is duplicated.
                EXEC GetErrorMsg 608, @errNum out, @errMsg out
				RETURN
			END
			/*
			-- Check is PeriodUnitId and NumberOfUnit is duplicated?.
			SELECT @iCnt = COUNT(*)
			  FROM [dbo].[LicenseType]
			 WHERE PeriodUnitId = @periodUnitId
			   AND NumberOfUnit = @numberOfUnit
			   AND LicenseTypeId <> @licenseTypeId;

			IF (@iCnt >= 1)
			BEGIN
				-- Cannot change item because the period and number of period is duplicated.
                EXEC GetErrorMsg 610, @errNum out, @errMsg out
				RETURN
			END
			*/
		END

		IF (@licenseTypeId IS NULL)
		BEGIN
			SELECT @vlicenseTypeId = (MAX([LicenseTypeId]) + 1)
			  FROM [dbo].[LicenseType];

			INSERT INTO [dbo].[LicenseType]
			(
				 LicenseTypeId
			   , Description
			   , AdText
			   , PeriodUnitId
			   , NumberOfUnit
			   , Price
			   , CurrencySymbol
			   , CurrencyText
			)
			VALUES
			(
			     @vlicenseTypeId
			   , LTRIM(RTRIM(@description))
			   , LTRIM(RTRIM(@adText))
			   , @periodUnitId
			   , @numberOfUnit
			   , @price
			   , COALESCE(@currSymbol, '$')
			   , COALESCE(@currText, 'USD')
			);
		END
		ELSE
		BEGIN
			SET @vlicenseTypeId = @licenseTypeId;

			UPDATE [dbo].[LicenseType]
			   SET [Description] = LTRIM(RTRIM(@description))
			     , AdText = LTRIM(RTRIM(COALESCE(@adText, AdText)))
				 , PeriodUnitId = COALESCE(@periodUnitId, NumberOfUnit)
				 , NumberOfUnit = COALESCE(@numberOfUnit, NumberOfUnit)
				 , Price = COALESCE(@price, Price)
				 , CurrencySymbol = COALESCE(@currSymbol, CurrencySymbol)
				 , CurrencyText = COALESCE(@currText, CurrencyText)
			 WHERE LicenseTypeId = @vlicenseTypeId;
		END

        EXEC GetErrorMsg 0, @errNum out, @errMsg out
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO


/*********** Script Update Date: 2018-04-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: SaveLicenseTypeML.
-- Description:	Save License Type ML.
-- [== History ==]
-- <2017-05-31> :
--	- Stored Procedure Created.
-- <2017-06-08> :
--  - The @errMsg set as nvarchar(MAX).
-- <2018-04-16> :
--	- change language id from nvarchar(10) to nvarchar(3).
--	- change error code(s).
--
-- [== Example ==]
--
--exec SaveLicenseTypeML 5, N'TH', N'ทดลองใช้งาน', N'ทดลองใช้งานราคาประหยัด', 599, N'฿', N'บาท'
-- =============================================
CREATE PROCEDURE [dbo].[SaveLicenseTypeML] (
  @licenseTypeId as int = null
, @langId as nvarchar(3) = null
, @description as nvarchar(100) = null
, @adText as nvarchar(MAX) = null
, @price as decimal(18, 2) = null
, @currSymbol as nvarchar(5) = null
, @currText as nvarchar(20) = null
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
DECLARE @iCnt int;
	-- Error Code:
	--   0 : Success
	-- 611 : LicenseTypeId cannot be null.
	-- 612 : Language Id cannot be null or empty string.
	-- 613 : Language Id not found.
	-- 614 : Description (ML) cannot be null or empty string.
	-- 615 : Advertise Text (ML) cannot be null or empty string.
	-- 616 : Price (ML) cannot be null.
	-- 617 : Description (ML) is duplicated.
	-- OTHER : SQL Error Number & Error Message.
	BEGIN TRY
		IF (@licenseTypeId IS NULL)
		BEGIN
			-- LicenseTypeId cannot be null.
            EXEC GetErrorMsg 611, @errNum out, @errMsg out
			RETURN
		END

		IF (dbo.IsNullOrEmpty(@langId) = 1)
		BEGIN
			-- Language Id cannot be null or empty string.
            EXEC GetErrorMsg 612, @errNum out, @errMsg out
			RETURN
		END

		SELECT @iCnt = COUNT(*)
		  FROM Language
		 WHERE UPPER(LTRIM(RTRIM(LangId))) = UPPER(LTRIM(RTRIM(@langId)));

		IF (@iCnt = 0)
		BEGIN
			-- Language Id not found.
            EXEC GetErrorMsg 613, @errNum out, @errMsg out
			RETURN
		END

		IF (dbo.IsNullOrEmpty(@description) = 1)
		BEGIN
			-- Description (ML) cannot be null or empty string.
            EXEC GetErrorMsg 614, @errNum out, @errMsg out
			RETURN
		END

		IF (dbo.IsNullOrEmpty(@adText) = 1)
		BEGIN
			-- Advertise Text (ML) cannot be null or empty string.
            EXEC GetErrorMsg 615, @errNum out, @errMsg out
			RETURN
		END

		IF (@price IS NULL)
		BEGIN
			-- Price (ML) cannot be null.
            EXEC GetErrorMsg 616, @errNum out, @errMsg out
			RETURN
		END

		-- Check is description is duplicated?.
		SELECT @iCnt = COUNT(*)
			FROM [dbo].[LicenseTypeML]
			WHERE UPPER(RTRIM(LTRIM([Description]))) = UPPER(RTRIM(LTRIM(@description)))
			  AND UPPER(RTRIM(LTRIM([LangId]))) = UPPER(RTRIM(LTRIM(@langId)))
			  AND LicenseTypeId <> @licenseTypeId;

		IF (@iCnt <> 0)
		BEGIN
			-- Description (ML) is duplicated.
            EXEC GetErrorMsg 617, @errNum out, @errMsg out
			RETURN
		END

		SELECT @iCnt = COUNT(*)
		  FROM LicenseTypeML
		 WHERE UPPER(RTRIM(LTRIM([LangId]))) = UPPER(RTRIM(LTRIM(@langId)))
		   AND [LicenseTypeId] = @licenseTypeId;

		IF (@iCnt = 0)
		BEGIN
			INSERT INTO [dbo].[LicenseTypeML]
			(
				 LicenseTypeId
			   , LangId
			   , Description
			   , AdText
			   , Price
			   , CurrencySymbol
			   , CurrencyText
			)
			VALUES
			(
			     @licenseTypeId
			   , UPPER(RTRIM(LTRIM(@langId)))
			   , LTRIM(RTRIM(@description))
			   , LTRIM(RTRIM(@adText))
			   , @price
			   , @currSymbol
			   , @currText
			);
		END
		ELSE
		BEGIN
			UPDATE [dbo].LicenseTypeML
			   SET [Description] = LTRIM(RTRIM(@description))
			     , AdText = LTRIM(RTRIM(COALESCE(@adText, AdText)))
				 , Price = COALESCE(@price, Price)
				 , CurrencySymbol = COALESCE(@currSymbol, CurrencySymbol)
				 , CurrencyText = COALESCE(@currText, CurrencyText)
			 WHERE LicenseTypeId = @licenseTypeId
			   AND UPPER(RTRIM(LTRIM([LangId]))) = UPPER(RTRIM(LTRIM(@langId)));
		END

		EXEC GetErrorMsg 0, @errNum out, @errMsg out
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO


/*********** Script Update Date: 2018-04-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetLicenses
-- [== History ==]
-- <2017-05-31> :
--	- Stored Procedure Created.
-- <2018-04-16> :
--	- change language id from nvarchar(10) to nvarchar(3).
--
-- [== Example ==]
--
--exec GetLicenseTypes N'EN'; -- for only EN language.
--exec GetLicenseTypes;       -- for get all.
-- =============================================
CREATE PROCEDURE [dbo].[GetLicenseTypes] 
(
  @langId nvarchar(3) = null
)
AS
BEGIN
	SELECT * 
	  FROM LicenseTypeMLView
	 WHERE langId = COALESCE(@langId, langId)
	   AND Enabled = 1
	 Order By SortOrder, LangId, LicenseTypeId;
END

GO


/*********** Script Update Date: 2018-04-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: SaveLicenseFeature.
-- Description:	Save License Feature.
-- [== History ==]
-- <2017-05-31> :
--	- Stored Procedure Created.
-- <2017-06-08> :
--  - The @errMsg set as nvarchar(MAX).
-- <2018-04-16> :
--	- change error code(s).
--
-- [== Example ==]
--declare seq int;
--exec SaveLicenseFeature 5, 1, 2, @seq out -- Save Feature Limit device with 2 device(s).
--select * from seq as Seq;
-- =============================================
CREATE PROCEDURE [dbo].[SaveLicenseFeature] (
  @licenseTypeId as int = null
, @limitUnitId as int = null
, @noOfLimit as int = null
, @seq as int = null out
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
DECLARE @iCnt int;
DECLARE @iSeq int;
	-- Error Code:
	--   0 : Success
	-- 701 : LicenseType Id cannot be null.
	-- 702 : LicenseType Id not found.
	-- 703 : LimitUnit Id cannot be null.
	-- 704 : LimitUnit Id not found.
	-- 705 : LimitUnit Id already exists.
	-- 706 : No Of Limit cannot be null.
	-- 707 : No Of Limit should be zero or more.
	-- 708 : Invalid Seq Number.
	-- OTHER : SQL Error Number & Error Message.
	BEGIN TRY
		IF (@licenseTypeId IS NULL)
		BEGIN
			-- LicenseType Id cannot be null.
            EXEC GetErrorMsg 701, @errNum out, @errMsg out
			RETURN
		END

		SELECT @iCnt = COUNT(*)
		  FROM LicenseType
		 WHERE LicenseTypeId = @licenseTypeId;
		IF (@iCnt = 0)
		BEGIN
			--LicenseType Id not found.
            EXEC GetErrorMsg 702, @errNum out, @errMsg out
			RETURN
		END

		IF (@limitUnitId IS NULL)
		BEGIN
			-- LimitUnit Id cannot be null.
            EXEC GetErrorMsg 703, @errNum out, @errMsg out
			RETURN
		END

		SELECT @iCnt = COUNT(*)
		  FROM LimitUnit
		 WHERE LimitUnitId = @limitUnitId;
		IF (@iCnt = 0)
		BEGIN
			-- LimitUnit Id not found.
            EXEC GetErrorMsg 704, @errNum out, @errMsg out
			RETURN
		END

		IF (@seq IS NULL)
		BEGIN
			SELECT @iCnt = COUNT(*)
			  FROM LicenseFeature
			 WHERE LicenseTypeId = @licenseTypeId
			   AND LimitUnitId = @limitUnitId;
		END
		ELSE
		BEGIN
			SELECT @iCnt = COUNT(*)
			  FROM LicenseFeature
			 WHERE LicenseTypeId = @licenseTypeId
			   AND LimitUnitId = @limitUnitId
			   AND Seq <> @seq;
		END

		IF (@iCnt <> 0)
		BEGIN
			-- LimitUnit Id already exists.
            EXEC GetErrorMsg 705, @errNum out, @errMsg out
			RETURN
		END

		IF (@noOfLimit IS NULL)
		BEGIN
			-- No Of Limit cannot be null.
            EXEC GetErrorMsg 706, @errNum out, @errMsg out
			RETURN
		END

		IF (@noOfLimit < 0)
		BEGIN
			-- No Of Limit should be zero or more.
            EXEC GetErrorMsg 707, @errNum out, @errMsg out
			RETURN
		END

		IF (@seq IS NULL)
		BEGIN
			SELECT @iSeq = MAX(Seq)
			  FROM LicenseFeature
			 WHERE LicenseTypeId = @licenseTypeId;
			IF (@iSeq IS NULL)
			BEGIN
				SET @iSeq = 1;
			END
			ELSE
			BEGIN
				SET @iSeq = @iSeq + 1;
			END
		END
		ELSE
		BEGIN
			SELECT @iCnt = COUNT(*)
			  FROM LicenseFeature
			 WHERE LicenseTypeId = @licenseTypeId
			   AND Seq = @seq;
			
			IF (@iCnt = 0)
			BEGIN
				-- Invalid Seq Number.
                EXEC GetErrorMsg 708, @errNum out, @errMsg out
				RETURN
			END

			SET @iSeq = @seq;
		END

		IF (@seq IS NULL)
		BEGIN
			INSERT INTO [dbo].[LicenseFeature]
			(
				 LicenseTypeId
			   , Seq
			   , LimitUnitId
			   , NoOfLimit
			)
			VALUES
			(
			     @licenseTypeId
			   , @iSeq
			   , @limitUnitId
			   , @noOfLimit
			);

			-- SET OUTPUT SEQ.
			SET @seq = @iSeq;
		END
		ELSE
		BEGIN
			UPDATE [dbo].[LicenseFeature]
			   SET LimitUnitId = COALESCE(@limitUnitId, LimitUnitId)
				 , NoOfLimit = COALESCE(@noOfLimit, NoOfLimit)
			 WHERE LicenseTypeId = @licenseTypeId
			   AND Seq = @iSeq;
		END

        EXEC GetErrorMsg 0, @errNum out, @errMsg out
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO


/*********** Script Update Date: 2018-04-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: GetLicenseFeatures.
-- Description:	Get License Features.
-- [== History ==]
-- <2017-05-31> :
--	- Stored Procedure Created.
-- <2018-04-16> :
--	- change language id from nvarchar(10) to nvarchar(3).
--
-- [== Example ==]
--
--exec GetLicenseFeatures N'EN';    -- for only EN language.
--exec GetLicenseFeatures;          -- for get all.
--exec GetLicenseFeatures N'EN', 1; -- for all features for LicenseTypeId = 1 in EN language.
--exec GetLicenseFeatures N'TH', 0; -- for all features for LicenseTypeId = 0 in TH language.
-- =============================================
CREATE PROCEDURE [dbo].[GetLicenseFeatures] 
(
  @langId nvarchar(3) = null
, @licenseTypeId int = null
)
AS
BEGIN
	SELECT * 
	  FROM LicenseFeatureMLView
	 WHERE langId = COALESCE(@langId, langId)
	   AND Enabled = 1
	   AND LicenseTypeId = COALESCE(@licenseTypeId, LicenseTypeId)
	 Order By SortOrder, LangId, LicenseTypeId;
END

GO


/*********** Script Update Date: 2018-04-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: SetCustomerPK.
-- Description:	Set Customer Primary Key.
-- [== History ==]
-- <2017-01-09> :
--	- Stored Procedure Created.
-- <2018-04-16> :
--	- change error code(s).
--
-- [== Example ==]
--
--exec SetCustomerPK N'EDL-C2017010001', N'Branch', 4, 'B', 4
-- =============================================
CREATE PROCEDURE [dbo].[SetCustomerPK] (
  @customerId nvarchar(30)
, @tableName nvarchar(50)
, @seedResetMode int = 1
, @prefix nvarchar(10)
, @seedDigits tinyint
, @errNum int = 0 out
, @errMsg nvarchar(MAX) = N'' out
)
AS
BEGIN
DECLARE @iTblCnt tinyint;
	-- Error Code:
	--   0 : Success
	-- 801 : CustomerId is null or empty string.
	-- 802 : Table Name is null or empty string.
	-- 803 : Seed Reset Mode should be number 1-4.
	-- 804 : Seed Digits should be number 1-9.
	-- OTHER : SQL Error Number & Error Message.
	BEGIN TRY
		IF @customerId is null OR RTRIM(LTRIM(@customerId)) = N''
		BEGIN
			-- CustomerId is null or empty string.
            EXEC GetErrorMsg 801, @errNum out, @errMsg out
			RETURN;
		END
		
		IF @tableName is null OR RTRIM(LTRIM(@tableName)) = N''
		BEGIN
			-- Table Name is null or empty string.
            EXEC GetErrorMsg 802, @errNum out, @errMsg out
			RETURN;
		END
		
		IF @seedResetMode is null OR @seedResetMode <= 0 OR @seedResetMode > 4
		BEGIN
			-- Seed Reset Mode should be number 1-4.
            EXEC GetErrorMsg 803, @errNum out, @errMsg out
			RETURN;
		END
		
		IF @seedDigits is null OR @seedDigits <= 0 OR @seedDigits > 9
		BEGIN
			-- Seed Digits should be number 1-9
            EXEC GetErrorMsg 804, @errNum out, @errMsg out
			RETURN;
		END

		SELECT @iTblCnt = COUNT(*)
		  FROM CustomerPK
		 WHERE LOWER(CustomerId) = LOWER(RTRIM(LTRIM(@customerId)))
		   AND LOWER([TableName]) = LOWER(RTRIM(LTRIM(@tableName)))
		IF @iTblCnt IS NULL OR @iTblCnt = 0
		BEGIN
			INSERT INTO CustomerPK(
					CustomerId
			      , [TableName]
				  , SeedResetMode
				  , LastSeed
				  , [Prefix]
				  , SeedDigits
				  , LastUpdated
				 )
			     VALUES (
				    RTRIM(LTRIM(@customerId))
				  , RTRIM(LTRIM(@tableName))
				  , @seedResetMode
				  , 0
				  , COALESCE(@prefix, N'')
				  , @seedDigits
				  , GETDATE()
				 );
		END
		ELSE
		BEGIN
			UPDATE CustomerPK
			   SET [TableName] = RTRIM(LTRIM(@tableName))
			     , SeedResetMode = @seedResetMode
				 , LastSeed = 0
				 , [Prefix] = COALESCE(@prefix, N'')
				 , SeedDigits = @seedDigits
				 , LastUpdated = GETDATE()
			 WHERE LOWER(CustomerId) = LOWER(RTRIM(LTRIM(@customerId)))
			   AND LOWER([TableName]) = LOWER(RTRIM(LTRIM(@tableName)));
		END

        EXEC GetErrorMsg 0, @errNum out, @errMsg out
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO


/*********** Script Update Date: 2018-04-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: NextCustomerPK.
-- Description:	Gets Next Customer Primary Key.
-- [== History ==]
-- <2017-01-09> :
--	- Stored Procedure Created.
-- <2018-04-16> :
--	- change error code(s).
--   
-- [== Example ==]
--
-- <Simple>
--exec NextCustomerPK N'EDL-C2017010001', N'Branch';
--
-- <Complex>
--declare @seedNo as nvarchar(30);
--declare @errNum as int;
--declare @errMsg as nvarchar(max);
--exec NextCustomerPK N'EDL-C2017010001', N'Branch'
--				, @seedNo out
--				, @errNum out
--				, @errMsg out;
--select @seedNo as seedcode
--     , @errNum as ErrNumber
--     , @errMsg as ErrMessage;
--select * from CustomerPK;
-- =============================================
CREATE PROCEDURE [dbo].[NextCustomerPK] 
(
  @customerId as nvarchar(30)
, @tableName as nvarchar(50)
, @seedcode nvarchar(max) = N'' out  -- prefix(max:10) + date(max:10) + seedi(max:10) = 30
, @errNum int = 0 out
, @errMsg nvarchar(MAX) = N'' out
)
AS
BEGIN
DECLARE @lastSeedId int;
DECLARE @resetMode tinyint;
DECLARE @prefix nvarchar(10);
DECLARE @seedDigits tinyint;
DECLARE @lastDate datetime;
DECLARE @now datetime;
DECLARE @isSameDate bit;
DECLARE @iTblCnt tinyint;
	-- Error Code:
	--   0 : Success
	-- 801 : CustomerId is null or empty string.
	-- 802 : Table Name is null or empty string.
	-- 805 : Table name is not exists in CustomerPK table.
	-- 806 : Not supports reset mode.
	-- 807 : Cannot generate seed code for table:
	-- OTHER : SQL Error Number & Error Message.
	BEGIN TRY
		IF @customerId is null OR RTRIM(LTRIM(@customerId)) = N''
		BEGIN
			-- CustomerID cannot be null or empty string.
            EXEC GetErrorMsg 801, @errNum out, @errMsg out
			RETURN;
		END

		IF @tableName is null OR RTRIM(LTRIM(@tableName)) = N''
		BEGIN
			-- Table name cannot be null or empty string.
            EXEC GetErrorMsg 802, @errNum out, @errMsg out
			RETURN;
		END

		SELECT @iTblCnt = COUNT(*)
		  FROM CustomerPK
		 WHERE LOWER(CustomerId) = LOWER(RTRIM(LTRIM(@customerId)))
		   AND LOWER([TableName]) = LOWER(RTRIM(LTRIM(@tableName)))
		IF @iTblCnt IS NULL OR @iTblCnt = 0
		BEGIN
			-- Table Name not exists in CustomerPK table.
            EXEC GetErrorMsg 805, @errNum out, @errMsg out
			RETURN;
		END

		SET @now = GETDATE();
		-- for testing
		--SET @now = CONVERT(datetime, '2017-12-03 23:55:11:123', 121);
		SELECT @lastSeedId = LastSeed
			 , @resetMode = SeedResetMode
			 , @prefix = [prefix]
			 , @seedDigits = SeedDigits
			 , @lastDate = LastUpdated
			FROM CustomerPK
			WHERE LOWER(CustomerId) = LOWER(RTRIM(LTRIM(@customerId)))
			  AND LOWER([TableName]) = LOWER(@tableName)
		-- for testing
		--SELECT @lastDate = CONVERT(datetime, '2016-11-03 23:55:11:123', 121);

		IF @lastSeedId IS NOT NULL OR @lastSeedId >= 0
		BEGIN
			-- format code
			SET @seedcode = @prefix;

			IF @resetMode = 1
			BEGIN
				SELECT @isSameDate = dbo.IsSameDate(@now, @lastDate)
				IF (@isSameDate = 0)
					SET @lastSeedId = 1;
				ELSE SET @lastSeedId = @lastSeedId + 1;
				-- daily
				SET @seedcode = @seedcode + 
					CONVERT(nvarchar(4), DATEPART(yyyy, @now)) +
					RIGHT('00' + CONVERT(nvarchar(2), DATEPART(mm, @now)), 2) +
					RIGHT('00' + CONVERT(nvarchar(2), DATEPART(dd, @now)), 2) +
					RIGHT(REPLICATE('0', @seedDigits) + RTRIM(CONVERT(nvarchar, @lastSeedId)), @seedDigits);
			END
			ELSE IF @resetMode = 2
			BEGIN
				SELECT @isSameDate = dbo.IsSameMonth(@now, @lastDate)
				IF (@isSameDate = 0)
					SET @lastSeedId = 1;
				ELSE SET @lastSeedId = @lastSeedId + 1;
				-- monthly
				SET @seedcode = @seedcode + 
					CONVERT(nvarchar(4), DATEPART(yyyy, @now)) +
					RIGHT('00' + CONVERT(nvarchar(2), DATEPART(mm, @now)), 2) +
					RIGHT(REPLICATE('0', @seedDigits) + RTRIM(CONVERT(nvarchar, @lastSeedId)), @seedDigits);
			END
			ELSE IF @resetMode = 3
			BEGIN
				SELECT @isSameDate = dbo.IsSameYear(@now, @lastDate)
				IF (@isSameDate = 0)
					SET @lastSeedId = 1;
				ELSE SET @lastSeedId = @lastSeedId + 1;
				-- yearly
				SET @seedcode = @seedcode + 
					CONVERT(nvarchar(4), DATEPART(yyyy, @now)) +
					RIGHT(REPLICATE('0', @seedDigits) + RTRIM(CONVERT(nvarchar, @lastSeedId)), @seedDigits);
			END
			ELSE IF @resetMode = 4
			BEGIN
				SET @lastSeedId = @lastSeedId + 1;
				-- ignore date
				SET @seedcode = @seedcode + 
					RIGHT(REPLICATE('0', @seedDigits) + RTRIM(CONVERT(nvarchar, @lastSeedId)), @seedDigits);
			END
			ELSE
			BEGIN
				-- not supports
				-- Not supports reset mode.
                EXEC GetErrorMsg 806, @errNum out, @errMsg out
				RETURN;
			END

			IF @seedcode IS NOT NULL OR @seedcode <> N''
			BEGIN
				-- update nexvalue and stamp last updated date.
				UPDATE CustomerPK
					SET LastSeed = @lastSeedId
					  , LastUpdated = @now
					WHERE LOWER(CustomerId) = LOWER(RTRIM(LTRIM(@customerId)))
					  AND LOWER([TableName]) = LOWER(@tableName)

                EXEC GetErrorMsg 0, @errNum out, @errMsg out
			END
			ELSE
			BEGIN
				-- Cannot generate seed code for table: 
                EXEC GetErrorMsg 807, @errNum out, @errMsg out
                SET @errMsg = @errMsg + ' ' + @tableName + '.'
			END
		END
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO


/*********** Script Update Date: 2018-04-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: GetCustomerPK.
-- Description:	Gets Customer Primary Key.
-- [== History ==]
-- <2017-01-09> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
--exec GetCustomerPK N'EDL-C2017010001', N'Branch'; -- for get match by name
--exec GetCustomerPK N'EDL-C2017010001'; -- for get all
-- =============================================
CREATE PROCEDURE [dbo].[GetCustomerPK] 
(
  @customerId nvarchar(30)
, @tableName nvarchar(50) = null
)
AS
BEGIN
	SELECT CustomerId
		 , LastSeed
		 , SeedResetMode
		 , CASE SeedResetMode
			 WHEN 1 THEN N'Daily'
			 WHEN 2 THEN N'Monthly'
			 WHEN 3 THEN N'Yearly'
			 WHEN 4 THEN N'Sequence'
		   END AS ResetMode
		 , [prefix]
		 , SeedDigits
		 , LastUpdated
		FROM CustomerPK
		WHERE LOWER(CustomerId) = LOWER(@customerId)
		  AND LOWER([TableName]) = LOWER(COALESCE(@tableName, [TableName]));
END

GO


/*********** Script Update Date: 2018-04-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: SaveCustomer.
-- Description:	Save Customer Information.
-- [== History ==]
-- <2016-11-02> :
--	- Stored Procedure Created.
-- <2017-06-07> :
--	- Fixed logic to check duplicate Customer Name.
-- <2017-06-08> :
--	- Add code to used exists data if null is set (TaxCode, Address1, Address2, etc.).
-- <2018-04-16> :
--	- change error code(s).
--
-- [== Example ==]
--
/*
-- Complex Example.
DECLARE @errNum int;
DECLARE @errMsg nvarchar(MAX);
DECLARE @customerId nvarchar(30)
-- [AddNew]
exec SaveCustomer --Company Name
                  N'Softbase Co., Ltd.'
				  --Tax Code
                , N'123-908-098-098'
				  --Address 1
				, N'222 first road my address 1'
				  --Address 2
				, N'address 2'
				  --City
				, N'banglumpoolang'
				  --Province
				, N'bangkok'
				  --PostalCode
				, N'10600'
				  --Phone
				, N'02-888-8822, 02-888-8888'
				  --Mobile
				, N'081-666-6666'
				  --Fax
				, N'02-899-9888'
				  --Email
				, N'chumponsenate@yahoo.com'
				  --CustomerId
				, @customerId out
				  -- Err Number
				, @errNum out
				  -- Err Message
				, @errMsg out
SELECT * FROM Customer
SELECT @customerId AS CustomerId, @errNum AS ErrNum, @errMsg AS ErrMsg
-- [Update]
exec SaveCustomer 
                  --Company Name
                  N'Softbase2 Co., Ltd.'
				  --Tax Code
                , N'123-908-098-098'
				  --Address 1
				, N'222 first road'
				  --Address 2
				, N'address 2'
				  --City
				, N'banglumpoolang'
				  --Province
				, N'bangkok'
				  --PostalCode
				, N'10600'
				  --Phone
				, N'02-888-8822'
				  --Mobile
				, N''
				  --Fax
				, N''
				  --Email
				, N''
				  --CustomerId
				, @customerId
				  -- Err Number
				, @errNum out
				  -- Err Message
				, @errMsg out
SELECT * FROM Customer
SELECT @customerId AS CustomerId, @errNum AS ErrNum, @errMsg AS ErrMsg
*/
-- =============================================
CREATE PROCEDURE [dbo].[SaveCustomer] (
  @customerName as nvarchar(50)
, @taxCode as nvarchar(30) = null
, @address1 as nvarchar(80) = null
, @address2 as nvarchar(80) = null
, @city as nvarchar(50) = null
, @province as nvarchar(50) = null
, @postalcode as nvarchar(8) = null
, @phone as nvarchar(80) = null
, @mobile as nvarchar(80) = null
, @fax as nvarchar(80) = null
, @email as nvarchar(80) = null
, @customerId as nvarchar(30) = null out
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
DECLARE @iCustCnt int = 0;
	-- Error Code:
	--   0 : Success
	-- 901 : Customer Name (default) cannot be null or empty string.
	-- 902 : The Customer Id is not exists.
	-- 903 : Customer Name (default) already exists.
	-- OTHER : SQL Error Number & Error Message.
	BEGIN TRY
		IF (dbo.IsNullOrEmpty(@customerName) = 1)
		BEGIN
			-- Customer Name (default) cannot be null or empty string.
            EXEC GetErrorMsg 901, @errNum out, @errMsg out
			RETURN
		END
		/* Check Name exists */
		IF (@customerId IS NOT NULL)
		BEGIN
			/* Check is Customer Id is exists. */
			SELECT @iCustCnt = COUNT(*)
			  FROM Customer
			 WHERE LOWER(CustomerId) = LOWER(RTRIM(LTRIM(@customerId)));
			IF (@iCustCnt = 0)
			BEGIN
                -- The Customer Id is not exists.
                EXEC GetErrorMsg 902, @errNum out, @errMsg out
				RETURN;
			END

			SELECT @iCustCnt = COUNT(*)
				FROM Customer
				WHERE LOWER(CustomerName) = LOWER(RTRIM(LTRIM(@customerName)))
				  AND LOWER(CustomerId) <> LOWER(RTRIM(LTRIM(@customerId)))
		END
		ELSE
		BEGIN
			SELECT @iCustCnt = COUNT(*)
				FROM Customer
				WHERE LOWER(CustomerName) = LOWER(RTRIM(LTRIM(@customerName)))
		END

		IF @iCustCnt <> 0
		BEGIN
			-- Customer Name (default) already exists.
            EXEC GetErrorMsg 903, @errNum out, @errMsg out
			RETURN;
		END
		/* Reset Counter */
		SET @iCustCnt = 0;

		IF dbo.IsNullOrEmpty(@customerId) = 1
		BEGIN
			EXEC NextMasterPK N'Customer'
							, @customerId out
							, @errNum out
							, @errMsg out;
			IF @errNum <> 0
			BEGIN
				RETURN;
			END	
		END
		ELSE
		BEGIN
			SELECT @iCustCnt = COUNT(*)
			  FROM Customer
			 WHERE LOWER(CustomerID) = LOWER(RTRIM(LTRIM(@customerId)))
		END

		IF @iCustCnt = 0
		BEGIN
			INSERT INTO Customer
			(
				  CustomerID
				, CustomerName
				, TaxCode
				, Address1
				, Address2
				, City
				, Province
				, PostalCode
				, Phone
				, Mobile
				, Fax
				, Email
				, ObjectStatus
			)
			VALUES
			(
				  RTRIM(LTRIM(@customerId))
				, RTRIM(LTRIM(@customerName))
				, RTRIM(LTRIM(@taxCode))
				, RTRIM(LTRIM(@address1))
				, RTRIM(LTRIM(@address2))
				, RTRIM(LTRIM(@city))
				, RTRIM(LTRIM(@province))
				, RTRIM(LTRIM(@postalcode))
				, RTRIM(LTRIM(@phone))
				, RTRIM(LTRIM(@mobile))
				, RTRIM(LTRIM(@fax))
				, RTRIM(LTRIM(@email))
				, 1
			);
			/* Init Related PK */
			exec SetCustomerPK @customerId, N'Branch', 4, 'B', 4;
			exec SetCustomerPK @customerId, N'MemberInfo', 4, 'M', 5;
			exec SetCustomerPK @customerId, N'Org', 4, 'O', 4;
			exec SetCustomerPK @customerId, N'QSet', 4, 'QS', 5;
			exec SetCustomerPK @customerId, N'Device', 4, 'D', 4;
		END
		ELSE
		BEGIN
			UPDATE Customer
			   SET CustomerName = RTRIM(LTRIM(@customerName)) /* Cannot be null. */
				 , TaxCode = RTRIM(LTRIM(COALESCE(@taxCode, TaxCode)))
				 , Address1 = RTRIM(LTRIM(COALESCE(@address1, Address1)))
				 , Address2 = RTRIM(LTRIM(COALESCE(@address2, Address2)))
				 , City = RTRIM(LTRIM(COALESCE(@city, City)))
				 , Province = RTRIM(LTRIM(COALESCE(@province, Province)))
				 , Postalcode = RTRIM(LTRIM(COALESCE(@postalcode, Postalcode)))
				 , Phone = RTRIM(LTRIM(COALESCE(@phone, Phone)))
				 , Mobile = RTRIM(LTRIM(COALESCE(@mobile, Mobile)))
				 , Fax = RTRIM(LTRIM(COALESCE(@fax, Fax)))
				 , Email = RTRIM(LTRIM(COALESCE(@email, Email)))
			 WHERE LOWER(CustomerID) = LOWER(RTRIM(LTRIM(@customerId)))
		END

        EXEC GetErrorMsg 0, @errNum out, @errMsg out
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO


/*********** Script Update Date: 2018-04-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: SaveCustomerML.
-- Description:	Save Customer ML.
-- [== History ==]
-- <2016-11-02> :
--	- Stored Procedure Created.
-- <2017-06-08> :
--	- Fixed Logic to checks duplicated name.
--	- Fixed Logic to checks mismatch langId.
--	- Add code to used exists data if null is set (TaxCode, Address1, Address2, etc.).
-- <2018-04-16> :
--	- change language id from nvarchar(10) to nvarchar(3).
--	- change error code(s).
--
-- [== Example ==]
--
/*
-- Complex Example.
DECLARE @errNum int;
DECLARE @errMsg nvarchar(MAX);
DECLARE @customerId nvarchar(30)
-- [AddNew]
exec SaveCustomerML --CustomerId
				    @customerId
				    --LangId
                  , N'TH'
				    --Company Name
                  , N'บริษัท ซอฟต์เบส จำกัด'
				    --Tax Code
                  , N'123-908-098-098'
				    --Address 1
				  , N'30 ซอยเจริญนคร 51 ถ.เจริญนคร'
				    --Address 2
				  , N'แขวงบางลำภูล่าง'
				    --City
				  , N'เขตคลองสาน'
				    --Province
				  , N'ก.ท.ม.'
				    --PostalCode
				  , N'10600'
				    -- Err Number
				  , @errNum out
				    -- Err Message
				  , @errMsg out

SELECT * FROM CustomerML
SELECT @errNum AS ErrNum, @errMsg AS ErrMsg
*/
-- =============================================
CREATE PROCEDURE [dbo].[SaveCustomerML] (
  @customerId as nvarchar(30) = null
, @langId as nvarchar(3)
, @customerName as nvarchar(50)
, @taxCode as nvarchar(30) = null
, @address1 as nvarchar(80) = null
, @address2 as nvarchar(80) = null
, @city as nvarchar(50) = null
, @province as nvarchar(50) = null
, @postalcode as nvarchar(8) = null
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
DECLARE @iLangCnt int = 0;
DECLARE @iCustCnt int = 0;
	-- Error Code:
	--   0 : Success
	-- 904 : Customer Id cannot be null or empty string.
	-- 905 : Lang Id cannot be null or empty string.
	-- 906 : Lang Id not found.
	-- 907 : Customer Name (ML) cannot be null or empty string.
	-- 908 : Customer Name (ML) is already exist.

	-- OTHER : SQL Error Number & Error Message.
	BEGIN TRY
		IF (dbo.IsNullOrEmpty(@customerId) = 1)
		BEGIN
			-- Customer Id cannot be null or empty string.
            EXEC GetErrorMsg 904, @errNum out, @errMsg out
			RETURN
		END

		IF (dbo.IsNullOrEmpty(@langId) = 1)
		BEGIN
			-- Lang Id cannot be null or empty string.
            EXEC GetErrorMsg 905, @errNum out, @errMsg out
			RETURN
		END

		SELECT @iLangCnt = COUNT(*)
		  FROM Language
		 WHERE UPPER(RTRIM(LTRIM(LangID))) = UPPER(RTRIM(LTRIM(@langId)));

		IF (@iLangCnt IS NULL OR @iLangCnt = 0)
		BEGIN
			-- Lang Id not found.
            EXEC GetErrorMsg 906, @errNum out, @errMsg out
			RETURN
		END

		IF (dbo.IsNullOrEmpty(@customerName) = 1)
		BEGIN
			-- Customer Name (ML) cannot be null or empty string.
            EXEC GetErrorMsg 907, @errNum out, @errMsg out
			RETURN
		END

		/* Check Duplicate Name in same language. */ 
		SELECT @iCustCnt = COUNT(*)
		  FROM CustomerML
		 WHERE UPPER(RTRIM(LTRIM(LangID))) = UPPER(RTRIM(LTRIM(@langId)))
		   AND UPPER(RTRIM(LTRIM(CustomerName))) = UPPER(RTRIM(LTRIM(@customerName)))
		   AND UPPER(RTRIM(LTRIM(CustomerId))) <> UPPER(RTRIM(LTRIM(@customerId)))

		IF @iCustCnt > 0
		BEGIN
			-- The Customer Name (ML) is already exist.
            EXEC GetErrorMsg 908, @errNum out, @errMsg out
			RETURN
		END

		SET @iCustCnt = 0; -- Reset

		/* check is need to insert or update? */
		SELECT @iCustCnt = COUNT(*)
		  FROM CustomerML
		 WHERE UPPER(RTRIM(LTRIM(LangID))) = UPPER(RTRIM(LTRIM(@langId)))
		   AND UPPER(RTRIM(LTRIM(CustomerId))) = UPPER(RTRIM(LTRIM(@customerId)));

		IF @iCustCnt = 0
		BEGIN
			INSERT INTO CustomerML
			(
				  CustomerID
				, LangId
				, CustomerName
				, TaxCode
				, Address1
				, Address2
				, City
				, Province
				, PostalCode
			)
			VALUES
			(
				  RTRIM(LTRIM(@customerId))
				, RTRIM(LTRIM(@langId))
				, RTRIM(LTRIM(@customerName))
				, RTRIM(LTRIM(@taxCode))
				, RTRIM(LTRIM(@address1))
				, RTRIM(LTRIM(@address2))
				, RTRIM(LTRIM(@city))
				, RTRIM(LTRIM(@province))
				, RTRIM(LTRIM(@postalcode))
			);
		END
		ELSE
		BEGIN
			UPDATE CustomerML
			   SET CustomerName = RTRIM(LTRIM(@customerName))
				 , TaxCode = RTRIM(LTRIM(COALESCE(@taxCode, TaxCode)))
				 , Address1 = RTRIM(LTRIM(COALESCE(@address1, Address1)))
				 , Address2 = RTRIM(LTRIM(COALESCE(@address2, Address2)))
				 , City = RTRIM(LTRIM(COALESCE(@city, City)))
				 , Province = RTRIM(LTRIM(COALESCE(@province, Province)))
				 , Postalcode = RTRIM(LTRIM(COALESCE(@postalcode, Postalcode)))
			 WHERE UPPER(RTRIM(LTRIM(LangID))) = UPPER(RTRIM(LTRIM(@langId)))
			   AND UPPER(RTRIM(LTRIM(CustomerID))) = UPPER(RTRIM(LTRIM(@customerId)))
		END

        EXEC GetErrorMsg 0, @errNum out, @errMsg out
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO


/*********** Script Update Date: 2018-04-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetCustomers
-- [== History ==]
-- <2017-05-31> :
--	- Stored Procedure Created.
-- <2018-04-> :
--	- change language id from nvarchar(10) to nvarchar(3).
--
-- [== Example ==]
--
--exec GetCustomers NULL, NULL, 1;             -- for only enabled languages.
--exec GetCustomers;                           -- for get all.
--exec GetCustomers N'EN';                     -- for get customers for EN language.
--exec GetCustomers N'TH';                     -- for get customers for TH language.
--exec GetCustomers N'TH', N'EDL-C2017060011'; -- for get customer for TH language by Customer Id.
-- =============================================
CREATE PROCEDURE [dbo].[GetCustomers] 
(
  @langId nvarchar(3) = NULL
, @customerId nvarchar(30) = NULL
, @enabled bit = NULL
)
AS
BEGIN
	SELECT * 
	  FROM CustomerMLView
	 WHERE [ENABLED] = COALESCE(@enabled, [ENABLED])
	   AND UPPER(LTRIM(RTRIM(LangId))) = UPPER(LTRIM(RTRIM(COALESCE(@langId, LangId))))
	   AND UPPER(LTRIM(RTRIM(CustomerId))) = UPPER(LTRIM(RTRIM(COALESCE(@customerId, CustomerId))))
	 ORDER BY SortOrder, CustomerId
END

GO


/*********** Script Update Date: 2018-04-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: SaveBranch.
-- Description:	Save Branch.
-- [== History ==]
-- <2017-01-09> :
--	- Stored Procedure Created.
-- <2017-06-07> :
--	- Fixed Logic to check duplicated Branch Name.
-- <2017-06-08> :
--  - The @errMsg set as nvarchar(MAX).
-- <2018-04-16> :
--	- change error code(s).
--
-- [== Example ==]
--
--exec SaveBranch N'EDL-C2017010001', N'Softbase'
--exec SaveBranch N'EDL-C2017010001', N'Services', N'B0001'
-- =============================================
CREATE PROCEDURE [dbo].[SaveBranch] (
  @customerId as nvarchar(30)
, @branchName as nvarchar(80)
, @branchId as nvarchar(30) = null out
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
DECLARE @iCustCnt int = 0;
DECLARE @iBranchCnt int = 0;
	-- Error Code:
	--   0 : Success
	-- 1001 : Customer Id cannot be null or empty string.
	-- 1002 : Branch Name (default) cannot be null or empty string.
	-- 1003 : Customer Id is not found.
	-- 1004 : Branch Id is not found.
	-- 1005 : Branch Name (default) already exists.
	-- OTHER : SQL Error Number & Error Message.
	BEGIN TRY
		IF (dbo.IsNullOrEmpty(@customerId) = 1)
		BEGIN
			-- Customer Id cannot be null or empty string.
            EXEC GetErrorMsg 1002, @errNum out, @errMsg out
			RETURN
		END

		IF (dbo.IsNullOrEmpty(@branchName) = 1)
		BEGIN
			-- Branch Name (default) cannot be null or empty string.
            EXEC GetErrorMsg 1002, @errNum out, @errMsg out
			RETURN
		END

		SELECT @iCustCnt = COUNT(*)
		  FROM Customer
		 WHERE RTRIM(LTRIM(CustomerId)) = RTRIM(LTRIM(@customerId));
		IF (@iCustCnt = 0)
		BEGIN
			-- Customer Id is not found.
            EXEC GetErrorMsg 1003, @errNum out, @errMsg out
			RETURN
		END

		/* Check Name exists */
		IF (@branchId IS NOT NULL AND LTRIM(RTRIM(@branchId)) <> N'')
		BEGIN
			SELECT @iBranchCnt = COUNT(*)
			  FROM Branch
			 WHERE LOWER(CustomerId) = LOWER(RTRIM(LTRIM(@customerId)))
			   AND LOWER(BranchId) = LOWER(RTRIM(LTRIM(@branchId)));
			IF (@iBranchCnt = 0)
			BEGIN
				-- Branch Id is not found.
                EXEC GetErrorMsg 1004, @errNum out, @errMsg out
				RETURN
			END

			SELECT @iBranchCnt = COUNT(*)
				FROM Branch
				WHERE LOWER(BranchName) = LOWER(RTRIM(LTRIM(@branchName)))
				  AND LOWER(CustomerId) = LOWER(RTRIM(LTRIM(@customerId)))
				  AND LOWER(BranchId) <> LOWER(RTRIM(LTRIM(@branchId)))
		END
		ELSE
		BEGIN
			SELECT @iBranchCnt = COUNT(*)
				FROM Branch
				WHERE LOWER(BranchName) = LOWER(RTRIM(LTRIM(@branchName)))
				  AND LOWER(CustomerId) = LOWER(RTRIM(LTRIM(@customerId)))
		END

		IF @iBranchCnt <> 0
		BEGIN
			-- Branch Name (default) already exists.
            EXEC GetErrorMsg 1005, @errNum out, @errMsg out
			RETURN;
		END

		SET @iBranchCnt = 0; -- Reset Counter.

		IF dbo.IsNullOrEmpty(@branchId) = 1
		BEGIN
			EXEC NextCustomerPK @customerId
			                , N'Branch'
							, @branchId out
							, @errNum out
							, @errMsg out;
			IF @errNum <> 0
			BEGIN
				RETURN;
			END	
		END
		ELSE
		BEGIN
			SELECT @iBranchCnt = COUNT(*)
			  FROM Branch
			 WHERE LOWER(BranchId) = LOWER(RTRIM(LTRIM(@branchId)))
			   AND LOWER(CustomerID) = LOWER(RTRIM(LTRIM(@customerId)))
		END

		IF @iBranchCnt = 0
		BEGIN
			INSERT INTO Branch
			(
				  CustomerID
				, BranchID
				, BranchName
				, ObjectStatus
			)
			VALUES
			(
				  RTRIM(LTRIM(@customerId))
				, RTRIM(LTRIM(@branchId))
				, RTRIM(LTRIM(@branchName))
				, 1
			);
		END
		ELSE
		BEGIN
			UPDATE Branch
			   SET BranchName = RTRIM(LTRIM(@branchName))
			 WHERE LOWER(BranchID) = LOWER(RTRIM(LTRIM(@branchId))) 
			   AND LOWER(CustomerId) = LOWER(RTRIM(LTRIM(@customerId)));
		END
		
        EXEC GetErrorMsg 0, @errNum out, @errMsg out
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO


/*********** Script Update Date: 2018-04-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: SaveBranchML.
-- Description:	SaveBranchML.
-- [== History ==]
-- <2016-11-02> :
--	- Stored Procedure Created.
-- <2017-06-08> :
--  - The @errMsg set as nvarchar(MAX).
--  - Add code to checks not allow conditions for BranchId, BranchName.
-- <2018-04-16> :
--	- change language id from nvarchar(10) to nvarchar(3).
--	- change error code(s).
--
-- [== Example ==]
--
--exec SaveBranchML N'EDL-C2017060005', N'B0001', N'TH', N'สำนักงานใหญ่'
--exec SaveBranchML N'EDL-C2017060005', N'B0001', N'JA', N'ヘッドクォーター'
-- =============================================
CREATE PROCEDURE [dbo].[SaveBranchML] (
  @customerId as nvarchar(30)
, @branchId as nvarchar(30)
, @langId as nvarchar(3)
, @branchName as nvarchar(80)
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
DECLARE @iLangCnt int = 0;
DECLARE @iBranchCnt int = 0;
	-- Error Code:
	--    0 : Success
    -- 1001 : Customer Id cannot be null or empty string.
	-- 1006 : Lang Id cannot be null or empty string.
	-- 1007 : Language Id not exist.
	-- 1008 : Branch Id cannot be null or empty string.
	-- 1009 : Branch Id is not found.
	-- 1010 : Branch Name (ML) is already exists.
	-- OTHER : SQL Error Number & Error Message.
	BEGIN TRY
		/* Check if lang id is not null. */
		IF (dbo.IsNullOrEmpty(@langId) = 1)
		BEGIN
			-- Lang Id cannot be null or empty string.
            EXEC GetErrorMsg 1006, @errNum out, @errMsg out
			RETURN
		END
		/* Check if language exists. */
		SELECT @iLangCnt = COUNT(LangId)
		  FROM Language
		 WHERE UPPER(RTRIM(LTRIM(LangId))) = UPPER(RTRIM(LTRIM(@langId)));
		IF (@iLangCnt IS NULL OR @iLangCnt = 0) 
		BEGIN
			-- Lang Id not exist.
            EXEC GetErrorMsg 1007, @errNum out, @errMsg out
			RETURN
		END

		/* Check if customer id is not null. */
		IF (dbo.IsNullOrEmpty(@customerId) = 1)
		BEGIN
            -- Customer Id cannot be null or empty string.
            EXEC GetErrorMsg 1001, @errNum out, @errMsg out
			RETURN
		END

		/* Check if branch id is not null. */
		IF (dbo.IsNullOrEmpty(@branchId) = 1)
		BEGIN
			-- Branch Id cannot be null or empty string.
            EXEC GetErrorMsg 1008, @errNum out, @errMsg out
			RETURN
		END

		/* Check Id is in table */ 
		SELECT @iBranchCnt = COUNT(*)
			FROM Branch
		   WHERE UPPER(RTRIM(LTRIM(BranchId))) = UPPER(RTRIM(LTRIM(@branchId)))
		     AND UPPER(RTRIM(LTRIM(CustomerId))) = UPPER(RTRIM(LTRIM(@customerId)))
		IF @iBranchCnt = 0
		BEGIN
			-- Branch Id is not found.
            EXEC GetErrorMsg 1009, @errNum out, @errMsg out
			RETURN
		END

		/* Check Branch Name is already exists. */
		SELECT @iBranchCnt = COUNT(*)
			FROM BranchML
		   WHERE UPPER(RTRIM(LTRIM(CustomerId))) = UPPER(RTRIM(LTRIM(@customerId)))
		     AND UPPER(RTRIM(LTRIM(LangId))) = UPPER(RTRIM(LTRIM(@langId)))
		     AND UPPER(RTRIM(LTRIM(BranchName))) = UPPER(RTRIM(LTRIM(@branchName)))
		     AND UPPER(RTRIM(LTRIM(BranchId))) <> UPPER(RTRIM(LTRIM(@branchId)))
		IF @iBranchCnt <> 0
		BEGIN
			-- Branch Name (ML) is already exists.
            EXEC GetErrorMsg 1010, @errNum out, @errMsg out
			RETURN
		END

		/* check is need to insert or update? */
		SELECT @iBranchCnt = COUNT(*)
			FROM BranchML
		   WHERE UPPER(RTRIM(LTRIM(BranchId))) = UPPER(RTRIM(LTRIM(@branchId)))
		     AND UPPER(RTRIM(LTRIM(CustomerId))) = UPPER(RTRIM(LTRIM(@customerId)))
			 AND UPPER(RTRIM(LTRIM(LangId))) = UPPER(RTRIM(LTRIM(@langId)));

		IF @iBranchCnt = 0
		BEGIN
			INSERT INTO BranchML
			(
				  CustomerId
				, BranchId
				, LangId
				, BranchName
			)
			VALUES
			(
				  UPPER(RTRIM(LTRIM(@customerId)))
				, UPPER(RTRIM(LTRIM(@branchId)))
				, UPPER(RTRIM(LTRIM(@langId)))
				, RTRIM(LTRIM(@branchName))
			);
		END
		ELSE
		BEGIN
			UPDATE BranchML
			   SET BranchName = RTRIM(LTRIM(@branchName))
		     WHERE UPPER(RTRIM(LTRIM(CustomerId))) = UPPER(RTRIM(LTRIM(@customerId)))
			   AND UPPER(RTRIM(LTRIM(BranchId))) = UPPER(RTRIM(LTRIM(@branchId)))
			   AND UPPER(RTRIM(LTRIM(LangId))) = UPPER(RTRIM(LTRIM(@langId)));
		END
		
        EXEC GetErrorMsg 0, @errNum out, @errMsg out
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO


/*********** Script Update Date: 2018-04-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: GetBranchs.
-- Description:	Get Branchs.
-- [== History ==]
-- <2017-05-31> :
--	- Stored Procedure Created.
-- <2018-04-16> :
--	- change language id from nvarchar(10) to nvarchar(3).
--
-- [== Example ==]
--
--exec GetBranchs NULL, NULL, NULL, 1;                 -- for only enabled languages.
--exec GetBranchs;                                     -- for get all.
--exec GetBranchs N'EN';                               -- for get Branchs for EN language.
--exec GetBranchs N'TH';                               -- for get Branchs for TH language.
--exec GetBranchs N'TH', N'EDL-C2017060011';           -- for get Branchs by CustomerID.
--exec GetBranchs N'TH', N'EDL-C2017060011', N'B0001'; -- for get Branch by CustomerID and BranchId.
-- =============================================
CREATE PROCEDURE [dbo].[GetBranchs] 
(
  @langId nvarchar(3) = NULL
, @customerId nvarchar(30) = NULL
, @branchId nvarchar(30) = NULL
, @enabled bit = NULL
)
AS
BEGIN
	SELECT * 
	  FROM BranchMLView
	 WHERE [ENABLED] = COALESCE(@enabled, [ENABLED])
	   AND UPPER(LTRIM(RTRIM(LangId))) = UPPER(LTRIM(RTRIM(COALESCE(@langId, LangId))))
	   AND UPPER(LTRIM(RTRIM(CustomerId))) = UPPER(LTRIM(RTRIM(COALESCE(@customerId, CustomerId))))
	   AND UPPER(LTRIM(RTRIM(BranchId))) = UPPER(LTRIM(RTRIM(COALESCE(@branchId, BranchId))))
	 ORDER BY SortOrder, LangId, CustomerId, BranchId;
END

GO


/*********** Script Update Date: 2018-04-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: SaveMemberInfo.
-- Description:	Save Member Information.
-- [== History ==]
-- <2016-12-14> :
--	- Stored Procedure Created.
-- <2017-01-09> :
--	- Add Field TagId, IDCard, EmployeeCode.
-- <2017-06-07> :
--	- Fixed Logic to check duplicated all Prefix - FirstName - LastName.
--	- Fixed Logic to check duplicated UserName.
-- <2017-06-08> :
--  - The @errMsg set as nvarchar(MAX).
-- <2017-06-12> :
--  - Add logic to checks IDCard, EmployeeCode and TagID.
-- <2018-04-16> :
--	- change error code(s).
--
-- [== Example ==]
--
--exec SaveMemberInfo N'EDL-C2017060005', N'', N'Administrator', N'', N'admin@softbase2.co.th', N'1234', 200
--exec SaveMemberInfo N'EDL-C2017060005', N'Mr.', N'Chumpon', N'Asaneerat', N'chumpon@softbase2.co.th', N'1234', 210
--exec SaveMemberInfo N'EDL-C2017060005', N'Mr.', N'Thana', N'Phorchan', N'thana@softbase2.co.th', N'1234', 280
-- =============================================
CREATE PROCEDURE [dbo].[SaveMemberInfo] (
  @customerId as nvarchar(30)
, @prefix as nvarchar(10) = null
, @firstName as nvarchar(40)
, @lastName as nvarchar(50) = null
, @userName as nvarchar(50)
, @passWord as nvarchar(20)
, @memberType as int = 280 /* Staff */
, @tagId as nvarchar(30) = null
, @idCard as nvarchar(30) = null
, @employeeCode as nvarchar(30) = null
, @memberId as nvarchar(30) = null out
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
DECLARE @iMemCnt int = 0;
DECLARE @iCnt int = 0;
	-- Error Code:
	--    0 : Success
	-- 1101 : Customer Id cannot be null or empty string.
	-- 1102 : Customer Id not found.
	-- 1103 : First Name (default) cannot be null or empty string.
	-- 1104 : User Name cannot be null or empty string.
	-- 1105 : Password cannot be null or empty string.
	-- 1106 : MemberType cannot be null.
	-- 1107 : MemberType allow only value 200 admin, 210 exclusive, 280 staff, 290 Device.
	-- 1108 : Member Full Name (default) already exists.
	-- 1109 : User Name already exists.
	-- 1110 : Member Id is not found.
	-- 1111 : IDCard is already exists.
	-- 1111 : Employee Code is already exists.
	-- 1113 : TagId is already exists.
	-- OTHER : SQL Error Number & Error Message.
	BEGIN TRY
		IF (dbo.IsNullOrEmpty(@customerId) = 1)
		BEGIN
			-- Customer Id cannot be null or empty string.
            EXEC GetErrorMsg 1101, @errNum out, @errMsg out
			RETURN
		END

		SELECT @iCnt = COUNT(*)
		  FROM Customer
		 WHERE LOWER(CustomerId) = LOWER(RTRIM(LTRIM(@customerId)));
		IF (@iCnt = 0)
		BEGIN
			-- Customer Id not found.
            EXEC GetErrorMsg 1102, @errNum out, @errMsg out
			RETURN
		END

		IF (dbo.IsNullOrEmpty(@firstName) = 1)
		BEGIN
			-- First Name (default) cannot be null or empty string.
            EXEC GetErrorMsg 1103, @errNum out, @errMsg out
			RETURN
		END

		IF (dbo.IsNullOrEmpty(@userName) = 1)
		BEGIN
			-- User Name cannot be null or empty string.
            EXEC GetErrorMsg 1104, @errNum out, @errMsg out
			RETURN
		END

		IF (dbo.IsNullOrEmpty(@passWord) = 1)
		BEGIN
			-- Password cannot be null or empty string.
            EXEC GetErrorMsg 1105, @errNum out, @errMsg out
			RETURN
		END

		IF (@memberType IS NULL)
		BEGIN
			-- MemberType cannot be null.
            EXEC GetErrorMsg 1106, @errNum out, @errMsg out
			RETURN
		END

		IF (@memberType <> 200 AND @memberType <> 210 AND @memberType <> 280 AND @memberType <> 290)
		BEGIN
			-- MemberType allow only value 200 admin, 210 exclusive, 280 staff, 290 Device.
            EXEC GetErrorMsg 1107, @errNum out, @errMsg out
			RETURN
		END

		/* Check Prefix, FirstName, LastName exists */
		IF (@memberId IS NOT NULL)
		BEGIN
			SELECT @iMemCnt = COUNT(*)
			  FROM MemberInfo
			 WHERE LOWER(CustomerId) = LOWER(RTRIM(LTRIM(@customerId)))
			   AND LOWER(MemberId) <> LOWER(RTRIM(LTRIM(@memberId)))
			   AND LOWER(RTRIM(LTRIM(Prefix))) = LOWER(RTRIM(LTRIM(@prefix)))
			   AND LOWER(RTRIM(LTRIM(FirstName))) = LOWER(RTRIM(LTRIM(@firstName)))
			   AND LOWER(RTRIM(LTRIM(LastName))) = LOWER(RTRIM(LTRIM(@lastName)))
		END
		ELSE
		BEGIN
			SELECT @iMemCnt = COUNT(*)
			  FROM MemberInfo
			 WHERE LOWER(CustomerId) = LOWER(RTRIM(LTRIM(@customerId)))
			   AND LOWER(RTRIM(LTRIM(Prefix))) = LOWER(RTRIM(LTRIM(@prefix)))
			   AND LOWER(RTRIM(LTRIM(FirstName))) = LOWER(RTRIM(LTRIM(@firstName)))
			   AND LOWER(RTRIM(LTRIM(LastName))) = LOWER(RTRIM(LTRIM(@lastName)))
		END

		IF @iMemCnt <> 0
		BEGIN
			-- Member Full Name (default) already exists.
            EXEC GetErrorMsg 1108, @errNum out, @errMsg out
			RETURN;
		END

		SET @iMemCnt = 0; -- Reset Counter.

		/* Check UserName exists */
		IF (@memberId IS NOT NULL)
		BEGIN
			SELECT @iMemCnt = COUNT(*)
			  FROM MemberInfo
			 WHERE LOWER(CustomerId) = LOWER(RTRIM(LTRIM(@customerId)))
			   AND LOWER(MemberId) <> LOWER(RTRIM(LTRIM(@memberId)))
			   AND LOWER(RTRIM(LTRIM(UserName))) = LOWER(RTRIM(LTRIM(@userName)))
		END
		ELSE
		BEGIN
			SELECT @iMemCnt = COUNT(*)
			  FROM MemberInfo
			 WHERE LOWER(CustomerId) = LOWER(RTRIM(LTRIM(@customerId)))
			   AND LOWER(RTRIM(LTRIM(UserName))) = LOWER(RTRIM(LTRIM(@userName)))
		END

		IF @iMemCnt <> 0
		BEGIN
			-- User Name already exists.
            EXEC GetErrorMsg 1109, @errNum out, @errMsg out
			RETURN;
		END

		IF (@memberId IS NOT NULL)
		BEGIN
			-- Checks is MemberId is valid.
			SELECT @iMemCnt = COUNT(*)
			  FROM MemberInfo
			 WHERE LOWER(CustomerId) = LOWER(RTRIM(LTRIM(@customerId)))
			   AND LOWER(RTRIM(LTRIM(MemberId))) = LOWER(RTRIM(LTRIM(@memberId)))
			IF (@iMemCnt = 0)
			BEGIN
				--- Member Id is not found.
                EXEC GetErrorMsg 1110, @errNum out, @errMsg out
				RETURN;
			END
			-- Check IDCard, EmployeeCode, TagId
			IF (@idCard IS NOT NULL)
			BEGIN
				SELECT @iMemCnt = COUNT(*)
					FROM MemberInfo
					WHERE LOWER(CustomerId) = LOWER(RTRIM(LTRIM(@customerId)))
					  AND LOWER(RTRIM(LTRIM(IDCard))) = LOWER(RTRIM(LTRIM(@idCard)))
					  AND LOWER(RTRIM(LTRIM(MemberId))) <> LOWER(RTRIM(LTRIM(@memberId)));
				IF (@iMemCnt <> 0)
				BEGIN
					-- IDCard is already exists.
                    EXEC GetErrorMsg 1111, @errNum out, @errMsg out
					RETURN;
				END
			END
			IF (@employeeCode IS NOT NULL)
			BEGIN
				SELECT @iMemCnt = COUNT(*)
					FROM MemberInfo
					WHERE LOWER(CustomerId) = LOWER(RTRIM(LTRIM(@customerId)))
					  AND LOWER(RTRIM(LTRIM(EmployeeCode))) = LOWER(RTRIM(LTRIM(@employeeCode)))
					  AND LOWER(RTRIM(LTRIM(MemberId))) <> LOWER(RTRIM(LTRIM(@memberId)));
				IF (@iMemCnt <> 0)
				BEGIN
					-- Employee Code is already exists.
                    EXEC GetErrorMsg 1112, @errNum out, @errMsg out
					RETURN;
				END
			END
			IF (@tagId IS NOT NULL)
			BEGIN
				SELECT @iMemCnt = COUNT(*)
					FROM MemberInfo
					WHERE LOWER(CustomerId) = LOWER(RTRIM(LTRIM(@customerId)))
					  AND LOWER(RTRIM(LTRIM(TagId))) = LOWER(RTRIM(LTRIM(@tagId)))
					  AND LOWER(RTRIM(LTRIM(MemberId))) <> LOWER(RTRIM(LTRIM(@memberId)));
				IF (@iMemCnt <> 0)
				BEGIN
					-- TagId is already exists.
                    EXEC GetErrorMsg 1113, @errNum out, @errMsg out
					RETURN;
				END
			END
		END
		ELSE
		BEGIN
			-- Check IDCard, EmployeeCode, TagId
			IF (@idCard IS NOT NULL)
			BEGIN
				SELECT @iMemCnt = COUNT(*)
				  FROM MemberInfo
				 WHERE LOWER(CustomerId) = LOWER(RTRIM(LTRIM(@customerId)))
				   AND LOWER(RTRIM(LTRIM(IDCard))) = LOWER(RTRIM(LTRIM(@idCard)));
				IF (@iMemCnt <> 0)
				BEGIN
					-- IDCard is already exists.
                    EXEC GetErrorMsg 1111, @errNum out, @errMsg out
					RETURN;
				END
			END
			IF (@employeeCode IS NOT NULL)
			BEGIN
				SELECT @iMemCnt = COUNT(*)
				  FROM MemberInfo
				 WHERE LOWER(CustomerId) = LOWER(RTRIM(LTRIM(@customerId)))
				   AND LOWER(RTRIM(LTRIM(EmployeeCode))) = LOWER(RTRIM(LTRIM(@employeeCode)));
				IF (@iMemCnt <> 0)
				BEGIN
					-- Employee Code is already exists.
                    EXEC GetErrorMsg 1112, @errNum out, @errMsg out
					RETURN;
				END
			END
			IF (@tagId IS NOT NULL)
			BEGIN
				SELECT @iMemCnt = COUNT(*)
				  FROM MemberInfo
				 WHERE LOWER(CustomerId) = LOWER(RTRIM(LTRIM(@customerId)))
				   AND LOWER(RTRIM(LTRIM(TagId))) = LOWER(RTRIM(LTRIM(@tagId)));
				IF (@iMemCnt <> 0)
				BEGIN
					-- TagId is already exists.
                    EXEC GetErrorMsg 1113, @errNum out, @errMsg out
					RETURN;
				END
			END
		END

		SET @iMemCnt = 0; -- Reset Counter.

		IF dbo.IsNullOrEmpty(@memberId) = 1
		BEGIN
			EXEC NextCustomerPK @customerId
							, N'MemberInfo'
							, @memberId out
							, @errNum out
							, @errMsg out;
			IF @errNum <> 0
			BEGIN
				RETURN;
			END	
		END
		ELSE
		BEGIN
			SELECT @iMemCnt = COUNT(*)
			  FROM MemberInfo
			 WHERE LOWER(MemberId) = LOWER(RTRIM(LTRIM(@memberId)))
			   AND LOWER(CustomerId) = LOWER(RTRIM(LTRIM(@customerId)))
		END

		IF @iMemCnt = 0
		BEGIN
			INSERT INTO MemberInfo
			(
				  MemberId
				, CustomerId
				, TagId
				, IDCard
				, EmployeeCode
				, Prefix
				, FirstName
				, LastName
				, UserName
				, [Password]
				, MemberType
				, ObjectStatus
			)
			VALUES
			(
				  RTRIM(LTRIM(@memberId))
				, RTRIM(LTRIM(@customerId))
				, RTRIM(LTRIM(@tagId))
				, RTRIM(LTRIM(@idCard))
				, RTRIM(LTRIM(@employeeCode))
				, RTRIM(LTRIM(@prefix))
				, RTRIM(LTRIM(@firstName))
				, RTRIM(LTRIM(@lastName))
				, RTRIM(LTRIM(@userName))
				, RTRIM(LTRIM(@passWord))
				, @memberType
				, 1
			);
		END
		ELSE
		BEGIN
			UPDATE MemberInfo
			   SET TagId = RTRIM(LTRIM(@tagId))
			     , IDCard = RTRIM(LTRIM(@idCard))
			     , EmployeeCode = RTRIM(LTRIM(@employeeCode))
			     , Prefix = RTRIM(LTRIM(@prefix))
			     , FirstName = RTRIM(LTRIM(@firstName))
				 , LastName = RTRIM(LTRIM(@lastName))
				 , UserName = RTRIM(LTRIM(@userName))
				 , [Password] = RTRIM(LTRIM(@passWord))
				 , MemberType = @memberType
			 WHERE LOWER(MemberId) = LOWER(RTRIM(LTRIM(@memberId))) 
			   AND LOWER(CustomerId) = LOWER(RTRIM(LTRIM(@customerId))) 
		END
		SET @errNum = 0;
		SET @errMsg = N'success';
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO


/*********** Script Update Date: 2018-04-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: SaveMemberInfoML.
-- Description:	Save Member Information (ML).
-- [== History ==]
-- <2017-06-07> :
--	- Stored Procedure Created.
-- <2017-06-08> :
--  - The @errMsg set as nvarchar(MAX).
-- <2018-04-16> :
--	- change language id from nvarchar(10) to nvarchar(3).
--	- change error code(s).
--
-- [== Example ==]
--
--exec SaveMemberInfoML N'EDL-C2017060005', N'M00002', N'TH', N'นาย', N'ชุมพล', N'อัศนีย์รัตน์'
--exec SaveMemberInfoML N'EDL-C2017060005', N'M00002', N'JA', N'氏', N'チュンポン', N'アサニーラット'
--exec SaveMemberInfoML N'EDL-C2017060005', N'M00003', N'TH', N'นาย', N'ธนา', N'โพธิ์จันทร์'
-- =============================================
CREATE PROCEDURE [dbo].[SaveMemberInfoML] (
  @customerId as nvarchar(30)
, @memberId as nvarchar(30)
, @langId as nvarchar(3)
, @prefix as nvarchar(10)
, @firstName as nvarchar(40)
, @lastName as nvarchar(50)
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
DECLARE @iLangCnt int = 0;
DECLARE @iMemCnt int = 0;
DECLARE @iCnt int = 0;
	-- Error Code:
	--   0 : Success
	-- 1101 : CustomerId cannot be null or empty string.
	-- 1102 : Customer Id not found.
	-- 1114 : Lang Id cannot be null or empty string.
	-- 1115 : Lang Id not exist.
	-- 1116 : Member Id cannot be null or empty string.
	-- 1117 : No Member match MemberId in specificed Customer Id.
	-- 1118 : Member Full Name (ML) already exists.
	-- OTHER : SQL Error Number & Error Message.
	BEGIN TRY
		/* Check if lang id is not null. */
		IF (dbo.IsNullOrEmpty(@langId) = 1)
		BEGIN
			-- Lang Id cannot be null or empty string.
            EXEC GetErrorMsg 1114, @errNum out, @errMsg out
			RETURN
		END
		/* Check if language exists. */
		SELECT @iLangCnt = COUNT(LangId)
		  FROM Language
		 WHERE UPPER(RTRIM(LTRIM(LangId))) = UPPER(RTRIM(LTRIM(@langId)));
		IF (@iLangCnt IS NULL OR @iLangCnt = 0) 
		BEGIN
			-- Lang Id not exist.
            EXEC GetErrorMsg 1115, @errNum out, @errMsg out
			RETURN
		END

		/* Check if customer id is not null. */
		IF (dbo.IsNullOrEmpty(@customerId) = 1)
		BEGIN
			-- Customer Id cannot be null or empty string.
            EXEC GetErrorMsg 1101, @errNum out, @errMsg out
			RETURN
		END

		SELECT @iCnt = COUNT(*)
		  FROM Customer
		 WHERE UPPER(RTRIM(LTRIM(CustomerId))) = UPPER(RTRIM(LTRIM(@customerId)));
		IF (@iCnt = 0)
		BEGIN
			-- Customer Id not found.
            EXEC GetErrorMsg 1102, @errNum out, @errMsg out
			RETURN
		END

		/* Check if branch id is not null. */
		IF (dbo.IsNullOrEmpty(@memberId) = 1)
		BEGIN
			-- Member Id cannot be null or empty string.
            EXEC GetErrorMsg 1116, @errNum out, @errMsg out
			RETURN
		END

		/* Check MemberId is in MemberInfo table */ 
		SELECT @iMemCnt = COUNT(*)
			FROM MemberInfo
		   WHERE UPPER(RTRIM(LTRIM(MemberId))) = UPPER(RTRIM(LTRIM(@memberId)))
		     AND UPPER(RTRIM(LTRIM(CustomerId))) = UPPER(RTRIM(LTRIM(@customerId)))
		IF @iMemCnt = 0
		BEGIN
			-- No Member match MemberId in specificed Customer Id.
            EXEC GetErrorMsg 1117, @errNum out, @errMsg out
			RETURN
		END

		/* Check Prefix, FirstName, LastName exists */
		SELECT @iMemCnt = COUNT(*)
			FROM MemberInfoML
			WHERE LOWER(CustomerId) = LOWER(RTRIM(LTRIM(@customerId)))
				AND UPPER(LangId) = UPPER(RTRIM(LTRIM(@langId)))
				AND LOWER(MemberId) <> LOWER(RTRIM(LTRIM(@memberId)))
				AND LOWER(RTRIM(LTRIM(Prefix))) = LOWER(RTRIM(LTRIM(@prefix)))
				AND LOWER(RTRIM(LTRIM(FirstName))) = LOWER(RTRIM(LTRIM(@firstName)))
				AND LOWER(RTRIM(LTRIM(LastName))) = LOWER(RTRIM(LTRIM(@lastName)))

		IF @iMemCnt <> 0
		BEGIN
			-- Member Full Name (ML) already exists.
            EXEC GetErrorMsg 1118, @errNum out, @errMsg out
			RETURN;
		END

		SET @iMemCnt = 0; -- Reset Counter.

		/* check is need to insert or update? */
		SELECT @iMemCnt = COUNT(*)
			FROM MemberInfoML
		   WHERE UPPER(RTRIM(LTRIM(MemberId))) = UPPER(RTRIM(LTRIM(@memberId)))
		     AND UPPER(RTRIM(LTRIM(CustomerId))) = UPPER(RTRIM(LTRIM(@customerId)))
			 AND UPPER(RTRIM(LTRIM(LangId))) = UPPER(RTRIM(LTRIM(@langId)));

		IF @iMemCnt = 0
		BEGIN
			INSERT INTO MemberInfoML
			(
				  CustomerId
				, MemberId
				, LangId
				, Prefix
				, FirstName
				, LastName
			)
			VALUES
			(
				  UPPER(RTRIM(LTRIM(@customerId)))
				, UPPER(RTRIM(LTRIM(@memberId)))
				, UPPER(RTRIM(LTRIM(@langId)))
				, RTRIM(LTRIM(@prefix))
				, RTRIM(LTRIM(@firstName))
				, RTRIM(LTRIM(@lastName))
			);
		END
		ELSE
		BEGIN
			UPDATE MemberInfoML
			   SET Prefix = RTRIM(LTRIM(@prefix))
			     , FirstName = RTRIM(LTRIM(@firstName))
				 , LastName = RTRIM(LTRIM(@lastName))
		     WHERE UPPER(RTRIM(LTRIM(CustomerId))) = UPPER(RTRIM(LTRIM(@customerId)))
			   AND UPPER(RTRIM(LTRIM(MemberId))) = UPPER(RTRIM(LTRIM(@memberId)))
			   AND UPPER(RTRIM(LTRIM(LangId))) = UPPER(RTRIM(LTRIM(@langId)));
		END
		
        EXEC GetErrorMsg 0, @errNum out, @errMsg out
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO


/*********** Script Update Date: 2018-04-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetMemberInfos
-- [== History ==]
-- <2017-05-31> :
--	- Stored Procedure Created.
-- <2018-04-16> :
--	- change language id from nvarchar(10) to nvarchar(3).
--
-- [== Example ==]
--
--exec GetMemberInfos NULL, NULL, NULL, 1;                  -- for only enabled languages.
--exec GetMemberInfos;                                      -- for get all.
--exec GetMemberInfos N'EN';                                -- for get MemberInfos for EN language.
--exec GetMemberInfos N'TH';                                -- for get MemberInfos for TH language.
--exec GetMemberInfos N'TH', N'EDL-C2017060011';            -- for get MemberInfos by CustomerID.
--exec GetMemberInfos N'TH', N'EDL-C2017060011', N'M00001'; -- for get MemberInfo by CustomerID and MemberId.
-- =============================================
CREATE PROCEDURE [dbo].[GetMemberInfos] 
(
  @langId nvarchar(3) = NULL
, @customerId nvarchar(30) = NULL
, @memberId nvarchar(30) = NULL
, @enabled bit = NULL
)
AS
BEGIN
	SELECT * 
	  FROM MemberInfoMLView
	 WHERE [ENABLED] = COALESCE(@enabled, [ENABLED])
	   AND UPPER(LTRIM(RTRIM(LangId))) = UPPER(LTRIM(RTRIM(COALESCE(@langId, LangId))))
	   AND UPPER(LTRIM(RTRIM(CustomerId))) = UPPER(LTRIM(RTRIM(COALESCE(@customerId, CustomerId))))
	   AND UPPER(LTRIM(RTRIM(MemberId))) = UPPER(LTRIM(RTRIM(COALESCE(@memberId, MemberId))))
	 ORDER BY SortOrder, LangId, CustomerId, MemberId;
END

GO


/*********** Script Update Date: 2018-04-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: Save Org.
-- Description:	Save Organization.
-- [== History ==]
-- <2016-12-14> :
--	- Stored Procedure Created.
-- <2017-01-09> :
--	- Add BranchId.
-- <2017-06-08> :
--  - The @errMsg set as nvarchar(MAX).
-- <2017-06-19> :
--  - Add more checks logic.
-- <2018-04-16> :
--	- change error code(s).
--
-- [== Example ==]
--
-- [== Complex Example ==]
/*
DECLARE @errNum int;
DECLARE @errMsg nvarchar(MAX);
DECLARE @orgId nvarchar(30) = null
exec SaveOrg N'EDL-C2017060005', null, N'B0001', N'Softbase', @orgId out, @errNum out, @errMsg out
SELECT @orgId AS OrgId, @errNum AS ErrNum, @errMsg AS ErrMsg
exec SaveOrg N'EDL-C2017060005', @orgId, N'B0001', N'Services', NULL, @errNum out, @errMsg out 
SELECT @errNum AS ErrNum, @errMsg AS ErrMsg
exec SaveOrg N'EDL-C2017060005', @orgId, N'B0001', N'Supports', NULL, @errNum out, @errMsg out 
SELECT @errNum AS ErrNum, @errMsg AS ErrMsg
SET @orgId = NULL
*/
-- =============================================
CREATE PROCEDURE [dbo].[SaveOrg] (
  @customerId as nvarchar(30)
, @parentId as nvarchar(30) = null
, @branchId as nvarchar(30) = null
, @orgName as nvarchar(80)
, @orgId as nvarchar(30) = null out
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
DECLARE @iCnt int = 0;
DECLARE @iOrgCnt int = 0;
	-- Error Code:
	--    0 : Success
	-- 1201 : Customer Id cannot be null or empty string.
	-- 1202 : Customer Id not found.
	-- 1203 : Branch Id cannot be null or empty string.
	-- 1204 : Branch Id not found.
	-- 1205 : The Root Org already assigned.
	-- 1206 : The Parent Org Id is not found.
	-- 1207 : Org Name (default) cannot be null or empty string.
	-- 1208 : Org Name (default) already exists.
	-- OTHER : SQL Error Number & Error Message.
	BEGIN TRY
		IF (dbo.IsNullOrEmpty(@customerId) = 1)
		BEGIN
			-- Customer Id cannot be null or empty string.
            EXEC GetErrorMsg 1201, @errNum out, @errMsg out
			RETURN
		END

		SELECT @iCnt = COUNT(*)
		  FROM Customer
		 WHERE LOWER(CustomerID) = LOWER(RTRIM(LTRIM(@customerId)))
		IF (@iCnt = 0)
		BEGIN
			-- Customer Id not found.
            EXEC GetErrorMsg 1202, @errNum out, @errMsg out
			RETURN
		END

		IF (dbo.IsNullOrEmpty(@branchId) = 1)
		BEGIN
			-- Branch Id cannot be null or empty string.
            EXEC GetErrorMsg 1203, @errNum out, @errMsg out
			RETURN
		END

		SELECT @iCnt = COUNT(*)
		  FROM Branch
		 WHERE LOWER(BranchID) = LOWER(RTRIM(LTRIM(@branchId)))
		   AND LOWER(CustomerID) = LOWER(RTRIM(LTRIM(@customerId)))
		IF (@iCnt = 0)
		BEGIN
			-- Branch Id not found.
            EXEC GetErrorMsg 1204, @errNum out, @errMsg out
			RETURN
		END

		IF (@parentId IS NULL OR LOWER(RTRIM(LTRIM(@parentId))) = N'')
		BEGIN
			SELECT @iOrgCnt = COUNT(*)
			  FROM Org
			 WHERE LOWER(CustomerID) = LOWER(RTRIM(LTRIM(@customerId)))
			   AND (ParentId IS NULL OR LOWER(RTRIM(LTRIM(ParentId))) = N'');
			IF (@iOrgCnt > 0 and @parentId is null and @orgId is null)
			BEGIN
				-- The Root Org already assigned.
                EXEC GetErrorMsg 1205, @errNum out, @errMsg out
				RETURN
			END
		END
		ELSE
		BEGIN
			SELECT @iCnt = COUNT(*)
			  FROM Org
			 WHERE LOWER(CustomerID) = LOWER(RTRIM(LTRIM(@customerId)))
			   AND LOWER(RTRIM(LTRIM(OrgId))) = LOWER(RTRIM(LTRIM(@parentId)))
			IF (@iCnt = 0)
			BEGIN
				-- The Parent Org Id is not found.
                EXEC GetErrorMsg 1206, @errNum out, @errMsg out
				RETURN
			END
		END

		IF (dbo.IsNullOrEmpty(@orgName) = 1)
		BEGIN
			-- Org Name (default) cannot be null or empty string.
            EXEC GetErrorMsg 1207, @errNum out, @errMsg out
			RETURN
		END

		IF (@orgId IS NULL)
		BEGIN
			SELECT @iOrgCnt = COUNT(*)
			  FROM Org
			 WHERE LOWER(CustomerID) = LOWER(RTRIM(LTRIM(@customerId)))
			   AND LOWER(BranchID) = LOWER(RTRIM(LTRIM(@branchId)))
			   AND LOWER(LTRIM(RTRIM(OrgName))) = LOWER(LTRIM(RTRIM(@orgName)))
			IF (@iOrgCnt <> 0)
			BEGIN
				-- Org Name (default) already exists.
                EXEC GetErrorMsg 1208, @errNum out, @errMsg out
				RETURN
			END
		END
		ELSE
		BEGIN
			SELECT @iOrgCnt = COUNT(*)
			  FROM Org
			 WHERE LOWER(CustomerID) = LOWER(RTRIM(LTRIM(@customerId)))
			   AND LOWER(BranchID) = LOWER(RTRIM(LTRIM(@branchId)))
			   AND LOWER(LTRIM(RTRIM(OrgId))) <> LOWER(LTRIM(RTRIM(@orgId)))
			   AND LOWER(LTRIM(RTRIM(OrgName))) = LOWER(LTRIM(RTRIM(@orgName)))
			IF (@iOrgCnt <> 0)
			BEGIN
				-- Org Name (default) already exists.
                EXEC GetErrorMsg 1208, @errNum out, @errMsg out
				RETURN
			END
		END

		/* RESET COUNTER*/
		SET @iOrgCnt = 0;

		IF dbo.IsNullOrEmpty(@orgId) = 1
		BEGIN
			EXEC NextCustomerPK @customerId
							, N'Org'
							, @orgId out
							, @errNum out
							, @errMsg out;
			IF @errNum <> 0
			BEGIN
				RETURN;
			END	
		END
		ELSE
		BEGIN
			SELECT @iOrgCnt = COUNT(*)
			  FROM Org
			 WHERE LOWER(OrgId) = LOWER(RTRIM(LTRIM(@orgId)))
			   AND LOWER(CustomerId) = LOWER(RTRIM(LTRIM(@customerId)))
		END

		IF @iOrgCnt = 0
		BEGIN
			INSERT INTO Org
			(
				  CustomerId
				, OrgID
				, BranchId
				, ParentId
				, OrgName
				, ObjectStatus
			)
			VALUES
			(
				  RTRIM(LTRIM(@customerId))
				, RTRIM(LTRIM(@orgId))
				, RTRIM(LTRIM(@branchId))
				, RTRIM(LTRIM(@parentId))
				, RTRIM(LTRIM(@orgName))
				, 1
			);
		END
		ELSE
		BEGIN
			UPDATE Org
			   SET ParentID = RTRIM(LTRIM(@parentId))
			     , BranchId = RTRIM(LTRIM(@branchId))
			     , OrgName = RTRIM(LTRIM(@orgName))
			 WHERE LOWER(OrgId) = LOWER(RTRIM(LTRIM(@orgId))) 
			   AND LOWER(CustomerId) = LOWER(RTRIM(LTRIM(@customerId)));
		END
		
        EXEC GetErrorMsg 0, @errNum out, @errMsg out
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO


/*********** Script Update Date: 2018-04-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: SaveOrgML.
-- Description:	Save Organization (ML).
-- [== History ==]
-- <2016-06-07> :
--	- Stored Procedure Created.
-- <2017-06-08> :
--  - The @errMsg set as nvarchar(MAX).
-- <2018-04-16> :
--	- change language id from nvarchar(10) to nvarchar(3).
--	- change error code(s).
--
-- [== Example ==]
--
--exec SaveOrgML N'EDL-C2017060005', N'O0013', N'TH', N'ฝ่ายบริการ'
--exec SaveOrgML N'EDL-C2017060005', N'O0013', N'JA', N'サービス部門'
-- =============================================
CREATE PROCEDURE [dbo].[SaveOrgML] (
  @customerId as nvarchar(30)
, @orgId as nvarchar(30)
, @langId as nvarchar(3)
, @orgName as nvarchar(80)
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
DECLARE @iCnt int = 0;
DECLARE @iLangCnt int = 0;
DECLARE @iOrgCnt int = 0;
	-- Error Code:
	--    0 : Success
	-- 1209 : Lang Id cannot be null or empty string.
	-- 1210 : Lang Id not found.
	-- 1211 : Customer Id cannot be null or empty string.
	-- 1212 : Customer Id not found.
	-- 1213 : Org Id cannot be null or empty string.
	-- 1214 : No Org match Org Id in specificed Customer Id.
	-- 1215 : Org Name (ML) already exists.
	-- OTHER : SQL Error Number & Error Message.
	BEGIN TRY
		/* Check if lang id is not null. */
		IF (dbo.IsNullOrEmpty(@langId) = 1)
		BEGIN
			-- Lang Id cannot be null or empty string.
            EXEC GetErrorMsg 1209, @errNum out, @errMsg out
			RETURN
		END
		/* Check if language exists. */
		SELECT @iLangCnt = COUNT(LangId)
		  FROM Language
		 WHERE UPPER(RTRIM(LTRIM(LangId))) = UPPER(RTRIM(LTRIM(@langId)));
		IF (@iLangCnt IS NULL OR @iLangCnt = 0) 
		BEGIN
			-- Lang Id not found.
            EXEC GetErrorMsg 1210, @errNum out, @errMsg out
			RETURN
		END

		/* Check if customer id is not null. */
		IF (dbo.IsNullOrEmpty(@customerId) = 1)
		BEGIN
			-- Customer Id cannot be null or empty string.
            EXEC GetErrorMsg 1211, @errNum out, @errMsg out
			RETURN
		END

		SELECT @iCnt = COUNT(*)
		  FROM Customer
		 WHERE UPPER(RTRIM(LTRIM(CustomerId))) = UPPER(RTRIM(LTRIM(@customerId)))
		IF (@iCnt = 0)
		BEGIN
			-- Customer Id not found.
            EXEC GetErrorMsg 1212, @errNum out, @errMsg out
			RETURN
		END

		/* Check if Org id is not null. */
		IF (dbo.IsNullOrEmpty(@orgId) = 1)
		BEGIN
			-- Org Id cannot be null or empty string.
            EXEC GetErrorMsg 1213, @errNum out, @errMsg out
			RETURN
		END

		/* Check OrgId is in Org table */ 
		SELECT @iOrgCnt = COUNT(*)
		  FROM Org
		 WHERE UPPER(RTRIM(LTRIM(OrgId))) = UPPER(RTRIM(LTRIM(@orgId)))
		   AND UPPER(RTRIM(LTRIM(CustomerId))) = UPPER(RTRIM(LTRIM(@customerId)))
		IF (@iOrgCnt = 0)
		BEGIN
			-- No Org match Org Id in specificed Customer Id.
            EXEC GetErrorMsg 1214, @errNum out, @errMsg out
			RETURN
		END

		SELECT @iOrgCnt = COUNT(*)
		  FROM OrgML
		 WHERE UPPER(RTRIM(LTRIM(OrgId))) <> UPPER(RTRIM(LTRIM(@orgId)))
		   AND UPPER(RTRIM(LTRIM(CustomerId))) = UPPER(RTRIM(LTRIM(@customerId)))
		   AND UPPER(RTRIM(LTRIM(LangId))) = UPPER(RTRIM(LTRIM(@langId)))
		   AND UPPER(RTRIM(LTRIM(OrgName))) = UPPER(RTRIM(LTRIM(@orgName)));
		IF (@iOrgCnt <> 0)
		BEGIN
			-- Org Name (ML) already exists.
            EXEC GetErrorMsg 1215, @errNum out, @errMsg out
			RETURN
		END

		SET @iOrgCnt = 0; -- Reset

		/* check is need to insert or update? */
		SELECT @iOrgCnt = COUNT(*)
		  FROM OrgML
		 WHERE UPPER(RTRIM(LTRIM(OrgId))) = UPPER(RTRIM(LTRIM(@orgId)))
		   AND UPPER(RTRIM(LTRIM(CustomerId))) = UPPER(RTRIM(LTRIM(@customerId)))
		   AND UPPER(RTRIM(LTRIM(LangId))) = UPPER(RTRIM(LTRIM(@langId)))

		IF (@iOrgCnt = 0)
		BEGIN
			INSERT INTO OrgML
			(
				  CustomerId
				, OrgId
				, LangId
				, OrgName
			)
			VALUES
			(
				  UPPER(RTRIM(LTRIM(@customerId)))
				, UPPER(RTRIM(LTRIM(@orgId)))
				, UPPER(RTRIM(LTRIM(@langId)))
				, RTRIM(LTRIM(@orgName))
			);
		END
		ELSE
		BEGIN
			UPDATE OrgML
			   SET OrgName = RTRIM(LTRIM(@orgName))
		     WHERE UPPER(RTRIM(LTRIM(CustomerId))) = UPPER(RTRIM(LTRIM(@customerId)))
			   AND UPPER(RTRIM(LTRIM(OrgId))) = UPPER(RTRIM(LTRIM(@orgId)))
			   AND UPPER(RTRIM(LTRIM(LangId))) = UPPER(RTRIM(LTRIM(@langId)));
		END
		
        EXEC GetErrorMsg 0, @errNum out, @errMsg out
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO


/*********** Script Update Date: 2018-04-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: GetOrgs
-- Description:	Get Organizations.
-- [== History ==]
-- <2017-05-31> :
--	- Stored Procedure Created.
-- <2018-04-16> :
--	- change language id from nvarchar(10) to nvarchar(3).
--
-- [== Example ==]
--
--/* Get All */
--exec GetOrgs NULL, NULL, NULL, NULL, 1; -- enabled languages only.
--exec GetOrgs; -- all languages.
--/* With Specificed CustomerId */
--exec GetOrgs N'EN', N'EDL-C2017060008'; -- Gets Orgs EN language.
--exec GetOrgs N'TH', N'EDL-C2017060008'; -- Gets Orgs TH language.
--/* With Specificed CustomerId, BranchId */
--exec GetOrgs N'EN', N'EDL-C2017060008', N'B0001'; -- Gets EN language in Branch 1.
--exec GetOrgs N'TH', N'EDL-C2017060008', N'B0002'; -- Gets TH language in Branch 2.
-- =============================================
CREATE PROCEDURE [dbo].[GetOrgs] 
(
  @langId nvarchar(3) = NULL
, @customerId nvarchar(30) = NULL
, @branchId nvarchar(30) = NULL
, @orgId nvarchar(30) = NULL
, @enabled bit = NULL
)
AS
BEGIN
	SELECT * 
	  FROM OrgMLView
	 WHERE [ENABLED] = COALESCE(@enabled, [ENABLED])
	   AND UPPER(LTRIM(RTRIM(LangId))) = UPPER(LTRIM(RTRIM(COALESCE(@langId, LangId))))
	   AND UPPER(LTRIM(RTRIM(CustomerId))) = UPPER(LTRIM(RTRIM(COALESCE(@customerId, CustomerId))))
	   AND UPPER(LTRIM(RTRIM(BranchId))) = UPPER(LTRIM(RTRIM(COALESCE(@branchId, BranchId))))
	   AND UPPER(LTRIM(RTRIM(OrgId))) = UPPER(LTRIM(RTRIM(COALESCE(@orgId, OrgId))))
	 ORDER BY SortOrder, LangId, CustomerId, BranchId, OrgId
END

GO


/*********** Script Update Date: 2018-04-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: SaveVote.
-- Description:	Save Vote.
-- [== History ==]
-- <2018-01-30> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- [== Complex Example ==]
/*
DECLARE @errNum int;
DECLARE @errMsg nvarchar(MAX);
DECLARE @customerId nvarchar(30);
DECLARE @orgId nvarchar(30);
DECLARE @branchId nvarchar(30);
DECLARE @deviceId nvarchar(50);
DECLARE @qSetId nvarchar(30);
DECLARE @qSeq int;
DECLARE @userId nvarchar(30);
DECLARE @voteSeq int = null
DECLARE @voteDate datetime;
DECLARE @voteValue int;
DECLARE @remark nvarchar(100)

SET @customerId = N'EDL-C2017060005';
SET @orgId = N'O0001';
SET @branchId = N'B0001';
SET @deviceId = N'4dff3f4640374939a856d892bc57bf1c';
SET @qSetId = 'QS2018010001';
SET @userId = NULL;
SET @voteDate = GETDATE();
SET @remark = NULL;

SET @qSeq = 1;
SET @voteValue = 1;
exec SaveVote @customerId, @orgId, @branchId
            , @deviceId
			, @qSetId, @qSeq
			, @userId
			, @voteDate, @voteValue, @remark
            , @voteSeq out, @errNum out, @errMsg out
SELECT @voteSeq as VoteSeq, @errNum AS ErrNum, @errMsg AS ErrMsg

SET @qSeq = 1;
SET @voteValue = 2;
exec SaveVote @customerId, @orgId, @branchId
            , @deviceId
			, @qSetId, @qSeq
			, @userId
			, @voteDate, @voteValue, @remark
            , @voteSeq out, @errNum out, @errMsg out 
SELECT @voteSeq as VoteSeq, @errNum AS ErrNum, @errMsg AS ErrMsg

SET @qSeq = 1;
SET @voteValue = 2;
exec SaveVote @customerId, @orgId, @branchId
            , @deviceId
			, @qSetId, @qSeq
			, @userId
			, @voteDate, @voteValue, @remark
            , @voteSeq out, @errNum out, @errMsg out 
SELECT @voteSeq as VoteSeq, @errNum AS ErrNum, @errMsg AS ErrMsg
*/
-- =============================================
CREATE PROCEDURE [dbo].[SaveVote] (
  @customerId as nvarchar(30)
, @orgId as nvarchar(30) = null
, @branchId as nvarchar(30) = null
, @deviceId as nvarchar(50) = null
, @qSetId as nvarchar(30) = null
, @qSeq as int = 0
, @userId as nvarchar(30) = null
, @voteDate as datetime = null
, @voteValue as int = 0
, @remark as nvarchar(100) = null
, @voteSeq as int = 0 out
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
DECLARE @iCnt int = 0;
DECLARE @iVoteSeq int = 0;
	-- Error Code:
	--    0 : Success
	-- 1701 : Customer Id cannot be null or empty string.
	-- 1702 : Customer Id not found.
	-- 1703 : Branch Id cannot be null or empty string.
	-- 1704 : Branch Id not found.
	-- 1705 : Org Id cannot be null or empty string.
	-- 1706 : Org Id not found.
	-- 1707 : QSet Id cannot be null or empty string.
	-- 1708 : QSet Id not found.
	-- OTHER : SQL Error Number & Error Message.
	BEGIN TRY
		IF (dbo.IsNullOrEmpty(@customerId) = 1)
		BEGIN
			-- Customer Id cannot be null or empty string.
            EXEC GetErrorMsg 1701, @errNum out, @errMsg out
			RETURN
		END

		SELECT @iCnt = COUNT(*)
		  FROM Customer
		 WHERE LOWER(CustomerID) = LOWER(RTRIM(LTRIM(@customerId)))
		IF (@iCnt = 0)
		BEGIN
			-- Customer Id not found.
            EXEC GetErrorMsg 1702, @errNum out, @errMsg out
			RETURN
		END

		IF (dbo.IsNullOrEmpty(@branchId) = 1)
		BEGIN
			-- Branch Id cannot be null or empty string.
            EXEC GetErrorMsg 1703, @errNum out, @errMsg out
			RETURN
		END

		SELECT @iCnt = COUNT(*)
		  FROM Branch
		 WHERE LOWER(BranchID) = LOWER(RTRIM(LTRIM(@branchId)))
		   AND LOWER(CustomerID) = LOWER(RTRIM(LTRIM(@customerId)))
		IF (@iCnt = 0)
		BEGIN
			-- Branch Id not found.
            EXEC GetErrorMsg 1704, @errNum out, @errMsg out
			RETURN
		END

		IF (dbo.IsNullOrEmpty(@orgId) = 1)
		BEGIN
			-- Org Id cannot be null or empty string.
            EXEC GetErrorMsg 1705, @errNum out, @errMsg out
			RETURN
		END

		SELECT @iCnt = COUNT(*)
		  FROM Org
		 WHERE LOWER(OrgID) = LOWER(RTRIM(LTRIM(@orgId)))
           AND LOWER(BranchID) = LOWER(RTRIM(LTRIM(@branchId)))
		   AND LOWER(CustomerID) = LOWER(RTRIM(LTRIM(@customerId)))
		IF (@iCnt = 0)
		BEGIN
			-- Org Id not found.
            EXEC GetErrorMsg 1706, @errNum out, @errMsg out
			RETURN
		END

		IF (dbo.IsNullOrEmpty(@qSetId) = 1)
		BEGIN
			-- QSet Id cannot be null or empty string.
            EXEC GetErrorMsg 1707, @errNum out, @errMsg out
			RETURN
		END

		SELECT @iCnt = COUNT(*)
		  FROM QSet
		 WHERE LOWER(QSetID) = LOWER(RTRIM(LTRIM(@qSetId)))
		   AND LOWER(CustomerID) = LOWER(RTRIM(LTRIM(@customerId)))
		IF (@iCnt = 0)
		BEGIN
			-- QSet Id not found.
            EXEC GetErrorMsg 1708, @errNum out, @errMsg out
			RETURN
		END

		/* RESET COUNTER*/
		SET @iVoteSeq = 0;
		SELECT @iVoteSeq = MAX(VoteSeq)
		  FROM Vote
		 WHERE CustomerId = LOWER(RTRIM(LTRIM(@customerId)))
		   AND OrgId = LOWER(RTRIM(LTRIM(@orgId)))
		   AND BranchId = LOWER(RTRIM(LTRIM(@branchId)))
		   AND DeviceId = LOWER(RTRIM(LTRIM(@deviceId)))
		   AND QSetId = LOWER(RTRIM(LTRIM(@qSetId)))
		   AND QSeq = LOWER(RTRIM(LTRIM(@qSeq)))

		IF (@iVoteSeq IS NULL OR @iVoteSeq <= 0)
		BEGIN
			SET @voteSeq = 1;
		END
		ELSE
		BEGIN
			SET @voteSeq = @iVoteSeq + 1;
		END

		INSERT INTO Vote
		(
			  CustomerId
			, OrgId
			, BranchId
			, DeviceId
			, QSetId
			, QSeq
			, VoteSeq
			, UserId
			, VoteDate
			, VoteValue
			, Remark
			, ObjectStatus
		)
		VALUES
		(
			  RTRIM(LTRIM(@customerId))
			, RTRIM(LTRIM(@orgId))
			, RTRIM(LTRIM(@branchId))
			, RTRIM(LTRIM(@deviceId))
			, RTRIM(LTRIM(@qSetId))
			, @qSeq
			, @voteSeq
			, RTRIM(LTRIM(@userId))
			, @voteDate
			, @voteValue
			, RTRIM(LTRIM(@remark))
			, 1
		);

		EXEC GetErrorMsg 0, @errNum out, @errMsg out
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO


/*********** Script Update Date: 2018-04-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	Register Customer.
-- [== History ==]
-- <2016-11-02> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
--exec RegisterCustomer N'Softbase Co., Ltd.', N'admin@softbase.co.th', N'1234'
-- =============================================
CREATE PROCEDURE [dbo].[RegisterCustomer] (
  @customerName as nvarchar(50)
, @userName as nvarchar(50)
, @passWord as nvarchar(20)
, @customerId as nvarchar(30) = null out
, @memberId as nvarchar(30) = null out
, @branchId as nvarchar(30) = null out
, @orgId as nvarchar(30) = null out
, @errNum as int = 0 out
, @errMsg as nvarchar(100) = N'' out)
AS
BEGIN
DECLARE @iAdminCnt int = 0;
DECLARE @iBranchCnt int = 0;
DECLARE @iOrgCnt int = 0;
	-- Error Code:
	--   0 : Success
	-- 101 : CustomerName cannot be null or empty string.
	-- 102 : UserName and Password cannot be null or empty string.
	-- OTHER : SQL Error Number & Error Message.
	BEGIN TRY
		IF (dbo.IsNullOrEmpty(@customerName) = 1)
		BEGIN
			SET @errNum = 101;
			SET @errMsg = N'CustomerName cannot be null or empty string.';
			RETURN
		END

		IF (dbo.IsNullOrEmpty(@customerName) = 1)
		BEGIN
			SET @errNum = 102;
			SET @errMsg = N'UserName and Password cannot be null or empty string.';
			RETURN
		END

		/* Save the customer */
		exec SaveCustomer @customerName 
						, null /* taxcode */
						, null /* address1 */
						, null /* address2 */
						, null /* city */
						, null /* province */
						, null /* postalcode */
						, null /* phone */
						, null /* mobile */
						, null /* fax */
						, null /* email */
						, @customerId out
						, @errNum out
						, @errMsg out

		IF (@errNum <> 0 OR dbo.IsNullOrEmpty(@customerId) = 1)
		BEGIN
			RETURN;
		END

		/* MEMBER INFO */
		SELECT @iAdminCnt = COUNT(*)
		  FROM MemberInfo
  		 WHERE LOWER(MemberId) = LOWER(RTRIM(LTRIM(@memberId)))
		   AND LOWER(CustomerId) = LOWER(RTRIM(LTRIM(@customerId)))
		   AND MemberType = 200; /* customer's admin */

		IF @iAdminCnt = 0
		BEGIN
			/* Save the admin member */
			exec SaveMemberInfo @customerId
							  , null /* prefix */
							  , N'admin' /* firstname */
							  , null /* lastname */
							  , @userName /* username */
							  , @passWord /* password */
							  , 200 /* membertype */
							  , null /* tagid */
							  , null /* idcard */
							  , null /* employeecode */
							  , @memberId out
							  , @errNum out
							  , @errMsg out;
		END

		IF (@errNum <> 0 OR dbo.IsNullOrEmpty(@memberId) = 1)
		BEGIN
			RETURN;
		END

		/* BRANCH */
		SELECT @iBranchCnt = COUNT(*)
		  FROM Branch
		 WHERE LOWER(CustomerID) = LOWER(RTRIM(LTRIM(@customerId)))

		IF @iBranchCnt = 0
		BEGIN
			exec SaveBranch @customerId
			             , N'HQ'
						 , @branchId out
					     , @errNum out
					     , @errMsg out;
		END

		IF (@errNum <> 0 OR dbo.IsNullOrEmpty(@branchId) = 1)
		BEGIN
			RETURN;
		END

		/* ORG */
		SELECT @iOrgCnt = COUNT(*)
		  FROM Org
  		 WHERE LOWER(CustomerID) = LOWER(RTRIM(LTRIM(@customerId)))
		   AND ParentId IS NULL;

		IF @iOrgCnt = 0
		BEGIN
			/* Save the root org */
			exec SaveOrg @customerId
			           , null /* ParentId */
					   , @branchId /* BranchId */
					   , @customerName /* OrgName */
					   , @orgId out
					   , @errNum out
					   , @errMsg out;
		END

		IF (@errNum <> 0 OR dbo.IsNullOrEmpty(@orgId) = 1)
		BEGIN
			RETURN;
		END

		SET @errNum = 0;
		SET @errMsg = N'success';
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO


/*********** Script Update Date: 2018-04-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	SignIn
-- [== History ==]
-- <2016-12-15> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
--exec SignIn N'admin@umi.co.th', N'1234';
--exec SignIn N'admin@umi.co.th', N'1234', N'EDL-C2017010002';
-- =============================================
CREATE PROCEDURE [dbo].[SignIn] (
  @langId nvarchar(3) = null
, @userName nvarchar(50) = null
, @passWord nvarchar(20) = null
, @customerId nvarchar(30) = null
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
    -- Error Code:
    --   0 : Success
    -- 101 : Not Found.
    -- OTHER : SQL Error Number & Error Message.
    BEGIN TRY
		SELECT CustomerId
			 , MemberId
			 , MemberType
             , IsEDLUser
			 , PrefixEN
			 , FirstNameEN
			 , LastNameEN
             , FullNameEN
			 , PrefixNative
			 , FirstNameNative
			 , LastNameNative
             , FullNameNative
			 , ObjectStatus
          FROM LogInView
         WHERE LOWER(UserName) = LOWER(LTRIM(RTRIM(@userName)))
           AND LOWER([Password]) = LOWER(LTRIM(RTRIM(@passWord)))
           AND LOWER(LangId) = LOWER(LTRIM(RTRIM(COALESCE(@langId, LangId))))
           AND LOWER(CustomerId) = LOWER(LTRIM(RTRIM(COALESCE(@customerId, CustomerId))))
         ORDER BY CustomerId, MemberId;

		SET @errNum = 0;
		SET @errMsg = N'success';
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO


/*********** Script Update Date: 2018-04-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	Init error messages.
-- [== History ==]
-- <2017-08-06> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
--exec InitErrorMessages
-- =============================================
CREATE PROCEDURE [dbo].[InitErrorMessages]
AS
BEGIN
    -- SUCCESS.
    EXEC SaveErrorMsg 0000, N'Success.'
    -- LANGUAGES.
    EXEC SaveErrorMsg 0101, N'Language Id cannot be null or empty string.'
    EXEC SaveErrorMsg 0102, N'Description(EN) cannot be null or empty string.'
    EXEC SaveErrorMsg 0103, N'Language Description (en) is duplicated.'
    -- MASTER PK.
    EXEC SaveErrorMsg 0201, N'Table Name is null or empty string.'
    EXEC SaveErrorMsg 0202, N'Seed Reset Mode should be number 1-3.'
    EXEC SaveErrorMsg 0203, N'Seed Digits should be number 1-9.'
    EXEC SaveErrorMsg 0204, N'Table name is not exists in MasterPK table.'
    EXEC SaveErrorMsg 0205, N'Not supports reset mode.'
    EXEC SaveErrorMsg 0206, N'Cannot generate seed code for table:'
    -- PERIOD UNITS.
    EXEC SaveErrorMsg 0301, N'PeriodUnit Id cannot be null.'
    EXEC SaveErrorMsg 0302, N'Description (default) cannot be null or empty string.'
    EXEC SaveErrorMsg 0303, N'Description (default) is duplicated.'
    EXEC SaveErrorMsg 0304, N'Description (ML) cannot be null or empty string.'
    EXEC SaveErrorMsg 0305, N'Cannot add new Description (ML) because the Description (ML) in same Language Id is already exists.'
    EXEC SaveErrorMsg 0306, N'Cannot change Description (ML) because the Description (ML) in same Language Id is already exists.'
    -- LIMIT UNITS.
    EXEC SaveErrorMsg 0401, N'LimitUnit Id cannot be null.'
    EXEC SaveErrorMsg 0402, N'Description (default) cannot be null or empty string.'
    EXEC SaveErrorMsg 0403, N'Description (default) is duplicated.'
    EXEC SaveErrorMsg 0404, N'UnitText (default) cannot be null or empty string.'
    EXEC SaveErrorMsg 0405, N'Language Id cannot be null or empty string.'
    EXEC SaveErrorMsg 0406, N'Language Id not found.'
    EXEC SaveErrorMsg 0407, N'Description (ML) cannot be null or empty string.'
    EXEC SaveErrorMsg 0408, N'Cannot add new Description (ML) because the Description (ML) in same Language Id is already exists.'
    EXEC SaveErrorMsg 0409, N'Cannot change Description (ML) because the Description (ML) in same Language Id is already exists.'
    -- USER INFO(S).
    EXEC SaveErrorMsg 0501, N'FirstName (default) cannot be null or empty string.'
    EXEC SaveErrorMsg 0502, N'UserName cannot be null or empty string.'
    EXEC SaveErrorMsg 0503, N'Password cannot be null or empty string.'
    EXEC SaveErrorMsg 0504, N'User Full Name (default) already exists.'
    EXEC SaveErrorMsg 0505, N'UserName already exists.'
    EXEC SaveErrorMsg 0506, N'Language Id cannot be null or empty string.'
    EXEC SaveErrorMsg 0507, N'The Language Id not exist.'
    EXEC SaveErrorMsg 0508, N'User Id cannot be null or empty string.'
    EXEC SaveErrorMsg 0509, N'FirstName (ML) cannot be null or empty string.'
    EXEC SaveErrorMsg 0510, N'No User match UserId.'
    EXEC SaveErrorMsg 0511, N'User Full Name (ML) already exists.'
    -- LICENSE TYPES.
    EXEC SaveErrorMsg 0601, N'Description (default) cannot be null or empty string.'
    EXEC SaveErrorMsg 0602, N'Advertise Text (default) cannot be null or empty string.'
    EXEC SaveErrorMsg 0603, N'PeriodUnitId cannot be null.'
    EXEC SaveErrorMsg 0604, N'PeriodUnitId not found.'
    EXEC SaveErrorMsg 0605, N'Number of Period cannot be null.'
    EXEC SaveErrorMsg 0606, N'Price cannot be null.'
    EXEC SaveErrorMsg 0607, N'Cannot add new item description because the description (default) is duplicated.'
    EXEC SaveErrorMsg 0608, N'Cannot change item description because the description (default) is duplicated.'
    EXEC SaveErrorMsg 0609, N'Cannot add new item because the period and number of period is duplicated.'
    EXEC SaveErrorMsg 0610, N'Cannot change item because the period and number of period is duplicated.'
    EXEC SaveErrorMsg 0611, N'LicenseTypeId cannot be null.'
    EXEC SaveErrorMsg 0612, N'Language Id cannot be null or empty string.'
    EXEC SaveErrorMsg 0613, N'Language Id not found.'    
    EXEC SaveErrorMsg 0614, N'Description (ML) cannot be null or empty string.'
    EXEC SaveErrorMsg 0615, N'Advertise Text (ML) cannot be null or empty string.'
    EXEC SaveErrorMsg 0616, N'Price (ML) cannot be null.'
    EXEC SaveErrorMsg 0617, N'Description (ML) is duplicated.'    
    -- LICENSE FEATURES.
    EXEC SaveErrorMsg 0701, N'LicenseType Id cannot be null.'
    EXEC SaveErrorMsg 0702, N'LicenseType Id not found.'
    EXEC SaveErrorMsg 0703, N'LimitUnit Id cannot be null.'
    EXEC SaveErrorMsg 0704, N'LimitUnit Id not found.'
    EXEC SaveErrorMsg 0705, N'LimitUnit Id already exists.'
    EXEC SaveErrorMsg 0706, N'No Of Limit cannot be null.'
    EXEC SaveErrorMsg 0707, N'No Of Limit should be zero or more.'
    EXEC SaveErrorMsg 0708, N'Invalid Seq Number.' 
    -- CUSTOMER PK.
    EXEC SaveErrorMsg 0801, N'CustomerId is null or empty string.'
    EXEC SaveErrorMsg 0802, N'Table Name is null or empty string.'
    EXEC SaveErrorMsg 0803, N'Seed Reset Mode should be number 1-4.'
    EXEC SaveErrorMsg 0804, N'Seed Digits should be number 1-9.'
    EXEC SaveErrorMsg 0805, N'Table Name not exists in CustomerPK table.'
    EXEC SaveErrorMsg 0806, N'Not supports reset mode.'
    EXEC SaveErrorMsg 0807, N'Cannot generate seed code for table:'    
    -- CUSTOMERS.
    EXEC SaveErrorMsg 0901, N'Customer Name (default) cannot be null or empty string.'
    EXEC SaveErrorMsg 0902, N'The Customer Id is not exists.'
    EXEC SaveErrorMsg 0903, N'Customer Name (default) is already exists.'
    EXEC SaveErrorMsg 0904, N'Customer Id cannot be null or empty string.'
    EXEC SaveErrorMsg 0905, N'Lang Id cannot be null or empty string.'
    EXEC SaveErrorMsg 0906, N'Lang Id not found.'
    EXEC SaveErrorMsg 0907, N'Customer Name (ML) cannot be null or empty string.'
    EXEC SaveErrorMsg 0908, N'Customer Name (ML) is already exist.'
    -- BRANCH.
    EXEC SaveErrorMsg 1001, N'Customer Id cannot be null or empty string.'
    EXEC SaveErrorMsg 1002, N'Branch Name (default) cannot be null or empty string.'
    EXEC SaveErrorMsg 1003, N'Customer Id is not found.'
    EXEC SaveErrorMsg 1004, N'Branch Id is not found.'
    EXEC SaveErrorMsg 1005, N'Branch Name (default) already exists.'
    EXEC SaveErrorMsg 1006, N'Lang Id cannot be null or empty string.'
    EXEC SaveErrorMsg 1007, N'Language Id not exist.'
    EXEC SaveErrorMsg 1008, N'Branch Id cannot be null or empty string.'
    EXEC SaveErrorMsg 1009, N'Branch Id is not found.'
    EXEC SaveErrorMsg 1010, N'Branch Name (ML) is already exists.'
    -- MEMBER INTO(S).
    EXEC SaveErrorMsg 1101, N'Customer Id cannot be null or empty string.'
    EXEC SaveErrorMsg 1102, N'Customer Id not found.'
    EXEC SaveErrorMsg 1103, N'First Name (default) cannot be null or empty string.'
    EXEC SaveErrorMsg 1104, N'User Name cannot be null or empty string.'
    EXEC SaveErrorMsg 1105, N'Password cannot be null or empty string.'
    EXEC SaveErrorMsg 1106, N'MemberType cannot be null.'
    EXEC SaveErrorMsg 1107, N'MemberType allow only value 200 admin, 210 exclusive, 280 staff, 290 Device.'
    EXEC SaveErrorMsg 1108, N'Member Full Name (default) already exists.'
    EXEC SaveErrorMsg 1109, N'User Name already exists.'
    EXEC SaveErrorMsg 1110, N'Member Id is not found.'
    EXEC SaveErrorMsg 1111, N'IDCard is already exists.'
    EXEC SaveErrorMsg 1112, N'Employee Code is already exists.'
    EXEC SaveErrorMsg 1113, N'TagId is already exists.'
    EXEC SaveErrorMsg 1114, N'Lang Id cannot be null or empty string.'
    EXEC SaveErrorMsg 1115, N'Lang Id not exist.'
    EXEC SaveErrorMsg 1116, N'Member Id cannot be null or empty string.'
    EXEC SaveErrorMsg 1117, N'No Member match MemberId in specificed Customer Id.'
    EXEC SaveErrorMsg 1118, N'Member Full Name (ML) already exists.'
    -- ORGS.
    EXEC SaveErrorMsg 1201, N'Customer Id cannot be null or empty string.'
    EXEC SaveErrorMsg 1202, N'Customer Id not found.'
    EXEC SaveErrorMsg 1203, N'Branch Id cannot be null or empty string.'
    EXEC SaveErrorMsg 1204, N'Branch Id not found.'
    EXEC SaveErrorMsg 1205, N'The Root Org already assigned.'
    EXEC SaveErrorMsg 1206, N'The Parent Org Id is not found.'
    EXEC SaveErrorMsg 1207, N'Org Name (default) cannot be null or empty string.'
    EXEC SaveErrorMsg 1208, N'Org Name (default) already exists.'
    EXEC SaveErrorMsg 1209, N'Lang Id cannot be null or empty string.'
    EXEC SaveErrorMsg 1210, N'Lang Id not found.'
    EXEC SaveErrorMsg 1211, N'Customer Id cannot be null or empty string.'
    EXEC SaveErrorMsg 1212, N'Customer Id not found.'
    EXEC SaveErrorMsg 1213, N'Org Id cannot be null or empty string.'
    EXEC SaveErrorMsg 1214, N'No Org match Org Id in specificed Customer Id.'
    EXEC SaveErrorMsg 1215, N'Org Name (ML) already exists.'
    -- DEVICES.

    -- QSETS.

    -- QSLIDES.

    -- QSLIDEITEMS.

    -- VOTES.
    EXEC SaveErrorMsg 1701, N'Customer Id cannot be null or empty string.'
    EXEC SaveErrorMsg 1702, N'Customer Id not found.'
    EXEC SaveErrorMsg 1703, N'Branch Id cannot be null or empty string.'
    EXEC SaveErrorMsg 1704, N'Branch Id not found.'
    EXEC SaveErrorMsg 1705, N'Org Id cannot be null or empty string.'
    EXEC SaveErrorMsg 1706, N'Org Id not found.'
    EXEC SaveErrorMsg 1707, N'QSet Id cannot be null or empty string.'
    EXEC SaveErrorMsg 1708, N'QSet Id not found.'

END

GO


/*********** Script Update Date: 2018-04-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	Init supports languages
-- [== History ==]
-- <2017-08-06> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
--exec InitLanguages
-- =============================================
CREATE PROCEDURE [dbo].[InitLanguages]
AS
BEGIN
    /*
    EXEC SaveLanguage N'', N'', N'', N'', 1, 1
    */
    EXEC SaveLanguage N'EN', N'US', N'English', N'English', 1, 1
    EXEC SaveLanguage N'TH', N'TH', N'Thai', N'ไทย', 2, 1
    EXEC SaveLanguage N'ZH', N'CN', N'Chinese', N'中文', 3, 1
    EXEC SaveLanguage N'JA', N'JP', N'Japanese', N'中文', 4, 1
    EXEC SaveLanguage N'DE', N'DE', N'German', N'Deutsche', 5, 0
    EXEC SaveLanguage N'FR', N'FR', N'French', N'français', 6, 0
    EXEC SaveLanguage N'KO', N'KR', N'Korean', N'한국어', 7, 1
    EXEC SaveLanguage N'RU', N'RU', N'Russian', N'Россия', 8, 0
    EXEC SaveLanguage N'ES', N'ES', N'Spanish', NULL, 9, 1
END

GO


/*********** Script Update Date: 2018-04-26  ***********/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	Init Init Period Units.
-- [== History ==]
-- <2017-08-06> :
--	- Stored Procedure Created.
-- <2018-04-16> :
--	- replace insert with sp call.
--
-- [== Example ==]
--
--exec InitPeriodUnits
-- =============================================
CREATE PROCEDURE [dbo].[InitPeriodUnits]
AS
BEGIN
    EXEC SavePeriodUnit 1, N'day'
    EXEC SavePeriodUnit 2, N'month'
    EXEC SavePeriodUnit 3, N'year'

	-- [ENGLISH]
    EXEC SavePeriodUnitML 1, N'EN', N'day'
    EXEC SavePeriodUnitML 2, N'EN', N'month'
    EXEC SavePeriodUnitML 3, N'EN', N'year'
	-- [THAI]
    EXEC SavePeriodUnitML 1, N'TH', N'วัน'
    EXEC SavePeriodUnitML 2, N'TH', N'เดือน'
    EXEC SavePeriodUnitML 3, N'TH', N'ปี'
	-- [CHINESE]
	EXEC SavePeriodUnitML 1, N'ZH', N'天'
	EXEC SavePeriodUnitML 2, N'ZH', N'月'
	EXEC SavePeriodUnitML 3, N'ZH', N'年'
	-- [JAPANESE]
	EXEC SavePeriodUnitML 1, N'JA', N'日'
	EXEC SavePeriodUnitML 2, N'JA', N'月'
	EXEC SavePeriodUnitML 3, N'JA', N'年'
	-- [GERMAN]
	EXEC SavePeriodUnitML 1, N'DE', N'Tag'
	EXEC SavePeriodUnitML 2, N'DE', N'Monat'
	EXEC SavePeriodUnitML 3, N'DE', N'Jahr'
	-- [FRENCH]
	EXEC SavePeriodUnitML 1, N'FR', N'jour'
	EXEC SavePeriodUnitML 2, N'FR', N'mois'
	EXEC SavePeriodUnitML 3, N'FR', N'an'
	-- [KOREAN]
	EXEC SavePeriodUnitML 1, N'KO', N'일'
	EXEC SavePeriodUnitML 2, N'KO', N'달'
	EXEC SavePeriodUnitML 3, N'KO', N'년'
END

GO


/*********** Script Update Date: 2018-04-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	Init Member Types.
-- [== History ==]
-- <2017-08-06> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
--exec InitMemberTypesS
-- =============================================
CREATE PROCEDURE [dbo].[InitMemberTypes]
AS
BEGIN
	-- [EDL - ADMIN]
	INSERT INTO MemberType VALUES (100, N'EDL - Admin')
	-- [EDL - POWER USER]
	INSERT INTO MemberType VALUES (110, N'EDL - Power User')
	-- [EDL - STAFF]
	INSERT INTO MemberType VALUES (180, N'EDL - Staff')
	-- [CUSTOMER - ADMIN]
	INSERT INTO MemberType VALUES (200, N'Admin')
	-- [CUSTOMER - EXCLUSIVE]
	INSERT INTO MemberType VALUES (210, N'Exclusive')
	-- [CUSTOMER - STAFF]
	INSERT INTO MemberType VALUES (280, N'Staff')
	-- [CUSTOMER - DEVICE]
	INSERT INTO MemberType VALUES (290, N'Device')

	-- [ENGLISH]
	INSERT INTO MemberTypeML VALUES(100, N'EN', N'EDL - Admin');
	INSERT INTO MemberTypeML VALUES(110, N'EN', N'EDL - Power User');
	INSERT INTO MemberTypeML VALUES(180, N'EN', N'EDL - Staff');
	INSERT INTO MemberTypeML VALUES(200, N'EN', N'Admin');
	INSERT INTO MemberTypeML VALUES(210, N'EN', N'Exclusive');
	INSERT INTO MemberTypeML VALUES(280, N'EN', N'Staff');
	INSERT INTO MemberTypeML VALUES(290, N'EN', N'Device');
	-- [THAI]
	INSERT INTO MemberTypeML VALUES(100, N'TH', N'อีดีแอล - ผู้ดูแลระบบ');
	INSERT INTO MemberTypeML VALUES(110, N'TH', N'อีดีแอล - เจ้าหน้าที่ระดับควบคุม');
	INSERT INTO MemberTypeML VALUES(180, N'TH', N'อีดีแอล - เจ้าหน้าที่ปฏิบัติการ');
	INSERT INTO MemberTypeML VALUES(200, N'TH', N'ผู้ดูแลระบบ');
	INSERT INTO MemberTypeML VALUES(210, N'TH', N'ผู้บริหาร');
	INSERT INTO MemberTypeML VALUES(280, N'TH', N'เจ้าหน้าที่ปฏิบัติการ');
	INSERT INTO MemberTypeML VALUES(290, N'TH', N'อุปกรณ์');
	-- [CHINESE]
	INSERT INTO MemberTypeML VALUES(100, N'ZH', N'EDL - 管理员');
	INSERT INTO MemberTypeML VALUES(110, N'ZH', N'EDL - 管理者');
	INSERT INTO MemberTypeML VALUES(180, N'ZH', N'EDL - 员工');
	INSERT INTO MemberTypeML VALUES(200, N'ZH', N'管理员');
	INSERT INTO MemberTypeML VALUES(210, N'ZH', N'管理者');
	INSERT INTO MemberTypeML VALUES(280, N'ZH', N'员工');
	INSERT INTO MemberTypeML VALUES(290, N'ZH', N'设备');
	-- [JAPANESE]
	INSERT INTO MemberTypeML VALUES(100, N'JA', N'EDL - 支配人');
	INSERT INTO MemberTypeML VALUES(110, N'JA', N'EDL - 監督');
	INSERT INTO MemberTypeML VALUES(180, N'JA', N'EDL - 職員');
	INSERT INTO MemberTypeML VALUES(200, N'JA', N'支配人');
	INSERT INTO MemberTypeML VALUES(210, N'JA', N'監督');
	INSERT INTO MemberTypeML VALUES(280, N'JA', N'職員');
	INSERT INTO MemberTypeML VALUES(290, N'JA', N'デバイス');
	-- [GERMAN]
	INSERT INTO MemberTypeML VALUES(100, N'DE', N'EDL - Administrator');
	INSERT INTO MemberTypeML VALUES(110, N'DE', N'EDL - Aufsicht');
	INSERT INTO MemberTypeML VALUES(180, N'DE', N'EDL - Belegschaft');
	INSERT INTO MemberTypeML VALUES(200, N'DE', N'Administrator');
	INSERT INTO MemberTypeML VALUES(210, N'DE', N'Exklusiv');
	INSERT INTO MemberTypeML VALUES(280, N'DE', N'Belegschaft');
	INSERT INTO MemberTypeML VALUES(290, N'DE', N'Device');
	-- [FRENCH]
	INSERT INTO MemberTypeML VALUES(100, N'FR', N'EDL - Administrateur');
	INSERT INTO MemberTypeML VALUES(110, N'FR', N'EDL - Superviseur');
	INSERT INTO MemberTypeML VALUES(180, N'FR', N'EDL - Personnel');
	INSERT INTO MemberTypeML VALUES(200, N'FR', N'Administrateur');
	INSERT INTO MemberTypeML VALUES(210, N'FR', N'Exclusif');
	INSERT INTO MemberTypeML VALUES(280, N'FR', N'Personnel');
	INSERT INTO MemberTypeML VALUES(290, N'FR', N'Appareil');
	-- [KOREAN]
	INSERT INTO MemberTypeML VALUES(100, N'KO', N'EDL - 관리자');
	INSERT INTO MemberTypeML VALUES(110, N'KO', N'EDL - 감독자');
	INSERT INTO MemberTypeML VALUES(180, N'KO', N'EDL - 직원');
	INSERT INTO MemberTypeML VALUES(200, N'KO', N'관리자');
	INSERT INTO MemberTypeML VALUES(210, N'KO', N'감독자');
	INSERT INTO MemberTypeML VALUES(280, N'KO', N'직원');
	INSERT INTO MemberTypeML VALUES(290, N'KO', N'장치');
END

GO


/*********** Script Update Date: 2018-04-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	Init Init Limit Units.
-- [== History ==]
-- <2017-08-06> :
--	- Stored Procedure Created.
-- <2018-04-16> :
--	- replace insert with sp call.
--
-- [== Example ==]
--
--exec InitLimitUnits
-- =============================================
CREATE PROCEDURE [dbo].[InitLimitUnits]
AS
BEGIN
	/* DEFAULT LIMIT UNITS. */
    EXEC SaveLimitUnit 1, N'Number of Device(s)', N'device(s)'
    EXEC SaveLimitUnit 2, N'Number of User(s)', N'user(s)'
    EXEC SaveLimitUnit 3, N'Number of Client(s)', N'client(s)'

	/* [== ENGLISH ==] */
	EXEC SaveLimitUnitML 1, N'EN', N'Number of Device(s)', N'device(s)'
	EXEC SaveLimitUnitML 2, N'EN', N'Number of User(s)', N'user(s)'
	EXEC SaveLimitUnitML 3, N'EN', N'Number of Client(s)', N'client(s)'
	/* [== THAI ==] */
	EXEC SaveLimitUnitML 1, N'TH', N'จำนวนเครื่อง', N'เครื่อง'
	EXEC SaveLimitUnitML 2, N'TH', N'จำนวนบัญชีผู้ใช้', N'คน'
	EXEC SaveLimitUnitML 3, N'TH', N'จำนวนจุดติดตั้ง', N'จุด'
	/* [== JAPANESE ==] */
	EXEC SaveLimitUnitML 1, N'JA', N'番号', N'デバイス'
	EXEC SaveLimitUnitML 2, N'JA', N'ユーザー数', N'人'
	EXEC SaveLimitUnitML 3, N'JA', N'同時ユーザー', N'ポイント'
END

GO


/*********** Script Update Date: 2018-04-26  ***********/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: InitLicenseTypes.
-- Description:	Init Init License Types.
-- [== History ==]
-- <2017-08-06> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
--exec InitLicenseTypes
-- =============================================
CREATE PROCEDURE [dbo].[InitLicenseTypes]
AS
BEGIN
DECLARE @id0 int;
DECLARE @id1 int;
DECLARE @id2 int;
DECLARE @id3 int;
	/* DELETE FIRST */
	DELETE FROM LicenseTypeML;
	DELETE FROM LicenseType;

	SET @id0 = 0
	SET @id1 = 1
	SET @id2 = 2
	SET @id3 = 3
	
	-- [DAY]
	INSERT INTO LicenseType VALUES (@id0, N'Trial', N'Free Full Functional', 1, 15, 0.00, N'฿', N'BAHT')
	-- [MONTH]
	INSERT INTO LicenseType VALUES (@id1, N'Monthly', N'Save 33% with full functions', 2, 1, 55.99, N'฿', N'BAHT')
	-- [6 Months]
	INSERT INTO LicenseType VALUES (@id2, N'6 Months', N'Save 40% with full functions', 2, 6, 315.99, N'฿', N'BAHT')
	-- [YEAR]
	INSERT INTO LicenseType VALUES (@id3, N'Yearly', N'Save 60% with full functions', 3, 1, 420.99, N'฿', N'BAHT')

	-- [ENGLISH]
	EXEC SaveLicenseTypeML @id0, N'EN', N'Trial', N'Free Full Functional', 0.00
	EXEC SaveLicenseTypeML @id1, N'EN', N'Monthly', N'Save 33% with full functions', 55.99
	EXEC SaveLicenseTypeML @id2, N'EN', N'6 Months', N'Save 40% with full functions', 315.99
	EXEC SaveLicenseTypeML @id3, N'EN', N'Yearly', N'Save 60% with full functions', 420.99
	-- [THAI]
	EXEC SaveLicenseTypeML @id0, N'TH', N'ทดลองใช้', N'ทดลองใช้ฟรี ทุกฟังก์ชั่น', 0.00, N'฿', N'บาท'
	EXEC SaveLicenseTypeML @id1, N'TH', N'รายเดือน', N'ประหยัดทันที 33% พร้อมใช้งานทุกฟังก์ชั่น', 2000.00, N'฿', N'บาท'
	EXEC SaveLicenseTypeML @id2, N'TH', N'6 เดือน', N'ประหยัดทันที 40% พร้อมใช้งานทุกฟังก์ชั่น', 10800.00, N'฿', N'บาท'
	EXEC SaveLicenseTypeML @id3, N'TH', N'รายปี', N'ประหยัดทันที 60% พร้อมใช้งานทุกฟังก์ชั่น', 14400.00, N'฿', N'บาท'
	-- [CHINESE]
	EXEC SaveLicenseTypeML @id0, N'ZH', N'审讯', N'免费试用 所有可用的功能', NULL
	EXEC SaveLicenseTypeML @id1, N'ZH', N'每月一次', N'ประหยัดทันที 33% 所有可用的功能', NULL
	EXEC SaveLicenseTypeML @id2, N'ZH', N'6个月', N'ประหยัดทันที 40% 所有可用的功能', NULL
	EXEC SaveLicenseTypeML @id3, N'ZH', N'每年', N'ประหยัดทันที 60% 所有可用的功能', NULL
	-- [JAPANESE]
	EXEC SaveLicenseTypeML @id0, N'JA', N'実験', N'無料体験. すべての利用可能な機能', NULL
	EXEC SaveLicenseTypeML @id1, N'JA', N'毎月', N'33％を保存. すべての利用可能な機能', NULL
	EXEC SaveLicenseTypeML @id2, N'JA', N'6 毎月', N'40％を保存. すべての利用可能な機能', NULL
	EXEC SaveLicenseTypeML @id3, N'JA', N'毎年', N'60％を保存. すべての利用可能な機能', NULL
	-- [GERMAN]
	EXEC SaveLicenseTypeML @id0, N'DE', N'Versuch', N'Voll funktionsfähige Prüfung. Alle verfügbaren Funktionen.', NULL
	EXEC SaveLicenseTypeML @id1, N'DE', N'monatlich', N'Sparen Sie 33%. Alle verfügbaren Funktionen.', NULL
	EXEC SaveLicenseTypeML @id2, N'DE', N'6 monatlich', N'Sparen Sie 40%. Alle verfügbaren Funktionen.', NULL
	EXEC SaveLicenseTypeML @id3, N'DE', N'jährlich', N'Sparen Sie 60%. Alle verfügbaren Funktionen.', NULL
	-- [FRENCH]
	EXEC SaveLicenseTypeML @id0, N'FR', N'épreuve', N'Complètement fonctionnel. Toutes les fonctions disponibles', NULL
	EXEC SaveLicenseTypeML @id1, N'FR', N'mensuel', N'Économisez 33% Toutes les fonctions disponibles', NULL
	EXEC SaveLicenseTypeML @id2, N'FR', N'6 mensuel', N'Économisez 40% Toutes les fonctions disponibles', NULL
	EXEC SaveLicenseTypeML @id3, N'FR', N'annuel', N'Économisez 60% Toutes les fonctions disponibles', NULL
	-- [KOREAN]
	EXEC SaveLicenseTypeML @id0, N'KO', N'공판', N'완전 기능 시험 사용 가능한 모든 기능을합니다.', NULL
	EXEC SaveLicenseTypeML @id1, N'KO', N'월', N'33 % 절감 사용 가능한 모든 기능을합니다.', NULL
	EXEC SaveLicenseTypeML @id2, N'KO', N'6 월', N'40 % 절감 사용 가능한 모든 기능을합니다.', NULL
	EXEC SaveLicenseTypeML @id3, N'KO', N'매년', N'50 % 절감 사용 가능한 모든 기능을합니다.', NULL
END

GO


/*********** Script Update Date: 2018-04-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: InitLicenseFeatures.
-- Description:	Init InitLicense Features.
-- [== History ==]
-- <2017-08-06> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
--exec InitLicenseFeatures
-- =============================================
CREATE PROCEDURE [dbo].[InitLicenseFeatures]
AS
BEGIN
    -- DELETE FIRST.
    DELETE FROM LicenseFeature

	/* Trial */
	INSERT INTO LicenseFeature
		VALUES (0, 1, 1, 1);
	INSERT INTO LicenseFeature
		VALUES (0, 2, 2, 1);
	INSERT INTO LicenseFeature
		VALUES (0, 3, 3, 1);
	/* Monthly */
	INSERT INTO LicenseFeature
		VALUES (1, 1, 1, 5);
	INSERT INTO LicenseFeature
		VALUES (1, 2, 2, 10);
	INSERT INTO LicenseFeature
		VALUES (1, 3, 3, 10);

	/* 6 Months */
	INSERT INTO LicenseFeature
		VALUES (2, 1, 1, 5);
	INSERT INTO LicenseFeature
		VALUES (2, 2, 2, 10);
	INSERT INTO LicenseFeature
		VALUES (2, 3, 3, 10);

	/* Yearly */
	INSERT INTO LicenseFeature
		VALUES (3, 1, 1, 10);
	INSERT INTO LicenseFeature
		VALUES (3, 2, 2, 20);
	INSERT INTO LicenseFeature
		VALUES (3, 3, 3, 20);
END

GO

/*********** Script Update Date: 2018-04-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	Init Default user for EDL and add related reset all generate id for PK.
-- [== History ==]
-- <2016-10-30> :
--	- Stored Procedure Created.
-- <2017-06-07> :
--	- Remove Auto Create EDL Admin User. Need to call manually.
--
-- [== Example ==]
--
--exec InitMasterPKs
-- =============================================
CREATE PROCEDURE [dbo].[InitMasterPKs] (
  @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
	BEGIN TRY
		-- For EDL
		exec SetMasterPK N'UserInfo', 1, 'EDL-U', 3;
		-- For Customer
		exec SetMasterPK N'Customer', 2, 'EDL-C', 4;

		IF (@errNum <> 0)
		BEGIN
			RETURN
		END
		SET @errNum = 0;
		SET @errMsg = N'success';
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO


/*********** Script Update Date: 2018-04-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: InitDefaultUser.
-- Description:	Init Init Default User.
-- [== History ==]
-- <2017-08-06> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
--exec InitDefaultUser
-- =============================================
CREATE PROCEDURE [dbo].[InitDefaultUser]
AS
BEGIN
	DECLARE @errNum int = null;
	DECLARE @errMsg nvarchar(MAX) = null;
	DECLARE @userId nvarchar(30);
	EXEC SaveUserInfo N'The', N'EDL', N'Administrator', N'raterweb2-admin@edl.co.th', N'1234', 100--, @userId out, @errNum out, @errMsg out;
	--SELECT @userId AS userId, @errNum AS ErrNum, @errMsg AS ErrMsg;
	EXEC SaveUserInfoML @userId, N'TH', N'[', N'แอดมิน', N']'--, @errNum out, @errMsg out;
	--SELECT @userId AS userId, @errNum AS ErrNum, @errMsg AS ErrMsg;
END

GO


/*********** Script Update Date: 2018-04-26  ***********/
GO
/****** Object:  StoredProcedure [dbo].[InitAll]    Script Date: 4/26/2018 22:40:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	Init All required data.
-- [== History ==]
-- <2017-08-06> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
--exec InitAll
-- =============================================
CREATE PROCEDURE [dbo].[InitAll]
AS
BEGIN
    EXEC InitErrorMessages;
    EXEC InitLanguages;
    EXEC InitMemberTypes;
    EXEC InitPeriodUnits;
    EXEC InitLimitUnits;
    EXEC InitLicenseTypes;
    EXEC InitLicenseFeatures;
    EXEC InitMasterPKs;
    EXEC InitDefaultUser;
END

GO

