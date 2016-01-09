USE [AWARE]
GO
/****** Object:  StoredProcedure [dbo].[usp_VerifyQiUserCredentials]    Script Date: 8/28/2014 4:46:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_VerifyQiUserCredentials]	
	@UserName VARCHAR(50),
	@VerifyCode VARCHAR(50)		
AS	
	SET NOCOUNT ON;
	SELECT COUNT(*) FROM USERS WHERE USER_NAME = @UserName AND VERIFY_CODE = @VerifyCode

GO
