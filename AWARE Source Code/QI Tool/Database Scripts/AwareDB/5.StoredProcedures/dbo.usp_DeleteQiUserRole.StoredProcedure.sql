USE [AWARE]
GO
/****** Object:  StoredProcedure [dbo].[usp_DeleteQiUserRole]    Script Date: 8/28/2014 4:46:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_DeleteQiUserRole]		
	@QiGroupId UNIQUEIDENTIFIER,
	@UserId UNIQUEIDENTIFIER	
AS	
    SET NOCOUNT ON;
	DELETE FROM SECURITY_ROLES WHERE GROUP_ID = @QiGroupId AND USER_ID = @UserId

GO
