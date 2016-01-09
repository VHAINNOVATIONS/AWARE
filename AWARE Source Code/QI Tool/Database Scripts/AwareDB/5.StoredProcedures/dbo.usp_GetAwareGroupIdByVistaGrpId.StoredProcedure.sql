USE [AWARE]
GO
/****** Object:  StoredProcedure [dbo].[usp_GetAwareGroupIdByVistaGrpId]    Script Date: 8/28/2014 4:46:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_GetAwareGroupIdByVistaGrpId]	
	@GroupId UNIQUEIDENTIFIER
AS	
	SET NOCOUNT ON;
	SELECT AWARE_GROUP_ID FROM AWARE_VISTA_GROUP_MAPPINGS WHERE ID = @GroupId

GO
