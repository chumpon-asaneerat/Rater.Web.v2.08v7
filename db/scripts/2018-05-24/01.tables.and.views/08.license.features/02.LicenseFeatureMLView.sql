SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[LicenseFeatureMLView]
AS
	SELECT LanguageView.LangId
		 --, LanguageView.FlagId
	     --, LanguageView.DescriptionEN
		 --, LanguageView.DescriptionNative
	     , LF.LicenseTypeId
	     , LF.Seq
		 , LF.LimitUnitId
		 , LF.LimitUnitDescriptionEN
		 , LF.LimitUnitDescriptionNative
		 , LF.NoOfLimit
		 , LF.LimitUnitTextEN
		 , LF.LimitUnitTextNative
		 , LanguageView.Enabled
		 , LanguageView.SortOrder
	  FROM LanguageView RIGHT OUTER JOIN 
	  (
	    SELECT dbo.LimitUnitMLView.LangId
			 , dbo.LicenseFeature.*
		     , dbo.LimitUnitMLView.LimitUnitDescriptionEN
		     , dbo.LimitUnitMLView.LimitUnitTextEN
		     , dbo.LimitUnitMLView.LimitUnitDescriptionNative
		     , dbo.LimitUnitMLView.LimitUnitTextNative
		  FROM dbo.LicenseFeature, dbo.LimitUnitMLView
		 WHERE dbo.LicenseFeature.LimitUnitId = dbo.LimitUnitMLView.LimitUnitId
	  ) AS LF ON (LanguageView.LangId = LF.LangId)

GO
