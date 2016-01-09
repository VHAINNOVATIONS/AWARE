USE [AWARE]
GO
/****** Object:  StoredProcedure [dbo].[usp_IsGroupPermittedAccess]    Script Date: 8/28/2014 4:46:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_IsGroupPermittedAccess]	
	@GrpName VARCHAR(50)			
AS	
	SET NOCOUNT ON;
	SELECT COUNT(*) FROM SECURITY_GROUPS WHERE GROUP_NAME = @GrpName AND ACTIVE = 1

GO
