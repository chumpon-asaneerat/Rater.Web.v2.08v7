SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: GetErrorMsgs.
-- Description:	Gets error messages
-- [== History ==]
-- <2017-05-31> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
--exec GetErrorMsgs; -- gets all error messages.
-- =============================================
CREATE PROCEDURE [dbo].[GetErrorMsgs]
AS
BEGIN
    SELECT *
    FROM [dbo].[ErrorMessage]
    ORDER BY ErrCode
END

GO
