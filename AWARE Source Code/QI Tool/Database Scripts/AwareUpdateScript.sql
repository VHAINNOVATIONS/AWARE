-- UpdateScript_1.1.sql
USE AWARE
GO
/* *******************************************************************************************
	This block of code is ok to run everytime 
	Be real carefull when adding code to this block
	*****************************************************************************************/
IF NOT EXISTS(SELECT * FROM sys.columns 
        WHERE [name] = N'VISTA_GROUP_ID' AND [object_id] = OBJECT_ID(N'PROVIDERS'))
BEGIN
    ALTER TABLE PROVIDERS 
	ADD VISTA_GROUP_ID UNIQUEIDENTIFIER null
END

-- Update the facilities table for any facility found in the Alerts table
INSERT INTO FACILITIES (NAME)
    SELECT DISTINCT(FacilityName) FROM Alerts$ WHERE FacilityName NOT IN (SELECT DISTINCT(NAME) FROM FACILITIES)

-- Update the Providers table for any ordering provider found in the Alerts table
DECLARE @PROV TABLE (ORDERINGPROVIDER VARCHAR(50), NAME VARCHAR(50), VISTA_ID VARCHAR(50))

INSERT @PROV (ORDERINGPROVIDER, NAME, VISTA_ID) SELECT DISTINCT(ORDERINGPROVIDER),
	CASE 
        WHEN CHARINDEX('[', ORDERINGPROVIDER) > 0 THEN 
            RTRIM(SUBSTRING(ORDERINGPROVIDER,1, CHARINDEX('[', ORDERINGPROVIDER) - 1))
        ELSE ORDERINGPROVIDER
    END,
	CASE 
        WHEN CHARINDEX('[', ORDERINGPROVIDER) > 0 THEN 
            RTRIM(SUBSTRING(ORDERINGPROVIDER,CHARINDEX('[', ORDERINGPROVIDER) + 1, (CHARINDEX(']', ORDERINGPROVIDER)-1) - charindex('[', ORDERINGPROVIDER)))
        ELSE NULL
    END	
FROM Alerts$
WHERE CHARINDEX('[', ORDERINGPROVIDER) > 0 
	AND RTRIM(SUBSTRING(ORDERINGPROVIDER,CHARINDEX('[', ORDERINGPROVIDER) + 1, (CHARINDEX(']', ORDERINGPROVIDER)-1) - charindex('[', ORDERINGPROVIDER))) NOT IN (SELECT DISTINCT(VISTA_ID) FROM PROVIDERS)

INSERT PROVIDERS (NAME, VISTA_ID) SELECT NAME, VISTA_ID FROM @PROV WHERE VISTA_ID NOT IN (SELECT DISTINCT(VISTA_ID) FROM PROVIDERS)

IF OBJECT_ID(N'tempdb..@PROV', N'U') IS NOT NULL 
DROP TABLE #PROV;

/* **********************
	Stored Procedures
   **********************/

	--------------------------------------------------------
	-- usp_GetUsersId
	--------------------------------------------------------
IF OBJECT_ID ( 'dbo.usp_GetUsersId', 'P' ) IS NOT NULL 
    DROP PROCEDURE dbo.usp_GetUsersId;
GO
CREATE PROCEDURE dbo.usp_GetUsersId
	@UserName VARCHAR(50)	 
AS	
    SET NOCOUNT ON;
	SELECT ID FROM USERS WHERE USER_NAME = @UserName;
GO

	--------------------------------------------------------
	-- usp_GetUsersIdWFacID
	--------------------------------------------------------
IF OBJECT_ID ( 'dbo.usp_GetUsersIdWFacID', 'P' ) IS NOT NULL 
    DROP PROCEDURE dbo.usp_GetUsersIdWFacID;
GO
CREATE PROCEDURE dbo.usp_GetUsersIdWFacID
	@UserName VARCHAR(50),
	@FacilityId VARCHAR(50)	 
AS	
    SET NOCOUNT ON;
	SELECT ID FROM USERS WHERE USER_NAME = @UserName AND FACILITY_ID = @FacilityId;
GO

	--------------------------------------------------------
	-- usp_DoesUserExist
	--------------------------------------------------------
IF OBJECT_ID ( 'dbo.usp_DoesUserExist', 'P' ) IS NOT NULL 
    DROP PROCEDURE dbo.usp_DoesUserExist;
GO
CREATE PROCEDURE dbo.usp_DoesUserExist
	@UserName VARCHAR(50)	
AS	
    SET NOCOUNT ON;
	DECLARE @RowCnt int;
	DECLARE @Exists bit;

	SET @Exists = 0;
	set @RowCnt =
	(
		SELECT COUNT(*) FROM USERS WHERE USER_NAME = @UserName
	)

	IF @RowCnt > 0
	BEGIN
		SET @Exists = 1;
	END

	SELECT @Exists;
GO


	--------------------------------------------------------
	-- usp_DoesUserExstWFacId
	--------------------------------------------------------
IF OBJECT_ID ( 'dbo.usp_DoesUserExistWFacId', 'P' ) IS NOT NULL 
    DROP PROCEDURE dbo.usp_DoesUserExistWFacId;
GO
CREATE PROCEDURE dbo.usp_DoesUserExistWFacId
	@UserName VARCHAR(50),
	@FacilityId VARCHAR(50) 
AS	
    SET NOCOUNT ON;
	DECLARE @RowCnt int;
	DECLARE @Exists bit;

	SET @Exists = 0;
	set @RowCnt =
	(
		SELECT COUNT(*) FROM USERS WHERE USER_NAME = @UserName AND FACILITY_ID = @FacilityId
	)

	IF @RowCnt > 0
	BEGIN
		SET @Exists = 1;
	END

	SELECT @Exists;
GO

	--------------------------------------------------------
	-- usp_AddUser
	--------------------------------------------------------
IF OBJECT_ID ( 'dbo.usp_AddUser', 'P' ) IS NOT NULL 
    DROP PROCEDURE dbo.usp_AddUser;
GO
CREATE PROCEDURE dbo.usp_AddUser
	@UserName VARCHAR(50),
	@FacilityId VARCHAR(50),
	@VerifyCode VARCHAR(50) 
AS	
    SET NOCOUNT ON;
	INSERT INTO USERS (USER_NAME, FACILITY_ID, VERIFY_CODE  ) VALUES (@UserName, @FacilityId, @VerifyCode)
GO


	--------------------------------------------------------
	-- usp_UpdateUser
	--------------------------------------------------------
IF OBJECT_ID ( 'dbo.usp_UpdateUser', 'P' ) IS NOT NULL 
    DROP PROCEDURE dbo.usp_UpdateUser;
GO
CREATE PROCEDURE dbo.usp_UpdateUser
	@UserName VARCHAR(50),
	@FacilityId VARCHAR(50),
	@VerifyCode VARCHAR(50),
	@UserId UNIQUEIDENTIFIER
AS	
    SET NOCOUNT ON;
	UPDATE USERS SET USER_NAME = @UserName, FACILITY_ID = @FacilityId, VERIFY_CODE = @VerifyCode WHERE ID = @UserId
GO

	--------------------------------------------------------
	-- usp_SelectUserRecsByFacID
	--------------------------------------------------------
IF OBJECT_ID ( 'dbo.usp_SelectUserRecsByFacID', 'P' ) IS NOT NULL 
    DROP PROCEDURE dbo.usp_SelectUserRecsByFacID;
GO
CREATE PROCEDURE dbo.usp_SelectUserRecsByFacID
	@FacilityId VARCHAR(50) = NULL,	
	@SortAsc bit = NULL
AS	
	DECLARE @sqlCmd NVARCHAR(4000)
    SET NOCOUNT ON;
	SELECT @sqlCmd ='SELECT ID, USER_NAME, FACILITY_ID FROM USERS '

	IF @FacilityId IS NOT NULL 
		SELECT @sqlCmd = @sqlCmd + N'WHERE FACILITY_ID = ' + '''' + @FacilityId +''''

	IF @SortAsc IS NOT NULL 
			SELECT @sqlCmd = @sqlCmd + N'ORDER BY USER_NAME ASC'	

	execute sp_executesql @sqlCmd
GO

	--------------------------------------------------------
	-- usp_SelectUsersVerifyCode
	--------------------------------------------------------
IF OBJECT_ID ( 'dbo.usp_SelectUsersVerifyCode', 'P' ) IS NOT NULL 
    DROP PROCEDURE dbo.usp_SelectUsersVerifyCode;
GO
CREATE PROCEDURE dbo.usp_SelectUsersVerifyCode
	@UserId VARCHAR(50)
AS		
    SET NOCOUNT ON;
	SELECT VERIFY_CODE FROM USERS WHERE ID = @UserId
GO

	--------------------------------------------------------
	-- usp_DeleteUserById
	--------------------------------------------------------
IF OBJECT_ID ( 'dbo.usp_DeleteUserById', 'P' ) IS NOT NULL 
    DROP PROCEDURE dbo.usp_DeleteUserById;
GO
CREATE PROCEDURE dbo.usp_DeleteUserById
	@UserId VARCHAR(50)
AS		
    SET NOCOUNT ON;
	DELETE FROM USERS WHERE id = @UserId
GO

	--------------------------------------------------------
	-- usp_GetUserNameById
	--------------------------------------------------------
IF OBJECT_ID ( 'dbo.usp_GetUserNameById', 'P' ) IS NOT NULL 
    DROP PROCEDURE dbo.usp_GetUserNameById;
GO
CREATE PROCEDURE dbo.usp_GetUserNameById
	@UserId VARCHAR(50)
AS		
    SET NOCOUNT ON;
	SELECT USER_NAME FROM USERS WHERE ID = @UserId
GO

	--------------------------------------------------------
	-- usp_GetProviderNameById
	--------------------------------------------------------
IF OBJECT_ID ( 'dbo.usp_GetProviderNameById', 'P' ) IS NOT NULL 
    DROP PROCEDURE dbo.usp_GetProviderNameById;
GO
CREATE PROCEDURE dbo.usp_GetProviderNameById
	@UserId VARCHAR(50)
AS		
    SET NOCOUNT ON;
	SELECT NAME FROM PROVIDERS WHERE ID = @UserId
GO

	/* **********************
		usp_GetFacilities
	   **********************/
USE AWARE
GO
IF OBJECT_ID ( 'dbo.usp_GetFacilities', 'P' ) IS NOT NULL 
    DROP PROCEDURE dbo.usp_GetFacilities;
GO
CREATE PROCEDURE dbo.usp_GetFacilities	 	
AS	
    SET NOCOUNT ON;
	SELECT NAME FROM FACILITIES;	
GO

	/* **********************
		usp_GetServices
	   **********************/
USE AWARE
GO
IF OBJECT_ID ( 'dbo.usp_GetServices', 'P' ) IS NOT NULL 
    DROP PROCEDURE dbo.usp_GetServices;
GO
CREATE PROCEDURE dbo.usp_GetServices	 
	@FacilityName varchar(50)	
AS	
    SET NOCOUNT ON;
	SELECT DISTINCT(Service) FROM Service$ WHERE FacilityName = @FacilityName	
GO

	/* **********************
		usp_GetQIGroups
	   **********************/
USE AWARE
GO
IF OBJECT_ID ( 'dbo.usp_GetQIGroups', 'P' ) IS NOT NULL 
    DROP PROCEDURE dbo.usp_GetQIGroups;
GO
CREATE PROCEDURE dbo.usp_GetQIGroups	
	@SortAsc bit = 0		
AS	
    SET NOCOUNT ON;
	IF @SortAsc = 1
		SELECT ID, GROUP_NAME, ACTIVE FROM SECURITY_GROUPS ORDER BY GROUP_NAME ASC	
	ELSE
		SELECT ID, GROUP_NAME, ACTIVE FROM SECURITY_GROUPS ORDER BY GROUP_NAME DESC	
GO

	/* **********************
		usp_UpdateFacilities
	   **********************/
USE AWARE
GO
IF OBJECT_ID ( 'dbo.usp_UpdateFacilities', 'P' ) IS NOT NULL 
    DROP PROCEDURE dbo.usp_UpdateFacilities;
GO
CREATE PROCEDURE dbo.usp_UpdateFacilities				
AS	
    SET NOCOUNT ON;
	
INSERT INTO FACILITIES (NAME)
    SELECT DISTINCT(FacilityName) FROM Alerts$ WHERE FacilityName NOT IN (SELECT DISTINCT(NAME) FROM FACILITIES)
GO

	/* **********************
		usp_UpdateProviders
	   **********************/
USE AWARE
GO
IF OBJECT_ID ( 'dbo.usp_UpdateProviders', 'P' ) IS NOT NULL 
    DROP PROCEDURE dbo.usp_UpdateProviders;
GO
CREATE PROCEDURE dbo.usp_UpdateProviders				
AS	
    SET NOCOUNT ON;
	DECLARE @PROV TABLE (ORDERINGPROVIDER VARCHAR(50), NAME VARCHAR(50), VISTA_ID VARCHAR(50))

	INSERT @PROV (ORDERINGPROVIDER, NAME, VISTA_ID) SELECT DISTINCT(ORDERINGPROVIDER),
		CASE 
			WHEN CHARINDEX('[', ORDERINGPROVIDER) > 0 THEN 
				RTRIM(SUBSTRING(ORDERINGPROVIDER,1, CHARINDEX('[', ORDERINGPROVIDER) - 1))
			ELSE ORDERINGPROVIDER
		END,
		CASE 
			WHEN CHARINDEX('[', ORDERINGPROVIDER) > 0 THEN 
				RTRIM(SUBSTRING(ORDERINGPROVIDER,CHARINDEX('[', ORDERINGPROVIDER) + 1, (CHARINDEX(']', ORDERINGPROVIDER)-1) - charindex('[', ORDERINGPROVIDER)))
			ELSE NULL
		END	
	FROM Alerts$
	WHERE CHARINDEX('[', ORDERINGPROVIDER) > 0 
		AND RTRIM(SUBSTRING(ORDERINGPROVIDER,CHARINDEX('[', ORDERINGPROVIDER) + 1, (CHARINDEX(']', ORDERINGPROVIDER)-1) - charindex('[', ORDERINGPROVIDER))) NOT IN (SELECT DISTINCT(VISTA_ID) FROM PROVIDERS)

	INSERT PROVIDERS (NAME, VISTA_ID) SELECT NAME, VISTA_ID FROM @PROV WHERE VISTA_ID NOT IN (SELECT DISTINCT(VISTA_ID) FROM PROVIDERS)

	IF OBJECT_ID(N'tempdb..@PROV', N'U') IS NOT NULL 
	DROP TABLE #PROV;
GO

	/* **********************
		usp_SyncQIFacilitiesAndProviders
	   **********************/
USE AWARE
GO
IF OBJECT_ID ( 'dbo.usp_SyncQIFacilitiesAndProviders', 'P' ) IS NOT NULL 
    DROP PROCEDURE dbo.usp_SyncQIFacilitiesAndProviders;
GO
CREATE PROCEDURE dbo.usp_SyncQIFacilitiesAndProviders				
AS	
    SET NOCOUNT ON;
	EXEC usp_UpdateFacilities
	EXEC usp_UpdateProviders
GO

	/* **********************
		usp_DoesQiGroupExists
	   **********************/
USE AWARE
GO
IF OBJECT_ID ( 'dbo.usp_DoesQiGroupExists', 'P' ) IS NOT NULL 
    DROP PROCEDURE dbo.usp_DoesQiGroupExists;
GO
CREATE PROCEDURE dbo.usp_DoesQiGroupExists		
	@QiGroupName VARCHAR(50)		
AS	
    SET NOCOUNT ON;
	SELECT COUNT(*) FROM SECURITY_GROUPS WHERE GROUP_NAME = @QiGroupName
GO

	/* **********************
		usp_IsQiGroupActive
	   **********************/
USE AWARE
GO
IF OBJECT_ID ( 'dbo.usp_IsQiGroupActive', 'P' ) IS NOT NULL 
    DROP PROCEDURE dbo.usp_IsQiGroupActive;
GO
CREATE PROCEDURE dbo.usp_IsQiGroupActive		
	@QiGroupId UNIQUEIDENTIFIER		
AS	
    SET NOCOUNT ON;
	SELECT ACTIVE FROM SECURITY_GROUPS WHERE ID = @QiGroupId
GO

	/* **********************
		usp_GetQiGroupId
	   **********************/
USE AWARE
GO
IF OBJECT_ID ( 'dbo.usp_GetQiGroupId', 'P' ) IS NOT NULL 
    DROP PROCEDURE dbo.usp_GetQiGroupId;
GO
CREATE PROCEDURE dbo.usp_GetQiGroupId		
	@QiGroupName VARCHAR(50)		
AS	
    SET NOCOUNT ON;
	SELECT ID FROM SECURITY_GROUPS WHERE GROUP_NAME = @QiGroupName
GO

	/* **********************
		usp_AddQiGroup
	   **********************/
USE AWARE
GO
IF OBJECT_ID ( 'dbo.usp_AddQiGroup', 'P' ) IS NOT NULL 
    DROP PROCEDURE dbo.usp_AddQiGroup;
GO
CREATE PROCEDURE dbo.usp_AddQiGroup		
	@QiGroupName VARCHAR(50),
	@QiGroupActive bit	
AS	
    SET NOCOUNT ON;
	INSERT INTO SECURITY_GROUPS (GROUP_NAME, ACTIVE) VALUES (@QiGroupName, @QiGroupActive)
GO

	/* **********************
		usp_UpdateQiGroup
	   **********************/
USE AWARE
GO
IF OBJECT_ID ( 'dbo.usp_UpdateQiGroup', 'P' ) IS NOT NULL 
    DROP PROCEDURE dbo.usp_UpdateQiGroup;
GO
CREATE PROCEDURE dbo.usp_UpdateQiGroup		
	@QiGroupName VARCHAR(50),
	@QiGroupActive BIT,	
	@QiGroupId UNIQUEIDENTIFIER
AS	
    SET NOCOUNT ON;
	UPDATE SECURITY_GROUPS 
		SET GROUP_NAME = @QiGroupName, 
		ACTIVE = @QiGroupActive 
	WHERE ID = @QiGroupId
GO

	/* **********************
		usp_DeleteQiGroup
	   **********************/
USE AWARE
GO
IF OBJECT_ID ( 'dbo.usp_DeleteQiGroup', 'P' ) IS NOT NULL 
    DROP PROCEDURE dbo.usp_DeleteQiGroup;
GO
CREATE PROCEDURE dbo.usp_DeleteQiGroup		
	@QiGroupId UNIQUEIDENTIFIER
AS	
    SET NOCOUNT ON;
	DELETE FROM SECURITY_GROUPS WHERE ID = @QiGroupId
GO

	/* **********************
		usp_AddUserToQiGroup
	   **********************/
USE AWARE
GO
IF OBJECT_ID ( 'dbo.usp_AddUserToQiGroup', 'P' ) IS NOT NULL 
    DROP PROCEDURE dbo.usp_AddUserToQiGroup;
GO
CREATE PROCEDURE dbo.usp_AddUserToQiGroup		
	@QiGroupId UNIQUEIDENTIFIER,
	@UserId UNIQUEIDENTIFIER
AS	
    SET NOCOUNT ON;
	INSERT SECURITY_ROLES (GROUP_ID, USER_ID) VALUES (@QiGroupId, @UserId)
GO

	/* **********************
		usp_DoesQiSecurityRoleExists
	   **********************/
USE AWARE
GO
IF OBJECT_ID ( 'dbo.usp_DoesQiSecurityRoleExists', 'P' ) IS NOT NULL 
    DROP PROCEDURE dbo.usp_DoesQiSecurityRoleExists;
GO
CREATE PROCEDURE dbo.usp_DoesQiSecurityRoleExists		
	@QiGroupId UNIQUEIDENTIFIER,
	@UserId UNIQUEIDENTIFIER
AS	
    SET NOCOUNT ON;
	SELECT COUNT(*) FROM SECURITY_ROLES WHERE GROUP_ID = @QiGroupId AND USER_ID = @UserId
GO

	/* **********************
		usp_GetQiRoleId
	   **********************/
USE AWARE
GO
IF OBJECT_ID ( 'dbo.usp_GetQiRoleId', 'P' ) IS NOT NULL 
    DROP PROCEDURE dbo.usp_GetQiRoleId;
GO
CREATE PROCEDURE dbo.usp_GetQiRoleId		
	@QiGroupId UNIQUEIDENTIFIER,
	@UserId UNIQUEIDENTIFIER
AS	
    SET NOCOUNT ON;
	SELECT ID FROM SECURITY_ROLES WHERE GROUP_ID = @QiGroupId AND USER_ID = @UserId
GO

	/* **********************
		usp_DeleteQiRole
	   **********************/
USE AWARE
GO
IF OBJECT_ID ( 'dbo.usp_DeleteQiRole', 'P' ) IS NOT NULL 
    DROP PROCEDURE dbo.usp_DeleteQiRole;
GO
CREATE PROCEDURE dbo.usp_DeleteQiRole		
	@QiRoleId UNIQUEIDENTIFIER	
AS	
    SET NOCOUNT ON;
	DELETE FROM SECURITY_ROLES WHERE ID = @QiRoleId
GO

	/* **********************
		usp_DeleteQiUserRole
	   **********************/
USE AWARE
GO
IF OBJECT_ID ( 'dbo.usp_DeleteQiUserRole', 'P' ) IS NOT NULL 
    DROP PROCEDURE dbo.usp_DeleteQiUserRole;
GO
CREATE PROCEDURE dbo.usp_DeleteQiUserRole		
	@QiGroupId UNIQUEIDENTIFIER,
	@UserId UNIQUEIDENTIFIER	
AS	
    SET NOCOUNT ON;
	DELETE FROM SECURITY_ROLES WHERE GROUP_ID = @QiGroupId AND USER_ID = @UserId
GO

	/* **********************
		usp_GetFacilities
	   **********************/
USE AWARE
GO
IF OBJECT_ID ( 'dbo.usp_GetFacilities', 'P' ) IS NOT NULL 
    DROP PROCEDURE dbo.usp_GetFacilities;
GO
CREATE PROCEDURE dbo.usp_GetFacilities			
AS	
    SET NOCOUNT ON;
	SELECT ID, NAME FROM FACILITIES
GO

	/* **********************
		usp_GetReportsInfo
	   **********************/
USE AWARE
GO
IF OBJECT_ID ( 'dbo.usp_GetReportsInfo', 'P' ) IS NOT NULL 
    DROP PROCEDURE dbo.usp_GetReportsInfo;
GO
CREATE PROCEDURE dbo.usp_GetReportsInfo	
	@ObjectTypeId INT,
	@SortAsc BIT = 0		
AS	
    SET NOCOUNT ON;
	if @SortAsc = 1
		SELECT ID, OBJECT_NAME, PRESENTATION_NAME FROM SECURITY_ITEMS WHERE OBJECT_TYPE_ID = @ObjectTypeId ORDER BY PRESENTATION_NAME ASC
	else
		SELECT ID, OBJECT_NAME, PRESENTATION_NAME FROM SECURITY_ITEMS WHERE OBJECT_TYPE_ID = @ObjectTypeId
GO

	/* **********************
		usp_GetReportsRec
	   **********************/
USE AWARE
GO
IF OBJECT_ID ( 'dbo.usp_GetReportsRec', 'P' ) IS NOT NULL 
    DROP PROCEDURE dbo.usp_GetReportsRec;
GO
CREATE PROCEDURE dbo.usp_GetReportsRec	
	@RptId UNIQUEIDENTIFIER,
	@ObjTypeId INT	
AS	
	SET NOCOUNT ON;
	SELECT ID, OBJECT_NAME, PRESENTATION_NAME FROM SECURITY_ITEMS WHERE OBJECT_TYPE_ID = @ObjTypeId AND ID = @RptId
GO

	/* **********************
		usp_UpdateReportsRec
	   **********************/
USE AWARE
GO
IF OBJECT_ID ( 'dbo.usp_UpdateReportsRec', 'P' ) IS NOT NULL 
    DROP PROCEDURE dbo.usp_UpdateReportsRec;
GO
CREATE PROCEDURE dbo.usp_UpdateReportsRec	
	@RepFileName VARCHAR(50),
	@RepPresName VARCHAR(50),
	@RptId UNIQUEIDENTIFIER		
AS	
	SET NOCOUNT ON;
	UPDATE SECURITY_ITEMS 
		SET 
			OBJECT_NAME = @RepFileName,
			PRESENTATION_NAME = @RepPresName
		WHERE ID = @RptId
GO

	/* **********************
		usp_GetReportIdByName
	   **********************/
USE AWARE
GO
IF OBJECT_ID ( 'dbo.usp_GetReportIdByName', 'P' ) IS NOT NULL 
    DROP PROCEDURE dbo.usp_GetReportIdByName;
GO
CREATE PROCEDURE dbo.usp_GetReportIdByName	
	@ObjTypeId INT,
	@RepName VARCHAR(50)		
AS	
	SET NOCOUNT ON;
	SELECT ID FROM SECURITY_ITEMS WHERE OBJECT_TYPE_ID = @ObjTypeId AND OBJECT_NAME = @RepName
GO

	/* **********************
		usp_VerifyQiUserCredentials
	   **********************/
USE AWARE
GO
IF OBJECT_ID ( 'dbo.usp_VerifyQiUserCredentials', 'P' ) IS NOT NULL 
    DROP PROCEDURE dbo.usp_VerifyQiUserCredentials;
GO
CREATE PROCEDURE dbo.usp_VerifyQiUserCredentials	
	@UserName VARCHAR(50),
	@VerifyCode VARCHAR(50)		
AS	
	SET NOCOUNT ON;
	SELECT COUNT(*) FROM USERS WHERE USER_NAME = @UserName AND VERIFY_CODE = @VerifyCode
GO

	/* **********************
		usp_IsGroupPermittedAccess
	   **********************/
USE AWARE
GO
IF OBJECT_ID ( 'dbo.usp_IsGroupPermittedAccess', 'P' ) IS NOT NULL 
    DROP PROCEDURE dbo.usp_IsGroupPermittedAccess;
GO
CREATE PROCEDURE dbo.usp_IsGroupPermittedAccess	
	@GrpName VARCHAR(50)			
AS	
	SET NOCOUNT ON;
	SELECT COUNT(*) FROM SECURITY_GROUPS WHERE GROUP_NAME = @GrpName AND ACTIVE = 1
GO

	/* **********************
		usp_DoesSecurityRightExists
	   **********************/
USE AWARE
GO
IF OBJECT_ID ( 'dbo.usp_DoesSecurityRightExists', 'P' ) IS NOT NULL 
    DROP PROCEDURE dbo.usp_DoesSecurityRightExists;
GO
CREATE PROCEDURE dbo.usp_DoesSecurityRightExists	
	@ObjectType INT,
	@ObjectId UNIQUEIDENTIFIER,
	@EntityId UNIQUEIDENTIFIER			
AS	
	SET NOCOUNT ON;
	SELECT COUNT(*) FROM SECURITY_RIGHTS 
		WHERE OBJECT_TYPE_ID = @ObjectType AND OBJECT_ID = @ObjectId AND ENTITY_ID = @EntityId 
GO

	/* **********************
		usp_GetClinicbyFacSrv
	   **********************/
USE AWARE
GO
IF OBJECT_ID ( 'dbo.usp_GetClinicbyFacSrv', 'P' ) IS NOT NULL 
    DROP PROCEDURE dbo.usp_GetClinicbyFacSrv;
GO
CREATE PROCEDURE dbo.usp_GetClinicbyFacSrv	
	@FacilityName VARCHAR(50),
	@Service VARCHAR(50)			
AS	
	SET NOCOUNT ON;
	SELECT Distinct(Clinic) FROM Clinic$ 
		WHERE FacilityName= @FacilityName AND Service = @Service
GO

	/* **********************
		usp_SelectProvider
	   **********************/
USE [AWARE]
GO
IF OBJECT_ID ( 'dbo.usp_SelectProvider', 'P' ) IS NOT NULL 
    DROP PROCEDURE dbo.usp_SelectProvider;
GO
CREATE PROCEDURE [dbo].[usp_SelectProvider]
	@OrdProvTbl VARCHAR(50),
	@FacilityName VARCHAR(50),	
	@Service VARCHAR(50) = NULL	,
	@Clinic VARCHAR(50) = NULL,
	@ViewAll BIT = NULL,
	@ProviderId VARCHAR(50)	= NULL
AS	
	DECLARE @sqlCmd NVARCHAR(4000)
    SET NOCOUNT ON;
	SELECT @sqlCmd ='SELECT Distinct(OrderingProvider) FROM ' + '' + @OrdProvTbl + ''  + ' WHERE FacilityName = ''' + '' + @FacilityName + ''''

	IF @Service IS NOT NULL 
		SELECT @sqlCmd = @sqlCmd + N' AND Service = ' + '''' + @Service +''''

	IF @Clinic IS NOT NULL 
			SELECT @sqlCmd = @sqlCmd + N' AND Clinic = ' + '''' + @Clinic + ''''

	IF @ViewAll IS NOT NULL
		IF @ViewAll = 0
			SELECT @sqlCmd = @sqlCmd + N' AND OrderingProvider LIKE ' + '''%[[' + @ProviderId + ']]'''

	execute sp_executesql @sqlCmd
GO

	/* **********************
		usp_SelectAlertTypes
	   **********************/
USE AWARE
GO
IF OBJECT_ID ( 'dbo.usp_SelectAlertTypes', 'P' ) IS NOT NULL 
    DROP PROCEDURE dbo.usp_SelectAlertTypes;
GO
CREATE PROCEDURE [dbo].[usp_SelectAlertTypes]
	@FacilityName VARCHAR(50),	
	@Service VARCHAR(50) = NULL	,
	@Clinic VARCHAR(50) = NULL,
	@Provider VARCHAR(50)	= NULL
AS	
	SET NOCOUNT ON;
	SELECT Distinct(AlertType) FROM AlertType$ 
	WHERE FacilityName = @FacilityName
		AND Service = @Service
		AND Clinic = @Clinic
		AND OrderingProvider = @Provider	
GO

	/* **********************
		usp_GetUserNameFromUserId
	   **********************/
USE AWARE
GO
IF OBJECT_ID ( 'dbo.usp_GetUserNameFromUserId', 'P' ) IS NOT NULL 
    DROP PROCEDURE dbo.usp_GetUserNameFromUserId;
GO
CREATE PROCEDURE [dbo].[usp_GetUserNameFromUserId]
	@UserId VARCHAR(50)
AS	
	SET NOCOUNT ON;
	SELECT USER_NAME FROM USERS WHERE ID = @UserId
GO

	/* **********************
		usp_InsertSecurityGroup
	   **********************/
USE AWARE
GO
IF OBJECT_ID ( 'dbo.usp_InsertSecurityGroup', 'P' ) IS NOT NULL 
    DROP PROCEDURE dbo.usp_InsertSecurityGroup;
GO
CREATE PROCEDURE [dbo].[usp_InsertSecurityGroup]
	@GroupName VARCHAR(50),
	@Active BIT
AS	
	SET NOCOUNT ON;
	INSERT INTO SECURITY_GROUPS (GROUP_NAME, ACTIVE) VALUES ( @GroupName, @Active)
GO

	/* **********************
		usp_DeleteSecurityGroup
	   **********************/
USE AWARE
GO
IF OBJECT_ID ( 'dbo.usp_DeleteSecurityGroup', 'P' ) IS NOT NULL 
    DROP PROCEDURE dbo.usp_DeleteSecurityGroup;
GO
CREATE PROCEDURE [dbo].usp_DeleteSecurityGroup
	@GroupId UNIQUEIDENTIFIER
AS	
	SET NOCOUNT ON;
	DELETE FROM SECURITY_GROUPS WHERE ID = @GroupId
GO

	/* **********************
		usp_DeleteSecurityRole
	   **********************/
USE AWARE
GO
IF OBJECT_ID ( 'dbo.usp_DeleteSecurityRole', 'P' ) IS NOT NULL 
    DROP PROCEDURE dbo.usp_DeleteSecurityRole;
GO
CREATE PROCEDURE [dbo].usp_DeleteSecurityRole
	@GroupId UNIQUEIDENTIFIER
AS	
	SET NOCOUNT ON;
	DELETE FROM SECURITY_ROLES WHERE GROUP_ID = @GroupId
GO

	/* **********************
		usp_DeleteSecurityRightByEntity
	   **********************/
USE AWARE
GO
IF OBJECT_ID ( 'dbo.usp_DeleteSecurityRightByEntity', 'P' ) IS NOT NULL 
    DROP PROCEDURE dbo.usp_DeleteSecurityRightByEntity;
GO
CREATE PROCEDURE [dbo].usp_DeleteSecurityRightByEntity
	@EntityId UNIQUEIDENTIFIER
AS	
	SET NOCOUNT ON;
	DELETE FROM SECURITY_RIGHTS WHERE ENTITY_ID = @EntityId
GO

	/* **********************
		usp_DeleteSecurityRight
	   **********************/
USE AWARE
GO
IF OBJECT_ID ( 'dbo.usp_DeleteSecurityRight', 'P' ) IS NOT NULL 
    DROP PROCEDURE dbo.usp_DeleteSecurityRight;
GO
CREATE PROCEDURE [dbo].[usp_DeleteSecurityRight]
	@EntityId VARCHAR(50),
	@ObjectType INT = NULL,
	@ObjectId VARCHAR(50) = NULL
AS	
	SET NOCOUNT ON;
	DECLARE @sqlCmd NVARCHAR(4000)
	SELECT @sqlCmd = N'DELETE FROM SECURITY_RIGHTS WHERE ENTITY_ID = ' + '''' + @EntityId + ''''
	IF @ObjectType IS NOT NULL
		SELECT @sqlCmd = @sqlCmd + N' AND OBJECT_TYPE_ID = '  + CAST(@ObjectType as nvarchar)
	IF @ObjectId IS NOT NULL
		SELECT @sqlCmd = @sqlCmd + N' AND OBJECT_ID = ' + '''' + @ObjectId + ''''

	EXECUTE sp_executesql @sqlCmd
GO

	/* **********************
		usp_GetSecurityRoleByUserId
	   **********************/
USE AWARE
GO
IF OBJECT_ID ( 'dbo.usp_GetSecurityRoleByUserId', 'P' ) IS NOT NULL 
    DROP PROCEDURE dbo.usp_GetSecurityRoleByUserId;
GO
CREATE PROCEDURE dbo.usp_GetSecurityRoleByUserId
	@UserIdId VARCHAR(50)	
AS	
	SET NOCOUNT ON;
	SELECT TOP 1 ID FROM SECURITY_ROLES WHERE USER_ID = @UserIdId
GO

	/* **********************
		usp_GetVistaGroups
	   **********************/
USE AWARE
GO
IF OBJECT_ID ( 'dbo.usp_GetVistaGroups', 'P' ) IS NOT NULL 
    DROP PROCEDURE dbo.usp_GetVistaGroups;
GO
CREATE PROCEDURE [dbo].usp_GetVistaGroups	
	@SortAsc BIT = NULL
AS	
	SET NOCOUNT ON;
	IF @SortAsc IS NOT NULL
		IF @SortAsc = 0
			SELECT ID, NAME, AWARE_GROUP_ID, FACILITY_ID FROM AWARE_VISTA_GROUP_MAPPINGS	
		ELSE
			SELECT ID, NAME, AWARE_GROUP_ID, FACILITY_ID FROM AWARE_VISTA_GROUP_MAPPINGS ORDER BY NAME ASC	
	ELSE
		SELECT ID, NAME, AWARE_GROUP_ID, FACILITY_ID FROM AWARE_VISTA_GROUP_MAPPINGS	
GO

	/* **********************
		usp_DoesVistaGrpExists
	   **********************/
USE AWARE
GO
IF OBJECT_ID ( 'dbo.usp_DoesVistaGrpExists', 'P' ) IS NOT NULL 
    DROP PROCEDURE dbo.usp_DoesVistaGrpExists;
GO
CREATE PROCEDURE dbo.usp_DoesVistaGrpExists	
	@GroupName VARCHAR(50)
AS	
	SET NOCOUNT ON;
	SELECT COUNT(*) FROM AWARE_VISTA_GROUP_MAPPINGS WHERE NAME = @GroupName
GO

	/* **********************
		usp_GetVistaGrpCountById
	   **********************/
USE AWARE
GO
IF OBJECT_ID ( 'dbo.usp_GetVistaGrpCountById', 'P' ) IS NOT NULL 
    DROP PROCEDURE dbo.usp_GetVistaGrpCountById;
GO
CREATE PROCEDURE dbo.usp_GetVistaGrpCountById	
	@GroupId UNIQUEIDENTIFIER
AS	
	SET NOCOUNT ON;
	SELECT COUNT(*) FROM AWARE_VISTA_GROUP_MAPPINGS WHERE ID = @GroupId
GO

	/* **********************
		usp_GetAwareGroupIdByVistaGrpId
	   **********************/
USE AWARE
GO
IF OBJECT_ID ( 'dbo.usp_GetAwareGroupIdByVistaGrpId', 'P' ) IS NOT NULL 
    DROP PROCEDURE dbo.usp_GetAwareGroupIdByVistaGrpId;
GO
CREATE PROCEDURE dbo.usp_GetAwareGroupIdByVistaGrpId	
	@GroupId UNIQUEIDENTIFIER
AS	
	SET NOCOUNT ON;
	SELECT AWARE_GROUP_ID FROM AWARE_VISTA_GROUP_MAPPINGS WHERE ID = @GroupId
GO

	/* **********************
		usp_DeleteAwareVistaGroupMapping
	   **********************/
USE AWARE
GO
IF OBJECT_ID ( 'dbo.usp_DeleteAwareVistaGroupMapping', 'P' ) IS NOT NULL 
    DROP PROCEDURE dbo.usp_DeleteAwareVistaGroupMapping;
GO
CREATE PROCEDURE dbo.usp_DeleteAwareVistaGroupMapping	
	@GroupId UNIQUEIDENTIFIER
AS	
	SET NOCOUNT ON;
	DELETE FROM AWARE_VISTA_GROUP_MAPPINGS WHERE ID = @GroupId
GO

	/* **********************
		usp_DeleteVistaGroupMapping
	   **********************/
USE AWARE
GO
IF OBJECT_ID ( 'dbo.usp_DeleteVistaGroupMapping', 'P' ) IS NOT NULL 
    DROP PROCEDURE dbo.usp_DeleteVistaGroupMapping;
GO
CREATE PROCEDURE dbo.usp_DeleteVistaGroupMapping
	@AwareGroupId VARCHAR(50)	
AS	
	SET NOCOUNT ON;
	DELETE FROM AWARE_VISTA_GROUP_MAPPINGS WHERE AWARE_GROUP_ID = @AwareGroupId
GO

	/* **********************
		usp_GetVistaGrpIdByName
	   **********************/
USE AWARE
GO
IF OBJECT_ID ( 'dbo.usp_GetVistaGrpIdByName', 'P' ) IS NOT NULL 
    DROP PROCEDURE dbo.usp_GetVistaGrpIdByName;
GO
CREATE PROCEDURE dbo.usp_GetVistaGrpIdByName	
	@GroupName VARCHAR(50)
AS	
	SET NOCOUNT ON;
	SELECT ID FROM AWARE_VISTA_GROUP_MAPPINGS WHERE NAME = @GroupName
GO

	/* **********************
		usp_InsertVistaGroupMapping
	   **********************/
USE AWARE
GO
IF OBJECT_ID ( 'dbo.usp_InsertVistaGroupMapping', 'P' ) IS NOT NULL 
    DROP PROCEDURE dbo.usp_InsertVistaGroupMapping;
GO
CREATE PROCEDURE dbo.usp_InsertVistaGroupMapping	
	@GroupName VARCHAR(50),
	@FacilityId UNIQUEIDENTIFIER,
	@AwareGrpId UNIQUEIDENTIFIER
AS	
	SET NOCOUNT ON;
	INSERT INTO AWARE_VISTA_GROUP_MAPPINGS (NAME, AWARE_GROUP_ID, FACILITY_ID) VALUES (@GroupName, @AwareGrpId, @FacilityId)
GO

	/* **********************
		usp_UpdateVistaGroupMapping
	   **********************/
USE AWARE
GO
IF OBJECT_ID ( 'dbo.usp_UpdateVistaGroupMapping', 'P' ) IS NOT NULL 
    DROP PROCEDURE dbo.usp_UpdateVistaGroupMapping;
GO
CREATE PROCEDURE dbo.usp_UpdateVistaGroupMapping	
	@GroupName VARCHAR(50),
	@FacilityId UNIQUEIDENTIFIER,
	@AwareGrpId UNIQUEIDENTIFIER,
	@VistaGrpId UNIQUEIDENTIFIER
AS	
	SET NOCOUNT ON;
	UPDATE AWARE_VISTA_GROUP_MAPPINGS 
		SET NAME = @GroupName,
			AWARE_GROUP_ID = @AwareGrpId,
			FACILITY_ID = @FacilityId
	WHERE ID = @VistaGrpId
GO


	/* **********************
		usp_AddSecurityRight
	   **********************/
USE AWARE
GO
IF OBJECT_ID ( 'dbo.usp_AddSecurityRight', 'P' ) IS NOT NULL 
    DROP PROCEDURE dbo.usp_AddSecurityRight;
GO
CREATE PROCEDURE dbo.usp_AddSecurityRight	
	@ObjTypeId INT,
	@ObjectId UNIQUEIDENTIFIER,
	@EntityId UNIQUEIDENTIFIER
AS	
	SET NOCOUNT ON;
	INSERT SECURITY_RIGHTS (OBJECT_TYPE_ID, OBJECT_ID, ENTITY_ID) VALUES (@ObjTypeId, @ObjectId, @EntityId)
GO

	/* **********************
		usp_GetSecurityRightId
	   **********************/
USE AWARE
GO
IF OBJECT_ID ( 'dbo.usp_GetSecurityRightId', 'P' ) IS NOT NULL 
    DROP PROCEDURE dbo.usp_GetSecurityRightId;
GO
CREATE PROCEDURE dbo.usp_GetSecurityRightId	
	@ObjectType INT,
	@ObjectId UNIQUEIDENTIFIER,
	@EntityId UNIQUEIDENTIFIER	
AS	
	SET NOCOUNT ON;
	SELECT ID FROM SECURITY_RIGHTS WHERE OBJECT_TYPE_ID = @ObjectType AND OBJECT_ID = @ObjectId AND ENTITY_ID = @EntityId
GO

	/* **********************
		usp_GetGroupIdByUserId
	   **********************/
USE AWARE
GO
IF OBJECT_ID ( 'dbo.usp_GetGroupIdByUserId', 'P' ) IS NOT NULL 
    DROP PROCEDURE dbo.usp_GetGroupIdByUserId;
GO
CREATE PROCEDURE dbo.usp_GetGroupIdByUserId
	@UserId VARCHAR(50)	
AS	
	SET NOCOUNT ON;
	SELECT TOP 1 GROUP_ID FROM SECURITY_ROLES WHERE USER_ID = @UserId
GO

	/* **********************
		usp_DoesSecurityRoleExistByUserId
	   **********************/
USE AWARE
GO
IF OBJECT_ID ( 'dbo.usp_DoesSecurityRoleExistByUserId', 'P' ) IS NOT NULL 
    DROP PROCEDURE dbo.usp_DoesSecurityRoleExistByUserId;
GO
CREATE PROCEDURE dbo.usp_DoesSecurityRoleExistByUserId
	@UserId VARCHAR(50)	
AS	
	SET NOCOUNT ON;
	SELECT COUNT(*) FROM SECURITY_ROLES WHERE USER_ID = @UserId
GO

	/* **********************
		usp_GetVistaProviderGroupId
	   **********************/
USE AWARE
GO
IF OBJECT_ID ( 'dbo.usp_GetVistaProviderGroupId', 'P' ) IS NOT NULL 
    DROP PROCEDURE dbo.usp_GetVistaProviderGroupId;
GO
CREATE PROCEDURE dbo.usp_GetVistaProviderGroupId
	@ProviderId VARCHAR(50)	
AS	
	SET NOCOUNT ON;
	SELECT avgm.AWARE_GROUP_ID FROM AWARE_VISTA_GROUP_MAPPINGS avgm JOIN PROVIDERS prv ON prv.VISTA_GROUP_ID = avgm.ID WHERE PRV.ID = @ProviderId
GO

	/* **********************
		usp_DoesVistaProviderExists
	   **********************/
USE AWARE
GO
IF OBJECT_ID ( 'dbo.usp_DoesVistaProviderExists', 'P' ) IS NOT NULL 
    DROP PROCEDURE dbo.usp_DoesVistaProviderExists;
GO
CREATE PROCEDURE dbo.usp_DoesVistaProviderExists
	@ProviderId VARCHAR(50)	
AS	
	SET NOCOUNT ON;
	SELECT COUNT(*) FROM PROVIDERS WHERE VISTA_ID = @ProviderId
GO

	/* **********************
		usp_GetVistaProviderID
	   **********************/
USE AWARE
GO
IF OBJECT_ID ( 'dbo.usp_GetVistaProviderID', 'P' ) IS NOT NULL 
    DROP PROCEDURE dbo.usp_GetVistaProviderID;
GO
CREATE PROCEDURE dbo.usp_GetVistaProviderID
	@VistaId VARCHAR(50)	
AS	
	SET NOCOUNT ON;
	SELECT TOP 1 ID FROM PROVIDERS WHERE VISTA_ID = @VistaId
GO

	/* **********************
		usp_InsertProvider
	   **********************/
USE AWARE
GO
IF OBJECT_ID ( 'dbo.usp_InsertProvider', 'P' ) IS NOT NULL 
    DROP PROCEDURE dbo.usp_InsertProvider;
GO
CREATE PROCEDURE dbo.usp_InsertProvider
	@Name VARCHAR(50),
	@VistaId VARCHAR(50),
	@VistaGrpId VARCHAR(50)
AS	
	SET NOCOUNT ON;
	INSERT PROVIDERS (NAME, VISTA_ID, VISTA_GROUP_ID) VALUES (@Name, @VistaId, @VistaGrpId)
GO

	/* **********************
		usp_UpdateProvider
	   **********************/
USE AWARE
GO
IF OBJECT_ID ( 'dbo.usp_UpdateProvider', 'P' ) IS NOT NULL 
    DROP PROCEDURE dbo.usp_UpdateProvider;
GO
CREATE PROCEDURE dbo.usp_UpdateProvider
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

	/* **********************
		usp_GetProviderVistaId
	   **********************/
USE AWARE
GO
IF OBJECT_ID ( 'dbo.usp_GetProviderVistaId', 'P' ) IS NOT NULL 
    DROP PROCEDURE dbo.usp_GetProviderVistaId;
GO
CREATE PROCEDURE dbo.usp_GetProviderVistaId
	@ProvId VARCHAR(50)
AS	
	SET NOCOUNT ON;
	SELECT VISTA_ID FROM PROVIDERS WHERE ID = @ProvId
GO

	/* **********************
		usp_CanProviderSeeAll
	   **********************/
USE AWARE
GO
IF OBJECT_ID ( 'dbo.usp_CanProviderSeeAll', 'P' ) IS NOT NULL 
    DROP PROCEDURE dbo.usp_CanProviderSeeAll;
GO
CREATE PROCEDURE dbo.usp_CanProviderSeeAll
	@ProvId VARCHAR(50)
AS	
	SET NOCOUNT ON;
	SELECT COUNT(*) FROM PROVIDERS prv 
		JOIN AWARE_VISTA_GROUP_MAPPINGS avgm ON avgm.ID = prv.VISTA_GROUP_ID 
		JOIN SECURITY_RIGHTS sr ON avgm.ID = sr.ENTITY_ID 
	WHERE prv.id = @ProvId
GO

	/* **********************
		usp_CanGroupSeeAll
	   **********************/
USE AWARE
GO
IF OBJECT_ID ( 'dbo.usp_CanGroupSeeAll', 'P' ) IS NOT NULL 
    DROP PROCEDURE dbo.usp_CanGroupSeeAll;
GO
CREATE PROCEDURE dbo.usp_CanGroupSeeAll
	@VistaGrpId VARCHAR(50)
AS	
	SET NOCOUNT ON;
	SELECT COUNT(*) FROM PROVIDERS prv 
		JOIN AWARE_VISTA_GROUP_MAPPINGS avgm ON avgm.ID = prv.VISTA_GROUP_ID 
		JOIN SECURITY_RIGHTS sr ON avgm.ID = sr.ENTITY_ID 
	WHERE avgm.id = @VistaGrpId
GO



/* **********************
	Indexes
   **********************/
USE AWARE
GO
IF EXISTS(SELECT * FROM sys.indexes WHERE object_id = object_id('dbo.Alerts$') AND NAME ='idx_FacilityName')
    DROP INDEX idx_FacilityName ON dbo.Alerts$;
GO
	CREATE CLUSTERED INDEX idx_FacilityName ON [dbo].[Alerts$]
	(
		FACILITYNAME ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO

USE AWARE
GO
IF EXISTS(SELECT * FROM sys.indexes WHERE object_id = object_id('dbo.Alerts$') AND NAME ='idx_FacilityNameOrdProvider')
    DROP INDEX idx_FacilityNameOrdProvider ON dbo.Alerts$;
GO	
	CREATE NONCLUSTERED INDEX [idx_FacilityNameOrdProvider] ON [dbo].[Alerts$]
	(
		[FACILITYNAME] ASC,
		[ORDERINGPROVIDER] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)

	GO

USE AWARE
GO
IF EXISTS(SELECT * FROM sys.indexes WHERE object_id = object_id('dbo.Alerts$') AND NAME ='idx_FacServClinOrdPrvAlert')
    DROP INDEX idx_FacServClinOrdPrvAlert ON dbo.Alerts$;
GO	
	CREATE NONCLUSTERED INDEX [idx_FacServClinOrdPrvAlert] ON [dbo].[Alerts$]
	(
		[FACILITYNAME] ASC,
		[SERVICE1] ASC,
		[ORDERINGPROVIDER] ASC,
		[ALERTCATEGORY] ASC,
		[CLINIC] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO

USE AWARE
GO
IF EXISTS(SELECT * FROM sys.indexes WHERE object_id = object_id('dbo.Alerts$') AND NAME ='idx_FacilityServiceClinic')
    DROP INDEX idx_FacilityServiceClinic ON dbo.Alerts$;
GO	
	CREATE NONCLUSTERED INDEX [idx_FacilityServiceClinic] ON [dbo].[Alerts$]
	(
		[FACILITYNAME] ASC,
		[SERVICE1] ASC,
		[CLINIC] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)

GO

USE AWARE
GO
IF EXISTS(SELECT * FROM sys.indexes WHERE object_id = object_id('dbo.Alerts$') AND NAME ='idx_FacilityService')
    DROP INDEX idx_FacilityService ON dbo.Alerts$;
GO		
	CREATE NONCLUSTERED INDEX [idx_FacilityService] ON [dbo].[Alerts$]
	(
		[FACILITYNAME] ASC,
		[SERVICE1] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)

GO

USE AWARE
GO
IF EXISTS(SELECT * FROM sys.indexes WHERE object_id = object_id('dbo.Alerts$') AND NAME ='idx_FacSrvClinOrdPrv')
    DROP INDEX idx_FacSrvClinOrdPrv ON dbo.Alerts$;
GO		
	CREATE NONCLUSTERED INDEX [idx_FacSrvClinOrdPrv] ON [dbo].[Alerts$]
	(
		[FACILITYNAME] ASC,
		[SERVICE1] ASC,
		[CLINIC] ASC,
		[ORDERINGPROVIDER] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO

USE AWARE
GO
IF EXISTS(SELECT * FROM sys.indexes WHERE object_id = object_id('dbo.SECURITY_ITEMS') AND NAME ='idx_ObjectTypeId')
    DROP INDEX idx_ObjectTypeId ON dbo.SECURITY_ITEMS
GO	
	CREATE NONCLUSTERED INDEX [idx_ObjectTypeId] ON [dbo].[SECURITY_ITEMS]
	(
		[OBJECT_TYPE_ID] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO



/* *******************************************************************************************
	End of run any and every time block
	*****************************************************************************************/



