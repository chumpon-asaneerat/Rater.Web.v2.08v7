GO
/****** Object:  StoredProcedure [dbo].[InitAll]    Script Date: 4/26/2018 22:40:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	Init All required data.
-- [== History ==]
-- <2017-08-06> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
--exec InitAll
-- =============================================
CREATE PROCEDURE [dbo].[InitAll]
AS
BEGIN
    EXEC InitErrorMessages;
    EXEC InitLanguages;
    EXEC InitMemberTypes;
    EXEC InitPeriodUnits;
    EXEC InitLimitUnits;
    EXEC InitLicenseTypes;
    EXEC InitLicenseFeatures;
    EXEC InitMasterPKs;
    EXEC InitDefaultUser;
END

GO
