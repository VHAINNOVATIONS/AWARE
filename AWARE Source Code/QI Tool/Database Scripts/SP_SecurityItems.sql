USE [AWARE]
GO

/****** Object:  StoredProcedure [dbo].[usp_AddSecurityItem]    Script Date: 7/22/2014 12:13:36 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[usp_AddSecurityItem]	
	@ObjectTypeId INT,	
	@ObjectName VARCHAR(100),
	@PresentationName VARCHAR(100)
AS	
	SET NOCOUNT ON;
	INSERT INTO SECURITY_ITEMS (OBJECT_TYPE_ID, OBJECT_NAME, PRESENTATION_NAME) VALUES (@ObjectTypeId, @ObjectName, @PresentationName)


GO

CREATE PROCEDURE [dbo].[usp_GetSecurityItemName]	
	@ObjectTypeId INT,
	@PresentationName VARCHAR(100)
AS	
	SET NOCOUNT ON;
	SELECT OBJECT_NAME FROM SECURITY_ITEMS WHERE PRESENTATION_NAME = @PresentationName AND OBJECT_TYPE_ID = @ObjectTypeId


GO


CREATE PROCEDURE [dbo].[usp_DoesSecurityItemExist]
	@ObjectTypeId INT,	
	@ObjectName VARCHAR(100)	
AS	
	SET NOCOUNT ON;
	SELECT COUNT(*) FROM SECURITY_ITEMS WHERE OBJECT_TYPE_ID = @ObjectTypeId AND OBJECT_NAME = @ObjectName

GO




