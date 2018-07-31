SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: QSlideView.
-- Description:	The QSlide View.
-- [== History ==]
-- <2018-05-15> :
--	- View Created.
--
-- [== Example ==]
--
-- =============================================
CREATE VIEW [dbo].[QSlideView]
AS
	SELECT LanguageView.LangId
		 --, LanguageView.FlagId
	     --, LanguageView.DescriptionEN
		 --, LanguageView.DescriptionNative
		 , LanguageView.Enabled
		 , LanguageView.SortOrder
	     , QSlide.CustomerId
	     , QSlide.QSetId
	     , QSlide.QSeq
		 , QSlide.QText AS QSlideTextEN
		 , QSlide.HasRemark
		 , QSlide.SortOrder AS QSlideOrder
		 , QSlide.ObjectStatus AS QSlideStatus
	  FROM LanguageView CROSS JOIN dbo.QSlide

GO
