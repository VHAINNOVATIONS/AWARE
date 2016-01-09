USE [AWARE]
GO
/****** Object:  StoredProcedure [dbo].[usp_UpdateProvider]    Script Date: 8/28/2014 4:46:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_UpdateProvider]
	@Name VARCHAR(50),
	@VistaId VARCHAR(50),
	@VistaGrpId VARCHAR(50)
AS	
	SET NOCOUNT ON;
	UPDATE PROVIDERS 
		SET NAME = @Name,  
		VISTA_GROUP_ID = @VistaGrpId
	WHERE 
		VISTA_ID = @VistaId

GO
