SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[UserInfoView]
AS
	SELECT LanguageView.LangId
		 --, LanguageView.FlagId
	     --, LanguageView.DescriptionEN
		 --, LanguageView.DescriptionNative
		 , LanguageView.Enabled
		 , LanguageView.SortOrder
	     , UserInfo.UserId
		 , UserInfo.MemberType
		 , UserInfo.UserName
		 , UserInfo.Password
		 , UserInfo.ObjectStatus
		 , UserInfo.Prefix AS PrefixEN
		 , UserInfo.FirstName AS FirstNameEN
		 , UserInfo.LastName AS LastNameEN
	  FROM LanguageView CROSS JOIN dbo.UserInfo

GO
