SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[BranchMLView]
AS
	SELECT BRV.LangId
	     , BRV.CustomerId
	     , BRV.BranchId
	     , BRV.BranchNameEN
		 , CASE 
			WHEN BRML.BranchName IS NULL THEN 
				BRV.BranchNameEN 
			ELSE 
				BRML.BranchName 
		   END AS BranchNameNative
	     , BRV.ObjectStatus
	     , BRV.Enabled
	     , BRV.SortOrder
		FROM dbo.BranchML AS BRML RIGHT OUTER JOIN BranchView AS BRV
		  ON (    BRML.LangId = BRV.LangId 
		      AND BRML.CustomerId = BRV.CustomerId
		      AND BRML.BranchId = BRV.BranchId
			 )

GO
