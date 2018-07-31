SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[ErrorMessageView]
AS
    SELECT LanguageView.LangId
		 --, LanguageView.FlagId
	     --, LanguageView.DescriptionEN
		 --, LanguageView.DescriptionNative
		 , LanguageView.Enabled
		 , LanguageView.SortOrder
		 , ErrorMessage.ErrCode
		 , ErrorMessage.ErrMsg
    FROM LanguageView CROSS JOIN dbo.ErrorMessage

GO
