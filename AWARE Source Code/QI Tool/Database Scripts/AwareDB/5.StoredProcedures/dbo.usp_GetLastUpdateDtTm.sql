USE [AWARE]
GO
/****** Object:  StoredProcedure [dbo].[usp_GetLastUpdateDtTm]  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_GetLastUpdateDtTm]		
AS	
    SET NOCOUNT ON;
	SELECT MAX(LAST_UPDATE) FROM SQLTRX_LAST_UPDATE