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
-- <2018-05-18> :
--	- Change parameter name.
-- <2018-05-29> :
--	- Add parameter langId.
--
-- [== Example ==]
--
--EXEC SaveErrorMsg N'EN', 0000, N'Success.';
--EXEC SaveErrorMsg N'EN', 0101, N'Language Id cannot be null or empty string.';
-- =============================================
CREATE PROCEDURE [dbo].[SaveErrorMsg](
  @langId as nvarchar(3)
, @errCode as int
, @message as nvarchar(MAX))
AS
BEGIN
DECLARE @lId nvarchar(3);
DECLARE @iCnt int = 0;
	-- Find Proper LangId
	EXEC FindLangId @langId, @lId out;

    SELECT @iCnt = COUNT(*)
      FROM ErrorMessage
     WHERE ErrCode = @errCode
	   AND UPPER(LTRIM(RTRIM(LangId))) = UPPER(LTRIM(RTRIM(@lId)));

    IF @iCnt = 0
    BEGIN
        -- INSERT
        INSERT INTO ErrorMessage
        (
              LangId
            , ErrCode
            , ErrMsg
        )
        VALUES
        (
		      UPPER(LTRIM(RTRIM(@lId)))
            , @errCode
            , @message
        );
    END
    ELSE
    BEGIN
        -- UPDATE
        UPDATE ErrorMessage
           SET ErrMsg = COALESCE(@message, ErrMsg)
         WHERE ErrCode = @errCode
		   AND UPPER(LTRIM(RTRIM(LangId))) = UPPER(LTRIM(RTRIM(@lId)));
    END 
END

GO
