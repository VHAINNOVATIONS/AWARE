USE [AWARE]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_GetAlertsByDaysOld]	
	@DaysOld int
AS	
	SET NOCOUNT ON;
	SELECT * FROM Alerts$ WHERE datediff(minute, getdate(), DATETIME1) > -(@DaysOld * 1440)