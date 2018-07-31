SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: RegisterClient.
-- Description:	Register Client.
-- [== History ==]
-- <2018-05-22> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
--EXEC RegisterClient N'3524260733', N'2018-05-22 00:10:11.333', N'{ isMobile: true }'
-- =============================================
CREATE PROCEDURE RegisterClient (
  @clientId nvarchar(50) = null
, @clientInitDate datetime = null
, @clientInfo nvarchar(MAX) = null
, @accessId nvarchar(30) = null out
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
DECLARE @iCnt int = 0;
    -- Error Code:
    --     0 : Success
    --  2301 : Client Id cannot be null or empty string.
	--  2302 : Client Init Date cannot be null.
	--  2303 : Client is already registered.
    -- OTHER : SQL Error Number & Error Message.
    BEGIN TRY
		IF (dbo.IsNullOrEmpty(@clientId) = 1)
		BEGIN
			-- Client Id cannot be null or empty string.
            EXEC GetErrorMsg 2301, @errNum out, @errMsg out
			RETURN
		END

		IF (@clientInitDate IS NULL)
		BEGIN
			-- Client Init Date cannot be null.
            EXEC GetErrorMsg 2302, @errNum out, @errMsg out
			RETURN
		END

		-- Check is already exists.
		SELECT @iCnt = COUNT(*)
		  FROM ClientAccess
		 WHERE LOWER(LTRIM(RTRIM(ClientId))) = LOWER(LTRIM(RTRIM(@clientId)))
		   AND ClientInitDate = @clientInitDate;

		IF (@iCnt <> 0)
		BEGIN
			-- Client is already registered.
			EXEC GetErrorMsg 2303, @errNum out, @errMsg out
			RETURN
		END

		-- Get Access Id.
		EXEC GetRandomHexCode 15, @accessId out;

		INSERT INTO ClientAccess
		(
		    AccessId
		  , ClientId
		  , ClientInitDate
		  , ClientInfo
		  , LastAccess
		)
		VALUES
		(
		    @accessId
		  , @clientId
		  , @clientInitDate
		  , @clientInfo
		  , GETDATE()
		);

		-- SUCCESS
		EXEC GetErrorMsg 0, @errNum out, @errMsg out
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO
