USE [AWARE]
GO
/****** Object:  StoredProcedure [dbo].[usp_AddSecurityItem]    Script Date: 8/28/2014 4:46:56 PM ******/
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
