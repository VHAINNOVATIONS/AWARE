USE [AWARE]
GO
/****** Object:  StoredProcedure [dbo].[usp_GetVistaGrpIdByName]    Script Date: 8/28/2014 4:46:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_GetVistaGrpIdByName]	
	@GroupName VARCHAR(50)
AS	
	SET NOCOUNT ON;
	SELECT ID FROM AWARE_VISTA_GROUP_MAPPINGS WHERE NAME = @GroupName

GO
