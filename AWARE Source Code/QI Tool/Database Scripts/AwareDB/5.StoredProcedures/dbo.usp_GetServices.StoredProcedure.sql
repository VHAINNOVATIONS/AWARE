USE [AWARE]
GO
/****** Object:  StoredProcedure [dbo].[usp_GetServices]    Script Date: 8/28/2014 4:46:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_GetServices]	 
	@FacilityName varchar(50)	
AS	
    SET NOCOUNT ON;
	SELECT DISTINCT(Service) FROM Service$ WHERE FacilityName = @FacilityName	

GO
