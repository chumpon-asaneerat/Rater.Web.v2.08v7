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
-- <2018-05-24> :
--	- Remove langId parameter.
--  - Add accessId out parameter.
--
-- [== Example ==]
--
--exec SignIn N'admin@umi.co.th', N'1234', N'EDL-C2017010002';
-- =============================================
CREATE PROCEDURE [dbo].[SignIn] (
  @userName nvarchar(50) = null
, @passWord nvarchar(20) = null
, @customerId nvarchar(30) = null
, @accessId nvarchar(30) = null out
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
DECLARE @iUsrCnt int = 0;
    -- Error Code:
    --    0 : Success
	-- 1901 : Customer Id cannot be null or empty string.
	-- 1902 : User Name cannot be null or empty string.
	-- 1903 : Password cannot be null or empty string.
	-- 1904 : Cannot found User that match information.
    -- OTHER : SQL Error Number & Error Message.
    BEGIN TRY
		IF (dbo.IsNullOrEmpty(@customerId) = 1)
		BEGIN
            -- Customer Id cannot be null or empty string.
            EXEC GetErrorMsg 1901, @errNum out, @errMsg out
			RETURN
		END

		IF (dbo.IsNullOrEmpty(@userName) = 1)
		BEGIN
            -- User Name cannot be null or empty string.
            EXEC GetErrorMsg 1902, @errNum out, @errMsg out
			RETURN
		END

		IF (dbo.IsNullOrEmpty(@passWord) = 1)
		BEGIN
            -- Password cannot be null or empty string.
            EXEC GetErrorMsg 1903, @errNum out, @errMsg out
			RETURN
		END

		SELECT @iUsrCnt = COUNT(*)
		  FROM LogInView
		 WHERE UserName = @userName
		   AND PassWord = @passWord
		   AND LangId = N'EN'
		   AND CustomerId = @customerId;
		IF (@iUsrCnt = 0)
		BEGIN
            -- Cannot found User that match information.
            EXEC GetErrorMsg 1904, @errNum out, @errMsg out
			RETURN
		END
		-- Keep data into session.

		-- SUCCESS
		EXEC GetErrorMsg 0, @errNum out, @errMsg out
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO