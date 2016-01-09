USE [AWARE]
GO
/****** Object:  StoredProcedure [dbo].[usp_InsertProvider]    Script Date: 8/28/2014 4:46:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_InsertProvider]
	@Name VARCHAR(50),
	@VistaId VARCHAR(50),
	@VistaGrpId VARCHAR(50)
AS	
	SET NOCOUNT ON;
	INSERT PROVIDERS (NAME, VISTA_ID, VISTA_GROUP_ID) VALUES (@Name, @VistaId, @VistaGrpId)

GO
