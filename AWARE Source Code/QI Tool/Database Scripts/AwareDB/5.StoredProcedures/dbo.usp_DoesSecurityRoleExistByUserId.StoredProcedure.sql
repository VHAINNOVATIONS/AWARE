USE [AWARE]
GO
/****** Object:  StoredProcedure [dbo].[usp_DoesSecurityRoleExistByUserId]    Script Date: 8/28/2014 4:46:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_DoesSecurityRoleExistByUserId]
	@UserId VARCHAR(50)	
AS	
	SET NOCOUNT ON;
	SELECT COUNT(*) FROM SECURITY_ROLES WHERE USER_ID = @UserId

GO
