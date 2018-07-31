SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[CustomerMLView]
AS
	SELECT CUV.LangId
	     , CUV.CustomerId
		 , CUV.CustomerNameEN
		 , CUV.TaxCodeEN
		 , CUV.Address1EN
		 , CUV.Address2EN
		 , CUV.CityEN
		 , CUV.ProvinceEN
		 , CUV.PostalCodeEN
		 , CASE 
			WHEN CUML.CustomerName IS NULL THEN 
				CUV.CustomerNameEN 
			ELSE 
				CUML.CustomerName 
		   END AS CustomerNameNative
		 , CASE 
			WHEN CUML.CustomerName IS NULL THEN 
				CUV.TaxCodeEN 
			ELSE 
				CUML.TaxCode 
		   END AS TaxCodeNative
		 , CASE 
			WHEN CUML.CustomerName IS NULL THEN 
				CUV.Address1EN 
			ELSE 
				CUML.Address1 
		   END AS Address1Native
		 , CASE 
			WHEN CUML.CustomerName IS NULL THEN 
				CUV.Address2EN 
			ELSE 
				CUML.Address2 
		   END AS Address2Native
		 , CASE 
			WHEN CUML.CustomerName IS NULL THEN 
				CUV.CityEN 
			ELSE 
				CUML.City 
		   END AS CityNative
		 , CASE 
			WHEN CUML.CustomerName IS NULL THEN 
				CUV.ProvinceEN 
			ELSE 
				CUML.Province 
		   END AS ProvinceNative
		 , CASE 
			WHEN CUML.CustomerName IS NULL THEN 
				CUV.PostalCodeEN 
			ELSE 
				CUML.PostalCode 
		   END AS PostalCodeNative
		 , CUV.Phone
		 , CUV.Mobile
		 , CUV.Fax
		 , CUV.Email
		 , CUV.ObjectStatus
		 , CUV.Enabled
		 , CUV.SortOrder
		FROM dbo.CustomerML AS CUML RIGHT OUTER JOIN CustomerView AS CUV
		  ON (CUML.LangId = CUV.LangId AND CUML.CustomerId = CUV.CustomerId)

GO
