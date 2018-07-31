/*********** Script Update Date: 2018-05-15  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: QSetView.
-- Description:	The QSet View.
-- [== History ==]
-- <2018-05-15> :
--	- View Created.
--
-- [== Example ==]
--
-- =============================================
CREATE VIEW [dbo].[QSetView]
AS
	SELECT LanguageView.LangId
		 --, LanguageView.FlagId
	     --, LanguageView.DescriptionEN
		 --, LanguageView.DescriptionNative
		 , LanguageView.Enabled
		 , LanguageView.SortOrder
	     , QSet.QSetId
	     , QSet.CustomerId
		 , QSet.BeginDate
		 , QSet.EndDate
		 , QSet.Description AS QSetDescriptionEN
		 , QSet.DisplayMode
		 , QSet.HasRemark
		 , QSet.IsDefault
		 , QSet.ObjectStatus AS QSetStatus
	  FROM LanguageView CROSS JOIN dbo.QSet

GO


/*********** Script Update Date: 2018-05-15  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: QSetMLView.
-- Description:	The QSet ML View.
-- [== History ==]
-- <2018-05-15> :
--	- View Created.
--
-- [== Example ==]
--
-- =============================================
CREATE VIEW [dbo].[QSetMLView]
AS
	SELECT QSetV.LangId
		 , QSetV.QSetId
		 , QSetV.CustomerId
		 , QSetV.BeginDate
		 , QSetV.EndDate
		 , QSetV.QSetDescriptionEN
		 , CASE 
			WHEN QSetML.Description IS NULL THEN 
				QSetV.QSetDescriptionEN 
			ELSE 
				QSetML.Description 
		   END AS QSetDescriptionNative
		 , QSetV.DisplayMode
		 , QSetV.HasRemark
		 , QSetV.IsDefault
		 , QSetV.QSetStatus
		 , QSetV.Enabled
		 , QSetV.SortOrder
		FROM dbo.QSetML AS QSetML RIGHT OUTER JOIN QSetView AS QSetV
		  ON (QSetML.LangId = QSetV.LangId 
		  AND QSetML.QSetId = QSetV.QSetId
		  AND QSetML.CustomerId = QSetV.CustomerId)

GO


/*********** Script Update Date: 2018-05-15  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: QSlideView.
-- Description:	The QSlide View.
-- [== History ==]
-- <2018-05-15> :
--	- View Created.
--
-- [== Example ==]
--
-- =============================================
CREATE VIEW [dbo].[QSlideView]
AS
	SELECT LanguageView.LangId
		 --, LanguageView.FlagId
	     --, LanguageView.DescriptionEN
		 --, LanguageView.DescriptionNative
		 , LanguageView.Enabled
		 , LanguageView.SortOrder
	     , QSlide.CustomerId
	     , QSlide.QSetId
	     , QSlide.QSeq
		 , QSlide.QText AS QSlideTextEN
		 , QSlide.HasRemark
		 , QSlide.SortOrder AS QSlideOrder
		 , QSlide.ObjectStatus AS QSlideStatus
	  FROM LanguageView CROSS JOIN dbo.QSlide

GO


/*********** Script Update Date: 2018-05-15  ***********/
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


/*********** Script Update Date: 2018-05-15  ***********/
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


/*********** Script Update Date: 2018-05-15  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: QSlideItemMLView.
-- Description:	The QSlide Item ML View.
-- [== History ==]
-- <2018-05-15> :
--	- View Created.
--
-- [== Example ==]
--
-- =============================================
CREATE VIEW [dbo].[QSlideItemMLView]
AS
	SELECT QItemV.LangId
		 , QItemV.CustomerId
		 , QItemV.QSetId
		 , QItemV.QSeq
		 , QItemV.QSSeq
		 , QItemV.QItemTextEN
		 , CASE 
			WHEN QItemML.QText IS NULL THEN 
				QItemV.QItemTextEN
			ELSE 
				QItemML.QText 
		   END AS QItemTextNative
		 , QItemV.IsRemark
		 , QItemV.QItemStatus
		 , QItemV.QItemOrder
		 , QItemV.Enabled
		 , QItemV.SortOrder
		FROM dbo.QSlideItemML AS QItemML RIGHT OUTER JOIN QSlideItemView AS QItemV
		  ON (QItemML.LangId = QItemV.LangId 
		  AND QItemML.CustomerId = QItemV.CustomerId
		  AND QItemML.QSetId = QItemV.QSetId
		  AND QItemML.QSeq = QItemV.QSeq
		  AND QItemML.QSSeq = QItemV.QSSeq)

GO


/*********** Script Update Date: 2018-05-15  ***********/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: GetLanguages.
-- Description:	Gets languages.
-- [== History ==]
-- <2017-05-31> :
--	- Stored Procedure Created.
-- <2018-04-16> :
--	- The @enabled parameter default value is NULL.
-- <2018-05-15> :
--	- change column LangId to langId
--	- change column FlagId to flagId
--
-- [== Example ==]
--
--exec GetLanguages; -- for get all.
--exec GetLanguages 1; -- for only enabled language.
--exec GetLanguages 0; -- for only disabled language.
-- =============================================
ALTER PROCEDURE [dbo].[GetLanguages]
(
    @enabled bit = null
)
AS
BEGIN
    SELECT langId
		 , flagId
		 , DescriptionEN
		 , DescriptionNative 
		 , SortOrder
		 , Enabled
      FROM [dbo].[LanguageView]
     WHERE [ENABLED] = COALESCE(@enabled, [ENABLED])
     ORDER BY SortOrder
END

GO


/*********** Script Update Date: 2018-05-15  ***********/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetMemberTypes
-- [== History ==]
-- <2017-05-31> :
--	- Stored Procedure Created.
-- <2018-04-16> :
--	- change language id from nvarchar(10) to nvarchar(3).
-- <2018-05-15> :
--	- change column LangId to langId
--	- change column MemberTypeId to memberTypeId
--
-- [== Example ==]
--
--exec GetMemberTypes NULL, 1;  -- for only enabled languages.
--exec GetMemberTypes;          -- for get all.
--exec GetMemberTypes N'EN';    -- for get MemberType for EN language.
--exec GetMemberTypes N'TH';    -- for get MemberType for TH language.
-- =============================================
ALTER PROCEDURE [dbo].[GetMemberTypes] 
(
  @langId nvarchar(3) = NULL
, @enabled bit = NULL
)
AS
BEGIN
	SELECT langId
		 , memberTypeId
		 , MemberTypeDescriptionEN
		 , MemberTypeDescriptionNavive
		 , SortOrder
		 , Enabled 
	  FROM MemberTypeMLView
	 WHERE [ENABLED] = COALESCE(@enabled, [ENABLED])
	   AND UPPER(LTRIM(RTRIM(LangId))) = UPPER(LTRIM(RTRIM(COALESCE(@langId,LangId))))
	 ORDER BY SortOrder, MemberTypeId
END

GO


/*********** Script Update Date: 2018-05-15  ***********/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: GetPeriodUnits.
-- Description:	Get Period Units.
-- [== History ==]
-- <2017-05-31> :
--	- Stored Procedure Created.
-- <2018-04-16> :
--	- change language id from nvarchar(10) to nvarchar(3).
-- <2018-05-15> :
--	- change column LangId to langId
--	- change column PeriodUnitId to periodUnitId
--
-- [== Example ==]
--
--exec GetPeriodUnits NULL, 1;  -- for only enabled languages.
--exec GetPeriodUnits;          -- for get all.
--exec GetPeriodUnits N'EN';    -- for get PeriodUnit for EN language.
-- =============================================
ALTER PROCEDURE [dbo].[GetPeriodUnits] 
(
  @langId nvarchar(3) = NULL
, @enabled bit = NULL
)
AS
BEGIN
	SELECT langId
		 , periodUnitId
		 , PeriodUnitDescriptionEN
		 , PeriodUnitDescriptionNative
		 , SortOrder
		 , Enabled 
	  FROM PeriodUnitMLView
	 WHERE [ENABLED] = COALESCE(@enabled, [ENABLED])
	   AND UPPER(LTRIM(RTRIM(LangId))) = UPPER(LTRIM(RTRIM(COALESCE(@langId,LangId))))
	 ORDER BY SortOrder, PeriodUnitId
END

GO


/*********** Script Update Date: 2018-05-15  ***********/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetLimitUnits
-- [== History ==]
-- <2017-05-31> :
--	- Stored Procedure Created.
-- <2018-04-16> :
--	- change language id from nvarchar(10) to nvarchar(3).
-- <2018-05-15> :
--	- change column LangId to langId
--	- change column LimitUnitId to limitUnitId
--
-- [== Example ==]
--
--exec GetLimitUnits NULL, 1;  -- for only enabled languages.
--exec GetLimitUnits;          -- for get all.
--exec GetLimitUnits N'EN';    -- for get LimitUnit for EN language.
-- =============================================
ALTER PROCEDURE [dbo].[GetLimitUnits] 
(
  @langId nvarchar(3) = NULL
, @enabled bit = NULL
)
AS
BEGIN
	SELECT langId
		 , limitUnitId
		 , LimitUnitDescriptionEN
		 , LimitUnitDescriptionNative
		 , LimitUnitTextEN
		 , LimitUnitTextNative
		 , SortOrder
		 , Enabled
	  FROM LimitUnitMLView
	 WHERE [ENABLED] = COALESCE(@enabled, [ENABLED])
	   AND UPPER(LTRIM(RTRIM(LangId))) = UPPER(LTRIM(RTRIM(COALESCE(@langId,LangId))))
	 ORDER BY SortOrder, LimitUnitId
END

GO


/*********** Script Update Date: 2018-05-15  ***********/
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


/*********** Script Update Date: 2018-05-15  ***********/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: GetLicenseFeatures.
-- Description:	Get License Features.
-- [== History ==]
-- <2017-05-31> :
--	- Stored Procedure Created.
-- <2018-04-16> :
--	- change language id from nvarchar(10) to nvarchar(3).
-- <2018-05-15> :
--	- change column LangId to langId
--	- change column LicenseTypeId to licenseTypeId
--	- change column LimitUnitId to limitUnitId
--
-- [== Example ==]
--
--exec GetLicenseFeatures N'EN';    -- for only EN language.
--exec GetLicenseFeatures;          -- for get all.
--exec GetLicenseFeatures N'EN', 1; -- for all features for LicenseTypeId = 1 in EN language.
--exec GetLicenseFeatures N'TH', 0; -- for all features for LicenseTypeId = 0 in TH language.
-- =============================================
ALTER PROCEDURE [dbo].[GetLicenseFeatures] 
(
  @langId nvarchar(3) = null
, @licenseTypeId int = null
)
AS
BEGIN
	SELECT langId
		 , licenseTypeId
		 , seq
		 , limitUnitId
		 , LimitUnitDescriptionEN
		 , LimitUnitDescriptionNative
		 , NoOfLimit
		 , LimitUnitTextEN
		 , LimitUnitTextNative
		 , SortOrder
		 , Enabled 
	  FROM LicenseFeatureMLView
	 WHERE langId = COALESCE(@langId, langId)
	   AND Enabled = 1
	   AND LicenseTypeId = COALESCE(@licenseTypeId, LicenseTypeId)
	 Order By SortOrder, LangId, LicenseTypeId;
END

GO


/*********** Script Update Date: 2018-05-15  ***********/
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
ALTER PROCEDURE [dbo].[GetLicenses] 
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


/*********** Script Update Date: 2018-05-15  ***********/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetUserInfos
-- [== History ==]
-- <2017-05-31> :
--	- Stored Procedure Created.
-- <2018-04-16> :
--	- change language id from nvarchar(10) to nvarchar(3).
-- <2018-05-15> :
--	- change column LangId to langId
--	- change column UserId to userId
--
-- [== Example ==]
--
--exec GetUserInfos NULL, NULL, 1;  -- for only enabled languages.
--exec GetUserInfos;                -- for get all.
--exec GetUserInfos N'EN', NULL;    -- for get UserInfo for EN language all member type.
--exec GetUserInfos N'TH', NULL;    -- for get UserInfo for TH language all member type.
--exec GetUserInfos N'EN', 100;     -- for get UserInfo for EN language member type = 100.
--exec GetUserInfos N'TH', 180;     -- for get UserInfo for TH language member type = 180.
-- =============================================
ALTER PROCEDURE [dbo].[GetUserInfos] 
(
  @langId nvarchar(3) = NULL
, @memberType int = NULL
, @enabled bit = NULL
)
AS
BEGIN
	SELECT langId
		 , userId
		 , MemberType
		 , PrefixEN
		 , FirstNameEn
		 , LastNameEn
		 , FullNameEN
		 , PrefixNative
		 , FirstNameNative
		 , LastNameNative
		 , FullNameNative
		 , UserName
		 , Password
		 , ObjectStatus
		 , SortOrder
		 , Enabled 
	  FROM UserInfoMLView
	 WHERE [ENABLED] = COALESCE(@enabled, [ENABLED])
	   AND [MemberType] = COALESCE(@memberType, [MemberType])
	   AND UPPER(LTRIM(RTRIM(LangId))) = UPPER(LTRIM(RTRIM(COALESCE(@langId,LangId))))
	 ORDER BY SortOrder, UserId
END

GO


/*********** Script Update Date: 2018-05-15  ***********/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetCustomers
-- [== History ==]
-- <2017-05-31> :
--	- Stored Procedure Created.
-- <2018-04-> :
--	- change language id from nvarchar(10) to nvarchar(3).
-- <2018-05-15> :
--	- change column LangId to langId
--
-- [== Example ==]
--
--exec GetCustomers NULL, NULL, 1;             -- for only enabled languages.
--exec GetCustomers;                           -- for get all.
--exec GetCustomers N'EN';                     -- for get customers for EN language.
--exec GetCustomers N'TH';                     -- for get customers for TH language.
--exec GetCustomers N'TH', N'EDL-C2017060011'; -- for get customer for TH language by Customer Id.
-- =============================================
ALTER PROCEDURE [dbo].[GetCustomers] 
(
  @langId nvarchar(3) = NULL
, @customerId nvarchar(30) = NULL
, @enabled bit = NULL
)
AS
BEGIN
	SELECT langId
		 , customerId
		 , CustomerNameEN
		 , CustomerNameNative
		 , TaxCodeEN
		 , TaxCodeNative
		 , Address1EN
		 , Address1Native
		 , Address2EN
		 , Address2Native
		 , CityEN
		 , CityNative
		 , ProvinceEN
		 , ProvinceNative
		 , PostalCodeEN
		 , PostalCodeNative
		 , Phone
		 , Mobile
		 , Fax
		 , Email
		 , ObjectStatus
		 , SortOrder
		 , Enabled 
	  FROM CustomerMLView
	 WHERE [ENABLED] = COALESCE(@enabled, [ENABLED])
	   AND UPPER(LTRIM(RTRIM(LangId))) = UPPER(LTRIM(RTRIM(COALESCE(@langId, LangId))))
	   AND UPPER(LTRIM(RTRIM(CustomerId))) = UPPER(LTRIM(RTRIM(COALESCE(@customerId, CustomerId))))
	 ORDER BY SortOrder, CustomerId
END

GO


/*********** Script Update Date: 2018-05-15  ***********/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetMemberInfos
-- [== History ==]
-- <2017-05-31> :
--	- Stored Procedure Created.
-- <2018-04-16> :
--	- change language id from nvarchar(10) to nvarchar(3).
-- <2018-05-15> :
--	- change column LangId to langId
--	- change column CustomerId to customerId
--	- change column MemberId to memberId
--
-- [== Example ==]
--
--exec GetMemberInfos NULL, NULL, NULL, 1;                  -- for only enabled languages.
--exec GetMemberInfos;                                      -- for get all.
--exec GetMemberInfos N'EN';                                -- for get MemberInfos for EN language.
--exec GetMemberInfos N'TH';                                -- for get MemberInfos for TH language.
--exec GetMemberInfos N'TH', N'EDL-C2017060011';            -- for get MemberInfos by CustomerID.
--exec GetMemberInfos N'TH', N'EDL-C2017060011', N'M00001'; -- for get MemberInfo by CustomerID and MemberId.
-- =============================================
ALTER PROCEDURE [dbo].[GetMemberInfos] 
(
  @langId nvarchar(3) = NULL
, @customerId nvarchar(30) = NULL
, @memberId nvarchar(30) = NULL
, @enabled bit = NULL
)
AS
BEGIN
	SELECT langId
		 , customerId
		 , memberId
		 , MemberType
		 , PrefixEN
		 , FirstNameEN
		 , LastNameEN
		 , FullNameEN
		 , PrefixNative
		 , FirstNameNative
		 , LastNameNative
		 , FullNameNative
		 , IDCard
		 , TagId
		 , EmployeeCode
		 , UserName
		 , Password
		 , ObjectStatus
		 , SortOrder
		 , Enabled 
	  FROM MemberInfoMLView
	 WHERE [ENABLED] = COALESCE(@enabled, [ENABLED])
	   AND UPPER(LTRIM(RTRIM(LangId))) = UPPER(LTRIM(RTRIM(COALESCE(@langId, LangId))))
	   AND UPPER(LTRIM(RTRIM(CustomerId))) = UPPER(LTRIM(RTRIM(COALESCE(@customerId, CustomerId))))
	   AND UPPER(LTRIM(RTRIM(MemberId))) = UPPER(LTRIM(RTRIM(COALESCE(@memberId, MemberId))))
	 ORDER BY SortOrder, LangId, CustomerId, MemberId;
END

GO


/*********** Script Update Date: 2018-05-15  ***********/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: GetBranchs.
-- Description:	Get Branchs.
-- [== History ==]
-- <2017-05-31> :
--	- Stored Procedure Created.
-- <2018-04-16> :
--	- change language id from nvarchar(10) to nvarchar(3).
-- <2018-05-15> :
--	- change column LangId to langId
--	- change column CustomerId to customerId
--	- change column BranchId to branchId
--
-- [== Example ==]
--
--exec GetBranchs NULL, NULL, NULL, 1;                 -- for only enabled languages.
--exec GetBranchs;                                     -- for get all.
--exec GetBranchs N'EN';                               -- for get Branchs for EN language.
--exec GetBranchs N'TH';                               -- for get Branchs for TH language.
--exec GetBranchs N'TH', N'EDL-C2017060011';           -- for get Branchs by CustomerID.
--exec GetBranchs N'TH', N'EDL-C2017060011', N'B0001'; -- for get Branch by CustomerID and BranchId.
-- =============================================
ALTER PROCEDURE [dbo].[GetBranchs] 
(
  @langId nvarchar(3) = NULL
, @customerId nvarchar(30) = NULL
, @branchId nvarchar(30) = NULL
, @enabled bit = NULL
)
AS
BEGIN
	SELECT langId
		 , customerId
		 , branchId
		 , BranchNameEN
		 , BranchNameNative
		 , ObjectStatus
		 , SortOrder
		 , Enabled 
	  FROM BranchMLView
	 WHERE [ENABLED] = COALESCE(@enabled, [ENABLED])
	   AND UPPER(LTRIM(RTRIM(LangId))) = UPPER(LTRIM(RTRIM(COALESCE(@langId, LangId))))
	   AND UPPER(LTRIM(RTRIM(CustomerId))) = UPPER(LTRIM(RTRIM(COALESCE(@customerId, CustomerId))))
	   AND UPPER(LTRIM(RTRIM(BranchId))) = UPPER(LTRIM(RTRIM(COALESCE(@branchId, BranchId))))
	 ORDER BY SortOrder, LangId, CustomerId, BranchId;
END

GO


/*********** Script Update Date: 2018-05-15  ***********/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: GetOrgs
-- Description:	Get Organizations.
-- [== History ==]
-- <2017-05-31> :
--	- Stored Procedure Created.
-- <2018-04-16> :
--	- change language id from nvarchar(10) to nvarchar(3).
-- <2018-05-15> :
--	- change column LangId to langId
--	- change column CustomerId to customerId
--	- change column OrgId to orgId
--	- change column ParentId to parentId
--	- change column BranchId to branchId
--
-- [== Example ==]
--
--/* Get All */
--exec GetOrgs NULL, NULL, NULL, NULL, 1; -- enabled languages only.
--exec GetOrgs; -- all languages.
--/* With Specificed CustomerId */
--exec GetOrgs N'EN', N'EDL-C2017060008'; -- Gets Orgs EN language.
--exec GetOrgs N'TH', N'EDL-C2017060008'; -- Gets Orgs TH language.
--/* With Specificed CustomerId, BranchId */
--exec GetOrgs N'EN', N'EDL-C2017060008', N'B0001'; -- Gets EN language in Branch 1.
--exec GetOrgs N'TH', N'EDL-C2017060008', N'B0002'; -- Gets TH language in Branch 2.
-- =============================================
ALTER PROCEDURE [dbo].[GetOrgs] 
(
  @langId nvarchar(3) = NULL
, @customerId nvarchar(30) = NULL
, @branchId nvarchar(30) = NULL
, @orgId nvarchar(30) = NULL
, @enabled bit = NULL
)
AS
BEGIN
	SELECT langId
		 , customerId
		 , orgId
		 , parentId
		 , branchId
		 , OrgNameEN
		 , BranchNameEN
		 , OrgNameNative
		 , BranchNameNative
		 , OrgStatus
		 , BranchStatus
		 , SortOrder
		 , Enabled 
	  FROM OrgMLView
	 WHERE [ENABLED] = COALESCE(@enabled, [ENABLED])
	   AND UPPER(LTRIM(RTRIM(LangId))) = UPPER(LTRIM(RTRIM(COALESCE(@langId, LangId))))
	   AND UPPER(LTRIM(RTRIM(CustomerId))) = UPPER(LTRIM(RTRIM(COALESCE(@customerId, CustomerId))))
	   AND UPPER(LTRIM(RTRIM(BranchId))) = UPPER(LTRIM(RTRIM(COALESCE(@branchId, BranchId))))
	   AND UPPER(LTRIM(RTRIM(OrgId))) = UPPER(LTRIM(RTRIM(COALESCE(@orgId, OrgId))))
	 ORDER BY SortOrder, LangId, CustomerId, BranchId, OrgId
END

GO


/*********** Script Update Date: 2018-05-15  ***********/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	Get Raw Votes.
-- [== History ==]
-- <2016-10-30> :
--	- Stored Procedure Created.
-- <2016-12-14> :
--	- Add supports pagination.
-- <2018-05-14> :
--	- Add lang Id.
--
-- [== Example ==]
--
--EXEC GetRawVotes N'TH'
--				 , N'EDL-C2018040002'
--				 , N'QS2018040001', 1
--				 , N'2018-05-09 00:00:00', N'2018-05-11 23:59:59';
-- =============================================
CREATE PROCEDURE [dbo].[GetRawVotes] 
(
  @langId as nvarchar(3)
, @customerId as nvarchar(30)
, @qsetId as nvarchar(30)
, @qseq as int
, @beginDate As DateTime = null
, @endDate As DateTime = null
, @pageNum as int = 1 out
, @rowsPerPage as int = 10 out
, @totalRecords as int = 0 out
, @maxPage as int = 0 out
, @errNum as int = 0 out
, @errMsg as nvarchar(100) = N'' out
)
AS
BEGIN
	-- Error Code:
	--   0 : Success
	-- 2101 : CustomerId cannot be null or empty string.
	-- 2102 : QSetId cannot be null or empty string.
	-- 2103 : QSeq cannot be null or less than 1.
	-- 2104 : Begin Date and End Date cannot be null.
	-- 2105 : LangId Is Null Or Empty String.
	-- OTHER : SQL Error Number & Error Message.
	BEGIN TRY
		SET @pageNum = isnull(@pageNum, 1);
		SET @rowsPerPage = isnull(@rowsPerPage, 10);

		IF (@rowsPerPage <= 0) SET @rowsPerPage = 10;
		IF (@pageNum <= 0) SET @pageNum = 1;

		SET @totalRecords = 0;

		IF (dbo.IsNullOrEmpty(@customerId) = 1)
		BEGIN
			-- CustomerId cannot be null or empty string.
			EXEC GetErrorMsg 2101, @errNum out, @errMsg out
			RETURN
		END

		IF (dbo.IsNullOrEmpty(@qsetId) = 1)
		BEGIN
			-- QSetId cannot be null or empty string.
			EXEC GetErrorMsg 2102, @errNum out, @errMsg out
			RETURN
		END

		IF (@qseq IS NULL OR @qseq < 1)
		BEGIN
			-- QSeq cannot be null or less than 1.
			EXEC GetErrorMsg 2103, @errNum out, @errMsg out
			RETURN
		END
		
		IF (@beginDate IS NULL OR @endDate IS NULL)
		BEGIN
			-- Begin Date and End Date cannot be null.
			EXEC GetErrorMsg 2104, @errNum out, @errMsg out
			RETURN
		END
		
		IF (dbo.IsNullOrEmpty(@langId) = 1)
		BEGIN
			-- LangId Is Null Or Empty String.
			EXEC GetErrorMsg 2105, @errNum out, @errMsg out
			RETURN
		END

		-- calculate total record and maxpages
		SELECT @totalRecords = COUNT(*) 
		  FROM Vote
		 WHERE LOWER(CustomerId) = LOWER(RTRIM(LTRIM(@customerId)))
		   AND LOWER(QSetId) = LOWER(RTRIM(LTRIM(@qsetId)))
		   AND QSeq = @qseq
		   AND VoteDate >= @beginDate
		   AND VoteDate <= @endDate
		   AND ObjectStatus = 1;

		SELECT @maxPage = 
			CASE WHEN (@totalRecords % @rowsPerPage > 0) THEN 
				(@totalRecords / @rowsPerPage) + 1
			ELSE 
				(@totalRecords / @rowsPerPage)
			END;

		WITH SQLPaging AS
		( 
			SELECT TOP(@rowsPerPage * @pageNum) ROW_NUMBER() OVER (ORDER BY A.VoteDate) AS RowNo
				, @pageNum PageNo
				, L.LangId
				, A.VoteDate
				, A.VoteSeq
				, A.CustomerId
				, A.QSetId
				, A.QSeq
				, A.VoteValue
				, A.Remark
				, A.OrgId
				, O.OrgNameEN
				, O.OrgNameNative
				, A.BranchId
				, B.BranchNameEN
				, B.BranchNameNative
				, A.DeviceId
				--, D.[Description]
				, A.UserId
				, M.FullNameEN
				, M.FullNameNative
			FROM Vote A 
					INNER JOIN LanguageView L ON (
							L.LangId = @langId
					)
					INNER JOIN OrgMLView O ON (
							O.OrgId = A.OrgId 
						AND O.CustomerId = A.CustomerId
						AND O.LangId = L.LangId
					)
					INNER JOIN BranchMLView B ON (
							B.BranchId = A.BranchId 
						AND B.CustomerId = A.CustomerId
						AND B.LangId = L.LangId
					)
					--INNER JOIN Device D ON (
					--		D.DeviceId = A.DeviceId 
					--	AND D.CustomerId = A.CustomerId
					--)
					LEFT OUTER JOIN MemberInfoMLView M ON (
							M.MemberId = A.UserId 
						AND M.CustomerId = A.CustomerId
						AND M.LangId = L.LangId
					)
			WHERE LOWER(A.CustomerId) = LOWER(RTRIM(LTRIM(@customerId)))
				AND LOWER(A.QSetId) = LOWER(RTRIM(LTRIM(@qsetId)))
				AND A.QSeq = @qseq
				AND A.ObjectStatus = 1
				AND A.VoteDate >= @beginDate
				AND A.VoteDate <= @endDate
			ORDER BY A.VoteDate, A.VoteSeq
		)
		SELECT * FROM SQLPaging WITH (NOLOCK) 
			WHERE RowNo > ((@pageNum - 1) * @rowsPerPage);

		-- success
		EXEC GetErrorMsg 0, @errNum out, @errMsg out
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO


/*********** Script Update Date: 2018-05-15  ***********/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: SaveQSet.
-- Description:	Save Question Set.
-- [== History ==]
-- <2018-05-13> :
--	- Stored Procedure Created.
-- <2018-05-15> :
--	- Add Check code for duplicate description (ERROR_CORE 1416).
--	
--
-- [== Example ==]
--DECLARE @customerId nvarchar(30) = NULL;
--DECLARE @qsetId nvarchar(30) = NULL;
--DECLARE @description nvarchar(MAX);
--DECLARE @displayMode tinyint = 0;
--DECLARE @hasRemark bit = 1;
--DECLARE @isDefault bit = 0;
--DECLARE @beginDate datetime = NULL;
--DECLARE @endDate datetime = NULL;
--DECLARE @errNum int;
--DECLARE @errMsg nvarchar(MAX);
--
--SET @customerId = N'EDL-C2018050001';
--SET @description = N'Question Set 1';
--SET @beginDate = '2018-05-10';
--SET @endDate = '2018-05-15';
--
--EXEC SaveQSet @customerId
--			  , @description
--			  , @hasRemark, @displayMode
--			  , @isDefault
--			  , @beginDate, @endDate
--			  , @qsetId out
--			  , @errNum out, @errMsg out
--SELECT @errNum AS ErrNum, @errMsg AS ErrMsg, @qsetId AS QSetId;
-- =============================================
ALTER PROCEDURE [dbo].[SaveQSet] (
  @customerId as nvarchar(30)
, @description as nvarchar(MAX)
, @hasRemark as bit = 0
, @displayMode as tinyint = 0
, @isDefault as bit = 0
, @beginDate as datetime = null
, @endDate as datetime = null
, @qSetId as nvarchar(30) = null out
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
DECLARE @iCustCnt int = 0;
DECLARE @iQSetCnt int = 0;
DECLARE @iVoteCnt int = 0;

DECLARE @vBeginDate datetime;
DECLARE @vEndDate datetime; 
DECLARE @vBeginDateStr nvarchar(40);
DECLARE @vEndDateStr nvarchar(40); 
	-- Error Code:
	--   0 : Success
	-- 1401 : Customer Id cannot be null or empty string.
	-- 1402 : Customer Id is not found.
	-- 1403 : QSet Id is not found.
	-- 1404 : QSet is already used in vote table.
	-- 1405 : Begin Date and/or End Date should not be null.
	-- 1406 : Display Mode is null or value is not in 0 to 1.
	-- 1407 : Begin Date should less than End Date.
	-- 1408 : Begin Date or End Date is overlap with another Question Set.
	-- 1416 : Description (default) cannot be null or empty string.
	-- 1417 : Description (default) already exists.
	-- OTHER : SQL Error Number & Error Message.
	BEGIN TRY
		IF @isDefault IS NULL
		BEGIN
			SET @isDefault = 0;
		END

		IF (dbo.IsNullOrEmpty(@customerId) = 1)
		BEGIN
			-- Customer Id cannot be null or empty string.
            EXEC GetErrorMsg 1401, @errNum out, @errMsg out
			RETURN
		END

		SELECT @iCustCnt = COUNT(*)
		  FROM Customer
		 WHERE RTRIM(LTRIM(CustomerId)) = RTRIM(LTRIM(@customerId));
		IF (@iCustCnt = 0)
		BEGIN
			-- Customer Id is not found.
            EXEC GetErrorMsg 1504, @errNum out, @errMsg out
			RETURN
		END

		/* Check if QSetId exists */
		IF (@qSetId IS NOT NULL AND LTRIM(RTRIM(@qSetId)) <> N'')
		BEGIN
			SELECT @iQSetCnt = COUNT(*)
			  FROM QSet
			 WHERE LOWER(CustomerId) = LOWER(RTRIM(LTRIM(@customerId)))
			   AND LOWER(QSetId) = LOWER(RTRIM(LTRIM(@qSetId)));
			IF (@iQSetCnt = 0)
			BEGIN
				-- QSet Id is not found.
                EXEC GetErrorMsg 1403, @errNum out, @errMsg out
				RETURN
			END
		END

		IF (@beginDate is null or @endDate is null)
		BEGIN
			-- Begin Date and/or End Date should not be null.
			EXEC GetErrorMsg 1405, @errNum out, @errMsg out
			RETURN
		END

		IF (@displayMode is null or (@displayMode < 0 or @displayMode > 1))
		BEGIN
			-- Display Mode is null or value is not in 0 to 1.
			EXEC GetErrorMsg 1406, @errNum out, @errMsg out
			RETURN
		END

		SET @iQSetCnt = 0; -- Reset Counter.

		-- Checks IsDefault, Begin-End Date.
		IF (@isDefault = 1)
		BEGIN
			-- Set default QSet so need to check the default is already exist or not.
			SELECT @iQSetCnt = COUNT(*)
			  FROM QSet
			 WHERE LOWER(CustomerId) = LOWER(RTRIM(LTRIM(@customerId)))
			   AND IsDefault = 1;

			IF (@iQSetCnt <> 0)
			BEGIN
				-- It's seem the default QSet is already exists.
				-- So change the exist default QSet with new one.
				UPDATE QSet
				   SET IsDefault = 1
				 WHERE LOWER(CustomerId) = LOWER(RTRIM(LTRIM(@customerId)));
			END
		END
		ELSE
		BEGIN
			-- Not a Default QSet so need to check begin data and end date
			-- not overlap with the exist ones but can exists within
			-- Look like.
			-- QSet exist :
			--		B											   E
			--		|----------------------------------------------|
			-- QSet new : (now allow end date is ).
			--			B											   E
			--			|----------------------------------------------|
			-- QSet new : (now allow).
			--	B											   E
			--	|----------------------------------------------|
			-- QSet new : (allow).
			--				B								E
			--				|-------------------------------|
			SET @vBeginDateStr = (CONVERT(nvarchar(4), DatePart(yyyy, @beginDate)) + '-' +
								  CONVERT(nvarchar(2), DatePart(mm, @beginDate)) + '-' +
								  CONVERT(nvarchar(2), DatePart(dd, @beginDate)) + ' ' +
								  N'00:00:00');
			SET @vBeginDate = CONVERT(datetime, @vBeginDateStr, 121);

			SET @vEndDateStr = (CONVERT(nvarchar(4), DatePart(yyyy, @endDate)) + '-' +
								CONVERT(nvarchar(2), DatePart(mm, @endDate)) + '-' +
								CONVERT(nvarchar(2), DatePart(dd, @endDate)) + ' ' +
								N'23:59:59');
			SET @vEndDate = CONVERT(datetime, @vEndDateStr, 121);

			IF (@vBeginDate > @vEndDate)
			BEGIN
				-- Begin Date should less than End Date.
				EXEC GetErrorMsg 1407, @errNum out, @errMsg out
				RETURN
			END

			IF (dbo.IsNullOrEmpty(@qSetId) = 1 AND @isDefault <> 1)
			BEGIN
				-- Check date in all records.
				SELECT @iQSetCnt = count(*)
				  FROM QSet
				 WHERE LOWER(CustomerId) = LOWER(RTRIM(LTRIM(@customerId)))
				   AND ((@vBeginDate between BeginDate and EndDate
					OR @vEndDate between BeginDate and EndDate))
				   AND IsDefault = 0;
			END
			ELSE
			BEGIN
				-- Check date exclude self record.
				SELECT @iQSetCnt = count(*)
				  FROM QSet
				 WHERE ((@vBeginDate between BeginDate and EndDate
					OR @vEndDate between BeginDate and EndDate))
				   AND LOWER(QSetId) <> LOWER(RTRIM(LTRIM(@qSetId)))
				   AND LOWER(CustomerId) = LOWER(RTRIM(LTRIM(@customerId)))
				   AND IsDefault = 0;
			END

			IF @iQSetCnt <> 0
			BEGIN
				-- Begin Date or End Date is overlap with another Question Set.
				EXEC GetErrorMsg 1408, @errNum out, @errMsg out
				RETURN
			END
		END

		IF (dbo.IsNullOrEmpty(@description) = 1)
		BEGIN
			-- Description (default) cannot be null or empty string.
            EXEC GetErrorMsg 1416, @errNum out, @errMsg out
			RETURN
		END

		SET @iQSetCnt = 0; -- Reset Counter.

		-- Checks Duplicated desctiption.
		IF (@qSetId IS NULL)
		BEGIN
			SELECT @iQSetCnt = COUNT(*)
			  FROM QSet
			 WHERE LOWER(CustomerID) = LOWER(RTRIM(LTRIM(@customerId)))
			   AND LOWER(LTRIM(RTRIM(Description))) = LOWER(LTRIM(RTRIM(@description)))
			IF (@iQSetCnt <> 0)
			BEGIN
				-- Description (default) already exists.
                EXEC GetErrorMsg 1417, @errNum out, @errMsg out
				RETURN
			END
		END
		ELSE
		BEGIN
			SELECT @iQSetCnt = COUNT(*)
			  FROM QSet
			 WHERE LOWER(CustomerID) = LOWER(RTRIM(LTRIM(@customerId)))
			   AND LOWER(LTRIM(RTRIM(QSetId))) <> LOWER(LTRIM(RTRIM(@qSetId)))
			   AND LOWER(LTRIM(RTRIM(Description))) = LOWER(LTRIM(RTRIM(@description)))
			IF (@iQSetCnt <> 0)
			BEGIN
				-- Description (default) already exists.
                EXEC GetErrorMsg 1417, @errNum out, @errMsg out
				RETURN
			END
		END

		IF dbo.IsNullOrEmpty(@qSetId) = 1
		BEGIN
			EXEC NextCustomerPK @customerId
			                , N'QSet'
							, @qSetId out
							, @errNum out
							, @errMsg out;
			IF @errNum <> 0
			BEGIN
				RETURN;
			END	
		END
		ELSE
		BEGIN
			SELECT @iQSetCnt = COUNT(*)
			  FROM QSet
			 WHERE LOWER(QSetId) = LOWER(RTRIM(LTRIM(@qSetId)))
			   AND LOWER(CustomerID) = LOWER(RTRIM(LTRIM(@customerId)))
		END

		-- Checks is already in used.
		SELECT @iVoteCnt = COUNT(*)
			FROM Vote
			WHERE LOWER(CustomerId) = LOWER(RTRIM(LTRIM(@customerId)))
			AND LOWER(QSetId) = LOWER(RTRIM(LTRIM(@qSetId)));

		IF (@iVoteCnt <> 0)
		BEGIN
			-- QSet is already used in vote table.
            EXEC GetErrorMsg 1404, @errNum out, @errMsg out
			RETURN
		END

		IF @iQSetCnt = 0
		BEGIN
			INSERT INTO QSet
			(
				  CustomerID
				, QSetID
				, [Description]
				, HasRemark
				, DisplayMode
				, IsDefault
				, BeginDate
				, EndDate
				, ObjectStatus
			)
			VALUES
			(
				  RTRIM(LTRIM(@customerId))
				, RTRIM(LTRIM(@qSetId))
				, RTRIM(LTRIM(@description))
				, @hasRemark
				, @displayMode
				, @isDefault
				, @vBeginDate
				, @vEndDate
				, 1
			);
		END
		ELSE
		BEGIN
			UPDATE QSet
			   SET [Description] = RTRIM(LTRIM(@description))
			     , HasRemark = @hasRemark
				 , DisplayMode = @displayMode
			     , IsDefault = @isDefault
				 , BeginDate = @vBeginDate
				 , EndDate = @vEndDate
			 WHERE LOWER(QSetID) = LOWER(RTRIM(LTRIM(@qSetId))) 
			   AND LOWER(CustomerId) = LOWER(RTRIM(LTRIM(@customerId)));
		END
		
		-- SUCCESS
        EXEC GetErrorMsg 0, @errNum out, @errMsg out
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO

/*********** Script Update Date: 2018-05-15  ***********/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: SaveQSetML.
-- Description:	Save Question Set ML.
-- [== History ==]
-- <2018-05-15> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
--exec SaveQSetML N'EDL-C2018050001', N'QS00001', N'TH', N'คำถามที่ 1'
--exec SaveQSetML N'EDL-C2018050001', N'QS00001', N'JA', N'質問 1'
-- =============================================
CREATE PROCEDURE [dbo].[SaveQSetML] (
  @customerId as nvarchar(30)
, @qSetId as nvarchar(30)
, @langId as nvarchar(3)
, @description as nvarchar(MAX)
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
DECLARE @iCnt int = 0;
DECLARE @iLangCnt int = 0;
DECLARE @iQSetCnt int = 0;
	-- Error Code:
	--    0 : Success
	-- 1409 : Lang Id cannot be null or empty string.
	-- 1410 : Lang Id not found.
	-- 1411 : Customer Id cannot be null or empty string.
	-- 1412 : Customer Id not found.
	-- 1413 : QSetId cannot be null or empty string.
	-- 1414 : No QSet match QSetId in specificed Customer Id.
	-- 1415 : Description(ML) already exists.
	-- 1418 : Description (ML) cannot be null or empty string.
	-- OTHER : SQL Error Number & Error Message.
	BEGIN TRY
		/* Check if lang id is not null. */
		IF (dbo.IsNullOrEmpty(@langId) = 1)
		BEGIN
			-- Lang Id cannot be null or empty string.
            EXEC GetErrorMsg 1409, @errNum out, @errMsg out
			RETURN
		END
		/* Check if language exists. */
		SELECT @iLangCnt = COUNT(LangId)
		  FROM Language
		 WHERE UPPER(RTRIM(LTRIM(LangId))) = UPPER(RTRIM(LTRIM(@langId)));
		IF (@iLangCnt IS NULL OR @iLangCnt = 0) 
		BEGIN
			-- Lang Id not found.
            EXEC GetErrorMsg 1410, @errNum out, @errMsg out
			RETURN
		END

		/* Check if customer id is not null. */
		IF (dbo.IsNullOrEmpty(@customerId) = 1)
		BEGIN
			-- Customer Id cannot be null or empty string.
            EXEC GetErrorMsg 1411, @errNum out, @errMsg out
			RETURN
		END

		SELECT @iCnt = COUNT(*)
		  FROM Customer
		 WHERE UPPER(RTRIM(LTRIM(CustomerId))) = UPPER(RTRIM(LTRIM(@customerId)))
		IF (@iCnt = 0)
		BEGIN
			-- Customer Id not found.
            EXEC GetErrorMsg 1412, @errNum out, @errMsg out
			RETURN
		END

		/* Check if QSetId is not null. */
		IF (dbo.IsNullOrEmpty(@qSetId) = 1)
		BEGIN
			-- QSetId cannot be null or empty string.
            EXEC GetErrorMsg 1413, @errNum out, @errMsg out
			RETURN
		END

		/* Check QSetId is in QSet table */ 
		SELECT @iQSetCnt = COUNT(*)
		  FROM QSet
		 WHERE UPPER(RTRIM(LTRIM(QSetId))) = UPPER(RTRIM(LTRIM(@qSetId)))
		   AND UPPER(RTRIM(LTRIM(CustomerId))) = UPPER(RTRIM(LTRIM(@customerId)))
		IF (@iQSetCnt = 0)
		BEGIN
			-- No QSet match QSetId in specificed Customer Id.
            EXEC GetErrorMsg 1414, @errNum out, @errMsg out
			RETURN
		END

		IF (dbo.IsNullOrEmpty(@description) = 1)
		BEGIN
			-- Description (ML) cannot be null or empty string.
            EXEC GetErrorMsg 1418, @errNum out, @errMsg out
			RETURN
		END

		SELECT @iQSetCnt = COUNT(*)
		  FROM QSetML
		 WHERE UPPER(RTRIM(LTRIM(QSetId))) <> UPPER(RTRIM(LTRIM(@qSetId)))
		   AND UPPER(RTRIM(LTRIM(CustomerId))) = UPPER(RTRIM(LTRIM(@customerId)))
		   AND UPPER(RTRIM(LTRIM(LangId))) = UPPER(RTRIM(LTRIM(@langId)))
		   AND UPPER(RTRIM(LTRIM(Description))) = UPPER(RTRIM(LTRIM(@description)));
		IF (@iQSetCnt <> 0)
		BEGIN
			-- Description (ML) already exists.
            EXEC GetErrorMsg 1415, @errNum out, @errMsg out
			RETURN
		END

		SET @iQSetCnt = 0; -- Reset

		/* check is need to insert or update? */
		SELECT @iQSetCnt = COUNT(*)
		  FROM QSetML
		 WHERE UPPER(RTRIM(LTRIM(QSetId))) <> UPPER(RTRIM(LTRIM(@qSetId)))
		   AND UPPER(RTRIM(LTRIM(CustomerId))) = UPPER(RTRIM(LTRIM(@customerId)))
		   AND UPPER(RTRIM(LTRIM(LangId))) = UPPER(RTRIM(LTRIM(@langId)))

		IF (@iQSetCnt = 0)
		BEGIN
			INSERT INTO QSetML
			(
				  CustomerId
				, QSetId
				, LangId
				, Description
			)
			VALUES
			(
				  UPPER(RTRIM(LTRIM(@customerId)))
				, UPPER(RTRIM(LTRIM(@qSetId)))
				, UPPER(RTRIM(LTRIM(@langId)))
				, RTRIM(LTRIM(@description))
			);
		END
		ELSE
		BEGIN
			UPDATE QSetML
			   SET Description = RTRIM(LTRIM(@description))
		     WHERE UPPER(RTRIM(LTRIM(CustomerId))) = UPPER(RTRIM(LTRIM(@customerId)))
			   AND UPPER(RTRIM(LTRIM(QSetId))) = UPPER(RTRIM(LTRIM(@qSetId)))
			   AND UPPER(RTRIM(LTRIM(LangId))) = UPPER(RTRIM(LTRIM(@langId)));
		END
		
		-- SUCCESS
        EXEC GetErrorMsg 0, @errNum out, @errMsg out
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO


/*********** Script Update Date: 2018-05-15  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: GetQSets.
-- Description:	Get Question Sets.
-- [== History ==]
-- <2018-05-15> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
--EXEC GetQSets NULL, NULL, NULL, 1
--EXEC GetQSets N'EN', NULL, NULL, 1
--EXEC GetQSets NULL, N'EDL-C2018050001', NULL, 1;
--EXEC GetQSets N'EN', N'EDL-C2018050001', NULL, 1;
--EXEC GetQSets NULL, N'EDL-C2018050001', N'QS00001', 1;
--EXEC GetQSets N'EN', N'EDL-C2018050001', N'QS00001', 1;
-- =============================================
CREATE PROCEDURE [dbo].[GetQSets]
(
  @langId nvarchar(3) = NULL
, @customerId nvarchar(30) = NULL
, @qSetId nvarchar(30) = NULL
, @enabled bit = NULL
)
AS
BEGIN
	SELECT langId
		 , customerId
		 , qSetId
		 , BeginDate
		 , EndDate
		 , QSetDescriptionEN
		 , QSetDescriptionNative
		 , DisplayMode
		 , HasRemark
		 , IsDefault
		 , QSetStatus
		 , SortOrder
		 , Enabled 
	  FROM QSetMLView
	 WHERE [ENABLED] = COALESCE(@enabled, [ENABLED])
	   AND UPPER(LTRIM(RTRIM(LangId))) = UPPER(LTRIM(RTRIM(COALESCE(@langId, LangId))))
	   AND UPPER(LTRIM(RTRIM(CustomerId))) = UPPER(LTRIM(RTRIM(COALESCE(@customerId, CustomerId))))
	   AND UPPER(LTRIM(RTRIM(QSetId))) = UPPER(LTRIM(RTRIM(COALESCE(@qSetId, QSetId))))
	 ORDER BY SortOrder, CustomerId, QSetId
END

GO


/*********** Script Update Date: 2018-05-15  ***********/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author: Chumpon Asaneerat
-- Name: SaveQSlide.
-- Description:	Save New Question Slide.
-- [== History ==]
-- <2018-05-15> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
--exec SaveQSlide N'EDL-C2018050001', N'QS00001', N'What do you feel today?'
--exec SaveQSlide N'EDL-C2018050001', N'QS00001', N'What do you feel today?' /*, 0, 1, @qSeq out, @errNum out, @errMsg out*/
--exec SaveQSlide N'EDL-C2018050001', N'QS00002', N'What do think about our service?'
--exec SaveQSlide N'EDL-C2018050001', N'QS00002', N'What do think about our food taste?'
-- =============================================
CREATE PROCEDURE [dbo].[SaveQSlide] (
  @customerId as nvarchar(30)
, @qSetId as nvarchar(30)
, @qText as nvarchar(max) = null
, @hasRemark as bit = 0
, @sortOrder int = 0
, @qSeq as int = 0 out
, @errNum as int = 0 out
, @errMsg as nvarchar(100) = N'' out)
AS
BEGIN
DECLARE @iCustCnt int = 0;
DECLARE @iQSetCnt int = 0;
DECLARE @iQSeqCnt int = 0;
DECLARE @iLastSeq int = 0;
DECLARE @vQSeq int = 0;
	-- Error Code:
	--    0 : Success
	-- 1501 : Customer Id cannot be null or empty string.
	-- 1502 : Question Set Id cannot be null or empty string.
	-- 1503 : Question Text cannot be null or empty string.
	-- 1504 : Customer Id is not found.
	-- 1505 : QSetId is not found. 
	-- 1506 : QSeq is not found.
	-- OTHER : SQL Error Number & Error Message.
	BEGIN TRY
		IF (dbo.IsNullOrEmpty(@customerId) = 1)
		BEGIN
			-- Customer Id cannot be null or empty string.
			EXEC GetErrorMsg 1501, @errNum out, @errMsg out
			RETURN
		END

		IF (dbo.IsNullOrEmpty(@qSetId) = 1)
		BEGIN
			-- Question Set Id cannot be null or empty string.
			EXEC GetErrorMsg 1502, @errNum out, @errMsg out
			RETURN
		END

		IF (dbo.IsNullOrEmpty(@qText) = 1)
		BEGIN
			-- Question Text cannot be null or empty string.
			EXEC GetErrorMsg 1503, @errNum out, @errMsg out
			RETURN
		END

		SELECT @iCustCnt = COUNT(*)
		  FROM Customer
		 WHERE RTRIM(LTRIM(CustomerId)) = RTRIM(LTRIM(@customerId));
		IF (@iCustCnt = 0)
		BEGIN
			-- Customer Id is not found.
            EXEC GetErrorMsg 1504, @errNum out, @errMsg out
			RETURN
		END

		/* Check if QSetId exists */
		IF (@qSetId IS NOT NULL AND LTRIM(RTRIM(@qSetId)) <> N'')
		BEGIN
			SELECT @iQSetCnt = COUNT(*)
			  FROM QSet
			 WHERE LOWER(CustomerId) = LOWER(RTRIM(LTRIM(@customerId)))
			   AND LOWER(QSetId) = LOWER(RTRIM(LTRIM(@qSetId)));
			IF (@iQSetCnt = 0)
			BEGIN
				-- QSetId is not found.
                EXEC GetErrorMsg 1505, @errNum out, @errMsg out
				RETURN
			END
		END

		-- Checks is Seq has value and exists
		IF (@qSeq IS NULL OR @qSeq <= 0)
		BEGIN
			SELECT @vQSeq = MAX(QSeq)
			  FROM QSlide
			 WHERE LOWER(CustomerId) = LOWER(RTRIM(LTRIM(@customerId)))
			   AND LOWER(QSetId) = LOWER(RTRIM(LTRIM(@qSetId)));
			IF (@vQSeq IS NULL OR @vQSeq <= 0)
			BEGIN
				-- SET SEQ TO 1.
				SET @iLastSeq = 1;
			END
			ELSE
			BEGIN
				-- INCREACE SEQ.
				SET @iLastSeq = @vQSeq + 1;
			END
			-- Set sort order if required.
			IF @sortOrder is null or @sortOrder <= 0
			BEGIN
				SET @sortOrder = @iLastSeq;
			END
			-- Check Has Remark.
			IF @hasRemark is null
			BEGIN
				SET @hasRemark = 0; -- default
			END
			-- INSERT
			INSERT INTO QSlide
			(
				  CustomerId
				, QSetId
				, QSeq
				, QText
				, HasRemark
				, SortOrder
				, ObjectStatus
			)
			VALUES
			(
				  RTRIM(LTRIM(@customerId))
				, RTRIM(LTRIM(@qSetId))
				, @iLastSeq
				, RTRIM(LTRIM(@qText))
				, @hasRemark
				, @sortOrder
				, 1
			);
			-- SET OUTPUT.
			SET @qSeq = @iLastSeq;
		END
		ELSE
		BEGIN
			-- CHECKS QSeq exist.
			SELECT @iQSeqCnt = COUNT(QSeq)
			  FROM QSlide
			 WHERE LOWER(CustomerId) = LOWER(RTRIM(LTRIM(@customerId)))
			   AND LOWER(QSetId) = LOWER(RTRIM(LTRIM(@qSetId)))
			   AND QSeq = @qSeq;
			IF (@iQSeqCnt IS NULL OR @iQSeqCnt <= 0)
			BEGIN
				-- QSeq is not found.
                EXEC GetErrorMsg 1506, @errNum out, @errMsg out
				RETURN
			END
			-- Set sort order if required.
			IF (@sortOrder IS NOT NULL AND @sortOrder <= 0)
			BEGIN
				SET @sortOrder = @qSeq;
			END
			-- UPDATE
			UPDATE QSlide
			   SET QText = RTRIM(LTRIM(@qText))
			     , HasRemark = COALESCE(@hasRemark, HasRemark)
				 , SortOrder = COALESCE(@sortOrder, SortOrder)
			 WHERE LOWER(CustomerId) = LOWER(RTRIM(LTRIM(@customerId)))
			   AND LOWER(QSetId) = LOWER(RTRIM(LTRIM(@qSetId)))
			   AND QSeq = @qSeq;
		END
 		-- SUCCESS
		EXEC GetErrorMsg 0, @errNum out, @errMsg out
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO


/*********** Script Update Date: 2018-05-15  ***********/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: SaveQSlideML.
-- Description:	Save Question Slide ML.
-- [== History ==]
-- <2018-05-15> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
--exec SaveQSlideML N'EDL-C2018050001', N'QS00001', 1, N'TH', N'คำถามที่ 1'
--exec SaveQSlideML N'EDL-C2018050001', N'QS00001', 1, N'JA', N'質問 1'
-- =============================================
CREATE PROCEDURE [dbo].[SaveQSlideML] (
  @customerId as nvarchar(30)
, @qSetId as nvarchar(30)
, @qSeq as int
, @langId as nvarchar(3)
, @qText as nvarchar(MAX)
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
DECLARE @iCnt int = 0;
DECLARE @iLangCnt int = 0;
DECLARE @iQSetCnt int = 0;
DECLARE @iQSlideCnt int = 0;
	-- Error Code:
	--    0 : Success
	-- 1507 : Lang Id cannot be null or empty string.
	-- 1508 : Lang Id not found.
	-- 1509 : Customer Id cannot be null or empty string.
	-- 1510 : Customer Id not found.
	-- 1511 : QSetId cannot be null or empty string.
	-- 1512 : No QSet match QSetId in specificed Customer Id.
	-- 1513 : QSeq is null or less than zero.
	-- 1514 : No QSlide match QSetId and QSeq.
	-- 1515 : Question Text (ML) cannot be null or empty string.
	-- 1516 : Question Text (ML) already exists.
	-- 1517 : 
	-- OTHER : SQL Error Number & Error Message.
	BEGIN TRY
		/* Check if lang id is not null. */
		IF (dbo.IsNullOrEmpty(@langId) = 1)
		BEGIN
			-- Lang Id cannot be null or empty string.
            EXEC GetErrorMsg 1507, @errNum out, @errMsg out
			RETURN
		END
		/* Check if language exists. */
		SELECT @iLangCnt = COUNT(LangId)
		  FROM Language
		 WHERE UPPER(RTRIM(LTRIM(LangId))) = UPPER(RTRIM(LTRIM(@langId)));
		IF (@iLangCnt IS NULL OR @iLangCnt = 0) 
		BEGIN
			-- Lang Id not found.
            EXEC GetErrorMsg 1508, @errNum out, @errMsg out
			RETURN
		END

		/* Check if customer id is not null. */
		IF (dbo.IsNullOrEmpty(@customerId) = 1)
		BEGIN
			-- Customer Id cannot be null or empty string.
            EXEC GetErrorMsg 1509, @errNum out, @errMsg out
			RETURN
		END

		SELECT @iCnt = COUNT(*)
		  FROM Customer
		 WHERE UPPER(RTRIM(LTRIM(CustomerId))) = UPPER(RTRIM(LTRIM(@customerId)))
		IF (@iCnt = 0)
		BEGIN
			-- Customer Id not found.
            EXEC GetErrorMsg 1510, @errNum out, @errMsg out
			RETURN
		END

		/* Check if QSetId is not null. */
		IF (dbo.IsNullOrEmpty(@qSetId) = 1)
		BEGIN
			-- QSetId cannot be null or empty string.
            EXEC GetErrorMsg 1511, @errNum out, @errMsg out
			RETURN
		END

		/* Check QSetId is in QSet table */ 
		SELECT @iQSetCnt = COUNT(*)
		  FROM QSet
		 WHERE UPPER(RTRIM(LTRIM(QSetId))) = UPPER(RTRIM(LTRIM(@qSetId)))
		   AND UPPER(RTRIM(LTRIM(CustomerId))) = UPPER(RTRIM(LTRIM(@customerId)))
		IF (@iQSetCnt = 0)
		BEGIN
			-- No QSet match QSetId in specificed Customer Id.
            EXEC GetErrorMsg 1512, @errNum out, @errMsg out
			RETURN
		END

		IF (@qSeq IS NULL OR @qSeq <= 0)
		BEGIN
			-- QSeq is null or less than zero.
            EXEC GetErrorMsg 1513, @errNum out, @errMsg out
			RETURN
		END

		/* Check QSetId, QSeq is in QSlide table */
		SELECT @iQSlideCnt = COUNT(*)
		  FROM QSlide
		 WHERE UPPER(RTRIM(LTRIM(QSetId))) = UPPER(RTRIM(LTRIM(@qSetId)))
		   AND UPPER(RTRIM(LTRIM(CustomerId))) = UPPER(RTRIM(LTRIM(@customerId)))
		   AND QSeq = @qSeq
		IF (@iQSlideCnt = 0)
		BEGIN
			-- No QSlide match QSetId and QSeq.
            EXEC GetErrorMsg 1514, @errNum out, @errMsg out
			RETURN
		END

		IF (dbo.IsNullOrEmpty(@qText) = 1)
		BEGIN
			-- Question Text (ML) cannot be null or empty string.
            EXEC GetErrorMsg 1515, @errNum out, @errMsg out
			RETURN
		END

		SELECT @iQSlideCnt = COUNT(*)
		  FROM QSlideML
		 WHERE UPPER(RTRIM(LTRIM(QSetId))) = UPPER(RTRIM(LTRIM(@qSetId)))
		   AND UPPER(RTRIM(LTRIM(CustomerId))) = UPPER(RTRIM(LTRIM(@customerId)))
		   AND QSeq <> @qSeq
		   AND UPPER(RTRIM(LTRIM(LangId))) = UPPER(RTRIM(LTRIM(@langId)))
		   AND UPPER(RTRIM(LTRIM(QText))) = UPPER(RTRIM(LTRIM(@qText)));
		IF (@iQSlideCnt <> 0)
		BEGIN
			-- Question Text (ML) already exists.
            EXEC GetErrorMsg 1516, @errNum out, @errMsg out
			RETURN
		END

		SET @iQSlideCnt = 0; -- Reset

		/* check is need to insert or update? */
		SELECT @iQSlideCnt = COUNT(*)
		  FROM QSlideML
		 WHERE UPPER(RTRIM(LTRIM(QSetId))) = UPPER(RTRIM(LTRIM(@qSetId)))
		   AND UPPER(RTRIM(LTRIM(CustomerId))) = UPPER(RTRIM(LTRIM(@customerId)))
		   AND QSeq = @qSeq
		   AND UPPER(RTRIM(LTRIM(LangId))) = UPPER(RTRIM(LTRIM(@langId)))

		IF (@iQSlideCnt = 0)
		BEGIN
			INSERT INTO QSlideML
			(
				  CustomerId
				, QSetId
				, QSeq
				, LangId
				, QText
			)
			VALUES
			(
				  UPPER(RTRIM(LTRIM(@customerId)))
				, UPPER(RTRIM(LTRIM(@qSetId)))
				, @qSeq
				, UPPER(RTRIM(LTRIM(@langId)))
				, RTRIM(LTRIM(@qText))
			);
		END
		ELSE
		BEGIN
			UPDATE QSlideML
			   SET QText = RTRIM(LTRIM(@qText))
		     WHERE UPPER(RTRIM(LTRIM(CustomerId))) = UPPER(RTRIM(LTRIM(@customerId)))
			   AND UPPER(RTRIM(LTRIM(QSetId))) = UPPER(RTRIM(LTRIM(@qSetId)))
			   AND QSeq = @qSeq
			   AND UPPER(RTRIM(LTRIM(LangId))) = UPPER(RTRIM(LTRIM(@langId)));
		END
		
		-- SUCCESS
        EXEC GetErrorMsg 0, @errNum out, @errMsg out
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO


/*********** Script Update Date: 2018-05-15  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: GetQSlides.
-- Description:	Get Question Slides.
-- [== History ==]
-- <2018-05-15> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
--EXEC GetQSlides NULL, NULL, NULL, NULL, 1
--EXEC GetQSlides N'EN', NULL, NULL, NULL, 1
--EXEC GetQSlides NULL, N'EDL-C2018050001', NULL, NULL, 1;
--EXEC GetQSlides N'EN', N'EDL-C2018050001', NULL, NULL, 1;
--EXEC GetQSlides NULL, N'EDL-C2018050001', N'QS00002', NULL, 1;
--EXEC GetQSlides N'EN', N'EDL-C2018050001', N'QS00002', NULL, 1;
-- =============================================
CREATE PROCEDURE [dbo].[GetQSlides]
(
  @langId nvarchar(3) = NULL
, @customerId nvarchar(30) = NULL
, @qSetId nvarchar(30) = NULL
, @qSeq int = NULL
, @enabled bit = NULL
)
AS
BEGIN
	SELECT langId
		 , customerId
		 , qSetId
		 , qSeq
		 , QSlideTextEN
		 , QSlideTextNative
		 , HasRemark
		 , QSlideStatus
		 , QSlideOrder
		 , Enabled 
	  FROM QSlideMLView
	 WHERE [ENABLED] = COALESCE(@enabled, [ENABLED])
	   AND UPPER(LTRIM(RTRIM(LangId))) = UPPER(LTRIM(RTRIM(COALESCE(@langId, LangId))))
	   AND UPPER(LTRIM(RTRIM(CustomerId))) = UPPER(LTRIM(RTRIM(COALESCE(@customerId, CustomerId))))
	   AND UPPER(LTRIM(RTRIM(QSetId))) = UPPER(LTRIM(RTRIM(COALESCE(@qSetId, QSetId))))
	   AND QSeq = COALESCE(@qSeq, QSeq)
	 ORDER BY SortOrder, CustomerId, QSetId, QSeq
END

GO


/*********** Script Update Date: 2018-05-15  ***********/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author: Chumpon Asaneerat
-- Name: SaveQSlideItem.
-- Description:	Save New Question Slide Item.
-- [== History ==]
-- <2018-05-15> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--DECLARE @customerId nvarchar(30) = N'EDL-C2018050001';
--DECLARE @qsetId nvarchar(30) = 'QS00001';
--DECLARE @qSeq int = 1;
--DECLARE @qSSeq int = NULL;
--DECLARE @qText nvarchar(MAX);
--DECLARE @isRemark bit = NULL;
--DECLARE @sortOrder int = NULL;
--DECLARE @errNum int;
--DECLARE @errMsg nvarchar(MAX);
--
--SET @qSSeq = NULL;
--SET @qText = N'Choice 1';
--SET @isRemark = NULL;
--EXEC SaveQSlideItem @customerId, @qsetId, @qSeq
--					, @qText, @isRemark, @sortOrder
--					, @qSSeq out
--					, @errNum out, @errMsg out
--SELECT @qSSeq AS QSSeq, @errNum AS ErrNum, @errMsg AS ErrMsg;
--
--SET @qSSeq = NULL;
--SET @qText = N'Choice 2';
--SET @isRemark = NULL;
--EXEC SaveQSlideItem @customerId, @qsetId, @qSeq
--					, @qText, @isRemark, @sortOrder
--					, @qSSeq out
--					, @errNum out, @errMsg out
--SELECT @qSSeq AS QSSeq, @errNum AS ErrNum, @errMsg AS ErrMsg;
--
--SET @qSSeq = NULL;
--SET @qText = N'Choice 3';
--SET @isRemark = NULL;
--EXEC SaveQSlideItem @customerId, @qsetId, @qSeq
--					, @qText, @isRemark, @sortOrder
--					, @qSSeq out
--					, @errNum out, @errMsg out
--SELECT @qSSeq AS QSSeq, @errNum AS ErrNum, @errMsg AS ErrMsg;
--
--SET @qSSeq = NULL;
--SET @qText = N'Choice 4';
--SET @isRemark = NULL;
--EXEC SaveQSlideItem @customerId, @qsetId, @qSeq
--					, @qText, @isRemark, @sortOrder
--					, @qSSeq out
--					, @errNum out, @errMsg out
--SELECT @qSSeq AS QSSeq, @errNum AS ErrNum, @errMsg AS ErrMsg;
--
--SET @qSSeq = NULL;
--SET @qText = N'Remark';
--SET @isRemark = 1;
--EXEC SaveQSlideItem @customerId, @qsetId, @qSeq
--					, @qText, @isRemark, @sortOrder
--					, @qSSeq out
--					, @errNum out, @errMsg out
--SELECT @qSSeq AS QSSeq, @errNum AS ErrNum, @errMsg AS ErrMsg;
-- =============================================
CREATE PROCEDURE [dbo].[SaveQSlideItem] (
  @customerId as nvarchar(30)
, @qSetId as nvarchar(30)
, @qSeq as int
, @qText as nvarchar(max) = null
, @isRemark as bit = 0
, @sortOrder int = 0
, @qSSeq as int = 0 out
, @errNum as int = 0 out
, @errMsg as nvarchar(100) = N'' out)
AS
BEGIN
DECLARE @iCustCnt int = 0;
DECLARE @iQSetCnt int = 0;
DECLARE @iQSlideCnt int = 0;
DECLARE @iQSSeqCnt int = 0;
DECLARE @iLastSSeq int = 0;
DECLARE @vQSSeq int = 0;
	-- Error Code:
	--    0 : Success
	-- 1601 : Customer Id cannot be null or empty string.
	-- 1602 : Question Set Id cannot be null or empty string.
	-- 1603 : QSeq cannot be null or less than zero.
	-- 1604 : Question Text cannot be null or empty string.
	-- 1605 : Customer Id is not found.
	-- 1606 : QSetId is not found. 
	-- 1607 : QSlide is not found.
	-- 1608 : QSSeq is not found.
	-- OTHER : SQL Error Number & Error Message.
	BEGIN TRY
		IF (dbo.IsNullOrEmpty(@customerId) = 1)
		BEGIN
			-- Customer Id cannot be null or empty string.
			EXEC GetErrorMsg 1601, @errNum out, @errMsg out
			RETURN
		END

		IF (dbo.IsNullOrEmpty(@qSetId) = 1)
		BEGIN
			-- Question Set Id cannot be null or empty string.
			EXEC GetErrorMsg 1602, @errNum out, @errMsg out
			RETURN
		END

		IF (@qSeq IS NULL OR @qSeq <= 0)
		BEGIN
			-- QSeq cannot be null or less than zero.
			EXEC GetErrorMsg 1603, @errNum out, @errMsg out
			RETURN
		END

		IF (dbo.IsNullOrEmpty(@qText) = 1)
		BEGIN
			-- Question Text cannot be null or empty string.
			EXEC GetErrorMsg 1604, @errNum out, @errMsg out
			RETURN
		END

		SELECT @iCustCnt = COUNT(*)
		  FROM Customer
		 WHERE RTRIM(LTRIM(CustomerId)) = RTRIM(LTRIM(@customerId));
		IF (@iCustCnt = 0)
		BEGIN
			-- Customer Id is not found.
            EXEC GetErrorMsg 1605, @errNum out, @errMsg out
			RETURN
		END

		/* Check if QSetId exists */
		IF (@qSetId IS NOT NULL AND LTRIM(RTRIM(@qSetId)) <> N'')
		BEGIN
			SELECT @iQSetCnt = COUNT(*)
			  FROM QSet
			 WHERE LOWER(CustomerId) = LOWER(RTRIM(LTRIM(@customerId)))
			   AND LOWER(QSetId) = LOWER(RTRIM(LTRIM(@qSetId)));
			IF (@iQSetCnt = 0)
			BEGIN
				-- QSetId is not found.
                EXEC GetErrorMsg 1606, @errNum out, @errMsg out
				RETURN
			END
		END

		/* Check if QSlide exists */
		SELECT @iQSlideCnt = COUNT(*)
		  FROM QSlide
		 WHERE LOWER(CustomerId) = LOWER(RTRIM(LTRIM(@customerId)))
		   AND LOWER(QSetId) = LOWER(RTRIM(LTRIM(@qSetId)))
		   AND QSeq = @qSeq;
		IF (@iQSlideCnt = 0)
		BEGIN
			-- QSlide is not found.
            EXEC GetErrorMsg 1607, @errNum out, @errMsg out
			RETURN
		END

		-- Checks is QSSeq has value and exists
		IF (@qSSeq IS NULL OR @qSSeq <= 0)
		BEGIN
			SELECT @vQSSeq = MAX(QSSeq)
			  FROM QSlideItem
			 WHERE LOWER(CustomerId) = LOWER(RTRIM(LTRIM(@customerId)))
			   AND LOWER(QSetId) = LOWER(RTRIM(LTRIM(@qSetId)))
			   AND QSeq = @qSeq;
			IF (@vQSSeq IS NULL OR @vQSSeq <= 0)
			BEGIN
				-- SET SEQ TO 1.
				SET @iLastSSeq = 1;
			END
			ELSE
			BEGIN
				-- INCREACE SEQ.
				SET @iLastSSeq = @vQSSeq + 1;
			END
			-- Set sort order if required.
			IF @sortOrder is null or @sortOrder <= 0
			BEGIN
				SET @sortOrder = @iLastSSeq;
			END
			-- Check Has Remark.
			IF @isRemark is null
			BEGIN
				SET @isRemark = 0; -- default
			END
			-- INSERT
			INSERT INTO QSlideItem
			(
				  CustomerId
				, QSetId
				, QSeq
				, QSSeq
				, QText
				, IsRemark
				, SortOrder
				, ObjectStatus
			)
			VALUES
			(
				  RTRIM(LTRIM(@customerId))
				, RTRIM(LTRIM(@qSetId))
				, @qSeq
				, @iLastSSeq
				, RTRIM(LTRIM(@qText))
				, @isRemark
				, @sortOrder
				, 1
			);
			-- SET OUTPUT.
			SET @qSSeq = @iLastSSeq;
		END
		ELSE
		BEGIN
			-- CHECKS QSSeq exist.
			SELECT @iQSSeqCnt = COUNT(QSSeq)
			  FROM QSlideItem
			 WHERE LOWER(CustomerId) = LOWER(RTRIM(LTRIM(@customerId)))
			   AND LOWER(QSetId) = LOWER(RTRIM(LTRIM(@qSetId)))
			   AND QSeq = @qSeq
			   AND QSSeq = @qSSeq;
			IF (@iQSSeqCnt IS NULL OR @iQSSeqCnt <= 0)
			BEGIN
				-- QSSeq is not found.
                EXEC GetErrorMsg 1608, @errNum out, @errMsg out
				RETURN
			END
			-- Set sort order if required.
			IF (@sortOrder IS NOT NULL AND @sortOrder <= 0)
			BEGIN
				SET @sortOrder = @qSSeq;
			END
			-- UPDATE
			UPDATE QSlideItem
			   SET QText = RTRIM(LTRIM(@qText))
			     , IsRemark = COALESCE(@isRemark, IsRemark)
				 , SortOrder = COALESCE(@sortOrder, SortOrder)
			 WHERE LOWER(CustomerId) = LOWER(RTRIM(LTRIM(@customerId)))
			   AND LOWER(QSetId) = LOWER(RTRIM(LTRIM(@qSetId)))
			   AND QSeq = @qSeq
			   AND QSSeq = @qSSeq;
		END
 		-- SUCCESS
		EXEC GetErrorMsg 0, @errNum out, @errMsg out
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO


/*********** Script Update Date: 2018-05-15  ***********/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: SaveQSlideItemML.
-- Description:	Save Question Slide Item ML.
-- [== History ==]
-- <2018-05-15> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
--exec SaveQSlideItemML N'EDL-C2018050001', N'QS00001', 1, N'TH', N'คำถามที่ 1'
--exec SaveQSlideItemML N'EDL-C2018050001', N'QS00001', 1, N'JA', N'質問 1'
--DECLARE @customerId nvarchar(30) = N'EDL-C2018050001';
--DECLARE @qsetId nvarchar(30) = 'QS00001';
--DECLARE @langId nvarchar(3) = NULL;
--DECLARE @qSeq int = 1;
--DECLARE @qSSeq int = 1;
--DECLARE @qText nvarchar(MAX);
--DECLARE @isRemark bit = NULL;
--DECLARE @sortOrder int = NULL;
--DECLARE @errNum int;
--DECLARE @errMsg nvarchar(MAX);

--SET @langId = N'TH';
--SET @qText = N'ตัวเลือกที่ 1';
--EXEC SaveQSlideItemML @customerId, @qsetId, @qSeq, @qSSeq, @langId
--					  , @qText
--					  , @errNum out, @errMsg out
--SELECT @errNum AS ErrNum, @errMsg AS ErrMsg;
--
--SET @langId = N'JA';
--SET @qText = N'選択肢 1';
--EXEC SaveQSlideItemML @customerId, @qsetId, @qSeq, @qSSeq, @langId
--					  , @qText
--					  , @errNum out, @errMsg out
--SELECT @errNum AS ErrNum, @errMsg AS ErrMsg;
-- =============================================
CREATE PROCEDURE [dbo].[SaveQSlideItemML] (
  @customerId as nvarchar(30)
, @qSetId as nvarchar(30)
, @qSeq as int
, @qSSeq as int
, @langId as nvarchar(3)
, @qText as nvarchar(MAX)
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
DECLARE @iCnt int = 0;
DECLARE @iLangCnt int = 0;
DECLARE @iQSetCnt int = 0;
DECLARE @iQSlideCnt int = 0;
DECLARE @iQSlideItemCnt int = 0;
	-- Error Code:
	--    0 : Success
	-- 1609 : Lang Id cannot be null or empty string.
	-- 1610 : Lang Id not found.
	-- 1611 : Customer Id cannot be null or empty string.
	-- 1612 : Customer Id not found.
	-- 1613 : QSetId cannot be null or empty string.
	-- 1614 : No QSet match QSetId in specificed Customer Id.
	-- 1615 : QSeq is null or less than zero.
	-- 1616 : No QSlide match QSetId and QSeq.
	-- 1617 : QSSeq is null or less than zero.
	-- 1618 : No QSlideItem match QSetId, QSeq and QSSeq.
	-- 1619 : Question Item Text (ML) cannot be null or empty string.
	-- 1620 : Question Item Text (ML) already exists.
	-- 1621 : 
	-- OTHER : SQL Error Number & Error Message.
	BEGIN TRY
		/* Check if lang id is not null. */
		IF (dbo.IsNullOrEmpty(@langId) = 1)
		BEGIN
			-- Lang Id cannot be null or empty string.
            EXEC GetErrorMsg 1609, @errNum out, @errMsg out
			RETURN
		END
		/* Check if language exists. */
		SELECT @iLangCnt = COUNT(LangId)
		  FROM Language
		 WHERE UPPER(RTRIM(LTRIM(LangId))) = UPPER(RTRIM(LTRIM(@langId)));
		IF (@iLangCnt IS NULL OR @iLangCnt = 0) 
		BEGIN
			-- Lang Id not found.
            EXEC GetErrorMsg 1610, @errNum out, @errMsg out
			RETURN
		END

		/* Check if customer id is not null. */
		IF (dbo.IsNullOrEmpty(@customerId) = 1)
		BEGIN
			-- Customer Id cannot be null or empty string.
            EXEC GetErrorMsg 1611, @errNum out, @errMsg out
			RETURN
		END

		SELECT @iCnt = COUNT(*)
		  FROM Customer
		 WHERE UPPER(RTRIM(LTRIM(CustomerId))) = UPPER(RTRIM(LTRIM(@customerId)))
		IF (@iCnt = 0)
		BEGIN
			-- Customer Id not found.
            EXEC GetErrorMsg 1612, @errNum out, @errMsg out
			RETURN
		END

		/* Check if QSetId is not null. */
		IF (dbo.IsNullOrEmpty(@qSetId) = 1)
		BEGIN
			-- QSetId cannot be null or empty string.
            EXEC GetErrorMsg 1613, @errNum out, @errMsg out
			RETURN
		END

		/* Check QSetId is in QSet table */ 
		SELECT @iQSetCnt = COUNT(*)
		  FROM QSet
		 WHERE UPPER(RTRIM(LTRIM(QSetId))) = UPPER(RTRIM(LTRIM(@qSetId)))
		   AND UPPER(RTRIM(LTRIM(CustomerId))) = UPPER(RTRIM(LTRIM(@customerId)))
		IF (@iQSetCnt = 0)
		BEGIN
			-- No QSet match QSetId in specificed Customer Id.
            EXEC GetErrorMsg 1614, @errNum out, @errMsg out
			RETURN
		END

		IF (@qSeq IS NULL OR @qSeq <= 0)
		BEGIN
			-- QSeq is null or less than zero.
            EXEC GetErrorMsg 1615, @errNum out, @errMsg out
			RETURN
		END

		/* Check QSetId, QSeq is in QSlide table */
		SELECT @iQSlideCnt = COUNT(*)
		  FROM QSlide
		 WHERE UPPER(RTRIM(LTRIM(QSetId))) = UPPER(RTRIM(LTRIM(@qSetId)))
		   AND UPPER(RTRIM(LTRIM(CustomerId))) = UPPER(RTRIM(LTRIM(@customerId)))
		   AND QSeq = @qSeq
		IF (@iQSlideCnt = 0)
		BEGIN
			-- No QSlide match QSetId and QSeq.
            EXEC GetErrorMsg 1616, @errNum out, @errMsg out
			RETURN
		END

		IF (@qSSeq IS NULL OR @qSSeq <= 0)
		BEGIN
			-- QSSeq is null or less than zero.
            EXEC GetErrorMsg 1617, @errNum out, @errMsg out
			RETURN
		END

		SELECT @iQSlideItemCnt = COUNT(*)
		  FROM QSlideItem
		 WHERE UPPER(RTRIM(LTRIM(QSetId))) = UPPER(RTRIM(LTRIM(@qSetId)))
		   AND UPPER(RTRIM(LTRIM(CustomerId))) = UPPER(RTRIM(LTRIM(@customerId)))
		   AND QSeq = @qSeq
		   AND QSSeq = @qSSeq;

		IF (@iQSlideItemCnt = 0)
		BEGIN
			-- No QSlideItem match QSetId, QSeq and QSSeq.
            EXEC GetErrorMsg 1618, @errNum out, @errMsg out
			RETURN
		END

		IF (dbo.IsNullOrEmpty(@qText) = 1)
		BEGIN
			-- Question Item Text (ML) cannot be null or empty string.
            EXEC GetErrorMsg 1619, @errNum out, @errMsg out
			RETURN
		END

		SELECT @iQSlideItemCnt = COUNT(*)
		  FROM QSlideItemML
		 WHERE UPPER(RTRIM(LTRIM(QSetId))) = UPPER(RTRIM(LTRIM(@qSetId)))
		   AND UPPER(RTRIM(LTRIM(CustomerId))) = UPPER(RTRIM(LTRIM(@customerId)))
		   AND QSeq = @qSeq
		   AND QSSeq <> @qSSeq
		   AND UPPER(RTRIM(LTRIM(LangId))) = UPPER(RTRIM(LTRIM(@langId)))
		   AND UPPER(RTRIM(LTRIM(QText))) = UPPER(RTRIM(LTRIM(@qText)));
		IF (@iQSlideItemCnt <> 0)
		BEGIN
			-- Question Item Text (ML) already exists.
            EXEC GetErrorMsg 1620, @errNum out, @errMsg out
			RETURN
		END

		SET @iQSlideItemCnt = 0; -- Reset

		/* check is need to insert or update? */
		SELECT @iQSlideItemCnt = COUNT(*)
		  FROM QSlideItemML
		 WHERE UPPER(RTRIM(LTRIM(QSetId))) = UPPER(RTRIM(LTRIM(@qSetId)))
		   AND UPPER(RTRIM(LTRIM(CustomerId))) = UPPER(RTRIM(LTRIM(@customerId)))
		   AND QSeq = @qSeq
		   AND QSSeq = @qSSeq
		   AND UPPER(RTRIM(LTRIM(LangId))) = UPPER(RTRIM(LTRIM(@langId)))

		IF (@iQSlideItemCnt = 0)
		BEGIN
			INSERT INTO QSlideItemML
			(
				  CustomerId
				, QSetId
				, QSeq
				, QSSeq
				, LangId
				, QText
			)
			VALUES
			(
				  UPPER(RTRIM(LTRIM(@customerId)))
				, UPPER(RTRIM(LTRIM(@qSetId)))
				, @qSeq
				, @qSSeq
				, UPPER(RTRIM(LTRIM(@langId)))
				, RTRIM(LTRIM(@qText))
			);
		END
		ELSE
		BEGIN
			UPDATE QSlideItemML
			   SET QText = RTRIM(LTRIM(@qText))
		     WHERE UPPER(RTRIM(LTRIM(CustomerId))) = UPPER(RTRIM(LTRIM(@customerId)))
			   AND UPPER(RTRIM(LTRIM(QSetId))) = UPPER(RTRIM(LTRIM(@qSetId)))
			   AND QSeq = @qSeq
			   AND QSSeq = @qSSeq
			   AND UPPER(RTRIM(LTRIM(LangId))) = UPPER(RTRIM(LTRIM(@langId)));
		END
		
		-- SUCCESS
        EXEC GetErrorMsg 0, @errNum out, @errMsg out
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO


/*********** Script Update Date: 2018-05-15  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: GetQSlideItems.
-- Description:	Get Question Slide Items.
-- [== History ==]
-- <2018-05-15> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
--EXEC GetQSlideItems NULL, NULL, NULL, NULL, NULL, 1
--EXEC GetQSlideItems N'EN', NULL, NULL, NULL, NULL, 1
--EXEC GetQSlideItems NULL, N'EDL-C2018050001', NULL, NULL, NULL, 1;
--EXEC GetQSlideItems N'EN', N'EDL-C2018050001', NULL, NULL, NULL, 1;
--EXEC GetQSlideItems NULL, N'EDL-C2018050001', N'QS00001', NULL, NULL, 1;
--EXEC GetQSlideItems N'JA', N'EDL-C2018050001', N'QS00001', NULL, NULL, 1;
-- =============================================
CREATE PROCEDURE [dbo].[GetQSlideItems]
(
  @langId nvarchar(3) = NULL
, @customerId nvarchar(30) = NULL
, @qSetId nvarchar(30) = NULL
, @qSeq int = NULL
, @qSSeq int = NULL
, @enabled bit = NULL
)
AS
BEGIN
	SELECT langId
		 , customerId
		 , qSetId
		 , qSeq
		 , qSSeq
		 , QItemTextEN
		 , QItemTextNative
		 , IsRemark
		 , QItemStatus
		 , QItemOrder
		 , Enabled 
	  FROM QSlideItemMLView
	 WHERE [ENABLED] = COALESCE(@enabled, [ENABLED])
	   AND UPPER(LTRIM(RTRIM(LangId))) = UPPER(LTRIM(RTRIM(COALESCE(@langId, LangId))))
	   AND UPPER(LTRIM(RTRIM(CustomerId))) = UPPER(LTRIM(RTRIM(COALESCE(@customerId, CustomerId))))
	   AND UPPER(LTRIM(RTRIM(QSetId))) = UPPER(LTRIM(RTRIM(COALESCE(@qSetId, QSetId))))
	   AND QSeq = COALESCE(@qSeq, QSeq)
	   AND QSSeq = COALESCE(@qSSeq, QSSeq)
	 ORDER BY SortOrder, CustomerId, QSetId, QSeq
END

GO


/*********** Script Update Date: 2018-05-15  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: InitErrorMessages.
-- Description:	Init error messages.
-- [== History ==]
-- <2017-08-06> :
--	- Stored Procedure Created.
-- <2018-05-10> :
--	- Update new error messages.
--
-- [== Example ==]
--
--exec InitErrorMessages
-- =============================================
ALTER PROCEDURE [dbo].[InitErrorMessages]
AS
BEGIN
    -- SUCCESS.
    EXEC SaveErrorMsg 0000, N'Success.'
    -- LANGUAGES.
    EXEC SaveErrorMsg 0101, N'Language Id cannot be null or empty string.'
    EXEC SaveErrorMsg 0102, N'Description(EN) cannot be null or empty string.'
    EXEC SaveErrorMsg 0103, N'Language Description (en) is duplicated.'
    -- MASTER PK.
    EXEC SaveErrorMsg 0201, N'Table Name is null or empty string.'
    EXEC SaveErrorMsg 0202, N'Seed Reset Mode should be number 1-3.'
    EXEC SaveErrorMsg 0203, N'Seed Digits should be number 1-9.'
    EXEC SaveErrorMsg 0204, N'Table name is not exists in MasterPK table.'
    EXEC SaveErrorMsg 0205, N'Not supports reset mode.'
    EXEC SaveErrorMsg 0206, N'Cannot generate seed code for table:'
    -- PERIOD UNITS.
    EXEC SaveErrorMsg 0301, N'PeriodUnit Id cannot be null.'
    EXEC SaveErrorMsg 0302, N'Description (default) cannot be null or empty string.'
    EXEC SaveErrorMsg 0303, N'Description (default) is duplicated.'
    EXEC SaveErrorMsg 0304, N'Description (ML) cannot be null or empty string.'
    EXEC SaveErrorMsg 0305, N'Cannot add new Description (ML) because the Description (ML) in same Language Id is already exists.'
    EXEC SaveErrorMsg 0306, N'Cannot change Description (ML) because the Description (ML) in same Language Id is already exists.'
    -- LIMIT UNITS.
    EXEC SaveErrorMsg 0401, N'LimitUnit Id cannot be null.'
    EXEC SaveErrorMsg 0402, N'Description (default) cannot be null or empty string.'
    EXEC SaveErrorMsg 0403, N'Description (default) is duplicated.'
    EXEC SaveErrorMsg 0404, N'UnitText (default) cannot be null or empty string.'
    EXEC SaveErrorMsg 0405, N'Language Id cannot be null or empty string.'
    EXEC SaveErrorMsg 0406, N'Language Id not found.'
    EXEC SaveErrorMsg 0407, N'Description (ML) cannot be null or empty string.'
    EXEC SaveErrorMsg 0408, N'Cannot add new Description (ML) because the Description (ML) in same Language Id is already exists.'
    EXEC SaveErrorMsg 0409, N'Cannot change Description (ML) because the Description (ML) in same Language Id is already exists.'
    -- USER INFO(S).
    EXEC SaveErrorMsg 0501, N'FirstName (default) cannot be null or empty string.'
    EXEC SaveErrorMsg 0502, N'UserName cannot be null or empty string.'
    EXEC SaveErrorMsg 0503, N'Password cannot be null or empty string.'
    EXEC SaveErrorMsg 0504, N'User Full Name (default) already exists.'
    EXEC SaveErrorMsg 0505, N'UserName already exists.'
    EXEC SaveErrorMsg 0506, N'Language Id cannot be null or empty string.'
    EXEC SaveErrorMsg 0507, N'The Language Id not exist.'
    EXEC SaveErrorMsg 0508, N'User Id cannot be null or empty string.'
    EXEC SaveErrorMsg 0509, N'FirstName (ML) cannot be null or empty string.'
    EXEC SaveErrorMsg 0510, N'No User match UserId.'
    EXEC SaveErrorMsg 0511, N'User Full Name (ML) already exists.'
    -- LICENSE TYPES.
    EXEC SaveErrorMsg 0601, N'Description (default) cannot be null or empty string.'
    EXEC SaveErrorMsg 0602, N'Advertise Text (default) cannot be null or empty string.'
    EXEC SaveErrorMsg 0603, N'PeriodUnitId cannot be null.'
    EXEC SaveErrorMsg 0604, N'PeriodUnitId not found.'
    EXEC SaveErrorMsg 0605, N'Number of Period cannot be null.'
    EXEC SaveErrorMsg 0606, N'Price cannot be null.'
    EXEC SaveErrorMsg 0607, N'Cannot add new item description because the description (default) is duplicated.'
    EXEC SaveErrorMsg 0608, N'Cannot change item description because the description (default) is duplicated.'
    EXEC SaveErrorMsg 0609, N'Cannot add new item because the period and number of period is duplicated.'
    EXEC SaveErrorMsg 0610, N'Cannot change item because the period and number of period is duplicated.'
    EXEC SaveErrorMsg 0611, N'LicenseTypeId cannot be null.'
    EXEC SaveErrorMsg 0612, N'Language Id cannot be null or empty string.'
    EXEC SaveErrorMsg 0613, N'Language Id not found.'    
    EXEC SaveErrorMsg 0614, N'Description (ML) cannot be null or empty string.'
    EXEC SaveErrorMsg 0615, N'Advertise Text (ML) cannot be null or empty string.'
    EXEC SaveErrorMsg 0616, N'Price (ML) cannot be null.'
    EXEC SaveErrorMsg 0617, N'Description (ML) is duplicated.'    
    -- LICENSE FEATURES.
    EXEC SaveErrorMsg 0701, N'LicenseType Id cannot be null.'
    EXEC SaveErrorMsg 0702, N'LicenseType Id not found.'
    EXEC SaveErrorMsg 0703, N'LimitUnit Id cannot be null.'
    EXEC SaveErrorMsg 0704, N'LimitUnit Id not found.'
    EXEC SaveErrorMsg 0705, N'LimitUnit Id already exists.'
    EXEC SaveErrorMsg 0706, N'No Of Limit cannot be null.'
    EXEC SaveErrorMsg 0707, N'No Of Limit should be zero or more.'
    EXEC SaveErrorMsg 0708, N'Invalid Seq Number.' 
    -- CUSTOMER PK.
    EXEC SaveErrorMsg 0801, N'CustomerId is null or empty string.'
    EXEC SaveErrorMsg 0802, N'Table Name is null or empty string.'
    EXEC SaveErrorMsg 0803, N'Seed Reset Mode should be number 1-4.'
    EXEC SaveErrorMsg 0804, N'Seed Digits should be number 1-9.'
    EXEC SaveErrorMsg 0805, N'Table Name not exists in CustomerPK table.'
    EXEC SaveErrorMsg 0806, N'Not supports reset mode.'
    EXEC SaveErrorMsg 0807, N'Cannot generate seed code for table:'    
    -- CUSTOMERS.
    EXEC SaveErrorMsg 0901, N'Customer Name (default) cannot be null or empty string.'
    EXEC SaveErrorMsg 0902, N'The Customer Id is not exists.'
    EXEC SaveErrorMsg 0903, N'Customer Name (default) is already exists.'
    EXEC SaveErrorMsg 0904, N'Customer Id cannot be null or empty string.'
    EXEC SaveErrorMsg 0905, N'Lang Id cannot be null or empty string.'
    EXEC SaveErrorMsg 0906, N'Lang Id not found.'
    EXEC SaveErrorMsg 0907, N'Customer Name (ML) cannot be null or empty string.'
    EXEC SaveErrorMsg 0908, N'Customer Name (ML) is already exist.'
    -- BRANCH.
    EXEC SaveErrorMsg 1001, N'Customer Id cannot be null or empty string.'
    EXEC SaveErrorMsg 1002, N'Branch Name (default) cannot be null or empty string.'
    EXEC SaveErrorMsg 1003, N'Customer Id is not found.'
    EXEC SaveErrorMsg 1004, N'Branch Id is not found.'
    EXEC SaveErrorMsg 1005, N'Branch Name (default) already exists.'
    EXEC SaveErrorMsg 1006, N'Lang Id cannot be null or empty string.'
    EXEC SaveErrorMsg 1007, N'Language Id not exist.'
    EXEC SaveErrorMsg 1008, N'Branch Id cannot be null or empty string.'
    EXEC SaveErrorMsg 1009, N'Branch Id is not found.'
    EXEC SaveErrorMsg 1010, N'Branch Name (ML) is already exists.'
    -- MEMBER INTO(S).
    EXEC SaveErrorMsg 1101, N'Customer Id cannot be null or empty string.'
    EXEC SaveErrorMsg 1102, N'Customer Id not found.'
    EXEC SaveErrorMsg 1103, N'First Name (default) cannot be null or empty string.'
    EXEC SaveErrorMsg 1104, N'User Name cannot be null or empty string.'
    EXEC SaveErrorMsg 1105, N'Password cannot be null or empty string.'
    EXEC SaveErrorMsg 1106, N'MemberType cannot be null.'
    EXEC SaveErrorMsg 1107, N'MemberType allow only value 200 admin, 210 exclusive, 280 staff, 290 Device.'
    EXEC SaveErrorMsg 1108, N'Member Full Name (default) already exists.'
    EXEC SaveErrorMsg 1109, N'User Name already exists.'
    EXEC SaveErrorMsg 1110, N'Member Id is not found.'
    EXEC SaveErrorMsg 1111, N'IDCard is already exists.'
    EXEC SaveErrorMsg 1112, N'Employee Code is already exists.'
    EXEC SaveErrorMsg 1113, N'TagId is already exists.'
    EXEC SaveErrorMsg 1114, N'Lang Id cannot be null or empty string.'
    EXEC SaveErrorMsg 1115, N'Lang Id not exist.'
    EXEC SaveErrorMsg 1116, N'Member Id cannot be null or empty string.'
    EXEC SaveErrorMsg 1117, N'No Member match MemberId in specificed Customer Id.'
    EXEC SaveErrorMsg 1118, N'Member Full Name (ML) already exists.'
    -- ORGS.
    EXEC SaveErrorMsg 1201, N'Customer Id cannot be null or empty string.'
    EXEC SaveErrorMsg 1202, N'Customer Id not found.'
    EXEC SaveErrorMsg 1203, N'Branch Id cannot be null or empty string.'
    EXEC SaveErrorMsg 1204, N'Branch Id not found.'
    EXEC SaveErrorMsg 1205, N'The Root Org already assigned.'
    EXEC SaveErrorMsg 1206, N'The Parent Org Id is not found.'
    EXEC SaveErrorMsg 1207, N'Org Name (default) cannot be null or empty string.'
    EXEC SaveErrorMsg 1208, N'Org Name (default) already exists.'
    EXEC SaveErrorMsg 1209, N'Lang Id cannot be null or empty string.'
    EXEC SaveErrorMsg 1210, N'Lang Id not found.'
    EXEC SaveErrorMsg 1211, N'Customer Id cannot be null or empty string.'
    EXEC SaveErrorMsg 1212, N'Customer Id not found.'
    EXEC SaveErrorMsg 1213, N'Org Id cannot be null or empty string.'
    EXEC SaveErrorMsg 1214, N'No Org match Org Id in specificed Customer Id.'
    EXEC SaveErrorMsg 1215, N'Org Name (ML) already exists.'
    -- DEVICES.

    -- QSETS.
    EXEC SaveErrorMsg 1401, N'Customer Id cannot be null or empty string.'
    EXEC SaveErrorMsg 1402, N'Customer Id is not found.'
    EXEC SaveErrorMsg 1403, N'QSet Id is not found.'
    EXEC SaveErrorMsg 1404, N'QSet is already used in vote table.'
    EXEC SaveErrorMsg 1405, N'Begin Date and/or End Date should not be null.'
    EXEC SaveErrorMsg 1406, N'Display Mode is null or value is not in 0 to 1.'
    EXEC SaveErrorMsg 1407, N'Begin Date should less than End Date.'
    EXEC SaveErrorMsg 1408, N'Begin Date or End Date is overlap with another Question Set.'
    EXEC SaveErrorMsg 1409, N'Lang Id cannot be null or empty string.'
    EXEC SaveErrorMsg 1410, N'Lang Id not found.'
    EXEC SaveErrorMsg 1411, N'Customer Id cannot be null or empty string.'
    EXEC SaveErrorMsg 1412, N'Customer Id not found.'
    EXEC SaveErrorMsg 1413, N'QSetId cannot be null or empty string.'
    EXEC SaveErrorMsg 1414, N'No QSet match QSetId in specificed Customer Id.'
    EXEC SaveErrorMsg 1415, N'Description(ML) already exists.'
    EXEC SaveErrorMsg 1416, N'Description (default) cannot be null or empty string.'
    EXEC SaveErrorMsg 1417, N'Description (default) already exists.'
    EXEC SaveErrorMsg 1418, N'Description (ML) cannot be null or empty string.'

    -- QSLIDES.
    EXEC SaveErrorMsg 1501, N'Customer Id cannot be null or empty string.'
    EXEC SaveErrorMsg 1502, N'Question Set Id cannot be null or empty string.'
    EXEC SaveErrorMsg 1503, N'Question Text cannot be null or empty string.'
    EXEC SaveErrorMsg 1504, N'Customer Id is not found.'
    EXEC SaveErrorMsg 1505, N'QSetId is not found.'
    EXEC SaveErrorMsg 1506, N'QSeq is not found.'
    EXEC SaveErrorMsg 1507, N'Lang Id cannot be null or empty string.'
    EXEC SaveErrorMsg 1508, N'Lang Id not found.'
    EXEC SaveErrorMsg 1509, N'Customer Id cannot be null or empty string.'
    EXEC SaveErrorMsg 1510, N'Customer Id not found.'
    EXEC SaveErrorMsg 1511, N'QSetId cannot be null or empty string.'
    EXEC SaveErrorMsg 1512, N'No QSet match QSetId in specificed Customer Id.'
    EXEC SaveErrorMsg 1513, N'QSeq is null or less than zero.'
    EXEC SaveErrorMsg 1514, N'No QSlide match QSetId and QSeq.'
    EXEC SaveErrorMsg 1515, N'Question Text (ML) cannot be null or empty string.'
    EXEC SaveErrorMsg 1516, N'Question Text (ML) already exists.'

    -- QSLIDEITEMS.
    EXEC SaveErrorMsg 1601, N'Customer Id cannot be null or empty string.'
    EXEC SaveErrorMsg 1602, N'Question Set Id cannot be null or empty string.'
    EXEC SaveErrorMsg 1603, N'QSeq cannot be null or less than zero.'
    EXEC SaveErrorMsg 1604, N'Question Text cannot be null or empty string.'
    EXEC SaveErrorMsg 1605, N'Customer Id is not found.'
    EXEC SaveErrorMsg 1606, N'QSetId is not found.'
    EXEC SaveErrorMsg 1607, N'QSlide is not found.'
    EXEC SaveErrorMsg 1608, N'QSSeq is not found.'
    EXEC SaveErrorMsg 1609, N'Lang Id cannot be null or empty string.'
    EXEC SaveErrorMsg 1610, N'Lang Id not found.'
    EXEC SaveErrorMsg 1611, N'Customer Id cannot be null or empty string.'
    EXEC SaveErrorMsg 1612, N'Customer Id not found.'
    EXEC SaveErrorMsg 1613, N'QSetId cannot be null or empty string.'
    EXEC SaveErrorMsg 1614, N'No QSet match QSetId in specificed Customer Id.'
    EXEC SaveErrorMsg 1615, N'QSeq is null or less than zero.'
    EXEC SaveErrorMsg 1616, N'No QSlide match QSetId and QSeq.'
    EXEC SaveErrorMsg 1617, N'QSSeq is null or less than zero.'
    EXEC SaveErrorMsg 1618, N'No QSlideItem match QSetId, QSeq and QSSeq.'
    EXEC SaveErrorMsg 1619, N'Question Item Text (ML) cannot be null or empty string.'
    EXEC SaveErrorMsg 1620, N'Question Item Text (ML) already exists.'

    -- VOTES.
    EXEC SaveErrorMsg 1701, N'Customer Id cannot be null or empty string.'
    EXEC SaveErrorMsg 1702, N'Customer Id not found.'
    EXEC SaveErrorMsg 1703, N'Branch Id cannot be null or empty string.'
    EXEC SaveErrorMsg 1704, N'Branch Id not found.'
    EXEC SaveErrorMsg 1705, N'Org Id cannot be null or empty string.'
    EXEC SaveErrorMsg 1706, N'Org Id not found.'
    EXEC SaveErrorMsg 1707, N'QSet Id cannot be null or empty string.'
    EXEC SaveErrorMsg 1708, N'QSet Id not found.'

    -- REGISTER CUSTOMER.
    EXEC SaveErrorMsg 1801, N'CustomerName cannot be null or empty string.'
    EXEC SaveErrorMsg 1802, N'UserName and Password cannot be null or empty string.'

    -- SIGNIN.
    EXEC SaveErrorMsg 1901, N'Reserved not exist.'

    -- GET VOTE SUMMARIES.
    EXEC SaveErrorMsg 2001, N'CustomerId cannot be null or empty string.'
    EXEC SaveErrorMsg 2002, N'QSetId cannot be null or empty string.'
    EXEC SaveErrorMsg 2003, N'QSeq cannot be null.'
    EXEC SaveErrorMsg 2004, N'The default OrgId not found.'
    EXEC SaveErrorMsg 2005, N'The BranchId not found.'

    -- GET RAW VOTES
    EXEC SaveErrorMsg 2101, N'CustomerId cannot be null or empty string.'
    EXEC SaveErrorMsg 2102, N'QSetId cannot be null or empty string.'
    EXEC SaveErrorMsg 2103, N'QSeq cannot be null or less than 1.'
    EXEC SaveErrorMsg 2104, N'Begin Date and End Date cannot be null.'
    EXEC SaveErrorMsg 2105, N'LangId Is Null Or Empty String.'
END

GO

EXEC InitErrorMessages;

GO

