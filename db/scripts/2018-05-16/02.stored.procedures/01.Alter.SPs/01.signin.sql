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
		SELECT langId
			 , customerId
			 , memberId
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
