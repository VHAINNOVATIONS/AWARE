USE [AWARE]
GO

CREATE PROCEDURE [dbo].[usp_SelectUserRecsByUserID]
	@UserId uniqueidentifier
AS	
	SELECT ID, USER_NAME, FACILITY_ID, VERIFY_CODE FROM USERS where ID = @UserId


GO


