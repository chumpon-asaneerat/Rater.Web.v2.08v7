SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: PeriodUnitMLView.
-- Description:	The Period Unit ML View.
-- [== History ==]
-- <2018-04-16> :
--	- View Created.
--
-- [== Example ==]
--
-- =============================================
CREATE VIEW [dbo].[PeriodUnitMLView]
AS
	SELECT PUV.LangId
		 , PUV.PeriodUnitId
		 , PUV.PeriodUnitDescriptionEN
		 , CASE 
			WHEN PUML.Description IS NULL THEN 
				PUV.PeriodUnitDescriptionEN 
			ELSE 
				PUML.Description 
		   END AS PeriodUnitDescriptionNative
		 , PUV.SortOrder
		 , PUV.Enabled
		FROM dbo.PeriodUnitML AS PUML RIGHT OUTER JOIN PeriodUnitView AS PUV
		  ON (PUML.LangId = PUV.LangId AND PUML.PeriodUnitId = PUV.PeriodUnitId)
GO
