USE [AWARE]
GO
/****** Object:  StoredProcedure [dbo].[usp_UpdateFacilities]    Script Date: 8/28/2014 4:46:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_UpdateFacilities]				
AS	
    SET NOCOUNT ON;
	
INSERT INTO FACILITIES (NAME)
    SELECT DISTINCT(FacilityName) FROM Alerts$ WHERE FacilityName NOT IN (SELECT DISTINCT(NAME) FROM FACILITIES)

GO
