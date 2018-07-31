/*********** Script Update Date: 2018-05-21  ***********/
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
-- <2016-12-16> :
--	- Add returns langId column.
--	- Change CustomerId to customerId.
--	- Change MemberId to memberId.
-- <2018-05-21> :
--	- Add returns columns CustomerNameEN and CustomerNameNative.
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
		SELECT A.langId
			 , A.customerId
			 , A.memberId
			 , A.MemberType
             , A.IsEDLUser
			 , A.PrefixEN
			 , A.FirstNameEN
			 , A.LastNameEN
             , A.FullNameEN
			 , A.PrefixNative
			 , A.FirstNameNative
			 , A.LastNameNative
             , A.FullNameNative
			 , B.CustomerNameEN
			 , B.CustomerNameNative
			 , A.ObjectStatus
          FROM LogInView A, CustomerMLView B
         WHERE LOWER(A.UserName) = LOWER(LTRIM(RTRIM(@userName)))
           AND LOWER(A.[Password]) = LOWER(LTRIM(RTRIM(@passWord)))
           AND LOWER(A.LangId) = LOWER(LTRIM(RTRIM(COALESCE(@langId, A.LangId))))
           AND LOWER(A.CustomerId) = LOWER(LTRIM(RTRIM(COALESCE(@customerId, A.CustomerId))))
		   AND B.CustomerId = A.CustomerId
		   AND B.LangId = A.LangId
         ORDER BY A.CustomerId, A.MemberId;

		EXEC GetErrorMsg 0, @errNum out, @errMsg out
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO

/*********** Script Update Date: 2018-05-21  ***********/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: GetMemberDescription
-- Description:	Get Member FullNameNative and CustomerNameNative.
-- [== History ==]
-- <2018-05-21> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
--exec GetMemberDescription N'EN', N'EDL-C2018040002', N'M00001';
--exec GetMemberDescription N'TH', N'EDL-C2018040002', N'M00001';
-- =============================================
CREATE PROCEDURE GetMemberDescription (
  @langId nvarchar(3) = null
, @customerId nvarchar(30) = null
, @memberId nvarchar(30) = null
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
    -- Error Code:
    --   0 : Success
    -- OTHER : SQL Error Number & Error Message.
    BEGIN TRY
		SELECT A.FullNameNative
			 , B.CustomerNameNative
          FROM LogInView A, CustomerMLView B
         WHERE LOWER(A.CustomerId) = LOWER(LTRIM(RTRIM(@customerId)))
           AND LOWER(A.MemberId) = LOWER(LTRIM(RTRIM(@memberId)))
           AND LOWER(A.LangId) = LOWER(LTRIM(RTRIM(COALESCE(@langId, A.LangId))))
           AND LOWER(A.CustomerId) = LOWER(LTRIM(RTRIM(COALESCE(@customerId, A.CustomerId))))
		   AND B.CustomerId = A.CustomerId
		   AND B.LangId = A.LangId
         ORDER BY A.CustomerId, A.MemberId;

		EXEC GetErrorMsg 0, @errNum out, @errMsg out
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO

