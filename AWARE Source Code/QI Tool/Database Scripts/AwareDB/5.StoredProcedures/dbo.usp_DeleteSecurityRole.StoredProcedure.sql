USE [AWARE]
GO
/****** Object:  StoredProcedure [dbo].[usp_DeleteSecurityRole]    Script Date: 8/28/2014 4:46:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_DeleteSecurityRole]
	@GroupId UNIQUEIDENTIFIER
AS	
	SET NOCOUNT ON;
	DELETE FROM SECURITY_ROLES WHERE GROUP_ID = @GroupId

GO
