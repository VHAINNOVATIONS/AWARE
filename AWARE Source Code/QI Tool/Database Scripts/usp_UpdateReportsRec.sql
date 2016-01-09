USE [AWARE]
GO

/****** Object:  StoredProcedure [dbo].[usp_UpdateReportsRec]    Script Date: 7/17/2014 3:29:35 PM ******/
DROP PROCEDURE [dbo].[usp_UpdateReportsRec]
GO

/****** Object:  StoredProcedure [dbo].[usp_UpdateReportsRec]    Script Date: 7/17/2014 3:29:35 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_UpdateReportsRec]	
	@RepFileName VARCHAR(100),
	@RepPresName VARCHAR(100),
	@RptId UNIQUEIDENTIFIER		
AS	
	SET NOCOUNT ON;
	UPDATE SECURITY_ITEMS 
		SET 
			OBJECT_NAME = @RepFileName,
			PRESENTATION_NAME = @RepPresName
		WHERE ID = @RptId

GO


