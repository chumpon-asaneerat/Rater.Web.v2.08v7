SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[MemberInfoView]
AS
	SELECT LanguageView.LangId
		 --, LanguageView.FlagId
	     --, LanguageView.DescriptionEN
		 --, LanguageView.DescriptionNative
		 , LanguageView.Enabled
		 , LanguageView.SortOrder
		 , MemberInfo.CustomerId
		 , MemberInfo.MemberId
		 , MemberInfo.TagId
		 , MemberInfo.IDCard
		 , MemberInfo.EmployeeCode
	     , MemberInfo.Prefix AS PrefixEN
	     , MemberInfo.FirstName AS FirstNameEN
	     , MemberInfo.LastName AS LastNameEN
		 , MemberInfo.UserName
		 , MemberInfo.Password
		 , MemberInfo.MemberType
		 , MemberInfo.ObjectStatus
	  FROM LanguageView CROSS JOIN dbo.MemberInfo

GO
