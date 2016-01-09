USE [AWARE]
GO
/****** Object:  StoredProcedure [dbo].[usp_AddQiGroup]    Script Date: 8/28/2014 4:46:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_AddQiGroup]		
	@QiGroupName VARCHAR(50),
	@QiGroupActive bit	
AS	
    SET NOCOUNT ON;
	INSERT INTO SECURITY_GROUPS (GROUP_NAME, ACTIVE) VALUES (@QiGroupName, @QiGroupActive)

GO
