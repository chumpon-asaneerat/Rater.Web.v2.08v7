SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[CustomerView]
AS
	SELECT LanguageView.LangId
		 --, LanguageView.FlagId
	     --, LanguageView.DescriptionEN
		 --, LanguageView.DescriptionNative
		 , LanguageView.Enabled
		 , LanguageView.SortOrder
	     , Customer.CustomerId
		 , Customer.CustomerName AS CustomerNameEN
		 , Customer.TaxCode AS TaxCodeEN
		 , Customer.Address1 AS Address1EN
		 , Customer.Address2 AS Address2EN
		 , Customer.City AS CityEN
		 , Customer.Province AS ProvinceEN
		 , Customer.PostalCode AS PostalCodeEN
		 , Customer.Phone
		 , Customer.Mobile
		 , Customer.Fax
		 , Customer.Email
		 , Customer.ObjectStatus
	  FROM LanguageView CROSS JOIN dbo.Customer

GO
