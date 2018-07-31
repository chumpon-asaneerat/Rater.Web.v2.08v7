SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[DeviceMLView]
AS
	SELECT DV.LangId
	     , DV.DeviceId
	     , DV.CustomerId
	     , DV.DeviceTypeId
	     , DV.DeviceNameEN
		 , CASE 
			WHEN DML.DeviceName IS NULL THEN 
				DV.DeviceNameEN 
			ELSE 
				DML.DeviceName 
		   END AS DeviceNameNative
	     , DV.LocationEN
		 , CASE 
			WHEN DML.Location IS NULL THEN 
				DV.LocationEN 
			ELSE 
				DML.Location 
		   END AS LocationNative
	     , DV.OrgId
	     , DV.MemberId
	     , DV.Enabled
	     , DV.SortOrder
		FROM dbo.DeviceML AS DML RIGHT OUTER JOIN DeviceView AS DV
		  ON (    DML.LangId = DV.LangId 
		      AND DML.DeviceId = DV.DeviceId
		      AND DML.CustomerId = DV.CustomerId
			 )
GO
