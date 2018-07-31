SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: LimitUnitMLView.
-- Description:	The Limit Unit ML View.
-- [== History ==]
-- <2018-04-16> :
--	- View Created.
--
-- [== Example ==]
--
-- =============================================
CREATE VIEW [dbo].[LimitUnitMLView]
AS
	SELECT LUV.LangId
		 , LUV.LimitUnitId
		 , LUV.LimitUnitDescriptionEN
		 , CASE 
			WHEN LMML.Description IS NULL THEN 
				LUV.LimitUnitDescriptionEN 
			ELSE 
				LMML.Description 
		   END AS LimitUnitDescriptionNative
		 , LUV.LimitUnitTextEN
		 , CASE 
			WHEN LMML.UnitText IS NULL THEN 
				LUV.LimitUnitTextEN 
			ELSE 
				LMML.UnitText 
		   END AS LimitUnitTextNative
		 , LUV.Enabled
		 , LUV.SortOrder
		FROM dbo.LimitUnitML AS LMML RIGHT OUTER JOIN LimitUnitView AS LUV
		  ON (LMML.LangId = LUV.LangId AND LMML.LimitUnitId = LUV.LimitUnitId)

GO
