USE [AWARE]
GO
/****** Object:  StoredProcedure [dbo].[usp_GetSecurityItemName]    Script Date: 8/28/2014 4:46:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_GetSecurityItemName]	
	@ObjectTypeId INT,
	@PresentationName VARCHAR(100)
AS	
	SET NOCOUNT ON;
	SELECT OBJECT_NAME FROM SECURITY_ITEMS WHERE PRESENTATION_NAME = @PresentationName AND OBJECT_TYPE_ID = @ObjectTypeId



GO
