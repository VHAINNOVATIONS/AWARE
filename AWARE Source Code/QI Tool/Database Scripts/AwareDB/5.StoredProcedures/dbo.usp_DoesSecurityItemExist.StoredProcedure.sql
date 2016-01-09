USE [AWARE]
GO
/****** Object:  StoredProcedure [dbo].[usp_DoesSecurityItemExist]    Script Date: 8/28/2014 4:46:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[usp_DoesSecurityItemExist]
	@ObjectTypeId INT,	
	@ObjectName VARCHAR(100)	
AS	
	SET NOCOUNT ON;
	SELECT COUNT(*) FROM SECURITY_ITEMS WHERE OBJECT_TYPE_ID = @ObjectTypeId AND OBJECT_NAME = @ObjectName


GO
