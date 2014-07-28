	/* **********************
		usp_SetQuotedIdentifier
	   **********************/
USE AWARE
GO
IF OBJECT_ID ( 'dbo.usp_SetQuotedIdentifier', 'P' ) IS NOT NULL 
    DROP PROCEDURE dbo.usp_SetQuotedIdentifier;
GO
CREATE PROCEDURE dbo.usp_SetQuotedIdentifier	
	@OnOff BIT		
AS	
	SET NOCOUNT ON;
	IF @OnOff = 0
		SET QUOTED_IDENTIFIER OFF
	ELSE
		SET QUOTED_IDENTIFIER ON
GO
