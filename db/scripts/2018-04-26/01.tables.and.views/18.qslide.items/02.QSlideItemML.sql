SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[QSlideItemML](
	[CustomerId] [nvarchar](30) NOT NULL,
	[QSetId] [nvarchar](30) NOT NULL,
	[QSeq] [int] NOT NULL,
	[QSSeq] [int] NOT NULL,
	[LangId] [nvarchar](3) NOT NULL,
	[QText] [nvarchar](max) NOT NULL,
 CONSTRAINT [PK_QSlideItemML] PRIMARY KEY CLUSTERED 
(
	[CustomerId] ASC,
	[QSetId] ASC,
	[QSeq] ASC,
	[QSSeq] ASC,
	[LangId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Customer Id.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'QSlideItemML', @level2type=N'COLUMN',@level2name=N'CustomerId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Question Set Id.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'QSlideItemML', @level2type=N'COLUMN',@level2name=N'QSetId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Question Slide Seq.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'QSlideItemML', @level2type=N'COLUMN',@level2name=N'QSeq'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Question Item Seq.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'QSlideItemML', @level2type=N'COLUMN',@level2name=N'QSSeq'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Language Id.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'QSlideItemML', @level2type=N'COLUMN',@level2name=N'LangId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Question Item Text.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'QSlideItemML', @level2type=N'COLUMN',@level2name=N'QText'
GO
