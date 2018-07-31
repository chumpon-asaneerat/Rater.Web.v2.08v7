/*********** Script Update Date: 2018-05-09  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[LocalLog](
	[LogId] [int] NOT NULL,
	[Seq] [int] NOT NULL,
	[SPName] [nvarchar](50) NOT NULL,
	[LogDate] [datetime] NOT NULL,
	[Msg] [nvarchar](max) NOT NULL,
 CONSTRAINT [PK_LocalLog_1] PRIMARY KEY CLUSTERED 
(
	[LogId] ASC,
	[Seq] ASC,
	[SPName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

ALTER TABLE [dbo].[LocalLog] ADD  CONSTRAINT [DF_LocalLog_LogDate]  DEFAULT (getdate()) FOR [LogDate]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The log table primary key,' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LocalLog', @level2type=N'COLUMN',@level2name=N'LogId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The log table sub primary key,' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LocalLog', @level2type=N'COLUMN',@level2name=N'Seq'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The sp name.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LocalLog', @level2type=N'COLUMN',@level2name=N'SPName'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The log message.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LocalLog', @level2type=N'COLUMN',@level2name=N'Msg'
GO


/*********** Script Update Date: 2018-05-09  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[LicenseMLView]
AS
	SELECT LTMLV.LangId
		  ,LTMLV.LicenseTypeId
		  ,LFMLV.Seq
		  ,LTMLV.LicenseTypeDescriptionEn
		  ,LTMLV.LicenseTypeDescriptionNative
		  ,LTMLV.AdTextEN
		  ,LTMLV.AdTextNative
		  ,LTMLV.PeriodUnitId
		  ,LTMLV.NumberOfUnit
		  ,LTMLV.UseDefaultPrice
		  ,LTMLV.Price
		  ,LTMLV.CurrencySymbol
		  ,LTMLV.CurrencyText
		  ,LFMLV.LimitUnitId
		  ,LFMLV.NoOfLimit
		  ,LFMLV.LimitUnitTextEN
		  ,LFMLV.LimitUnitTextNative
		  ,LFMLV.LimitUnitDescriptionEN
		  ,LFMLV.LimitUnitDescriptionNative
		  ,LTMLV.Enabled
		  ,LTMLV.SortOrder
	  FROM LicenseTypeMLView LTMLV LEFT JOIN
		(
		 SELECT * 
		   FROM LicenseFeatureMLView LFMLV
		) AS LFMLV ON (
		      LFMLV.LangId = LTMLV.LangId
		  AND LFMLV.LicenseTypeId = LTMLV.LicenseTypeId
		)
GO


/*********** Script Update Date: 2018-05-09  ***********/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: BeginLog.
-- Description:	Begin Log.
-- [== History ==]
-- <2018-05-09> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
--exec BeginLog N'test';
-- =============================================
CREATE PROCEDURE [dbo].[BeginLog]
(
 @spName nvarchar(50)
,@logId int output
)
AS
BEGIN
DECLARE @seq int;
DECLARE @tSPName nvarchar(50);
DECLARE @msg nvarchar(MAX);
	-- SET VARIABLES.
	SET @tSPName = LTRIM(RTRIM(@spName));
	SET @msg = N'Begin Log for : ' + LTRIM(RTRIM(@spName));

	SELECT @logId = MAX(LogId)
	  FROM LocalLog
	 WHERE LOWER(LTRIM(RTRIM(SPName))) = LOWER(@tSPName);
	IF (@logId IS NULL OR @logId = 0)
	BEGIN
		SET @logId = 1; -- set logid to 1
		SET @seq = 1; -- set seq to 1
	END
	ELSE
	BEGIN
		SET @logId = @logId + 1; -- Increase log id.
		SELECT @seq = MAX(Seq)
		  FROM LocalLog
		 WHERE LOWER(LTRIM(RTRIM(SPName))) = LOWER(@tSPName)
		   AND LogId = @logId;
		IF (@seq IS NULL OR @seq = 0)
		BEGIN
			SET @seq = 1;
		END
		ELSE
		BEGIN
			SET @seq = @seq + 1; -- Increase sequence.
		END
	END

	-- INSERT DATA TO LOCAL LOG.
	INSERT INTO LocalLog
	(
		 LogId
		,Seq
		,SPName
		,Msg
	)
	VALUES
	(
		 @logId
		,@seq 
		,@tSPName
		,@msg
	)
END

GO


/*********** Script Update Date: 2018-05-09  ***********/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: EndLog.
-- Description:	Begin Log.
-- [== History ==]
-- <2018-05-09> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- DECLARE @logId = 1;
-- DECLARE @spName = N'test'
--exec Log N'message 1', @logId, @spName;
-- =============================================
CREATE PROCEDURE Log
(
 @msg nvarchar(MAX)
,@logId int
,@spName nvarchar(50)
)
AS
BEGIN
DECLARE @seq int;
DECLARE @tSPName nvarchar(50);
	-- SET VARIABLES.
	SET @tSPName = LTRIM(RTRIM(@spName));

	SELECT @logId = MAX(LogId)
	  FROM LocalLog
	 WHERE LOWER(LTRIM(RTRIM(SPName))) = LOWER(@tSPName);
	IF (@logId IS NOT NULL AND @logId > 0)
	BEGIN
		SELECT @seq = MAX(Seq)
		  FROM LocalLog
		 WHERE LOWER(LTRIM(RTRIM(SPName))) = LOWER(@tSPName)
		   AND LogId = @logId;
		IF (@seq IS NULL OR @seq = 0)
		BEGIN
			SET @seq = 1;
		END
		ELSE
		BEGIN
			SET @seq = @seq + 1; -- Increase sequence.
		END

		-- INSERT DATA TO LOCAL LOG.
		INSERT INTO LocalLog
		(
			 LogId
			,Seq
			,SPName
			,Msg
		)
		VALUES
		(
			 @logId
			,@seq 
			,@tSPName
			,@msg
		)
	END
END

GO


/*********** Script Update Date: 2018-05-09  ***********/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: EndLog.
-- Description:	Begin Log.
-- [== History ==]
-- <2018-05-09> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- DECLARE @logId = 1;
--exec EndLog @logId, N'test';
-- =============================================
CREATE PROCEDURE EndLog
(
 @logId int
,@spName nvarchar(50)
)
AS
BEGIN
DECLARE @seq int;
DECLARE @tSPName nvarchar(50);
DECLARE @msg nvarchar(MAX);
	-- SET VARIABLES.
	SET @tSPName = LTRIM(RTRIM(@spName));
	SET @msg = N'End Log for : ' + LTRIM(RTRIM(@spName));

	SELECT @logId = MAX(LogId)
	  FROM LocalLog
	 WHERE LOWER(LTRIM(RTRIM(SPName))) = LOWER(@tSPName);
	IF (@logId IS NOT NULL AND @logId > 0)
	BEGIN
		SELECT @seq = MAX(Seq)
		  FROM LocalLog
		 WHERE LOWER(LTRIM(RTRIM(SPName))) = LOWER(@tSPName)
		   AND LogId = @logId;
		IF (@seq IS NULL OR @seq = 0)
		BEGIN
			SET @seq = 1;
		END
		ELSE
		BEGIN
			SET @seq = @seq + 1; -- Increase sequence.
		END

		-- INSERT DATA TO LOCAL LOG.
		INSERT INTO LocalLog
		(
			 LogId
			,Seq
			,SPName
			,Msg
		)
		VALUES
		(
			 @logId
			,@seq 
			,@tSPName
			,@msg
		)
	END

	-- SHOW OUTPUT.
	SELECT * 
	  FROM LocalLog
	 WHERE LogId = @logId
	   AND LOWER(LTRIM(RTRIM(SPName))) = LOWER(@tSPName);

	-- DELETE ALL DATA
	DELETE 
	  FROM LocalLog
	 WHERE LogId = @logId
	   AND LOWER(LTRIM(RTRIM(SPName))) = LOWER(@tSPName);
END

GO


/*********** Script Update Date: 2018-05-09  ***********/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: GetLicenses.
-- Description:	Get Licenses.
-- [== History ==]
-- <2018-05-09> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
--exec GetLicenses N'EN';    -- for only EN language.
--exec GetLicenses;          -- for get all.
-- =============================================
CREATE PROCEDURE [dbo].[GetLicenses] 
(
  @langId nvarchar(3) = null
, @licenseTypeId int = null  
)
AS
BEGIN
	SELECT * 
	  FROM LicenseMLView
	 WHERE langId = COALESCE(@langId, langId)
	   AND LicenseTypeId = COALESCE(@licenseTypeId, LicenseTypeId)
	   AND Enabled = 1
	 Order By SortOrder, LicenseTypeId, Seq
END

GO


/*********** Script Update Date: 2018-05-09  ***********/
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
ALTER PROCEDURE [dbo].[RegisterCustomer] (
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
	--    0 : Success
	-- 1801 : CustomerName cannot be null or empty string.
	-- 1802 : UserName and Password cannot be null or empty string.
	-- OTHER : SQL Error Number & Error Message.
	BEGIN TRY
		IF (dbo.IsNullOrEmpty(@customerName) = 1)
		BEGIN
			EXEC GetErrorMsg 1801, @errNum out, @errMsg out
			RETURN
		END

		IF (dbo.IsNullOrEmpty(@customerName) = 1)
		BEGIN
			EXEC GetErrorMsg 1802, @errNum out, @errMsg out
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

		EXEC GetErrorMsg 0, @errNum out, @errMsg out
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO


/*********** Script Update Date: 2018-05-09  ***********/
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
ALTER PROCEDURE [dbo].[SignIn] (
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

		EXEC GetErrorMsg 0, @errNum out, @errMsg out
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO


/*********** Script Update Date: 2018-05-09  ***********/
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
-- <2018-05-10> :
--	- remove branchId from parameter.
--
-- [== Example ==]
--
-- [== Complex Example ==]
/*
DECLARE @errNum int;
DECLARE @errMsg nvarchar(MAX);
DECLARE @customerId nvarchar(30);
DECLARE @orgId nvarchar(30);
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
SET @deviceId = N'4dff3f4640374939a856d892bc57bf1c';
SET @qSetId = 'QS2018010001';
SET @userId = NULL;
SET @voteDate = GETDATE();
SET @remark = NULL;

SET @qSeq = 1;
SET @voteValue = 1;
exec SaveVote @customerId, @orgId
            , @deviceId
			, @qSetId, @qSeq
			, @userId
			, @voteDate, @voteValue, @remark
            , @voteSeq out, @errNum out, @errMsg out
SELECT @voteSeq as VoteSeq, @errNum AS ErrNum, @errMsg AS ErrMsg

SET @qSeq = 1;
SET @voteValue = 2;
exec SaveVote @customerId, @orgId
            , @deviceId
			, @qSetId, @qSeq
			, @userId
			, @voteDate, @voteValue, @remark
            , @voteSeq out, @errNum out, @errMsg out 
SELECT @voteSeq as VoteSeq, @errNum AS ErrNum, @errMsg AS ErrMsg

SET @qSeq = 1;
SET @voteValue = 2;
exec SaveVote @customerId, @orgId
            , @deviceId
			, @qSetId, @qSeq
			, @userId
			, @voteDate, @voteValue, @remark
            , @voteSeq out, @errNum out, @errMsg out 
SELECT @voteSeq as VoteSeq, @errNum AS ErrNum, @errMsg AS ErrMsg
*/
-- =============================================
ALTER PROCEDURE [dbo].[SaveVote] (
  @customerId as nvarchar(30)
, @orgId as nvarchar(30) = null
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
DECLARE @branchId nvarchar(30);
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

		IF (dbo.IsNullOrEmpty(@orgId) = 1)
		BEGIN
			-- Org Id cannot be null or empty string.
            EXEC GetErrorMsg 1705, @errNum out, @errMsg out
			RETURN
		END

		SELECT @iCnt = COUNT(*)
		  FROM Org
		 WHERE LOWER(OrgID) = LOWER(RTRIM(LTRIM(@orgId)))
           --AND LOWER(BranchID) = LOWER(RTRIM(LTRIM(@branchId)))
		   AND LOWER(CustomerID) = LOWER(RTRIM(LTRIM(@customerId)))
		IF (@iCnt = 0)
		BEGIN
			-- Org Id not found.
            EXEC GetErrorMsg 1706, @errNum out, @errMsg out
			RETURN
		END

		-- Find Branch Id from customerid and orgid.
		SELECT @branchId = BranchId
		  FROM Org
		 WHERE OrgID = @orgId
		   AND CustomerId = @customerId;

		-- NOTE: No Need to Check Branch Id.
		/*
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
		*/

		IF (dbo.IsNullOrEmpty(@qSetId) = 1)
		BEGIN
			-- QSet Id cannot be null or empty string.
            EXEC GetErrorMsg 1707, @errNum out, @errMsg out
			RETURN
		END

		-- NOTE: Temporary disable check QSet code.
		/*
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
		*/

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


/*********** Script Update Date: 2018-05-09  ***********/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: __GenerateSubOrgInClause
-- Description:	Internal Get Sub Org In Clause (use internally).
-- [== History ==]
-- <2018-05-09> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
--EXEC __GenerateSubOrgInClause N'EDL-C2017030001', N'O0001'
-- =============================================
CREATE PROCEDURE __GenerateSubOrgInClause
(
  @customerId nvarchar(30)
, @orgID nvarchar(30)
, @includeSubOrg bit = 1
, @retVal As nvarchar(MAX) = N'' output
)
AS
BEGIN
DECLARE @subOrgID As nvarchar(30)
DECLARE @itemCnt As int
DECLARE @maxCnt As int
DECLARE @retSubVal As nvarchar(MAX)

	SET @itemCnt = 0;
	SET @maxCnt = 0;
	SET @retVal = N'';

	SELECT @maxCnt = COUNT(*) 
	  FROM ORG
 	 WHERE ObjectStatus = 1 AND 
		   ParentId = @orgID AND
		   CustomerId = @customerId;
	DECLARE ORG_CURSOR CURSOR 
			LOCAL
			FORWARD_ONLY 
			READ_ONLY 
			FAST_FORWARD 
		FOR  
		SELECT OrgID
		  FROM ORG 
		 WHERE ObjectStatus = 1 
           AND ParentId = @orgID 
           AND CustomerId = @customerId

	OPEN ORG_CURSOR  
	FETCH NEXT FROM ORG_CURSOR INTO @subOrgID
	WHILE @@FETCH_STATUS = 0  
	BEGIN
		--PRINT @subOrgID;				
		IF @itemCnt = 0
		BEGIN
			SET @retVal = N'''' + @subOrgID + N'''';
		END
		ELSE
		BEGIN
			SET @retVal = @retVal + N', ''' + @subOrgID + N'''';
		END
		
		IF @IncludeSubOrg =  1 AND @maxCnt > 0
		BEGIN
			SET @retSubVal = N'';
			EXEC __GenerateSubOrgInClause @customerId, @subOrgID, @includeSubOrg, @retSubVal output;
			
			IF @retSubVal <> ''
			BEGIN
				--PRINT @retSubVal;
				SET @retVal = @retVal + N', ' + @retSubVal;
			END
		END
		
		SET @itemCnt = @itemCnt + 1;
		
		FETCH NEXT FROM ORG_CURSOR INTO @subOrgID
	END  

	CLOSE ORG_CURSOR  
	DEALLOCATE ORG_CURSOR 	
END

GO



/*********** Script Update Date: 2018-05-09  ***********/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	Generate Sub Org In Clause.
-- [== History ==]
-- <2018-05-09> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- EXEC GenerateSubOrgInClause N'EDL-C2017030001', N'O0001' -- Get in clause for root note
-- EXEC GenerateSubOrgInClause N'EDL-C2017030001', N'O0001', 0 -- Get in clause for root note not include sub org
-- =============================================
CREATE PROCEDURE GenerateSubOrgInClause
(
  @customerId nvarchar(30)
, @orgID nvarchar(30)
, @includeSubOrg bit = 1
, @ShowOutput bit = 0
, @retVal As nvarchar(MAX) = N'' output
)
AS
BEGIN
	SET NOCOUNT ON;
	SET @retVal = N'';
	
	IF @IncludeSubOrg <> 0
	BEGIN
		EXEC __GenerateSubOrgInClause @customerId, @orgID, @includeSubOrg, @retVal output;
	END
	
	--PRINT @retVal;
	
	IF @retVal <> N''
	BEGIN
		--PRINT N'HAS SUB ORG';
		SET @retVal = N'''' + @orgID + N''', ' + @retVal;
	END
	ELSE
	BEGIN
		--PRINT N'NO SUB ORG';
		SET @retVal = N'''' + @orgID + N'''';
	END
	IF @ShowOutput <> 0
	BEGIN
		SELECT @retVal AS InClause;
	END
END

GO


/*********** Script Update Date: 2018-05-09  ***********/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: __BuildTotalVoteCountQuery.
-- Description:	Build Query for select votevalue and total vote count for that votevalue.
-- [== History ==]
-- <2018-05-09> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
--DECLARE @customerId nvarchar(30) = N'EDL-C2018040002'
--DECLARE @orgId nvarchar(30) = N'O0001';
--DECLARE @deviceId nvarchar(50) = N'233356614';
--DECLARE @qsetId nvarchar(30) = N'QS2018040001';
--DECLARE @qSeq int = 1; -- has single question.
--DECLARE @userId nvarchar(30) = NULL;
--DECLARE @beginDate datetime = N'2018-01-01';
--DECLARE @endDate datetime = N'2018-12-31';
--DECLARE @sql nvarchar(MAx);
--SET @orgId = NULL;
--SET @deviceId = NULL;
--
--EXEC __BuildTotalVoteCountQuery @customerId
--							    , @qsetId, @qSeq
--							    , @beginDate, @endDate
--							    , @orgId, @deviceId, @userId
--							    , @sql output;
-- =============================================
CREATE PROCEDURE [dbo].[__BuildTotalVoteCountQuery]
(
  @customerId as nvarchar(30)
, @qSetId as nvarchar(30)
, @qSeq as int
, @beginDate As DateTime = null
, @endDate As DateTime = null
, @orgId as nvarchar(30) = null
, @deviceId as nvarchar(30) = null
, @userId as nvarchar(30) = null
, @sql as nvarchar(MAX) output
)
AS
BEGIN
DECLARE @showOutput as int = 0;
DECLARE @objectStatus as int = 1;
DECLARE @includeSubOrg bit = 1;
DECLARE @inClause as nvarchar(MAX);

	IF (dbo.IsNullOrEmpty(@orgId) = 0) -- OrgId Exist.
	BEGIN
		EXEC GenerateSubOrgInClause @customerId, @orgId, @includeSubOrg, @showOutput, @inClause output
	END

	SET @sql = N'';
	SET @sql = @sql + 'SELECT VoteValue' + CHAR(13);
	SET @sql = @sql + '     , Count(VoteValue) AS TotalVote' + CHAR(13);
	SET @sql = @sql + '     , VoteValue * Count(VoteValue) AS TotalXCount' + CHAR(13);
	SET @sql = @sql + '     , Count(Remark) AS TotalRemark' + CHAR(13);
	SET @sql = @sql + '  FROM VOTE ' + CHAR(13);
	SET @sql = @sql + ' WHERE ' + CHAR(13);
	SET @sql = @sql + '		ObjectStatus = ' + convert(nvarchar, @objectStatus) + ' AND ' + CHAR(13);
	SET @sql = @sql + '		CustomerID = N''' + @customerId + ''' AND ' + CHAR(13);

	IF (dbo.IsNullOrEmpty(@userId) = 0)
	BEGIN
		SET @sql = @sql + '		UserID = N''' + @userId + ''' AND ' + CHAR(13);
	END

	IF (dbo.IsNullOrEmpty(@deviceId) = 0)
	BEGIN
		SET @sql = @sql + '		DeviceID = N''' + @deviceId + ''' AND ' + CHAR(13);
	END

	IF (dbo.IsNullOrEmpty(@orgId) = 0)
	BEGIN
		SET @sql = @sql + '		OrgID in (' + @inClause + ') AND ' + CHAR(13);
	END

	SET @sql = @sql + '		QSetID = N''' + @qSetId + ''' AND ' + CHAR(13);
	SET @sql = @sql + '		QSeq = ' + convert(nvarchar, @qSeq) + ' AND ' + CHAR(13);

	SET @sql = @sql + '		(VoteDate >= ''' + replace(convert(nvarchar, @beginDate, 120),'/','-') + ''' AND ' + CHAR(13);
	SET @sql = @sql + '		 VoteDate <= ''' + replace(convert(nvarchar, @endDate, 120),'/','-') + ''') ' + CHAR(13);

	SET @sql = @sql + ' GROUP BY VoteValue ' + CHAR(13);
	SET @sql = @sql + ' ORDER BY VoteValue ' + CHAR(13);

END

GO


/*********** Script Update Date: 2018-05-09  ***********/
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
--
-- [== Example ==]
--
--EXEC GetVoteSummaries NULL, N'EDL-C2017050001', N'QS00001', 1, '2017-01-01', '2017-12-31', null, null, null
--EXEC GetVoteSummaries  N'TH', N'EDL-C2017050001', N'QS00001', 1, '2017-01-01', '2017-12-31', N'O0001', null, null
-- =============================================
CREATE PROCEDURE [dbo].[GetVoteSummaries] (
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
		DeviceId nvarchar(50) COLLATE DATABASE_DEFAULT
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
		SET @maxChoice = 4;
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
		 ORDER BY lgv.SortOrder, vs.Choice
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
		 ORDER BY lgv.SortOrder, vs.Choice
	END

	DROP TABLE #VOTESUM
	DROP TABLE #VOTEDATA
END

GO


/*********** Script Update Date: 2018-05-09  ***********/
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

