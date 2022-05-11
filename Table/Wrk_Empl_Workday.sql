USE [MMA_DW_EHB]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Wrk_Empl_Workday](
	[EMPL_ID] [varchar](50) NULL,
	[Dpt_Region] [varchar](50) NULL,
	[StaffCode] [varchar](50) NULL,
	[Email_Addr] [varchar](50) NULL
) ON [PRIMARY]
GO