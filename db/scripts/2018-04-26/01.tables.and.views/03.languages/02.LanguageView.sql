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
