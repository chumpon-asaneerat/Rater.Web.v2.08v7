SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetLicenses
-- [== History ==]
-- <2017-05-31> :
--	- Stored Procedure Created.
-- <2018-04-16> :
--	- change language id from nvarchar(10) to nvarchar(3).
-- <2018-05-15> :
--	- change column LangId to langId
--	- change column LicenseTypeId to licenseTypeId
--	- change column PeriodUnitId to periodUnitId
--
-- [== Example ==]
--
--exec GetLicenseTypes N'EN'; -- for only EN language.
--exec GetLicenseTypes;       -- for get all.
-- =============================================
ALTER PROCEDURE [dbo].[GetLicenseTypes] 
(
  @langId nvarchar(3) = null
)
AS
BEGIN
	SELECT langId
		 , licenseTypeId
		 , LicenseTypeDescriptionEn
		 , LicenseTypeDescriptionNative
		 , AdTextEN
		 , AdTextNative
		 , periodUnitId
		 , NumberOfUnit
		 , UseDefaultPrice
		 , Price
		 , CurrencySymbol
		 , CurrencyText
		 , SortOrder
		 , Enabled 
	  FROM LicenseTypeMLView
	 WHERE langId = COALESCE(@langId, langId)
	   AND Enabled = 1
	 Order By SortOrder, LangId, LicenseTypeId;
END

GO
