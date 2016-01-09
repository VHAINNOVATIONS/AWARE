USE [AWARE]
GO
/****** Object:  StoredProcedure [dbo].[usp_GetReportIdByName]    Script Date: 8/28/2014 4:46:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[usp_GetReportIdByName]	
	@ObjTypeId INT,
	@RepName VARCHAR(100)		
AS	
	SET NOCOUNT ON;
	SELECT ID FROM SECURITY_ITEMS WHERE OBJECT_TYPE_ID = @ObjTypeId AND OBJECT_NAME = @RepName


GO
