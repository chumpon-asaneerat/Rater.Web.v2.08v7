/*********** Script Update Date: 2018-05-22  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[ClientAccess](
	[AccessId] [nvarchar](30) NOT NULL,
	[ClientId] [nvarchar](50) NULL,
	[ClientInitDate] [datetime] NULL,
	[ClientInfo] [nvarchar](max) NULL,
	[CustomerId] [nvarchar](30) NULL,
	[OrgId] [nvarchar](30) NULL,
	[MemberId] [nvarchar](30) NULL,
	[MemberTypeId] [int] NULL,
	[LastAccess] [datetime] NULL,
 CONSTRAINT [PK_ClientAccess] PRIMARY KEY CLUSTERED 
(
	[AccessId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Unique access Id.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ClientAccess', @level2type=N'COLUMN',@level2name=N'AccessId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Client Id. from ClientJS.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ClientAccess', @level2type=N'COLUMN',@level2name=N'ClientId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Client Init Date.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ClientAccess', @level2type=N'COLUMN',@level2name=N'ClientInitDate'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Customer Id.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ClientAccess', @level2type=N'COLUMN',@level2name=N'CustomerId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The OrgId.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ClientAccess', @level2type=N'COLUMN',@level2name=N'OrgId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The UserId (EDL User) or MemberId (Customer User).' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ClientAccess', @level2type=N'COLUMN',@level2name=N'MemberId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The member type Id.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ClientAccess', @level2type=N'COLUMN',@level2name=N'MemberTypeId'
GO

/*********** Script Update Date: 2018-05-22  ***********/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: RegisterClient.
-- Description:	Register Client.
-- [== History ==]
-- <2018-05-22> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
--EXEC RegisterClient N'3524260733', N'2018-05-22 00:10:11.333', N'{ isMobile: true }'
-- =============================================
CREATE PROCEDURE RegisterClient (
  @clientId nvarchar(50) = null
, @clientInitDate datetime = null
, @clientInfo nvarchar(MAX) = null
, @accessId nvarchar(30) = null out
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
DECLARE @iCnt int = 0;
    -- Error Code:
    --     0 : Success
    --  2301 : Client Id cannot be null or empty string.
	--  2302 : Client Init Date cannot be null.
	--  2303 : Client is already registered.
    -- OTHER : SQL Error Number & Error Message.
    BEGIN TRY
		IF (dbo.IsNullOrEmpty(@clientId) = 1)
		BEGIN
			-- Client Id cannot be null or empty string.
            EXEC GetErrorMsg 2301, @errNum out, @errMsg out
			RETURN
		END

		IF (@clientInitDate IS NULL)
		BEGIN
			-- Client Init Date cannot be null.
            EXEC GetErrorMsg 2302, @errNum out, @errMsg out
			RETURN
		END

		-- Check is already exists.
		SELECT @iCnt = COUNT(*)
		  FROM ClientAccess
		 WHERE LOWER(LTRIM(RTRIM(ClientId))) = LOWER(LTRIM(RTRIM(@clientId)))
		   AND ClientInitDate = @clientInitDate;

		IF (@iCnt <> 0)
		BEGIN
			-- Client is already registered.
			EXEC GetErrorMsg 2303, @errNum out, @errMsg out
			RETURN
		END

		-- Get Access Id.
		EXEC GetRandomHexCode 15, @accessId out;

		INSERT INTO ClientAccess
		(
		    AccessId
		  , ClientId
		  , ClientInitDate
		  , ClientInfo
		  , LastAccess
		)
		VALUES
		(
		    @accessId
		  , @clientId
		  , @clientInitDate
		  , @clientInfo
		  , GETDATE()
		);

		-- SUCCESS
		EXEC GetErrorMsg 0, @errNum out, @errMsg out
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO

