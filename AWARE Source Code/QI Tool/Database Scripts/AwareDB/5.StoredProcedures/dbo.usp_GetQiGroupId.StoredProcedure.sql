USE [AWARE]
GO
/****** Object:  StoredProcedure [dbo].[usp_GetQiGroupId]    Script Date: 8/28/2014 4:46:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_GetQiGroupId]		
	@QiGroupName VARCHAR(50)		
AS	
    SET NOCOUNT ON;
	SELECT ID FROM SECURITY_GROUPS WHERE GROUP_NAME = @QiGroupName

GO
