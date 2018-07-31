SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[UserInfoMLView]
AS
	SELECT UIV.LangId
	     , UIV.UserId
		 , UIV.MemberType
		 , UIV.PrefixEN
		 , UIV.FirstNameEn
		 , UIV.LastNameEn
	     , RTRIM(LTRIM(RTRIM(LTRIM(ISNULL(UIV.PrefixEN, N''))) + N' ' +
		               RTRIM(LTRIM(UIV.FirstNameEN)) + N' ' +
		               RTRIM(LTRIM(ISNULL(UIV.LastNameEN, N''))))) AS FullNameEN
		 , CASE 
			WHEN UIML.FirstName IS NULL THEN /* Use FirstName to check for used Native data */
				UIV.PrefixEN 
			ELSE 
				UIML.Prefix 
		   END AS PrefixNative
		 , CASE 
			WHEN UIML.FirstName IS NULL THEN 
				UIV.FirstNameEN 
			ELSE 
				UIML.FirstName 
		   END AS FirstNameNative
		 , CASE 
			WHEN UIML.FirstName IS NULL THEN /* Use FirstName to check for used Native data */
				UIV.LastNameEN 
			ELSE 
				UIML.LastName
		   END AS LastNameNative
		 , CASE 
			WHEN UIML.FirstName IS NULL THEN /* Use FirstName to check for used Native data */
				RTRIM(LTRIM(RTRIM(LTRIM(ISNULL(UIV.PrefixEN, N''))) + N' ' +
				            RTRIM(LTRIM(UIV.FirstNameEN)) + N' ' +
				            RTRIM(LTRIM(ISNULL(UIV.LastNameEN, N'')))))
			ELSE 
				RTRIM(LTRIM(RTRIM(LTRIM(ISNULL(UIML.Prefix, N''))) + N' ' +
				            RTRIM(LTRIM(UIML.FirstName)) + N' ' +
				            RTRIM(LTRIM(ISNULL(UIML.LastName, N'')))))
		   END AS FullNameNative
	     , UIV.UserName
	     , UIV.Password
		 , UIV.ObjectStatus
		 , UIV.Enabled
		 , UIV.SortOrder
		FROM dbo.UserInfoML AS UIML RIGHT OUTER JOIN UserInfoView AS UIV
		  ON (UIML.LangId = UIV.LangId AND UIML.UserId = UIV.UserId)

GO
