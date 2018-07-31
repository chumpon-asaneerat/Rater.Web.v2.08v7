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
-- <2018-05-29> :
--	- Update code for new table structure.
--
-- [== Example ==]
--
--EXEC SaveLanguage N'EN', N'us', N'English', N'English', N'$', N'USD', N'USD', 1, 1
--EXEC SaveLanguage N'TH', N'th', N'Thai', N'ไทย', N'฿', N'BAHT', N'บาท', 2, 1
--EXEC SaveLanguage N'JP', N'ja', N'Japanese', N'中文', N'¥', N'CNY', N'元', 3, 1
--EXEC SaveLanguage N'CN', N'zh', N'Chinese', N'中文', N'¥', N'Yen', N'日元', 4, 1
-- =============================================
CREATE PROCEDURE [dbo].[SaveLanguage] (
  @langId as nvarchar(3) = null
, @flagId as nvarchar(3) = null
, @langEN as nvarchar(50) = null
, @langNative as nvarchar(50) = null
, @currSymbol as nvarchar(3) = null
, @currEN as nvarchar(50) = null
, @currNative as nvarchar(50) = null
, @langOrder as int = null
, @langEnabled as bit = null
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
DECLARE @iCnt int = 0;
DECLARE @iDescCnt int = 0;
DECLARE @iLangOrder int = 0;
DECLARE @bEnabled bit = 0;

	-- Error Code:
	--    0 : Success
	-- 1001 : Language Id cannot be null or empty string.
	-- 1002 : Description(EN) cannot be null or empty string.
	-- 1003 : Language Description (EN) is duplicated.
	-- 1004 : Currency Symbol cannot be null or empty string.
	-- 1005 : Currency Description(EN) cannot be null or empty string.
	-- OTHER : SQL Error Number & Error Message.
	BEGIN TRY
		IF (dbo.IsNullOrEmpty(@langId) = 1)
		BEGIN
			EXEC GetErrorMsg @langId, 1001, @errNum out, @errMsg out
			RETURN
		END

		IF (dbo.IsNullOrEmpty(@langEN) = 1)
		BEGIN
			EXEC GetErrorMsg @langId, 1002, @errNum out, @errMsg out
			RETURN
		END

		-- Check INSERT OR UPDATE?.
		SELECT @iCnt = COUNT(*)
		  FROM [dbo].[Language]
		 WHERE LOWER(RTRIM(LTRIM([LangId]))) = LOWER(RTRIM(LTRIM(@langId)))

		IF (@iCnt = 0)
		BEGIN
			-- Detected language not exists so need to check duplicate description.
			-- Check is description is duplicated?.
			SELECT @iDescCnt = COUNT(*)
				FROM [dbo].[Language]
				WHERE UPPER(RTRIM(LTRIM(LangEN))) = UPPER(RTRIM(LTRIM(@langEN)))

			IF (@iDescCnt <> 0)
			BEGIN
				EXEC GetErrorMsg @langId, 1003, @errNum out, @errMsg out
				RETURN
			END
		END

		IF (dbo.IsNullOrEmpty(@currSymbol) = 1)
		BEGIN
			EXEC GetErrorMsg @langId, 1004, @errNum out, @errMsg out
			RETURN
		END

		IF (dbo.IsNullOrEmpty(@currEN) = 1)
		BEGIN
			EXEC GetErrorMsg @langId, 1005, @errNum out, @errMsg out
			RETURN
		END
		-- Auto set sort order if required.
		IF (@langOrder IS NULL)
		BEGIN
			SELECT @langOrder = MAX(LangOrder)
				FROM [dbo].[Language];
			IF (@langOrder IS NULL)
			BEGIN
				SET @iLangOrder = 1;
			END
			ELSE
			BEGIN
				SET @iLangOrder = @langOrder + 1;
			END
		END
		ELSE
		BEGIN
			SET @iLangOrder = @langOrder;
		END
		-- Check enabled flag.
		IF (@langEnabled IS NULL)
		BEGIN
			SET @bEnabled = 0; -- default mode is disabled.
		END
		ELSE
		BEGIN
			SET @bEnabled = @langEnabled; -- change mode.
		END

		IF @iCnt = 0
		BEGIN
			-- INSERT
			INSERT INTO [dbo].[Language]
			(
				  LangId
				, FlagId
				, LangEN
				, LangNative
				, CurrSymbol
				, CurrEN
				, CurrNative
				, LangOrder
				, LangEnabled
			)
			VALUES
			(
				  UPPER(RTRIM(LTRIM(@langId)))
				, COALESCE(LOWER(RTRIM(LTRIM(@flagId))), LOWER(RTRIM(LTRIM(@langId))))
				, RTRIM(LTRIM(@langEN))
				, RTRIM(LTRIM(@langNative))
				, RTRIM(LTRIM(@currSymbol))
				, RTRIM(LTRIM(@currEN))
				, RTRIM(LTRIM(@currNative))
				, @iLangOrder
				, @bEnabled
			);
		END
		ELSE
		BEGIN
			-- UPDATE
			UPDATE Language
			   SET FlagId =  COALESCE(LOWER(RTRIM(LTRIM(@flagId))), FlagId)
			     , LangEN = RTRIM(LTRIM(@langEN))
			     , LangNative = COALESCE(RTRIM(LTRIM(@langNative)), LangNative)
				 , CurrSymbol = COALESCE(RTRIM(LTRIM(@currSymbol)), CurrSymbol)
				 , CurrEN = COALESCE(RTRIM(LTRIM(@currEN)), CurrEN)
				 , CurrNative = COALESCE(RTRIM(LTRIM(@currNative)), CurrNative)
			     , LangOrder = COALESCE(@iLangOrder, LangOrder)
			     , LangEnabled =  COALESCE(@bEnabled, LangEnabled)
			 WHERE LOWER(RTRIM(LTRIM(LangId))) = LOWER(RTRIM(LTRIM(@langId)));
		END
		EXEC GetErrorMsg @langId, 0, @errNum out, @errMsg out
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO
