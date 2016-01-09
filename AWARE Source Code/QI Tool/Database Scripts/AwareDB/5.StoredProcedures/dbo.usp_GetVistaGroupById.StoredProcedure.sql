USE [AWARE]
GO
/****** Object:  StoredProcedure [dbo].[usp_GetVistaGroupById]    Script Date: 8/28/2014 4:46:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_GetVistaGroupById]	
	@VistaGroupId UNIQUEIDENTIFIER
AS	
	SELECT ID, NAME, AWARE_GROUP_ID, FACILITY_ID FROM AWARE_VISTA_GROUP_MAPPINGS 
	WHERE ID = @VistaGroupId


GO
