
/****** Object:  StoredProcedure [dbo].[usp_GetReportIdByName]    Script Date: 7/18/2014 1:49:53 PM ******/
DROP PROCEDURE [dbo].[usp_GetReportIdByName]
GO



CREATE PROCEDURE [dbo].[usp_GetReportIdByName]	
	@ObjTypeId INT,
	@RepName VARCHAR(100)		
AS	
	SET NOCOUNT ON;
	SELECT ID FROM SECURITY_ITEMS WHERE OBJECT_TYPE_ID = @ObjTypeId AND OBJECT_NAME = @RepName

GO


