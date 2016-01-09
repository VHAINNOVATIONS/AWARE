USE [AWARE]
GO
/****** Object:  StoredProcedure [dbo].[usp_SelectUserRecsByUserID]    Script Date: 8/28/2014 4:46:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_SelectUserRecsByUserID]
	@UserId uniqueidentifier
AS	
	SELECT ID, USER_NAME, FACILITY_ID, VERIFY_CODE FROM USERS where ID = @UserId



GO
