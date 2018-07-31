SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: GetDeviceTypes.
-- Description:	Get Devices.
-- [== History ==]
-- <2018-05-22> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
--exec GetDeviceTypes N'EN';
--exec GetDeviceTypes N'TH';
--exec GetDeviceTypes N'TH', 0;
--exec GetDeviceTypes N'TH', 101
-- =============================================
CREATE PROCEDURE [dbo].[GetDeviceTypes]
    (
    @langId nvarchar(3) = NULL
,
    @deviceTypeId int = NULL
)
AS
BEGIN
    SELECT langId
		 , deviceTypeId
		 , DescriptionEN as TypeEN
		 , DescriptionNative as TypeNative
		 , SortOrder
		 , Enabled
    FROM DeviceTypeMLView
    WHERE UPPER(LTRIM(RTRIM(LangId))) = UPPER(LTRIM(RTRIM(COALESCE(@langId, LangId))))
        AND UPPER(LTRIM(RTRIM(DeviceTypeId))) = UPPER(LTRIM(RTRIM(COALESCE(@deviceTypeId, DeviceTypeId))))
    ORDER BY SortOrder, LangId, deviceTypeId;
END

GO
