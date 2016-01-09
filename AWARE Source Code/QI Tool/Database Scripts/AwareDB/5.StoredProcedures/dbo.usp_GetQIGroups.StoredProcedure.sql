USE [AWARE]
GO
/****** Object:  StoredProcedure [dbo].[usp_GetQIGroups]    Script Date: 8/28/2014 4:46:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_GetQIGroups]	
	@SortAsc bit = 0		
AS	
    SET NOCOUNT ON;
	IF @SortAsc = 1
		SELECT ID, GROUP_NAME, ACTIVE FROM SECURITY_GROUPS ORDER BY GROUP_NAME ASC	
	ELSE
		SELECT ID, GROUP_NAME, ACTIVE FROM SECURITY_GROUPS ORDER BY GROUP_NAME DESC	

GO
