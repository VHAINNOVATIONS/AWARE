USE [AWARE]
GO
/****** Object:  StoredProcedure [dbo].[usp_DeleteVistaGroupMapping]    Script Date: 8/28/2014 4:46:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_DeleteVistaGroupMapping]
	@AwareGroupId VARCHAR(50)	
AS	
	SET NOCOUNT ON;
	DELETE FROM AWARE_VISTA_GROUP_MAPPINGS WHERE AWARE_GROUP_ID = @AwareGroupId

GO
