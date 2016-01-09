USE [AWARE]
GO
/****** Object:  StoredProcedure [dbo].[usp_InsertVistaGroupMapping]    Script Date: 8/28/2014 4:46:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_InsertVistaGroupMapping]	
	@GroupName VARCHAR(50),
	@FacilityId UNIQUEIDENTIFIER,
	@AwareGrpId UNIQUEIDENTIFIER
AS	
	SET NOCOUNT ON;
	INSERT INTO AWARE_VISTA_GROUP_MAPPINGS (NAME, AWARE_GROUP_ID, FACILITY_ID) VALUES (@GroupName, @AwareGrpId, @FacilityId)

GO
