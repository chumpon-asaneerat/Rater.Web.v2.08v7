SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: LimitUnitView.
-- Description:	The Limit Unit View.
-- [== History ==]
-- <2018-04-16> :
--	- View Created.
--
-- [== Example ==]
--
-- =============================================
CREATE VIEW [dbo].[LimitUnitView]
AS
	SELECT LanguageView.LangId
		 --, LanguageView.FlagId
	     --, LanguageView.DescriptionEN
		 --, LanguageView.DescriptionNative
		 , LanguageView.Enabled
		 , LanguageView.SortOrder
	     , LimitUnit.LimitUnitId
		 , LimitUnit.Description AS LimitUnitDescriptionEN
		 , LimitUnit.UnitText AS LimitUnitTextEN
	  FROM LanguageView CROSS JOIN dbo.LimitUnit

GO
