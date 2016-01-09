USE [AWARE]
GO
/****** Object:  StoredProcedure [dbo].[usp_GetSecurityRightId]    Script Date: 8/28/2014 4:46:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_GetSecurityRightId]	
	@ObjectType INT,
	@ObjectId UNIQUEIDENTIFIER,
	@EntityId UNIQUEIDENTIFIER	
AS	
	SET NOCOUNT ON;
	SELECT ID FROM SECURITY_RIGHTS WHERE OBJECT_TYPE_ID = @ObjectType AND OBJECT_ID = @ObjectId AND ENTITY_ID = @EntityId

GO
