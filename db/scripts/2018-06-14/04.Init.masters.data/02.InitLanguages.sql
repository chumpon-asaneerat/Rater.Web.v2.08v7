SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	Init supports languages
-- [== History ==]
-- <2017-08-06> :
--	- Stored Procedure Created.
-- <2018-05-29> :
--	- Update code for new table structure.
--
-- [== Example ==]
--
--exec InitLanguages
-- =============================================
CREATE PROCEDURE [dbo].[InitLanguages]
AS
BEGIN
    EXEC SaveLanguage N'EN', N'us', N'English', N'English', N'$', N'USD', N'USD', 1, 1
    EXEC SaveLanguage N'TH', N'th', N'Thai', N'ไทย', N'฿', N'BAHT', N'บาท', 2, 1
    EXEC SaveLanguage N'ZH', N'cn', N'Chinese', N'中文', N'¥', N'CNY', N'元', 3, 1
    EXEC SaveLanguage N'JA', N'jp', N'Japanese', N'中文', N'¥', N'Yen', N'日元', 4, 1
    EXEC SaveLanguage N'DE', N'de', N'German', N'Deutsche', N'€', N'EUR', NULL, 5, 0
    EXEC SaveLanguage N'FR', N'fr', N'French', N'français', N'€', N'EUR', NULL, 6, 0
    EXEC SaveLanguage N'KO', N'kr', N'Korean', N'한국어', N'₩', N'Won', N'원', 7, 1
    EXEC SaveLanguage N'RU', N'ru', N'Russian', N'Россия', N'₽', N'RUB', N'рубль', 8, 0
    EXEC SaveLanguage N'ES', N'es', N'Spanish', NULL, N'€', N'EUR', N'EUR', 9, 1
END

GO

EXEC InitLanguages;
GO
