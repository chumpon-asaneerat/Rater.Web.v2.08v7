SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: QSetView.
-- Description:	The QSet View.
-- [== History ==]
-- <2018-05-15> :
--	- View Created.
--
-- [== Example ==]
--
-- =============================================
CREATE VIEW [dbo].[QSetView]
AS
	SELECT LanguageView.LangId
		 --, LanguageView.FlagId
	     --, LanguageView.DescriptionEN
		 --, LanguageView.DescriptionNative
		 , LanguageView.Enabled
		 , LanguageView.SortOrder
	     , QSet.QSetId
	     , QSet.CustomerId
		 , QSet.BeginDate
		 , QSet.EndDate
		 , QSet.Description AS QSetDescriptionEN
		 , QSet.DisplayMode
		 , QSet.HasRemark
		 , QSet.IsDefault
		 , QSet.ObjectStatus AS QSetStatus
	  FROM LanguageView CROSS JOIN dbo.QSet

GO
