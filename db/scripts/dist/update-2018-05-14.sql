/*********** Script Update Date: 2018-05-14  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

DROP TABLE [dbo].[QSet]
GO

CREATE TABLE [dbo].[QSet](
	[QSetId] [nvarchar](30) NOT NULL,
	[CustomerId] [nvarchar](30) NOT NULL,
	[Description] [nvarchar](max) NOT NULL,
	[HasRemark] [bit] NOT NULL,
	[DisplayMode] [tinyint] NOT NULL,
	[IsDefault] [bit] NOT NULL,
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

ALTER TABLE [dbo].[QSet] ADD  CONSTRAINT [DF_QSet_IsDefault]  DEFAULT ((0)) FOR [IsDefault]
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

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'1 to set as default Question Set.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'QSet', @level2type=N'COLUMN',@level2name=N'IsDefault'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The begin date.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'QSet', @level2type=N'COLUMN',@level2name=N'BeginDate'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The end date.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'QSet', @level2type=N'COLUMN',@level2name=N'EndDate'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 - Inactive, 1 - Active' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'QSet', @level2type=N'COLUMN',@level2name=N'ObjectStatus'
GO


/*********** Script Update Date: 2018-05-14  ***********/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	Get Vote Summaries.
-- [== History ==]
-- <2017-04-12> :
--	- Stored Procedure Created.
-- <2018-05-10> :
--	- Changes code supports unlimited choices.
--	- Add Remark count.
--	- Add langId parameter.
-- <2018-05-13> :
--  - Add QSetId, QSeq in result query.
--
-- [== Example ==]
--
--EXEC GetVoteSummaries NULL, N'EDL-C2017050001', N'QS00001', 1, '2017-01-01', '2017-12-31', null, null, null
--EXEC GetVoteSummaries  N'TH', N'EDL-C2017050001', N'QS00001', 1, '2017-01-01', '2017-12-31', N'O0001', null, null
-- =============================================
ALTER PROCEDURE [dbo].[GetVoteSummaries] (
  @langId as nvarchar(3)
, @customerId as nvarchar(30)
, @qSetId as nvarchar(30)
, @qSeq as int
, @BeginDate As DateTime = null
, @EndDate As DateTime = null
, @orgId as nvarchar(30) = null
, @deviceId as nvarchar(50) = null
, @userId as nvarchar(30) = null
, @errNum as int = 0 out
, @errMsg as nvarchar(100) = N'' out)
AS
BEGIN
DECLARE @ShowOutput bit = 0;
DECLARE @branchId nvarchar(30);
	-- Error Code:
	--    0 : Success
	-- 2001 : CustomerId cannot be null or empty string.
	-- 2002 : QSetId cannot be null or empty string.
	-- 2003 : QSeq cannot be null.
	-- 2004 : The default OrgId not found.
	-- 2005 : The BranchId not found.
	-- 2006 : 
	-- OTHER : SQL Error Number & Error Message.

	CREATE TABLE #VOTEDATA
	(
		VoteValue tinyint,
		TotalVote Int,
		TotalXCount int,
		TotalRemark Int
	) 

	CREATE TABLE #VOTESUM
	(
		Choice int,				-- choice value.
		Cnt int,				-- count = current choice count.
		Pct decimal(18, 2),		-- percent = (current choice count * 100 / overall choices count).
		RemarkCnt int,			-- Remark count.
		MaxChoice tinyint,		-- max choice value.
		TotCnt int,				-- Total count -> overall choices count.
		TotCntXChoice int,		-- Total count * choice value. (for internal calc).
		AvgPct decimal(18, 2),	-- Choice Average Percent
		AvgTot decimal(18, 2),	-- Choice Average Total = (TotCntXChoice / TotCnt).
		CustomerId nvarchar(30) COLLATE DATABASE_DEFAULT,
		BranchId nvarchar(30) COLLATE DATABASE_DEFAULT,
		OrgId nvarchar(30) COLLATE DATABASE_DEFAULT,
		UserId nvarchar(30) COLLATE DATABASE_DEFAULT,
		DeviceId nvarchar(50) COLLATE DATABASE_DEFAULT,
		QSetId nvarchar(30) COLLATE DATABASE_DEFAULT,
		QSeq int
	)

	BEGIN TRY
		IF (dbo.IsNullOrEmpty(@customerId) = 1)
		BEGIN
			EXEC GetErrorMsg 2001, @errNum out, @errMsg out
			RETURN
		END
		IF (dbo.IsNullOrEmpty(@qSetId) = 1)
		BEGIN
			EXEC GetErrorMsg 2002, @errNum out, @errMsg out
			RETURN
		END
		IF (@qSeq IS NULL)
		BEGIN
			EXEC GetErrorMsg 2003, @errNum out, @errMsg out
			RETURN
		END

		IF (dbo.IsNullOrEmpty(@orgId) = 1)
		BEGIN
			-- OrgID not exist so find root org id and branch id.
			SELECT @orgId = OrgId
				 , @branchId = BranchId
			  FROM Org
			 WHERE LOWER(LTRIM(RTRIM(CustomerId))) = LOWER(LTRIM(RTRIM(@customerId)))
			   AND ParentId IS NULL
		END
		ELSE
		BEGIN
			-- OrgID exist so find branch id.
			SELECT @branchId = BranchId
			  FROM Org
			 WHERE LOWER(LTRIM(RTRIM(CustomerId))) = LOWER(LTRIM(RTRIM(@customerId)))
			   AND LOWER(LTRIM(RTRIM(OrgId))) = LOWER(LTRIM(RTRIM(@orgId)))
		END
		
		IF (dbo.IsNullOrEmpty(@orgId) = 1)
		BEGIN
			EXEC GetErrorMsg 2004, @errNum out, @errMsg out
			RETURN
		END

		IF (dbo.IsNullOrEmpty(@branchId) = 1)
		BEGIN
			EXEC GetErrorMsg 2005, @errNum out, @errMsg out
			RETURN
		END

		DECLARE @sqlCommand as nvarchar(MAX);

		EXEC __BuildTotalVoteCountQuery @customerId
									  , @qsetId, @qSeq
									  , @beginDate, @endDate
									  , @orgId, @deviceId, @userId
									  , @sqlCommand output

		--SELECT @sqlCommand;
		INSERT INTO #VOTEDATA EXECUTE sp_executesql @sqlCommand -- Insert into temp table

		DECLARE @iChoice tinyint;
		DECLARE @iCnt int;
		DECLARE @maxChoice as tinyint;
		DECLARE @decimalPlaces as int = 2;

		DECLARE @totalCount int;
		DECLARE @totalXCount int;

		--SELECT @maxChoice = COUNT(*)
		--  FROM QSlideItem
		-- WHERE QSetId = @qSetId
		--   AND QSeq = @qSeq
		--   AND CustomerId = @customerId
		--   AND ObjectStatus = 1
		
		SET @maxChoice = 4; -- Fake max choice.

		SET @iChoice = 1;
		WHILE (@iChoice <= @maxChoice)
		BEGIN
			SELECT @iCnt = COUNT(*) 
			  FROM #VOTEDATA 
			 WHERE VoteValue = @iChoice;
			IF (@iCnt IS NULL OR @iCnt = 0)
			BEGIN
				INSERT INTO #VOTEDATA(
					  VoteValue
					, TotalVote
					, TotalRemark)
				VALUES(
					  @iChoice
					, 0
					, 0);
			END
			SET @iChoice = @iChoice + 1; -- increase.
		END


		SELECT @totalCount = SUM(TotalVote)
		     , @totalXCount = SUM(TotalXCount)
		  FROM #VOTEDATA;

		-- Insert Non calc values.
		INSERT INTO #VOTESUM
		(
			 CustomerID
			,BranchID
			,OrgID
			,UserId
			,DeviceId
			,QSetId
			,QSeq
			,MaxChoice
			,TotCnt
			,TotCntXChoice
			,Choice
			,Cnt
			,RemarkCnt
		)
		SELECT @customerId AS CustomerId
			 , @branchId AS BranchId
			 , @orgId AS OrgId
			 , @userId AS UserId
			 , @deviceId AS DeviceId
			 , @qSetId AS QSetId
			 , @qSeq AS QSeq
			 , @maxChoice AS MaxChoice
			 , @totalCount AS TotCnt
			 , @totalXCount AS TotCntXChoice
			 , VoteValue AS Choice
			 , TotalVote AS Cnt
			 , TotalRemark AS RemarkCnt
		  FROM #VOTEDATA;

		-- Update Calc Percent value, Total avarage.
		UPDATE #VOTESUM
		   SET Pct = vd.Pct
		     , AvgTot = vd.AvgTot
			 , AvgPct = vd.AvgPct
		  FROM (
			SELECT t1.Choice
			     , t2.Pct
				 , t2.AvgTot
				 , ROUND((100 / Convert(decimal(18,2), MaxChoice)) * t2.AvgTot, @decimalPlaces) AS AvgPct
				FROM #VOTESUM t1 INNER JOIN 
				(
					SELECT Choice
						 , ROUND(Convert(decimal(18,2), (Cnt * 100)) / Convert(decimal(18,2), TotCnt), @decimalPlaces) AS Pct
						 , ROUND(Convert(decimal(18,2), TotCntXChoice) / Convert(decimal(18,2), TotCnt), @decimalPlaces) AS AvgTot
					  FROM #VOTESUM
				) AS t2 ON t2.Choice = t1.Choice
		  ) AS vd
		 WHERE vd.Choice = #VOTESUM.Choice

		-- SUCCESS
		EXEC GetErrorMsg 0, @errNum out, @errMsg out
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH

	IF (dbo.IsNullOrEmpty(@userId) = 1)
	BEGIN
		SELECT vs.Choice
			 , vs.Cnt
			 , vs.Pct
			 , vs.RemarkCnt
			 , vs.MaxChoice
			 , vs.TotCnt
			 , vs.AvgPct
			 , vs.AvgTot
			 , lgv.LangId
			 , vs.CustomerId
			 , cmlv.CustomerNameEN
			 , cmlv.CustomerNameNative
			 , vs.BranchId
			 , omlv.BranchNameEN
			 , omlv.BranchNameNative
			 , vs.OrgId
			 , omlv.ParentId
			 , omlv.OrgNameEN
			 , omlv.OrgNameNative
			 , vs.QSetId
			 , vs.QSeq
			 , vs.UserId
			 , NULL AS FullNameEN
			 , NULL AS FullNameNative
			 , vs.DeviceId
		  FROM #VOTESUM as vs
			 , LanguageView lgv
			 , CustomerMLView cmlv
			 , OrgMLView omlv
			 --, LogInView lmlv
		 WHERE lgv.LangId = COALESCE(@langId, lgv.LangId)
		   AND lgv.Enabled = 1
		   AND cmlv.CustomerId = vs.CustomerId
		   AND cmlv.LangId = lgv.LangId
		   AND omlv.CustomerId = vs.CustomerId
		   AND omlv.OrgId = vs.OrgId 
		   AND omlv.LangId = lgv.LangId
		   --AND lmlv.CustomerId = COALESCE(@customerId, omlv.CustomerId) 
		   --AND lmlv.MemberId = COALESCE(@userId, lmlv.MemberId)
		   --AND lmlv.LangId = lgv.LangId
		 ORDER BY lgv.SortOrder, vs.QSetId, vs.QSeq, vs.Choice
	END
	ELSE
	BEGIN
		SELECT vs.Choice
			 , vs.Cnt
			 , vs.Pct
			 , vs.RemarkCnt
			 , vs.MaxChoice
			 , vs.TotCnt
			 , vs.AvgPct
			 , vs.AvgTot
			 , lgv.LangId
			 , vs.CustomerId
			 , cmlv.CustomerNameEN
			 , cmlv.CustomerNameNative
			 , vs.BranchId
			 , omlv.BranchNameEN
			 , omlv.BranchNameNative
			 , vs.OrgId
			 , omlv.ParentId
			 , omlv.OrgNameEN
			 , omlv.OrgNameNative
			 , vs.QSetId
			 , vs.QSeq
			 , vs.UserId
			 , lmlv.FullNameEN
			 , lmlv.FullNameNative
			 , vs.DeviceId
		  FROM #VOTESUM as vs
			 , LanguageView lgv
			 , CustomerMLView cmlv
			 , OrgMLView omlv
			 , LogInView lmlv
		 WHERE lgv.LangId = COALESCE(@langId, lgv.LangId)
		   AND lgv.Enabled = 1
		   AND cmlv.CustomerId = vs.CustomerId
		   AND cmlv.LangId = lgv.LangId
		   AND omlv.CustomerId = vs.CustomerId
		   AND omlv.OrgId = vs.OrgId 
		   AND omlv.LangId = lgv.LangId
		   AND lmlv.CustomerId = COALESCE(@customerId, omlv.CustomerId) 
		   AND lmlv.MemberId = COALESCE(@userId, lmlv.MemberId)
		   AND lmlv.LangId = lgv.LangId
		 ORDER BY lgv.SortOrder, vs.QSetId, vs.QSeq, vs.Choice
	END

	DROP TABLE #VOTESUM
	DROP TABLE #VOTEDATA
END

GO


/*********** Script Update Date: 2018-05-14  ***********/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: SaveQSet.
-- Description:	Save Question Set.
-- [== History ==]
-- <2018-05-13> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
--exec SaveQSet N'EDL-C2017010001', N'Softbase'
--exec SaveQSet N'EDL-C2017010001', N'Services', N'B0001'
-- =============================================
CREATE PROCEDURE [dbo].[SaveQSet] (
  @customerId as nvarchar(30)
, @description as nvarchar(MAX)
, @hasRemark as bit = 0
, @displayMode as tinyint = 0
, @isDefault as bit = 0
, @beginDate as datetime = null
, @endDate as datetime = null
, @qSetId as nvarchar(30) = null out
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
DECLARE @iCustCnt int = 0;
DECLARE @iQSetCnt int = 0;
DECLARE @iVoteCnt int = 0;

DECLARE @vBeginDate datetime;
DECLARE @vEndDate datetime; 
DECLARE @vBeginDateStr nvarchar(40);
DECLARE @vEndDateStr nvarchar(40); 

	-- Error Code:
	--   0 : Success
	-- 1401 : Customer Id cannot be null or empty string.
	-- 1402 : Customer Id is not found.
	-- 1403 : QSet Id is not found.
	-- 1404 : QSet is already used in vote table.
	-- 1405 : Begin Date and/or End Date should not be null.
	-- 1406 : Display Mode is null or value is not in 0 to 1.
	-- 1407 : Begin Date should less than End Date.
	-- 1408 : Begin Date or End Date is overlap with another Question Set.
	-- 1409 : 
	-- OTHER : SQL Error Number & Error Message.
	BEGIN TRY
		IF @isDefault IS NULL
		BEGIN
			SET @isDefault = 0;
		END

		IF (dbo.IsNullOrEmpty(@customerId) = 1)
		BEGIN
			-- Customer Id cannot be null or empty string.
            EXEC GetErrorMsg 1401, @errNum out, @errMsg out
			RETURN
		END

		SELECT @iCustCnt = COUNT(*)
		  FROM Customer
		 WHERE RTRIM(LTRIM(CustomerId)) = RTRIM(LTRIM(@customerId));
		IF (@iCustCnt = 0)
		BEGIN
			-- Customer Id is not found.
            EXEC GetErrorMsg 1402, @errNum out, @errMsg out
			RETURN
		END

		/* Check if QSetId exists */
		IF (@qSetId IS NOT NULL AND LTRIM(RTRIM(@qSetId)) <> N'')
		BEGIN
			SELECT @iQSetCnt = COUNT(*)
			  FROM QSet
			 WHERE LOWER(CustomerId) = LOWER(RTRIM(LTRIM(@customerId)))
			   AND LOWER(QSetId) = LOWER(RTRIM(LTRIM(@qSetId)));
			IF (@iQSetCnt = 0)
			BEGIN
				-- QSet Id is not found.
                EXEC GetErrorMsg 1403, @errNum out, @errMsg out
				RETURN
			END
		END

		IF (@beginDate is null or @endDate is null)
		BEGIN
			-- Begin Date and/or End Date should not be null.
			EXEC GetErrorMsg 1405, @errNum out, @errMsg out
			RETURN
		END

		IF (@displayMode is null or (@displayMode < 0 or @displayMode > 1))
		BEGIN
			-- Display Mode is null or value is not in 0 to 1.
			EXEC GetErrorMsg 1406, @errNum out, @errMsg out
			RETURN
		END

		SET @iQSetCnt = 0; -- Reset Counter.

		-- Checks IsDefault, Begin-End Date.
		IF (@isDefault = 1)
		BEGIN
			-- Set default QSet so need to check the default is already exist or not.
			SELECT @iQSetCnt = COUNT(*)
			  FROM QSet
			 WHERE LOWER(CustomerId) = LOWER(RTRIM(LTRIM(@customerId)))
			   AND IsDefault = 1;

			IF (@iQSetCnt <> 0)
			BEGIN
				-- It's seem the default QSet is already exists.
				-- So change the exist default QSet with new one.
				UPDATE QSet
				   SET IsDefault = 1
				 WHERE LOWER(CustomerId) = LOWER(RTRIM(LTRIM(@customerId)));
			END
		END
		ELSE
		BEGIN
			-- Not a Default QSet so need to check begin data and end date
			-- not overlap with the exist ones but can exists within
			-- Look like.
			-- QSet exist :
			--		B											   E
			--		|----------------------------------------------|
			-- QSet new : (now allow end date is ).
			--			B											   E
			--			|----------------------------------------------|
			-- QSet new : (now allow).
			--	B											   E
			--	|----------------------------------------------|
			-- QSet new : (allow).
			--				B								E
			--				|-------------------------------|
			SET @vBeginDateStr = (CONVERT(nvarchar(4), DatePart(yyyy, @beginDate)) + '-' +
								  CONVERT(nvarchar(2), DatePart(mm, @beginDate)) + '-' +
								  CONVERT(nvarchar(2), DatePart(dd, @beginDate)) + ' ' +
								  N'00:00:00');
			SET @vBeginDate = CONVERT(datetime, @vBeginDateStr, 121);

			SET @vEndDateStr = (CONVERT(nvarchar(4), DatePart(yyyy, @endDate)) + '-' +
								CONVERT(nvarchar(2), DatePart(mm, @endDate)) + '-' +
								CONVERT(nvarchar(2), DatePart(dd, @endDate)) + ' ' +
								N'23:59:59');
			SET @vEndDate = CONVERT(datetime, @vEndDateStr, 121);

			IF (@vBeginDate > @vEndDate)
			BEGIN
				-- Begin Date should less than End Date.
				EXEC GetErrorMsg 1407, @errNum out, @errMsg out
				RETURN
			END

			IF (dbo.IsNullOrEmpty(@qSetId) = 1 AND @isDefault <> 1)
			BEGIN
				-- Check date in all records.
				SELECT @iQSetCnt = count(*)
				  FROM QSet
				 WHERE LOWER(CustomerId) = LOWER(RTRIM(LTRIM(@customerId)))
				   AND ((@vBeginDate between BeginDate and EndDate
					OR @vEndDate between BeginDate and EndDate))
				   AND IsDefault = 0;
			END
			ELSE
			BEGIN
				-- Check date exclude self record.
				SELECT @iQSetCnt = count(*)
				  FROM QSet
				 WHERE ((@vBeginDate between BeginDate and EndDate
					OR @vEndDate between BeginDate and EndDate))
				   AND LOWER(QSetId) <> LOWER(RTRIM(LTRIM(@qSetId)))
				   AND LOWER(CustomerId) = LOWER(RTRIM(LTRIM(@customerId)))
				   AND IsDefault = 0;
			END

			IF @iQSetCnt <> 0
			BEGIN
				-- Begin Date or End Date is overlap with another Question Set.
				EXEC GetErrorMsg 1408, @errNum out, @errMsg out
				RETURN
			END
		END

		IF dbo.IsNullOrEmpty(@qSetId) = 1
		BEGIN
			EXEC NextCustomerPK @customerId
			                , N'QSet'
							, @qSetId out
							, @errNum out
							, @errMsg out;
			IF @errNum <> 0
			BEGIN
				RETURN;
			END	
		END
		ELSE
		BEGIN
			SELECT @iQSetCnt = COUNT(*)
			  FROM QSet
			 WHERE LOWER(QSetId) = LOWER(RTRIM(LTRIM(@qSetId)))
			   AND LOWER(CustomerID) = LOWER(RTRIM(LTRIM(@customerId)))
		END

		-- Checks is already in used.
		SELECT @iVoteCnt = COUNT(*)
			FROM Vote
			WHERE LOWER(CustomerId) = LOWER(RTRIM(LTRIM(@customerId)))
			AND LOWER(QSetId) = LOWER(RTRIM(LTRIM(@qSetId)));

		IF (@iVoteCnt <> 0)
		BEGIN
			-- QSet is already used in vote table.
            EXEC GetErrorMsg 1404, @errNum out, @errMsg out
			RETURN
		END

		IF @iQSetCnt = 0
		BEGIN
			INSERT INTO QSet
			(
				  CustomerID
				, QSetID
				, [Description]
				, HasRemark
				, DisplayMode
				, IsDefault
				, BeginDate
				, EndDate
				, ObjectStatus
			)
			VALUES
			(
				  RTRIM(LTRIM(@customerId))
				, RTRIM(LTRIM(@qSetId))
				, RTRIM(LTRIM(@description))
				, @hasRemark
				, @displayMode
				, @isDefault
				, @vBeginDate
				, @vEndDate
				, 1
			);
		END
		ELSE
		BEGIN
			UPDATE QSet
			   SET [Description] = RTRIM(LTRIM(@description))
			     , HasRemark = @hasRemark
				 , DisplayMode = @displayMode
			     , IsDefault = @isDefault
				 , BeginDate = @vBeginDate
				 , EndDate = @vEndDate
			 WHERE LOWER(QSetID) = LOWER(RTRIM(LTRIM(@qSetId))) 
			   AND LOWER(CustomerId) = LOWER(RTRIM(LTRIM(@customerId)));
		END
		
		-- SUCCESS
        EXEC GetErrorMsg 0, @errNum out, @errMsg out
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO


/*********** Script Update Date: 2018-05-14  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: InitErrorMessages.
-- Description:	Init error messages.
-- [== History ==]
-- <2017-08-06> :
--	- Stored Procedure Created.
-- <2018-05-10> :
--	- Update new error messages.
--
-- [== Example ==]
--
--exec InitErrorMessages
-- =============================================
ALTER PROCEDURE [dbo].[InitErrorMessages]
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
    EXEC SaveErrorMsg 1401, N'Customer Id cannot be null or empty string.'
    EXEC SaveErrorMsg 1402, N'Customer Id is not found.'
    EXEC SaveErrorMsg 1403, N'QSet Id is not found.'
    EXEC SaveErrorMsg 1404, N'QSet is already used in vote table.'
    EXEC SaveErrorMsg 1405, N'Begin Date and/or End Date should not be null.'
    EXEC SaveErrorMsg 1406, N'Display Mode is null or value is not in 0 to 1.'
    EXEC SaveErrorMsg 1407, N'Begin Date should less than End Date.'
    EXEC SaveErrorMsg 1408, N'Begin Date or End Date is overlap with another Question Set.'

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

    -- REGISTER CUSTOMER.
    EXEC SaveErrorMsg 1801, N'CustomerName cannot be null or empty string.'
    EXEC SaveErrorMsg 1802, N'UserName and Password cannot be null or empty string.'

    -- SIGNIN.
    EXEC SaveErrorMsg 1901, N'Reserved not exist.'

    -- GET VOTE SUMMARIES.
    EXEC SaveErrorMsg 2001, N'CustomerId cannot be null or empty string.'
    EXEC SaveErrorMsg 2002, N'QSetId cannot be null or empty string.'
    EXEC SaveErrorMsg 2003, N'QSeq cannot be null.'
    EXEC SaveErrorMsg 2004, N'The default OrgId not found.'
    EXEC SaveErrorMsg 2005, N'The BranchId not found.'
END

GO

EXEC InitErrorMessages;

GO

