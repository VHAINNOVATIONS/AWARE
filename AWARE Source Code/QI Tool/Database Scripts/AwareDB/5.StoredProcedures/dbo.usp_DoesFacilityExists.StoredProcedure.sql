USE [AWARE]
GO
/****** Object:  StoredProcedure [dbo].[usp_DoesFacilityExists]    Script Date: 8/28/2014 4:46:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_DoesFacilityExists]
	@Facility VARCHAR(50)	
AS	
	SET NOCOUNT ON;
	SELECT COUNT(*) FROM FACILITIES WHERE NAME = @Facility

GO
