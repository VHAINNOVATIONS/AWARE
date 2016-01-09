USE AWARE
GO
IF OBJECT_ID ( 'dbo.usp_GetLastUpdateDateTime', 'P' ) IS NOT NULL 
    DROP PROCEDURE dbo.usp_GetLastUpdateDateTime;
GO
CREATE PROCEDURE [dbo].[usp_GetLastUpdateDateTime]		 
AS	
    SET NOCOUNT ON;
	SELECT MAX(LAST_UPDATE) FROM SQLTRX_LAST_UPDATE
GO

