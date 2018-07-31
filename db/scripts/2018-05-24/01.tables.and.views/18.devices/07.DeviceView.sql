SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[DeviceView]
AS
	SELECT LanguageView.LangId
		 --, LanguageView.FlagId
	     --, LanguageView.DescriptionEN
		 --, LanguageView.DescriptionNative
		 , LanguageView.Enabled
		 , LanguageView.SortOrder
		 , Device.CustomerId
		 , Device.DeviceId
		 , Device.DeviceTypeId
	     , Device.DeviceName AS DeviceNameEN
		 , Device.Location AS LocationEN
		 , Device.OrgId
		 , Device.MemberId
		 , Device.ObjectStatus
	  FROM LanguageView CROSS JOIN dbo.Device

GO