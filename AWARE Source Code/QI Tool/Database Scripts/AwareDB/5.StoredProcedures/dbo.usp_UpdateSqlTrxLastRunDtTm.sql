USE [AWARE]
GO
/****** Object:  StoredProcedure [dbo].[usp_UpdateSqlTrxLastRunDtTm]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_UpdateSqlTrxLastRunDtTm]	
AS	
	SET NOCOUNT ON;
	INSERT INTO SQLTRX_LAST_UPDATE (LAST_UPDATE) VALUES (GETDATE())



