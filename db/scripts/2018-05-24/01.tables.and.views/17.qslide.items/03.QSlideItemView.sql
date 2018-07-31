SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: QSlideItemView.
-- Description:	The QSlideItem View.
-- [== History ==]
-- <2018-05-15> :
--	- View Created.
--
-- [== Example ==]
--
-- =============================================
CREATE VIEW [dbo].[QSlideItemView]
AS
	SELECT LanguageView.LangId
		 --, LanguageView.FlagId
	     --, LanguageView.DescriptionEN
		 --, LanguageView.DescriptionNative
		 , LanguageView.Enabled
		 , LanguageView.SortOrder
	     , QSlideItem.CustomerId
	     , QSlideItem.QSetId
	     , QSlideItem.QSeq
		 , QSlideItem.QSSeq
		 , QSlideItem.QText AS QItemTextEN
		 , QSlideItem.IsRemark
		 , QSlideItem.SortOrder AS QItemOrder
		 , QSlideItem.ObjectStatus AS QItemStatus
	  FROM LanguageView CROSS JOIN dbo.QSlideItem

GO
