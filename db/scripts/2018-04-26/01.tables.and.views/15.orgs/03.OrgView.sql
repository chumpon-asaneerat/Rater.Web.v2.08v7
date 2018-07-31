SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[OrgView]
AS
	SELECT LanguageView.LangId
		 --, LanguageView.FlagId
	     --, LanguageView.DescriptionEN
		 --, LanguageView.DescriptionNative
		 , LanguageView.Enabled
		 , LanguageView.SortOrder
		 , dbo.Org.CustomerId
		 , dbo.Org.OrgId
		 , dbo.Org.BranchId
		 , dbo.Org.ParentId
	     , dbo.Org.OrgName AS OrgNameEN
		 , dbo.Org.ObjectStatus
	  FROM LanguageView CROSS JOIN dbo.Org

GO
