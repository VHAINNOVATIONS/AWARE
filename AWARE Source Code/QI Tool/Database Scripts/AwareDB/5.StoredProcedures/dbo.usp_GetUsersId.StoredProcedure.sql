USE [AWARE]
GO
/****** Object:  StoredProcedure [dbo].[usp_GetUsersId]    Script Date: 8/28/2014 4:46:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_GetUsersId]
	@UserName VARCHAR(50)	 
AS	
    SET NOCOUNT ON;
	SELECT ID FROM USERS WHERE USER_NAME = @UserName;

GO
