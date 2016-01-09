USE [AWARE]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_GetAlertsCountByDaysOld]	
	@DaysOld int
AS	
	SET NOCOUNT ON;
	SELECT COUNT(*) FROM Alerts$ WHERE datediff(minute, getdate(), DATETIME1) > -(@DaysOld * 1440)
