SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: QSlideMLView.
-- Description:	The QSlide ML View.
-- [== History ==]
-- <2018-05-15> :
--	- View Created.
--
-- [== Example ==]
--
-- =============================================
CREATE VIEW [dbo].[QSlideMLView]
AS
	SELECT QSlideV.LangId
		 , QSlideV.CustomerId
		 , QSlideV.QSetId
		 , QSlideV.QSeq
		 , QSlideV.QSlideTextEN
		 , CASE 
			WHEN QSlideML.QText IS NULL THEN 
				QSlideV.QSlideTextEN
			ELSE 
				QSlideML.QText 
		   END AS QSlideTextNative
		 , QSlideV.HasRemark
		 , QSlideV.QSlideStatus
		 , QSlideV.QSlideOrder
		 , QSlideV.Enabled
		 , QSlideV.SortOrder
		FROM dbo.QSlideML AS QSlideML RIGHT OUTER JOIN QSlideView AS QSlideV
		  ON (QSlideML.LangId = QSlideV.LangId 
		  AND QSlideML.CustomerId = QSlideV.CustomerId
		  AND QSlideML.QSetId = QSlideV.QSetId
		  AND QSlideML.QSeq = QSlideV.QSeq)

GO
