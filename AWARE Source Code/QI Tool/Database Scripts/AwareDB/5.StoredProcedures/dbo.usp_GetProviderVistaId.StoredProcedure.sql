USE [AWARE]
GO
/****** Object:  StoredProcedure [dbo].[usp_GetProviderVistaId]    Script Date: 8/28/2014 4:46:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_GetProviderVistaId]
	@ProvId VARCHAR(50)
AS	
	SET NOCOUNT ON;
	SELECT VISTA_ID FROM PROVIDERS WHERE ID = @ProvId

GO
