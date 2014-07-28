
/* GET LIST OF ALL CONSULTS in date range specified into ClinicType8t*/
DROP TABLE ClinicType8$ SELECT DISTINCT   Consult$.STA3N,Consult$.ConsultSID,Consult$.PatientLocationSID, Consult$.RequestDateTime, Consult$.FromLocationSID, 
                      Consult$.ToRequestServiceName, Consult$.AttentionToStaffSID, Consult$.CPRSStatus, TestInstitutionDIM$.InstitutionIEN, Consult$.FileEntryVistaDate,
                      Consult$.ConsultIEN ,TestInstitutionDIM$.InstitutionName,Consult$.ToRequestServiceSID,Consult$.PatientSID,Consult$.OrderingInstitutionSID,
                      Consult$.RoutingInstitutionSID
                      
                      
INTO ClinicType8$
FROM          (Consult$ 
                        JOIN
                      TestInstitutionDIM$ ON Consult$.OrderingInstitutionSID = TestInstitutionDIM$.InstitutionSID)
                      
WHERE  (Consult$.ToRequestServiceName LIKE '%MH%' OR Consult$.ToRequestServiceName LIKE '%MENTAL%' OR Consult$.ToRequestServiceName LIKE '%PSY%')
       AND (YEAR(Consult$.RequestDateTime)=2000) AND (MONTH(Consult$.RequestDateTime)>=5) AND (MONTH(Consult$.RequestDateTime)<=7)
ORDER BY Consult$.ConsultSID

GO
IF OBJECT_ID (N'dbo.ufnConfirmVistaDateGTDateTime', N'FN') IS NOT NULL
    DROP FUNCTION ufnConfirmVistaDateGTDateTime;
GO
CREATE FUNCTION dbo.ufnConfirmVistaDateGTDateTime(@VisitVistaDate float,@AppointmentDateTime datetime)
RETURNS int
AS 
-- Returns comparison of date ( year, month, day and hours and minutes) for 2 dates passed as 'true' or 'false'
BEGIN
    DECLARE @ret int;
    DECLARE @monthday1 int;
    DECLARE @monthday2 int;
    SET @monthday1=(Cast (Substring(STR(@VisitVistaDate,11,3),4,2)as INT)*100)+Cast (Substring(STR(@VisitVistaDate,11,3),6,2)as INT)
    SET @monthday2=(MONTH(@AppointmentDateTime)*100)+DAY(@AppointmentDateTime)
    SET @ret =
    CASE 
        WHEN 
            ((Cast (Substring(STR(@VisitVistaDate,11,3),1,3)as INT)+1700) = YEAR(@AppointmentDateTime))AND (@monthday1>=@monthday2) AND ((@monthday1-@monthday2)<130)
        THEN 1
        WHEN 
            ((Cast (Substring(STR(@VisitVistaDate,11,3),1,3)as INT)+1700) = (YEAR(@AppointmentDateTime)+1)) AND (MONTH(@AppointmentDateTime)>11) AND (Cast (Substring(STR(@VisitVistaDate,11,3),4,2)as INT)<2) AND ((@monthday1+1200)>=@monthday2)  AND (((@monthday1+1200)-@monthday2)<130)
        THEN 1
        ELSE 0    
    END
    return @ret 
END;

GO
/*  Find Outpatient Encounters and potenetially related Test Appointments for same specified consults in date range as ClinicType8 and stored in ClincType5*/

DROP TABLE ClinicType5$ SELECT DISTINCT   Consult$.ConsultSID,Consult$.STA3N,Consult$.PatientLocationSID, Consult$.RequestDateTime, 
                      Consult$.FromLocationSID, 
                      Consult$.ToRequestServiceName, Consult$.AttentionToStaffSID, Consult$.CPRSStatus, TestInstitutionDIM$.InstitutionIEN, 
                      Consult$.FileEntryVistaDate,
                      Consult$.ConsultIEN ,TestInstitutionDIM$.InstitutionName,Consult$.ToRequestServiceSID,Consult$.PatientSID,
                      TestOutpatientEncounter$.VisitVistaDate,TestOutpatientEncounter$.PrimaryStopCode,TestLocationDim$.LocationName,
                      TestOutpatientEncounter$.Sta3n1,TestOutpatientEncounter$.PrimaryStopCodeSID,TestAssociatedStopCodes$.StopCodeSID,
                      TestStopCOdeDim$.StopCodeName,TestAppointment$.VisitSID,TestAppointment$.LocationSID,TestAppointment$.AppointmentDateTime,
                      TestOutpatientEncounter$.VisitCreatedDate,Consult$.OrderingInstitutionSID,Consult$.RoutingInstitutionSID,TestOutpatientEncounter$.VisitSID AS VisitSID1
                      
INTO ClinicType5$
FROM          (Consult$ 
                        INNER JOIN
                      TestOutpatientEncounter$ on Consult$.PatientSID = TestOutpatientEncounter$.PatientSID
                        INNER JOIN
                      TestAppointment$  ON TestOutpatientEncounter$.LocationSID =  TestAppointment$.LocationSID
                        JOIN
                      TestLocationDim$  ON TestOutpatientEncounter$.LocationSID = TestLocationDim$.LocationSID
                        JOIN
                      TestInstitutionDIM$ ON Consult$.OrderingInstitutionSID = TestInstitutionDIM$.InstitutionSID
                        JOIN
                      TestAssociatedStopCodes$ ON TestOutpatientEncounter$.PrimaryStopCodeSID = TestAssociatedStopCodes$.StopCodeSID
                        JOIN
                      TestStopCOdeDim$ ON TestAssociatedStopCodes$.StopCodeSID = TestStopCOdeDim$.StopCodeSID)
WHERE  (Consult$.ToRequestServiceName LIKE '%MH%' OR Consult$.ToRequestServiceName LIKE '%MENTAL%' OR Consult$.ToRequestServiceName LIKE '%PSY%') AND (YEAR(Consult$.RequestDateTime)=2000) AND (MONTH(Consult$.RequestDateTime)>=5) AND (MONTH(Consult$.RequestDateTime)<=7) AND (dbo.ufnConfirmVistaDateGTDateTime(TestOutpatientEncounter$.VisitVistaDate,Consult$.RequestDateTime)=1)
        AND (YEAR(TestAppointment$.AppointmentDateTime)=2000) AND (MONTH(TestAppointment$.AppointmentDateTime)>=5) AND (MONTH(TestAppointment$.AppointmentDateTime)<=7)  
        AND (((TestOutpatientEncounter$.PrimaryStopCode >499) AND (TestOutpatientEncounter$.PrimaryStopCode <600))OR ((TestOutpatientEncounter$.PrimaryStopCode >210) AND (TestOutpatientEncounter$.PrimaryStopCode <231)))
        AND ((Consult$.CPRSStatus  !='DISCONTINUED' ) AND (Consult$.CPRSStatus != 'CANCELLED' ) AND (TestAppointment$.PatientSID = Consult$.PatientSID) ) 
ORDER BY
       Consult$.ConsultSID,TestOutpatientEncounter$.PrimaryStopCode,TestAppointment$.AppointmentDateTime

GO

/*SQL below. Re-position fields in logical order of importance from ClinicType5 to ClinicType22*/
DROP TABLE ClinicType22$ SELECT DISTINCT ClinicType5$.STA3N,ClinicType5$.ConsultSID,ClinicType5$.PrimaryStopCode,
                      ClinicType5$.PatientLocationSID, ClinicType5$.RequestDateTime, ClinicType5$.FromLocationSID, 
                      ClinicType5$.ToRequestServiceName, ClinicType5$.AttentionToStaffSID, ClinicType5$.CPRSStatus,
                      ClinicType5$.InstitutionIEN, ClinicType5$.FileEntryVistaDate,
                      ClinicType5$.ConsultIEN ,ClinicType5$.InstitutionName,ClinicType5$.ToRequestServiceSID,
                      ClinicType5$.PatientSID,
                      ClinicType5$.VisitVistaDate,ClinicType5$.LocationName,
                      ClinicType5$.Sta3n1,ClinicType5$.PrimaryStopCodeSID,ClinicType5$.StopCodeSID,
                      ClinicType5$.StopCodeName,ClinicType5$.VisitSID,ClinicType5$.LocationSID,ClinicType5$.AppointmentDateTime,
                      ClinicType5$.VisitCreatedDate,ClinicType5$.OrderingInstitutionSID,ClinicType5$.RoutingInstitutionSID,ClinicType5$.VisitSID1
INTO  ClinicType22$
FROM  ClinicType5$

GO
IF OBJECT_ID (N'dbo.ufnConfirmVistaDateSameAsDateTime', N'FN') IS NOT NULL
    DROP FUNCTION ufnConfirmVistaDateSameAsDateTime;
GO
CREATE FUNCTION dbo.ufnConfirmVistaDateSameAsDateTime(@VisitVistaDate float,@AppointmentDateTime datetime)
RETURNS int
AS 
-- Returns comparison of date ( year, month, day and hours and minutes) for 2 dates passed, one as Vista datetime , the other as SQL datetime as 'true' or 'false'
BEGIN
    DECLARE @ret int;
    SET @ret =
    CASE 
        WHEN 
            ((Cast (Substring(STR(@VisitVistaDate,11,3),1,3)as INT)+1700) = YEAR(@AppointmentDateTime))AND (Cast (Substring(STR(@VisitVistaDate,11,3),4,2)as INT) = MONTH(@AppointmentDateTime)) AND
            (Cast (Substring(STR(@VisitVistaDate,11,3),6,2)as INT) = DAY(@AppointmentDateTime)) AND
            (LEN(STR(@VisitVistaDate,12,4))=9) AND (Cast(Substring(STR(@VisitVistaDate,12,4),9,1)AS INT) = Cast(Substring(Cast(Convert(time,@AppointmentDateTime)as NVARCHAR),1,2) AS INT)) AND 
            (Substring(Cast(Convert(time,@AppointmentDateTime)as NVARCHAR),4,2) ='00') THEN 1
        WHEN 
            ((Cast (Substring(STR(@VisitVistaDate,11,3),1,3)as INT)+1700) = YEAR(@AppointmentDateTime))AND (Cast (Substring(STR(@VisitVistaDate,11,3),4,2)as INT) = MONTH(@AppointmentDateTime)) AND
            (Cast (Substring(STR(@VisitVistaDate,11,3),6,2)as INT) = DAY(@AppointmentDateTime)) AND
            (LEN(STR(@VisitVistaDate,12,4))=10)  AND (Cast(Substring(STR(@VisitVistaDate,12,4),9,2) as INT) = Cast(Substring(Cast(Convert(time,@AppointmentDateTime)as NVARCHAR),1,2) AS INT) AND
            (Substring(Cast(Convert(time,@AppointmentDateTime)as NVARCHAR),4,2)) ='00')   THEN 1
        WHEN
            ((Cast (Substring(STR(@VisitVistaDate,11,3),1,3)as INT)+1700) = YEAR(@AppointmentDateTime))AND (Cast (Substring(STR(@VisitVistaDate,11,3),4,2)as INT) = MONTH(@AppointmentDateTime)) AND
            (Cast (Substring(STR(@VisitVistaDate,11,3),6,2)as INT) = DAY(@AppointmentDateTime)) AND
            (LEN(STR(@VisitVistaDate,12,4))=11)  AND (Cast(Substring(STR(@VisitVistaDate,12,4),9,2) as INT) = Cast(Substring(Cast(Convert(time,@AppointmentDateTime)as NVARCHAR),1,2) AS INT)) AND
            (Cast((Substring(STR(@VisitVistaDate,12,4),11,1)+'0') AS INT) =Cast(Substring(Cast(Convert(time,@AppointmentDateTime)as NVARCHAR),4,2) as INT))         THEN 1
        WHEN 
            ((Cast (Substring(STR(@VisitVistaDate,11,3),1,3)as INT)+1700) = YEAR(@AppointmentDateTime))AND (Cast (Substring(STR(@VisitVistaDate,11,3),4,2)as INT) = MONTH(@AppointmentDateTime)) AND
            (Cast (Substring(STR(@VisitVistaDate,11,3),6,2)as INT) = DAY(@AppointmentDateTime)) AND
            (LEN(STR(@VisitVistaDate,12,4))>=12) AND (Substring(STR(@VisitVistaDate,12,4),9,4) = Substring(Cast(Convert(time,@AppointmentDateTime)as NVARCHAR),1,2)+ Substring(Cast(Convert(time,@AppointmentDateTime)as NVARCHAR),4,2))       THEN 1
        ELSE 0    
    END
    return @ret 
END;



GO

/*Find matches of Test Outpatient Encounters in vista datetime to Test Appointment ones in datetime from FUNCTION VistaDateSameAsDateTime(vista date tiem, appointdatetime) ret int
from ClinicType22 to ClinciType23*/

DROP TABLE ClinicType23$ SELECT DISTINCT   ClinicType22$.ConsultSID,ClinicType22$.STA3N,ClinicType22$.PatientLocationSID, ClinicType22$.RequestDateTime, ClinicType22$.FromLocationSID, 
                      ClinicType22$.ToRequestServiceName, ClinicType22$.AttentionToStaffSID, ClinicType22$.CPRSStatus, ClinicType22$.InstitutionIEN, ClinicType22$.FileEntryVistaDate,
                      ClinicType22$.ConsultIEN ,ClinicType22$.InstitutionName,ClinicType22$.ToRequestServiceSID,ClinicType22$.PatientSID,
                      ClinicType22$.VisitVistaDate,ClinicType22$.PrimaryStopCode,ClinicType22$.LocationName,
                      ClinicType22$.Sta3n1,ClinicType22$.PrimaryStopCodeSID,ClinicType22$.StopCodeSID,
                      ClinicType22$.StopCodeName,ClinicType22$.VisitSID,ClinicType22$.LocationSID,ClinicType22$.AppointmentDateTime,
                      ClinicType22$.VisitCreatedDate,ClinicType22$.OrderingInstitutionSID,ClinicType22$.RoutingInstitutionSID,ClinicType22$.VisitSID1
                      
INTO ClinicType23$
FROM ClinicType22$
                       
WHERE (dbo.ufnConfirmVistaDateSameAsDateTime(ClinicType22$.VisitVistaDate,ClinicType22$.AppointmentDateTime)=1)
/* and(SUBSTRING(ClinicType22$.LocationName,1,1)!='Z') */


GO

/* Add Test Institution to fields for all consults list including adding Location Name and VIstaSID1 as Dummy fields
from ClinicType8 to ClinicType18*/

DROP TABLE ClinicType18$ SELECT DISTINCT   ClinicType8$.STA3N,ClinicType8$.ConsultSID,ClinicType8$.PatientLocationSID, ClinicType8$.RequestDateTime, ClinicType8$.FromLocationSID, 
                      ClinicType8$.ToRequestServiceName, ClinicType8$.AttentionToStaffSID, ClinicType8$.CPRSStatus, TestInstitutionDIM$.InstitutionIEN, ClinicType8$.FileEntryVistaDate,
                      ClinicType8$.ConsultIEN ,TestInstitutionDIM$.InstitutionName,ClinicType8$.ToRequestServiceSID,ClinicType8$.PatientSID,ClinicType8$.OrderingInstitutionSID,
                      ClinicType8$.RoutingInstitutionSID,-1 as VisitSID1,'' as LocationName
                      
INTO ClinicType18$
FROM          (ClinicType8$ 
                        JOIN
                      TestInstitutionDIM$ ON ClinicType8$.OrderingInstitutionSID = TestInstitutionDIM$.InstitutionSID)
                      
WHERE  (ClinicType8$.ToRequestServiceName LIKE '%MH%' OR ClinicType8$.ToRequestServiceName LIKE '%MENTAL%' OR ClinicType8$.ToRequestServiceName LIKE '%PSY%') 


GO

/* Left join all selected consults in ClinicType18 with ClinicType23 to produce excluded entries in ClinicType19 */

DROP TABLE ClinicType19$ SELECT ClinicType18$.STA3N,ClinicType18$.ConsultSID,ClinicType18$.ToRequestServiceSID,
ClinicType18$.ToRequestServiceName,
ClinicType18$.PatientLocationSID,ClinicType18$.RequestDateTime,ClinicType18$.FromLocationSID,
ClinicType18$.AttentionToStaffSID,ClinicType18$.CPRSStatus,
ClinicType18$.FileEntryVistaDate,ClinicType18$.ConsultIEN,
ClinicType18$.PatientSID,ClinicType18$.OrderingInstitutionSID,ClinicType18$.RoutingInstitutionSID,ClinicType18$.VisitSID1,ClinicType18$.LocationName

INTO ClinicType19$
FROM   (ClinicType18$
       LEFT JOIN ClinicType23$
       ON ClinicType18$.ConsultSID = ClinicType23$.ConsultSID)
       
WHERE ClinicType23$.PrimaryStopCode IS NULL

GO

/* For excluded consults above find all multiple asosciated clinc stop codes 
associated with last assessed "TO Request Service" . From  ClinicType19 to ClinicType20*/

DROP TABLE ClinicType20$ select cc.STA3N,cc.consultSID,da.StopCode,cc.ToRequestServiceName, da.StopCodeSID,
ll.PrimaryStopCode as ReferringPrimaryStopCode,
ll.SecondaryStopCode as ReferringSecondaryStopCode,cc.ToRequestServiceSID,
cc.PatientLocationSID,cc.RequestDateTime,cc.FromLocationSID,
cc.AttentionToStaffSID,cc.CPRSStatus,
cc.FileEntryVistaDate,cc.ConsultIEN,
cc.PatientSID,cc.OrderingInstitutionSID,cc.RoutingInstitutionSID,cc.VisitSID1,cc.LocationName
INTO ClinicType20$
FROM ClinicType19$ as cc 

      join 
      TestRequestServiceDim$ on
      cc.ToRequestServiceSID = TestRequestServiceDim$.RequestServiceSID
      join 
     TestAssociatedStopCodes$ as da on
     (TestRequestServiceDim$.RequestServiceSID= da.RequestServiceSID )/*and da.StopCode between 500 and 600*/
     join 
     TestLocationDim$ as ll
     on cc.PatientLocationSID = ll.LocationSID
WHERE     (((da.StopCode > 499) and (da.stopcode <601))OR ((da.StopCode >210) AND (da.StopCode <231))) 
           AND (cc.ToRequestServiceName LIKE '%MH%' OR cc.ToRequestServiceName LIKE '%MENTAL%' OR cc.ToRequestServiceName LIKE '%PSY%')



GO


/* For excluded entries list, add additionmal dummy fields and calculated fields
  From ClinicType20 to ClinicType25*/
  
DROP TABLE ClinicType25$ SELECT [STA3N]
      ,[consultSID]
      ,[StopCode]
      ,[ToRequestServiceName]
      ,[StopCodeSID]
      ,[ReferringPrimaryStopCode]
      ,[ReferringSecondaryStopCode]
      ,[ToRequestServiceSID]
      ,[PatientLocationSID]
      ,[RequestDateTime]
      ,[FromLocationSID]
      ,[AttentionToStaffSID]
      ,[CPRSStatus]
      ,[FileEntryVistaDate]
      ,[ConsultIEN]
      ,[PatientSID]
      ,[LocationName]
      ,[OrderingInstitutionSID]
      ,[RoutingInstitutionSID]
      ,[VisitSID1]as VistaSID1
      ,NULL AS ConsultInitiationDate
      ,NULL AS WaitTime
      ,(CASE WHEN
           ([CPRSStatus] = 'CANCELLED') OR ([CPRSStatus] = 'DISCONTINUED')
        THEN 0
        ELSE 1
        END) AS WaitTimeGT15DaysWoVisit
      ,(CASE WHEN
           [CPRSStatus] = 'CANCELLED'
        THEN 1
        ELSE 0
        END) AS CancelledAppointmentYesNo
      ,(CASE WHEN
           [CPRSStatus] = 'DISCONTINUED'
        THEN 1
        ELSE 0
        END) AS DiscontinuedAppointmentYesNo
  INTO [consults].[dbo].ClinicType25$
  FROM [consults].[dbo].[ClinicType20$]
 
 
  

GO


/*Do valid calculated fields for outpaient encounter involved encounter associated aconsults.
 From ClinciType23 to ClinicType26 */
 
DROP TABLE ClinicType26A$ SELECT [ConsultSID]
      ,[STA3N]
      ,[PatientLocationSID]
      ,[RequestDateTime]
      ,[FromLocationSID]
      ,[ToRequestServiceName]
      ,[AttentionToStaffSID]
      ,[CPRSStatus]
      ,[InstitutionIEN]
      ,[FileEntryVistaDate]
      ,[ConsultIEN]
      ,[InstitutionName]
      ,[ToRequestServiceSID]
      ,[PatientSID]
      ,[VisitVistaDate]
      ,[PrimaryStopCode]
      ,[LocationName]
      ,[Sta3n1]
      ,[PrimaryStopCodeSID]
      ,[StopCodeSID]
      ,[StopCodeName]
      ,[VisitSID]
      ,[LocationSID]
      ,[VisitCreatedDate]
      ,[OrderingInstitutionSID]
      ,[RoutingInstitutionSID]
      ,[VisitSID1]as VistaSID1
      ,[AppointmentDateTime] as ConsultInitiationDate
      ,DATEDIFF(DAY,[RequestDateTime],[AppointmentDateTime]) AS WaitTime
      ,(CASE WHEN
           DATEDIFF(DAY,[RequestDateTime],[AppointmentDateTime]) > 15
        THEN 1
        ELSE 0
        END) AS WaitTimeGT15DaysWoVisit
      ,(CASE WHEN
           [CPRSStatus] = 'CANCELLED'
        THEN 1
        ELSE 0
        END) AS CancelledAppointmentYesNo
      ,(CASE WHEN
           [CPRSStatus] = 'DISCONTINUED'
        THEN 1
        ELSE 0
        END) AS DiscontinuedAppointmentYesNo
  INTO [consults].[dbo].ClinicType26A$
  FROM [consults].[dbo].[ClinicType23$]

GO

/*NEXT, reduce to entry MATCHED APPT DATETIME TO VISTAVISTADATE TO JUST 1ST ONE MATCH ON 1ST ConsultInitiationDate 
=APPT DATE WITH ROW SEARCH =1*/

USE consults
DROP TABLE ClinicType26B$ SELECT l26.ConsultSID,l26.STA3N,l26.PatientLocationSID,l26.RequestDateTime,l26.FromLocationSID,l26.ToRequestServiceName,
l26.AttentionToStaffSID,l26.CPRSStatus,l26.InstitutionIEN,l26.FileEntryVistaDate,l26.ConsultIEN,l26.InstitutionName,
l26.ToRequestServiceSID,l26.PatientSID,l26.VisitVistaDate,l26.PrimaryStopCode,l26.LocationName,l26.Sta3n1,
l26.PrimaryStopCodeSID,l26.StopCodeSID,l26.StopCodeName,l26.VisitSID,l26.LocationSID,l26.VisitCreatedDate,
l26.OrderingInstitutionSID,l26.RoutingInstitutionSID,l26.VistaSID1,
l26.ConsultInitiationDate,l26.WaitTime,l26.WaitTimeGT15DaysWoVisit,l26.CancelledAppointmentYesNo,l26.DiscontinuedAppointmentYesNo,
ROW_NUMBER() OVER (partition by l26.ConsultSID,l26.STA3N ORDER BY l26.ConsultSID,l26.STA3N,l26.ConsultInitiationDate ASC) AS ROWNUMBER
INTO ClinicType26B$
FROM ClinicType26A$ as l26

--WHERE ROWNUMBER=1
--GROUP BY ClinicType26A$.STA3N,ClinicType26A$.ConsultSID,ClinicType26A$.ConsultInitiationDate

GO
/* NEXT CHOOSE ONLY CHOOSE ROW NUMBER 1 AS EARLIEST ELEMENT FOR NEXT SCHEDULED APPT . FROM ClinicType24A TO ClinicType24B */

DROP TABLE ClinicType26$ SELECT l26.ConsultSID,l26.STA3N,l26.PatientLocationSID,l26.RequestDateTime,l26.FromLocationSID,l26.ToRequestServiceName,
l26.AttentionToStaffSID,l26.CPRSStatus,l26.InstitutionIEN,l26.FileEntryVistaDate,l26.ConsultIEN,l26.InstitutionName,
l26.ToRequestServiceSID,l26.PatientSID,l26.VisitVistaDate,l26.PrimaryStopCode,l26.LocationName,l26.Sta3n1,
l26.PrimaryStopCodeSID,l26.StopCodeSID,l26.StopCodeName,l26.VisitSID,l26.LocationSID,l26.VisitCreatedDate,
l26.OrderingInstitutionSID,l26.RoutingInstitutionSID,l26.VistaSID1,
l26.ConsultInitiationDate,l26.WaitTime,l26.WaitTimeGT15DaysWoVisit,l26.CancelledAppointmentYesNo,l26.DiscontinuedAppointmentYesNo,
l26.ROWNUMBER
INTO ClinicType26$
FROM ClinicType26B$ as l26
   
WHERE ROWNUMBER=1
--GROUP BY ClinicType26B$.STA3N,ClinicType26B$.ConsultSID,ClinicType26B$.ConsultInitiationDate

GO

/* Union Test oupatient Encounter associated consults to excluded non Test Outpatient Encnounter associated consult list. 
 From ClinicType26 and ClinicType25 into ClinicType21A*/
 
DECLARE @EMPTY1 varchar(30) = '@NULL'
DECLARE @EMPTY2 varchar(30) = '@NULL'
DROP TABLE ClinicType21A$ SELECT l26.STA3N, l26.ConsultSID,l26.PrimaryStopCode,
l26.ToRequestServiceName,l26.StopCodeSID,
l26.ToRequestServiceSID,l26.PatientLocationSID,l26.RequestDateTime,l26.FromLocationSID,l26.AttentionToStaffSID,
l26.CPRSStatus,l26.FileEntryVistaDate,l26.ConsultIEN,
l26.PatientSID,l26.OrderingInstitutionSID,l26.RoutingInstitutionSID,l26.LocationName,l26.VistaSID1,
l26.ConsultInitiationDate,l26.WaitTime,l26.WaitTimeGT15DaysWoVisit,l26.CancelledAppointmentYesNo,l26.DiscontinuedAppointmentYesNo

INTO ClinicType21A$
FROM ClinicType26$ as l26
UNION
SELECT ClinicType25$.STA3N,ClinicType25$.ConsultSID,ClinicType25$.StopCode,
ClinicType25$.ToRequestServiceName, ClinicType25$.StopCodeSID,
ClinicType25$.ToRequestServiceSID,
ClinicType25$.PatientLocationSID,ClinicType25$.RequestDateTime,ClinicType25$.FromLocationSID,
ClinicType25$.AttentionToStaffSID,ClinicType25$.CPRSStatus,
ClinicType25$.FileEntryVistaDate,ClinicType25$.ConsultIEN,
ClinicType25$.PatientSID,ClinicType25$.OrderingInstitutionSID,ClinicType25$.RoutingInstitutionSID,ClinicType25$.LocationName,ClinicType25$.VistaSID1,
ClinicType25$.ConsultInitiationDate,ClinicType25$.WaitTime,ClinicType25$.WaitTimeGT15DaysWoVisit,
ClinicType25$.CancelledAppointmentYesNo,ClinicType25$.DiscontinuedAppointmentYesNo
FROM ClinicType25$

ORDER BY 2;

GO


IF OBJECT_ID (N'dbo.ufnNextScheduledAppt', N'FN') IS NOT NULL
    DROP FUNCTION ufnNextScheduledAppt;
GO
CREATE FUNCTION dbo.ufnNextScheduledAppt(@ConsultInitiationDate datetime,@AppointmentDateTime datetime,@RequestDateTime datetime)
RETURNS datetime
AS 
-- Returns comparison of date ( year, month, day and hours and minutes) for 2 dates passed 
-- if any outpatient encounter  found in next 90 days from consult request datetime . Return DateTime of this encounter
BEGIN
    DECLARE @ret datetime;
    SET @ret =
    CASE 
        /*WHEN 
            (@ConsultInitiationDate !='') AND (@AppointmentDateTime>@ConsultInitiationDate) AND (@AppointmentDateTime<DATEADD(month,3,@ConsultInitiationDate))
        THEN @AppointmentDateTime
        WHEN 
            ((@ConsultInitiationDate ='')OR (ISNULL(@ConsultInitiationDate) ) AND (@AppointmentDateTime>@RequestDateTime) AND (@AppointmentDateTime<DATEADD(month,3,@RequestDateTime))
        THEN @AppointmentDateTime */
        WHEN
            (@AppointmentDateTime>@RequestDateTime) AND (@AppointmentDateTime<DATEADD(month,3,@RequestDateTime)) AND (@AppointmentDateTime>DATEADD(day,15,@RequestDateTime))
        THEN @AppointmentDateTime
        ELSE ''    
    END
    return @ret 
END;

GO

/* Repeating entries with matched exact Test Outpatient Encounter datetime to Test Appointment datetime 
 From ClinicType21A into ClinicType21B*/
 
DROP TABLE ClinicType21B$ SELECT ClinicType21A$.STA3N,ClinicType21A$.ConsultSID,ClinicType21A$.PrimaryStopCode,
ClinicType21A$.ToRequestServiceName, ClinicType21A$.StopCodeSID,
ClinicType21A$.ToRequestServiceSID,
ClinicType21A$.PatientLocationSID,ClinicType21A$.RequestDateTime,ClinicType21A$.FromLocationSID,
ClinicType21A$.AttentionToStaffSID,ClinicType21A$.CPRSStatus,
ClinicType21A$.FileEntryVistaDate,ClinicType21A$.ConsultIEN,
ClinicType21A$.PatientSID,ClinicType21A$.OrderingInstitutionSID,ClinicType21A$.RoutingInstitutionSID,ClinicType21A$.LocationName,ClinicType21A$.VistaSID1,
ClinicType21A$.ConsultInitiationDate,ClinicType21A$.WaitTime,ClinicType21A$.WaitTimeGT15DaysWoVisit,
ClinicType21A$.CancelledAppointmentYesNo,ClinicType21A$.DiscontinuedAppointmentYesNo,
dbo.ufnNextScheduledAppt(ClinicType21A$.ConsultInitiationDate,TestAppointment$.AppointmentDateTime,ClinicType21A$.RequestDateTime)as NextScheduledAppt,TestLocationDim$.LocationName as NextSchedLocationName
                      
INTO ClinicType21B$
FROM (ClinicType21A$ 
                       
                        JOIN
                      TestAppointment$  ON ClinicType21A$.PatientSID =  TestAppointment$.PatientSID
                        JOIN
                      TestLocationDim$  ON TestAppointment$.LocationSID = TestLocationDim$.LocationSID)
                      
WHERE  (TestAppointment$.PatientSID = ClinicType21A$.PatientSID)
       AND (dbo.ufnNextScheduledAppt(ClinicType21A$.ConsultInitiationDate,TestAppointment$.AppointmentDateTime,ClinicType21A$.RequestDateTime)!='')
       AND (((TestLocationDim$.PrimaryStopCodeIEN >499) AND (TestLocationDim$.PrimaryStopCodeIEN <600))OR ((TestLocationDim$.PrimaryStopCodeIEN >210) AND (TestLocationDim$.PrimaryStopCodeIEN <231)))
       
   

GO


/* Order by Station, ConsultSID, and Primary StopCode, and next Scheduled Appt
From clinciType21B to ClinicType21C*/

DROP TABLE ClinicType21C$ SELECT ClinicType21B$.STA3N,ClinicType21B$.ConsultSID,ClinicType21B$.PrimaryStopCode,
ClinicType21B$.ToRequestServiceName, ClinicType21B$.StopCodeSID,
ClinicType21B$.ToRequestServiceSID,
ClinicType21B$.PatientLocationSID,ClinicType21B$.RequestDateTime,ClinicType21B$.FromLocationSID,
ClinicType21B$.AttentionToStaffSID,ClinicType21B$.CPRSStatus,
ClinicType21B$.FileEntryVistaDate,ClinicType21B$.ConsultIEN,
ClinicType21B$.PatientSID,ClinicType21B$.OrderingInstitutionSID,ClinicType21B$.RoutingInstitutionSID,ClinicType21B$.LocationName,ClinicType21B$.VistaSID1,
ClinicType21B$.ConsultInitiationDate,ClinicType21B$.WaitTime,ClinicType21B$.WaitTimeGT15DaysWoVisit,
ClinicType21B$.CancelledAppointmentYesNo,ClinicType21B$.DiscontinuedAppointmentYesNo,
ClinicType21B$.NextScheduledAppt,ClinicType21B$.NextSchedLocationName
                      
INTO ClinicType21C$
FROM ClinicType21B$ 
ORDER BY ClinicType21B$.STA3N,ClinicType21B$.ConsultSID,ClinicType21B$.PrimaryStopCode,ClinicType21B$.NextScheduledAppt

GO

/* ADD NULL NEXT SCHEDULED APPT and LOCATION NAME IN WHOLE LIST ClinicType21A TO MAKE ClinicType21AA */

DROP TABLE ClinicType21AA$ SELECT ClinicType21A$.STA3N,ClinicType21A$.ConsultSID,ClinicType21A$.PrimaryStopCode,
ClinicType21A$.ToRequestServiceName, ClinicType21A$.StopCodeSID,
ClinicType21A$.ToRequestServiceSID,
ClinicType21A$.PatientLocationSID,ClinicType21A$.RequestDateTime,ClinicType21A$.FromLocationSID,
ClinicType21A$.AttentionToStaffSID,ClinicType21A$.CPRSStatus,
ClinicType21A$.FileEntryVistaDate,ClinicType21A$.ConsultIEN,
ClinicType21A$.PatientSID,ClinicType21A$.OrderingInstitutionSID,ClinicType21A$.RoutingInstitutionSID,ClinicType21A$.LocationName,ClinicType21A$.VistaSID1,
ClinicType21A$.ConsultInitiationDate,ClinicType21A$.WaitTime,ClinicType21A$.WaitTimeGT15DaysWoVisit,
ClinicType21A$.CancelledAppointmentYesNo,ClinicType21A$.DiscontinuedAppointmentYesNo,
NULL AS NextScheduledAppt,'' as NextSchedLocationName
                      
INTO ClinicType21AA$
FROM ClinicType21A$ 

GO

/*AND DO ORDER BY TO MAKE ClinicType21AB */

DROP TABLE ClinicType21AB$ SELECT ClinicType21AA$.STA3N,ClinicType21AA$.ConsultSID,ClinicType21AA$.PrimaryStopCode,
ClinicType21AA$.ToRequestServiceName, ClinicType21AA$.StopCodeSID,
ClinicType21AA$.ToRequestServiceSID,
ClinicType21AA$.PatientLocationSID,ClinicType21AA$.RequestDateTime,ClinicType21AA$.FromLocationSID,
ClinicType21AA$.AttentionToStaffSID,ClinicType21AA$.CPRSStatus,
ClinicType21AA$.FileEntryVistaDate,ClinicType21AA$.ConsultIEN,
ClinicType21AA$.PatientSID,ClinicType21AA$.OrderingInstitutionSID,ClinicType21AA$.RoutingInstitutionSID,ClinicType21AA$.LocationName,ClinicType21AA$.VistaSID1,
ClinicType21AA$.ConsultInitiationDate,ClinicType21AA$.WaitTime,ClinicType21AA$.WaitTimeGT15DaysWoVisit,
ClinicType21AA$.CancelledAppointmentYesNo,ClinicType21AA$.DiscontinuedAppointmentYesNo,
ClinicType21AA$.NextScheduledAppt,ClinicType21AA$.NextSchedLocationName
                      
INTO ClinicType21AB$
FROM ClinicType21AA$ 
ORDER BY ClinicType21AA$.STA3N,ClinicType21AA$.ConsultSID,ClinicType21AA$.PrimaryStopCode,ClinicType21AA$.NextScheduledAppt

GO

/*NEXT DO LEFT JOIN OF ClinicType21AB WITH ClinicType21C INTO ClinicType21D FOR EXCLUDED CONSULT entries */


DROP TABLE ClinicType21D$ Select ClinicType21AB$.STA3N,ClinicType21AB$.ConsultSID,ClinicType21AB$.PrimaryStopCode,
ClinicType21AB$.ToRequestServiceName, ClinicType21AB$.StopCodeSID,
ClinicType21AB$.ToRequestServiceSID,
ClinicType21AB$.PatientLocationSID,ClinicType21AB$.RequestDateTime,ClinicType21AB$.FromLocationSID,
ClinicType21AB$.AttentionToStaffSID,ClinicType21AB$.CPRSStatus,
ClinicType21AB$.FileEntryVistaDate,ClinicType21AB$.ConsultIEN,
ClinicType21AB$.PatientSID,ClinicType21AB$.OrderingInstitutionSID,ClinicType21AB$.RoutingInstitutionSID,ClinicType21AB$.LocationName,ClinicType21AB$.VistaSID1,
ClinicType21AB$.ConsultInitiationDate,ClinicType21AB$.WaitTime,ClinicType21AB$.WaitTimeGT15DaysWoVisit,
ClinicType21AB$.CancelledAppointmentYesNo,ClinicType21AB$.DiscontinuedAppointmentYesNo,
ClinicType21AB$.NextScheduledAppt,ClinicType21AB$.NextSchedLocationName

INTO ClinicType21D$
FROM   (ClinicType21AB$
       LEFT JOIN ClinicType21C$
       ON ClinicType21AB$.ConsultSID = ClinicType21C$.ConsultSID)
       
WHERE ClinicType21C$.PrimaryStopCode IS NULL

GO

/* DO UNION OF ClinicType21C AND ClinicType21D INTO ClinicType21 for composite Next Scheduled Appt entries */

DROP TABLE ClinicType21$ Select ClinicType21C$.STA3N,ClinicType21C$.ConsultSID,ClinicType21C$.PrimaryStopCode,
ClinicType21C$.ToRequestServiceName, ClinicType21C$.StopCodeSID,
ClinicType21C$.ToRequestServiceSID,
ClinicType21C$.PatientLocationSID,ClinicType21C$.RequestDateTime,ClinicType21C$.FromLocationSID,
ClinicType21C$.AttentionToStaffSID,ClinicType21C$.CPRSStatus,
ClinicType21C$.FileEntryVistaDate,ClinicType21C$.ConsultIEN,
ClinicType21C$.PatientSID,ClinicType21C$.OrderingInstitutionSID,ClinicType21C$.RoutingInstitutionSID,ClinicType21C$.LocationName,ClinicType21C$.VistaSID1,
ClinicType21C$.ConsultInitiationDate,ClinicType21C$.WaitTime,ClinicType21C$.WaitTimeGT15DaysWoVisit,
ClinicType21C$.CancelledAppointmentYesNo,ClinicType21C$.DiscontinuedAppointmentYesNo,
ClinicType21C$.NextScheduledAppt,ClinicType21C$.NextSchedLocationName

INTO ClinicType21$
FROM ClinicType21C$ 
UNION
SELECT ClinicType21D$.STA3N,ClinicType21D$.ConsultSID,ClinicType21D$.PrimaryStopCode,
ClinicType21D$.ToRequestServiceName, ClinicType21D$.StopCodeSID,
ClinicType21D$.ToRequestServiceSID,
ClinicType21D$.PatientLocationSID,ClinicType21D$.RequestDateTime,ClinicType21D$.FromLocationSID,
ClinicType21D$.AttentionToStaffSID,ClinicType21D$.CPRSStatus,
ClinicType21D$.FileEntryVistaDate,ClinicType21D$.ConsultIEN,
ClinicType21D$.PatientSID,ClinicType21D$.OrderingInstitutionSID,ClinicType21D$.RoutingInstitutionSID,ClinicType21D$.LocationName,ClinicType21D$.VistaSID1,
ClinicType21D$.ConsultInitiationDate,ClinicType21D$.WaitTime,ClinicType21D$.WaitTimeGT15DaysWoVisit,
ClinicType21D$.CancelledAppointmentYesNo,ClinicType21D$.DiscontinuedAppointmentYesNo,
ClinicType21D$.NextScheduledAppt,ClinicType21D$.NextSchedLocationName
FROM ClinicType21D$


GO

/*DO ADD ROW NUMBER TO BE ABLE TO FIND EARLIEST NEXT SCHEDULED APPT IN FUTURE  FROM ClinicType21 TO ClinicType24A */

USE consults
DROP TABLE ClinicType24A$ SELECT ClinicType21$.STA3N,ClinicType21$.ConsultSID,ClinicType21$.PrimaryStopCode,ClinicTypeStaticMap$.ClinicType,
ClinicType21$.ToRequestServiceName, ClinicType21$.StopCodeSID,
ClinicType21$.ToRequestServiceSID,
ClinicType21$.PatientLocationSID,ClinicType21$.RequestDateTime,ClinicType21$.FromLocationSID,
ClinicType21$.AttentionToStaffSID,ClinicType21$.CPRSStatus,
ClinicType21$.FileEntryVistaDate,ClinicType21$.ConsultIEN,
ClinicType21$.PatientSID,ClinicType21$.OrderingInstitutionSID,ClinicType21$.RoutingInstitutionSID,ClinicType21$.LocationName,ClinicType21$.VistaSID1,
ClinicType21$.ConsultInitiationDate,ClinicType21$.WaitTime,ClinicType21$.WaitTimeGT15DaysWoVisit,
ClinicType21$.CancelledAppointmentYesNo,ClinicType21$.DiscontinuedAppointmentYesNo,ClinicType21$.NextScheduledAppt,ClinicType21$.NextSchedLocationName,
ROW_NUMBER() OVER (partition by ClinicType21$.STA3N,ClinicType21$.ConsultSID,ClinicType21$.PrimaryStopCode ORDER BY ClinicType21$.STA3N,ClinicType21$.ConsultSID,ClinicType21$.PrimaryStopCode,ClinicType21$.NextScheduledAppt ASC) AS ROWNUMBER
INTO ClinicType24A$
FROM ClinicType21$
        JOIN ClinicTypeStaticMap$
           ON ClinicType21$.PrimaryStopCode = ClinicTypeStaticMap$.StopCode
--WHERE ROWNUMBER=1
--GROUP BY ClinicType21$.STA3N,ClinicType21$.ConsultSID,ClinicType21$.PrimaryStopCode,ClinicTypeStaticMap$.ClinicType,ClinicType21$.NextScheduledAppt


GO



/* NEXT CHOOSE ONLY CHOOSE ROW NUMBER 1 AS EARLIEST ELEMENT FOR NEXT SCHEDULED APPT . FROM ClinicType24A TO ClinicType24B */

DROP TABLE ClinicType24B$ SELECT ClinicType24A$.STA3N,ClinicType24A$.ConsultSID,ClinicType24A$.PrimaryStopCode,ClinicType24A$.ClinicType,
ClinicType24A$.ToRequestServiceName, ClinicType24A$.StopCodeSID,
ClinicType24A$.ToRequestServiceSID,
ClinicType24A$.PatientLocationSID,ClinicType24A$.RequestDateTime,ClinicType24A$.FromLocationSID,
ClinicType24A$.AttentionToStaffSID,ClinicType24A$.CPRSStatus,
ClinicType24A$.FileEntryVistaDate,ClinicType24A$.ConsultIEN,
ClinicType24A$.PatientSID,ClinicType24A$.OrderingInstitutionSID,ClinicType24A$.RoutingInstitutionSID,ClinicType24A$.LocationName,ClinicType24A$.VistaSID1,
ClinicType24A$.ConsultInitiationDate,ClinicType24A$.WaitTime,ClinicType24A$.WaitTimeGT15DaysWoVisit,
ClinicType24A$.CancelledAppointmentYesNo,ClinicType24A$.DiscontinuedAppointmentYesNo,ClinicType24A$.NextScheduledAppt,ClinicType24A$.NextSchedLocationName,
ClinicType24A$.ROWNUMBER
INTO ClinicType24B$
FROM ClinicType24A$
   
WHERE ROWNUMBER=1
--GROUP BY ClinicType24A$.STA3N,ClinicType24A$.ConsultSID,ClinicType24A$.NextScheduledAppt


GO


/* NEXT, FIND "ESTABLISHED' OR "NEW" PATIENT STATUS */

/* FIRST REMOVE ROW NUMBER FOR NEXT SCHEDULED APPT . FROM ClinicType24B TO ClinicType24C */

DROP TABLE ClinicType24C$ SELECT ClinicType24B$.STA3N,ClinicType24B$.ConsultSID,ClinicType24B$.PrimaryStopCode,ClinicType24B$.ClinicType,
ClinicType24B$.ToRequestServiceName, ClinicType24B$.StopCodeSID,
ClinicType24B$.ToRequestServiceSID,
ClinicType24B$.PatientLocationSID,ClinicType24B$.RequestDateTime,ClinicType24B$.FromLocationSID,
ClinicType24B$.AttentionToStaffSID,ClinicType24B$.CPRSStatus,
ClinicType24B$.FileEntryVistaDate,ClinicType24B$.ConsultIEN,
ClinicType24B$.PatientSID,ClinicType24B$.OrderingInstitutionSID,ClinicType24B$.RoutingInstitutionSID,ClinicType24B$.LocationName,ClinicType24B$.VistaSID1,
ClinicType24B$.ConsultInitiationDate,ClinicType24B$.WaitTime,ClinicType24B$.WaitTimeGT15DaysWoVisit,
ClinicType24B$.CancelledAppointmentYesNo,ClinicType24B$.DiscontinuedAppointmentYesNo,ClinicType24B$.NextScheduledAppt,ClinicType24B$.NextSchedLocationName
INTO ClinicType24C$
FROM ClinicType24B$


GO

/* NEXT, FUNCTION FOR RETURN ESTABLISHED(1) OR NEW PATIENT (0) STATUS FROM APPTS IN LAST 3 MONTHS OR  */

IF OBJECT_ID (N'dbo.ufnConfirmEstablishedPatient', N'FN') IS NOT NULL
    DROP FUNCTION ufnConfirmEstablishedPatient;
GO
CREATE FUNCTION dbo.ufnConfirmEstablishedPatient(@RequestDateTime datetime,@AppointmentDateTime datetime)
RETURNS datetime
AS 
--- Determine Patient "New" or "Establihed" status 
-- Returns comparison of date ( year, month, day and hours and minutes) for 2 dates passed as 'true' or 'false'
-- if any Appt  found in previous last 90 days return datetime(True (1)) else '' date as False (0))
BEGIN
    DECLARE @ret datetime;
    SET @ret =
    CASE 
        WHEN 
            (@RequestDateTime !='') AND (@AppointmentDateTime<@RequestDateTime) AND (@AppointmentDateTime>=DATEADD(month,-3,@RequestDateTime))
        THEN @AppointmentDateTime
        ELSE ''   
    END
    return @ret 
END;

GO

/* Determine Established(1) or New patient (0) status with function ufnConfiRmEstablishedPatient

   From ClinicType24C to ClinicType24D*/

DROP TABLE ClinicType24D$ SELECT ClinicType24C$.STA3N,ClinicType24C$.ConsultSID,ClinicType24C$.PrimaryStopCode,ClinicType24C$.ClinicType,
ClinicType24C$.ToRequestServiceName,ClinicType24C$.StopCodeSID,
ClinicType24C$.ToRequestServiceSID,
ClinicType24C$.PatientLocationSID,ClinicType24C$.RequestDateTime,ClinicType24C$.FromLocationSID,
ClinicType24C$.AttentionToStaffSID,ClinicType24C$.CPRSStatus,
ClinicType24C$.FileEntryVistaDate,ClinicType24C$.ConsultIEN,
ClinicType24C$.PatientSID,ClinicType24C$.OrderingInstitutionSID,ClinicType24C$.RoutingInstitutionSID,ClinicType24C$.LocationName,ClinicType24C$.VistaSID1,
ClinicType24C$.ConsultInitiationDate,ClinicType24C$.WaitTime,ClinicType24C$.WaitTimeGT15DaysWoVisit,
ClinicType24C$.CancelledAppointmentYesNo,ClinicType24C$.DiscontinuedAppointmentYesNo,ClinicType24C$.NextScheduledAppt,ClinicType24C$.NextSchedLocationName,
1  AS PatientNewEstablish,
dbo.ufnConfirmEstablishedPatient(ClinicType24C$.RequestDateTime,TestAppointment$.AppointmentDateTime) as PatientEstablishDT
                 
INTO ClinicType24D$
FROM (ClinicType24C$ 
                      JOIN
                      TestAppointment$  ON ClinicType24C$.PatientSID =  TestAppointment$.PatientSID
                      JOIN
                      TestLocationDim$  ON TestAppointment$.LocationSID = TestLocationDim$.LocationSID)
WHERE  (TestAppointment$.PatientSID = ClinicType24C$.PatientSID)
       AND (dbo.ufnConfirmEstablishedPatient(ClinicType24C$.RequestDateTime,TestAppointment$.AppointmentDateTime)!='')
       AND ((TestAppointment$.AppointmentDateTime<ClinicType24C$.RequestDateTime) AND (TestAppointment$.AppointmentDateTime>=DATEADD(month,-3,ClinicType24C$.RequestDateTime)))
       AND (((TestLocationDim$.PrimaryStopCodeIEN >499) AND (TestLocationDim$.PrimaryStopCodeIEN <600))OR ((TestLocationDim$.PrimaryStopCodeIEN >210) AND (TestLocationDim$.PrimaryStopCodeIEN <231)))
      
   

GO

/*  ORDER BY PatientEstablishDT   FROM ClinicType24D TO ClinicType24E*/

DROP TABLE ClinicType24E$ SELECT ClinicType24D$.STA3N,ClinicType24D$.ConsultSID,ClinicType24D$.PrimaryStopCode,ClinicType24D$.ClinicType,
ClinicType24D$.ToRequestServiceName, ClinicType24D$.StopCodeSID,
ClinicType24D$.ToRequestServiceSID,
ClinicType24D$.PatientLocationSID,ClinicType24D$.RequestDateTime,ClinicType24D$.FromLocationSID,
ClinicType24D$.AttentionToStaffSID,ClinicType24D$.CPRSStatus,
ClinicType24D$.FileEntryVistaDate,ClinicType24D$.ConsultIEN,
ClinicType24D$.PatientSID,ClinicType24D$.OrderingInstitutionSID,ClinicType24D$.RoutingInstitutionSID,ClinicType24D$.LocationName,ClinicType24D$.VistaSID1,
ClinicType24D$.ConsultInitiationDate,ClinicType24D$.WaitTime,ClinicType24D$.WaitTimeGT15DaysWoVisit,
ClinicType24D$.CancelledAppointmentYesNo,ClinicType24D$.DiscontinuedAppointmentYesNo,
ClinicType24D$.NextScheduledAppt,ClinicType24D$.NextSchedLocationName,ClinicType24D$.PatientNewEstablish,ClinicType24D$.PatientEstablishDT
                      
INTO ClinicType24E$
FROM ClinicType24D$ 
ORDER BY ClinicType24D$.STA3N,ClinicType24D$.ConsultSID,ClinicType24D$.PrimaryStopCode,ClinicType24D$.PatientEstablishDT

GO

/* ADD A "NULLED" PatientEstablishDT, and 0 PatientNewEstablish as  TO WHOLE LIST ClinicType24C TO MAKE ClinicType24DD */

DROP TABLE ClinicType24DD$ SELECT ClinicType24C$.STA3N,ClinicType24C$.ConsultSID,ClinicType24C$.PrimaryStopCode,ClinicType24C$.ClinicType,
ClinicType24C$.ToRequestServiceName, ClinicType24C$.StopCodeSID,
ClinicType24C$.ToRequestServiceSID,
ClinicType24C$.PatientLocationSID,ClinicType24C$.RequestDateTime,ClinicType24C$.FromLocationSID,
ClinicType24C$.AttentionToStaffSID,ClinicType24C$.CPRSStatus,
ClinicType24C$.FileEntryVistaDate,ClinicType24C$.ConsultIEN,
ClinicType24C$.PatientSID,ClinicType24C$.OrderingInstitutionSID,ClinicType24C$.RoutingInstitutionSID,ClinicType24C$.LocationName,ClinicType24C$.VistaSID1,
ClinicType24C$.ConsultInitiationDate,ClinicType24C$.WaitTime,ClinicType24C$.WaitTimeGT15DaysWoVisit,
ClinicType24C$.CancelledAppointmentYesNo,ClinicType24C$.DiscontinuedAppointmentYesNo,ClinicType24C$.NextScheduledAppt,ClinicType24C$.NextSchedLocationName,
0 AS PatientNewEstablish,NULL AS PatientEstablishDT
                      
INTO ClinicType24DD$
FROM ClinicType24C$ 

GO

/*DO ORDER BY TO MAKE ClinicType24EE */

DROP TABLE ClinicType24EE$ SELECT ClinicType24DD$.STA3N,ClinicType24DD$.ConsultSID,ClinicType24DD$.PrimaryStopCode,ClinicType24DD$.ClinicType,
ClinicType24DD$.ToRequestServiceName, ClinicType24DD$.StopCodeSID,
ClinicType24DD$.ToRequestServiceSID,
ClinicType24DD$.PatientLocationSID,ClinicType24DD$.RequestDateTime,ClinicType24DD$.FromLocationSID,
ClinicType24DD$.AttentionToStaffSID,ClinicType24DD$.CPRSStatus,
ClinicType24DD$.FileEntryVistaDate,ClinicType24DD$.ConsultIEN,
ClinicType24DD$.PatientSID,ClinicType24DD$.OrderingInstitutionSID,ClinicType24DD$.RoutingInstitutionSID,ClinicType24DD$.LocationName,ClinicType24DD$.VistaSID1,
ClinicType24DD$.ConsultInitiationDate,ClinicType24DD$.WaitTime,ClinicType24DD$.WaitTimeGT15DaysWoVisit,
ClinicType24DD$.CancelledAppointmentYesNo,ClinicType24DD$.DiscontinuedAppointmentYesNo,
ClinicType24DD$.NextScheduledAppt,ClinicType24DD$.NextSchedLocationName,ClinicType24DD$.PatientNewEstablish,ClinicType24DD$.PatientEstablishDT
                      
INTO ClinicType24EE$
FROM ClinicType24DD$ 
ORDER BY ClinicType24DD$.STA3N,ClinicType24DD$.ConsultSID,ClinicType24DD$.PrimaryStopCode,ClinicType24DD$.PatientEstablishDT

GO
/*NEXT DO LEFT JOIN OF ClinicType24EE WITH ClinicType24E INTO ClinicType24FF FOR EXCLUDED CONSULT entries  with PatientEstablishDT*/


DROP TABLE ClinicType24FF$ Select ClinicType24EE$.STA3N,ClinicType24EE$.ConsultSID,ClinicType24EE$.PrimaryStopCode,ClinicType24EE$.ClinicType,
ClinicType24EE$.ToRequestServiceName, ClinicType24EE$.StopCodeSID,
ClinicType24EE$.ToRequestServiceSID,
ClinicType24EE$.PatientLocationSID,ClinicType24EE$.RequestDateTime,ClinicType24EE$.FromLocationSID,
ClinicType24EE$.AttentionToStaffSID,ClinicType24EE$.CPRSStatus,
ClinicType24EE$.FileEntryVistaDate,ClinicType24EE$.ConsultIEN,
ClinicType24EE$.PatientSID,ClinicType24EE$.OrderingInstitutionSID,ClinicType24EE$.RoutingInstitutionSID,ClinicType24EE$.LocationName,ClinicType24EE$.VistaSID1,
ClinicType24EE$.ConsultInitiationDate,ClinicType24EE$.WaitTime,ClinicType24EE$.WaitTimeGT15DaysWoVisit,
ClinicType24EE$.CancelledAppointmentYesNo,ClinicType24EE$.DiscontinuedAppointmentYesNo,
ClinicType24EE$.NextScheduledAppt,ClinicType24EE$.NextSchedLocationName,ClinicType24EE$.PatientNewEstablish,ClinicType24EE$.PatientEstablishDT

INTO ClinicType24FF$
FROM   (ClinicType24EE$
       LEFT JOIN ClinicType24E$
       ON ClinicType24EE$.ConsultSID = ClinicType24E$.ConsultSID)
       
WHERE ClinicType24E$.ConsultSID IS NULL

GO
/* DO UNION OF ClinicType24FF AND ClinicType24E INTO ClinicType24GG*/

DROP TABLE ClinicType24GG$ Select ClinicType24FF$.STA3N,ClinicType24FF$.ConsultSID,ClinicType24FF$.PrimaryStopCode,ClinicType24FF$.ClinicType,
ClinicType24FF$.ToRequestServiceName, ClinicType24FF$.StopCodeSID,
ClinicType24FF$.ToRequestServiceSID,
ClinicType24FF$.PatientLocationSID,ClinicType24FF$.RequestDateTime,ClinicType24FF$.FromLocationSID,
ClinicType24FF$.AttentionToStaffSID,ClinicType24FF$.CPRSStatus,
ClinicType24FF$.FileEntryVistaDate,ClinicType24FF$.ConsultIEN,
ClinicType24FF$.PatientSID,ClinicType24FF$.OrderingInstitutionSID,ClinicType24FF$.RoutingInstitutionSID,ClinicType24FF$.LocationName,ClinicType24FF$.VistaSID1,
ClinicType24FF$.ConsultInitiationDate,ClinicType24FF$.WaitTime,ClinicType24FF$.WaitTimeGT15DaysWoVisit,
ClinicType24FF$.CancelledAppointmentYesNo,ClinicType24FF$.DiscontinuedAppointmentYesNo,
ClinicType24FF$.NextScheduledAppt,ClinicType24FF$.NextSchedLocationName,ClinicType24FF$.PatientNewEstablish,ClinicType24FF$.PatientEstablishDT

INTO ClinicType24GG$
FROM ClinicType24FF$ 
UNION
SELECT ClinicType24E$.STA3N,ClinicType24E$.ConsultSID,ClinicType24E$.PrimaryStopCode,ClinicType24E$.ClinicType,
ClinicType24E$.ToRequestServiceName, ClinicType24E$.StopCodeSID,
ClinicType24E$.ToRequestServiceSID,
ClinicType24E$.PatientLocationSID,ClinicType24E$.RequestDateTime,ClinicType24E$.FromLocationSID,
ClinicType24E$.AttentionToStaffSID,ClinicType24E$.CPRSStatus,
ClinicType24E$.FileEntryVistaDate,ClinicType24E$.ConsultIEN,
ClinicType24E$.PatientSID,ClinicType24E$.OrderingInstitutionSID,ClinicType24E$.RoutingInstitutionSID,ClinicType24E$.LocationName,ClinicType24E$.VistaSID1,
ClinicType24E$.ConsultInitiationDate,ClinicType24E$.WaitTime,ClinicType24E$.WaitTimeGT15DaysWoVisit,
ClinicType24E$.CancelledAppointmentYesNo,ClinicType24E$.DiscontinuedAppointmentYesNo,
ClinicType24E$.NextScheduledAppt,ClinicType24E$.NextSchedLocationName,ClinicType24E$.PatientNewEstablish,ClinicType24E$.PatientEstablishDT

FROM ClinicType24E$


GO

/*DO ADD ROW NUMBER FOR PATIENT NEW/ESTABLISED Status ,BE ABLE TO FIND EARLIEST PREVIOUS SCHEDULED APPT IN PAST. 
TAKE FROM ClinicType24GG INTO ClinicType24HH */

USE consults
DROP TABLE ClinicType24HH$ SELECT ClinicType24GG$.STA3N,ClinicType24GG$.ConsultSID,ClinicType24GG$.PrimaryStopCode,ClinicType24GG$.ClinicType,
ClinicType24GG$.ToRequestServiceName, ClinicType24GG$.StopCodeSID,
ClinicType24GG$.ToRequestServiceSID,
ClinicType24GG$.PatientLocationSID,ClinicType24GG$.RequestDateTime,ClinicType24GG$.FromLocationSID,
ClinicType24GG$.AttentionToStaffSID,ClinicType24GG$.CPRSStatus,
ClinicType24GG$.FileEntryVistaDate,ClinicType24GG$.ConsultIEN,
ClinicType24GG$.PatientSID,ClinicType24GG$.OrderingInstitutionSID,ClinicType24GG$.RoutingInstitutionSID,ClinicType24GG$.LocationName,ClinicType24GG$.VistaSID1,
ClinicType24GG$.ConsultInitiationDate,ClinicType24GG$.WaitTime,ClinicType24GG$.WaitTimeGT15DaysWoVisit,
ClinicType24GG$.CancelledAppointmentYesNo,ClinicType24GG$.DiscontinuedAppointmentYesNo,ClinicType24GG$.NextScheduledAppt,ClinicType24GG$.NextSchedLocationName,
ClinicType24GG$.PatientNewEstablish,ClinicType24GG$.PatientEstablishDT,
ROW_NUMBER() OVER (partition by ClinicType24GG$.STA3N,ClinicType24GG$.ConsultSID,ClinicType24GG$.PrimaryStopCode ORDER BY ClinicType24GG$.STA3N,ClinicType24GG$.ConsultSID,
ClinicType24GG$.PrimaryStopCode,ClinicType24GG$.PatientEstablishDT ASC) AS ROWNUMBER
INTO ClinicType24HH$
FROM ClinicType24GG$
--WHERE ROWNUMBER=1
--GROUP BY ClinicType21$.STA3N,ClinicType21$.ConsultSID,ClinicType21$.PrimaryStopCode,ClinicTypeStaticMap$.ClinicType,ClinicType21$.NextScheduledAppt

GO
/* NEXT FOR NEW/STABLISHED PATIENT Status, ONLY CHOOSE ROW NUMBER 1 AS EARLIEST ELEMENT FOR PREVIOUS SCHEDULED APPT . FROM ClinicType24HH TO ClinicType24 */

DROP TABLE ClinicType24II$ SELECT ClinicType24HH$.STA3N,ClinicType24HH$.ConsultSID,ClinicType24HH$.PrimaryStopCode,ClinicType24HH$.ClinicType,
ClinicType24HH$.ToRequestServiceName, ClinicType24HH$.StopCodeSID,
ClinicType24HH$.ToRequestServiceSID,
ClinicType24HH$.PatientLocationSID,ClinicType24HH$.RequestDateTime,ClinicType24HH$.FromLocationSID,
ClinicType24HH$.AttentionToStaffSID,ClinicType24HH$.CPRSStatus,
ClinicType24HH$.FileEntryVistaDate,ClinicType24HH$.ConsultIEN,
ClinicType24HH$.PatientSID,ClinicType24HH$.OrderingInstitutionSID,ClinicType24HH$.RoutingInstitutionSID,ClinicType24HH$.LocationName,ClinicType24HH$.VistaSID1,
ClinicType24HH$.ConsultInitiationDate,ClinicType24HH$.WaitTime,ClinicType24HH$.WaitTimeGT15DaysWoVisit,
ClinicType24HH$.CancelledAppointmentYesNo,ClinicType24HH$.DiscontinuedAppointmentYesNo,ClinicType24HH$.NextScheduledAppt,ClinicType24HH$.NextSchedLocationName,
ClinicType24HH$.PatientNewEstablish,ClinicType24HH$.PatientEstablishDT,
ClinicType24HH$.ROWNUMBER
INTO ClinicType24II$
FROM ClinicType24HH$
   
WHERE ROWNUMBER=1
/*ORDER BY ClinicType24HH$.STA3N,ClinicType24HH$.ConsultSID,ClinicType24HH$.PrimaryStopCode*/

GO

/* NEXT ORDER FROM ClinicType24II TO ClinicType24 */

DROP TABLE ClinicType24$ SELECT ClinicType24II$.STA3N,ClinicType24II$.ConsultSID,ClinicType24II$.PrimaryStopCode,ClinicType24II$.ClinicType,
ClinicType24II$.ToRequestServiceName, ClinicType24II$.StopCodeSID,
ClinicType24II$.ToRequestServiceSID,
ClinicType24II$.PatientLocationSID,ClinicType24II$.RequestDateTime,ClinicType24II$.FromLocationSID,
ClinicType24II$.AttentionToStaffSID,ClinicType24II$.CPRSStatus,
ClinicType24II$.FileEntryVistaDate,ClinicType24II$.ConsultIEN,
ClinicType24II$.PatientSID,ClinicType24II$.OrderingInstitutionSID,ClinicType24II$.RoutingInstitutionSID,ClinicType24II$.LocationName,ClinicType24II$.VistaSID1,
ClinicType24II$.ConsultInitiationDate,ClinicType24II$.WaitTime,ClinicType24II$.WaitTimeGT15DaysWoVisit,
ClinicType24II$.CancelledAppointmentYesNo,ClinicType24II$.DiscontinuedAppointmentYesNo,ClinicType24II$.NextScheduledAppt,ClinicType24II$.NextSchedLocationName,
ClinicType24II$.PatientNewEstablish,ClinicType24II$.PatientEstablishDT
/*ClinicType24HH$.ROWNUMBER*/
INTO ClinicType24$
FROM ClinicType24II$
ORDER BY ClinicType24II$.STA3N,ClinicType24II$.ConsultSID,ClinicType24II$.PrimaryStopCode
GO

