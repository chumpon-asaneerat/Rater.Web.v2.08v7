SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[MemberInfoMLView]
AS
	SELECT MIV.LangId
	     , MIV.CustomerId
	     , MIV.MemberId
	     , MIV.MemberType
	     , MIV.PrefixEN
	     , MIV.FirstNameEN
	     , MIV.LastNameEN
		 , CASE 
			WHEN MIML.FirstName IS NULL THEN 
				MIV.PrefixEN 
			ELSE 
				MIML.Prefix 
		   END AS PrefixNative
		 , CASE 
			WHEN MIML.FirstName IS NULL THEN 
				MIV.FirstNameEN 
			ELSE 
				MIML.FirstName 
		   END AS FirstNameNative
		 , CASE 
			WHEN MIML.FirstName IS NULL THEN 
				MIV.LastNameEN 
			ELSE 
				MIML.LastName 
		   END AS LastNameNative
	     , RTRIM(LTRIM(RTRIM(LTRIM(ISNULL(MIV.PrefixEN, N''))) + N' ' +
		               RTRIM(LTRIM(MIV.FirstNameEN)) + N' ' +
		               RTRIM(LTRIM(ISNULL(MIV.LastNameEN, N''))))) AS FullNameEN
		 , CASE 
			WHEN MIML.FirstName IS NULL THEN /* Use FirstName to check for used Native data */
				RTRIM(LTRIM(RTRIM(LTRIM(ISNULL(MIV.PrefixEN, N''))) + N' ' +
				            RTRIM(LTRIM(MIV.FirstNameEN)) + N' ' +
				            RTRIM(LTRIM(ISNULL(MIV.LastNameEN, N'')))))
			ELSE 
				RTRIM(LTRIM(RTRIM(LTRIM(ISNULL(MIML.Prefix, N''))) + N' ' +
				            RTRIM(LTRIM(MIML.FirstName)) + N' ' +
				            RTRIM(LTRIM(ISNULL(MIML.LastName, N'')))))
		   END AS FullNameNative
	     , MIV.IDCard
	     , MIV.TagId
	     , MIV.EmployeeCode
	     , MIV.UserName
	     , MIV.Password
	     , MIV.ObjectStatus
	     , MIV.Enabled
	     , MIV.SortOrder
		FROM dbo.MemberInfoML AS MIML RIGHT OUTER JOIN MemberInfoView AS MIV
		  ON (    MIML.LangId = MIV.LangId 
		      AND MIML.CustomerId = MIV.CustomerId
		      AND MIML.MemberId = MIV.MemberId
			 )

GO
