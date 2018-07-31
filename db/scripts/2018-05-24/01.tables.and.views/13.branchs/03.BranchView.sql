SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[BranchView]
AS
	SELECT LanguageView.LangId
		 --, LanguageView.FlagId
	     --, LanguageView.DescriptionEN
		 --, LanguageView.DescriptionNative
		 , LanguageView.Enabled
		 , LanguageView.SortOrder
		 , Branch.CustomerId
		 , Branch.BranchId
	     , Branch.BranchName AS BranchNameEN
		 , Branch.ObjectStatus
	  FROM LanguageView CROSS JOIN dbo.Branch

GO
