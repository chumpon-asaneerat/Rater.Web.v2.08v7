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
-- <2018-05-15> :
--	- change column LangId to langId
--	- change column FlagId to flagId
--
-- [== Example ==]
--
--exec GetLanguages; -- for get all.
--exec GetLanguages 1; -- for only enabled language.
--exec GetLanguages 0; -- for only disabled language.
-- =============================================
ALTER PROCEDURE [dbo].[GetLanguages]
(
    @enabled bit = null
)
AS
BEGIN
    SELECT langId
		 , flagId
		 , DescriptionEN
		 , DescriptionNative 
		 , SortOrder
		 , Enabled
      FROM [dbo].[LanguageView]
     WHERE [ENABLED] = COALESCE(@enabled, [ENABLED])
     ORDER BY SortOrder
END

GO
