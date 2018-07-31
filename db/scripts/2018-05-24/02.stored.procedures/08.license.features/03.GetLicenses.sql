SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: GetLicenses.
-- Description:	Get Licenses.
-- [== History ==]
-- <2018-05-09> :
--	- Stored Procedure Created.
-- <2018-05-15> :
--	- change column LangId to langId
--	- change column LicenseTypeId to licenseTypeId
--	- change column PeriodUnitId to periodUnitId
--  - change column NumberOfUnit to NoOfUnit
--	- change column LimitUnitId to limitUnitId
--
-- [== Example ==]
--
--exec GetLicenses N'EN';    -- for only EN language.
--exec GetLicenses;          -- for get all.
-- =============================================
CREATE PROCEDURE [dbo].[GetLicenses] 
(
  @langId nvarchar(3) = null
, @licenseTypeId int = null  
)
AS
BEGIN
	SELECT langId
		 , licenseTypeId
		 , seq
		 , LicenseTypeDescriptionEn
		 , LicenseTypeDescriptionNative
		 , AdTextEN
		 , AdTextNative
		 , periodUnitId
		 , NumberOfUnit as NoOfUnit
		 , UseDefaultPrice
		 , Price
		 , CurrencySymbol
		 , CurrencyText
		 , limitUnitId
		 , LimitUnitDescriptionEN
		 , LimitUnitDescriptionNative
		 , NoOfLimit
		 , LimitUnitTextEN
		 , LimitUnitTextNative
		 , SortOrder
		 , Enabled
	  FROM LicenseMLView
	 WHERE langId = COALESCE(@langId, langId)
	   AND LicenseTypeId = COALESCE(@licenseTypeId, LicenseTypeId)
	   AND Enabled = 1
	 Order By SortOrder, LicenseTypeId, Seq
END

GO
