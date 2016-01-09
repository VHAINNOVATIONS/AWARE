
ALTER PROCEDURE [dbo].[usp_CanProviderSeeAll]
       @ProvId VARCHAR(50)
AS

       SET NOCOUNT ON;
       DECLARE @rowCnt INT
       SET @rowCnt = (SELECT COUNT(*) FROM PROVIDERS prv
                                         JOIN AWARE_VISTA_GROUP_MAPPINGS avgm ON avgm.ID = prv.VISTA_GROUP_ID
                                         JOIN SECURITY_RIGHTS sr ON avgm.ID = sr.ENTITY_ID
                        WHERE prv.id = @ProvId)

       IF @rowCnt = 0

       BEGIN
              SET @rowCnt = (SELECT COUNT(*) FROM USERS WHERE ID = @ProvId)
       END

		SELECT @rowCnt

GO


