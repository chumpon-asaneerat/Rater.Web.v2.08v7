SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: FindLangId.
-- Description:	Find Proper LangId.
-- [== History ==]
-- <2018-05-29> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
--EXEC FindLangId N'EN';
--EXEC FindLangId N'EN';
-- =============================================
CREATE PROCEDURE FindLangId
(
  @langId as nvarchar(3)
, @lId nvarchar(3) out
)
AS
BEGIN
	IF (dbo.IsNullOrEmpty(@langId) = 1)
	BEGIN
		SET @lId = N'EN';
	END
	ELSE
	BEGIN
		IF (dbo.IsLangExist(@langId) = 0)
		BEGIN
			-- LangId Not Exist.
			SET @lId = N'EN';
		END
		ELSE
		BEGIN
			-- LangId Exist.
			SET @lId = @langId;
		END
	END
END

GO
