USE [AWARE]
GO
/****** Object:  Table [dbo].[Followups$]    Script Date: 8/28/2014 4:46:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Followups$](
	[STATION_DATETIME_ALERTID] [varchar](50) NOT NULL,
	[FOLLOWUP] [varchar](50) NOT NULL,
	[FOLLOWUPDATETIME] [datetime] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
