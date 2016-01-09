USE [AWARE]
GO
/****** Object:  StoredProcedure [dbo].[usp_SelectUsersVerifyCode]    Script Date: 8/28/2014 4:46:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_SelectUsersVerifyCode]
	@UserId VARCHAR(50)
AS		
    SET NOCOUNT ON;
	SELECT VERIFY_CODE FROM USERS WHERE ID = @UserId

GO
