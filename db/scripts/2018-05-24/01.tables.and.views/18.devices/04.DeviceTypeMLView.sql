SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[DeviceTypeMLView]
AS
	SELECT DTV.LangId
	     , DTV.DeviceTypeId
	     , DTV.DescriptionEN
		 , CASE 
			WHEN DTML.Description IS NULL THEN 
				DTV.DescriptionEN 
			ELSE 
				DTML.Description 
		   END AS DescriptionNative
	     , DTV.Enabled
	     , DTV.SortOrder
		FROM dbo.DeviceTypeML AS DTML RIGHT OUTER JOIN DeviceTypeView AS DTV
		  ON (    DTML.LangId = DTV.LangId 
		      AND DTML.DeviceTypeId = DTV.DeviceTypeId
			 )
GO