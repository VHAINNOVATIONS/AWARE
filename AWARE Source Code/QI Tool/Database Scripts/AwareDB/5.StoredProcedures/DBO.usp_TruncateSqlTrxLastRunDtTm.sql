USE [AWARE]
GO
/****** Object:  StoredProcedure [dbo].[usp_TruncateSqlTrxLastRunDtTm]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_TruncateSqlTrxLastRunDtTm]	
AS	
	SET NOCOUNT ON;
	TRUNCATE TABLE SQLTRX_LAST_UPDATE



