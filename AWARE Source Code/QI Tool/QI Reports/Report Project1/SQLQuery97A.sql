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

DROP TABLE ClinicType5$ SELECT DISTINCT   Consult$.ConsultSID,Consult$.STA3N,Consult$.PatientLocationSID, Consult$.RequestDateTime, Consult$.FromLocationSID, 
                      Consult$.ToRequestServiceName, Consult$.AttentionToStaffSID, Consult$.CPRSStatus, TestInstitutionDIM$.InstitutionIEN, Consult$.FileEntryVistaDate,
                      Consult$.ConsultIEN ,TestInstitutionDIM$.InstitutionName,Consult$.ToRequestServiceSID,Consult$.PatientSID,
                      TestOutpatientEncounter$.VisitVistaDate,TestOutpatientEncounter$.PrimaryStopCode,TestLocationDim$.LocationName,
                      TestOutpatientEncounter$.Sta3n1,TestOutpatientEncounter$.PrimaryStopCodeSID,TestAssociatedStopCodes$.StopCodeSID,
                      TestStopCOdeDim$.StopCodeName,TestAppointment$.VisitSID,TestAppointment$.LocationSID,TestAppointment$.AppointmentDateTime,
                      TestOutpatientEncounter$.VisitCreatedDate,Consult$.OrderingInstitutionSID,Consult$.RoutingInstitutionSID
                      
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

DROP TABLE ClinicType22$ SELECT DISTINCT ClinicType5$.STA3N,ClinicType5$.ConsultSID,ClinicType5$.PrimaryStopCode,
                      ClinicType5$.PatientLocationSID, ClinicType5$.RequestDateTime, ClinicType5$.FromLocationSID, 
                      ClinicType5$.ToRequestServiceName, ClinicType5$.AttentionToStaffSID, ClinicType5$.CPRSStatus,
                      ClinicType5$.InstitutionIEN, ClinicType5$.FileEntryVistaDate,
                      ClinicType5$.ConsultIEN ,ClinicType5$.InstitutionName,ClinicType5$.ToRequestServiceSID,
                      ClinicType5$.PatientSID,
                      ClinicType5$.VisitVistaDate,ClinicType5$.LocationName,
                      ClinicType5$.Sta3n1,ClinicType5$.PrimaryStopCodeSID,ClinicType5$.StopCodeSID,
                      ClinicType5$.StopCodeName,ClinicType5$.VisitSID,ClinicType5$.LocationSID,ClinicType5$.AppointmentDateTime,
                      ClinicType5$.VisitCreatedDate,ClinicType5$.OrderingInstitutionSID,ClinicType5$.RoutingInstitutionSID
INTO  ClinicType22$
FROM  ClinicType5$

GO
IF OBJECT_ID (N'dbo.ufnConfirmVistaDateSameAsDateTime', N'FN') IS NOT NULL
    DROP FUNCTION ufnConfirmVistaDateSameAsDateTime;
GO
CREATE FUNCTION dbo.ufnConfirmVistaDateSameAsDateTime(@VisitVistaDate float,@AppointmentDateTime datetime)
RETURNS int
AS 
-- Returns comparison of date ( year, month, day and hours and minutes) for 2 dates passed as 'true' or 'false'
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
/*replace OLD sql 37A . NOW SQL 8A WITH SQL 7 above AS FUNCTION ConfirmHourMinute(vista date tiem, appointdatetime) ret int*/
DROP TABLE ClinicType23$ SELECT DISTINCT   ClinicType22$.ConsultSID,ClinicType22$.STA3N,ClinicType22$.PatientLocationSID, ClinicType22$.RequestDateTime, ClinicType22$.FromLocationSID, 
                      ClinicType22$.ToRequestServiceName, ClinicType22$.AttentionToStaffSID, ClinicType22$.CPRSStatus, ClinicType22$.InstitutionIEN, ClinicType22$.FileEntryVistaDate,
                      ClinicType22$.ConsultIEN ,ClinicType22$.InstitutionName,ClinicType22$.ToRequestServiceSID,ClinicType22$.PatientSID,
                      ClinicType22$.VisitVistaDate,ClinicType22$.PrimaryStopCode,ClinicType22$.LocationName,
                      ClinicType22$.Sta3n1,ClinicType22$.PrimaryStopCodeSID,ClinicType22$.StopCodeSID,
                      ClinicType22$.StopCodeName,ClinicType22$.VisitSID,ClinicType22$.LocationSID,ClinicType22$.AppointmentDateTime,
                      ClinicType22$.VisitCreatedDate,ClinicType22$.OrderingInstitutionSID,ClinicType22$.RoutingInstitutionSID
                      
INTO ClinicType23$
FROM          ClinicType22$
                       
WHERE (dbo.ufnConfirmVistaDateSameAsDateTime(ClinicType22$.VisitVistaDate,ClinicType22$.AppointmentDateTime)=1) and(SUBSTRING(ClinicType22$.LocationName,1,1)!='Z') 


GO

DROP TABLE ClinicType18$ SELECT DISTINCT   ClinicType8$.STA3N,ClinicType8$.ConsultSID,ClinicType8$.PatientLocationSID, ClinicType8$.RequestDateTime, ClinicType8$.FromLocationSID, 
                      ClinicType8$.ToRequestServiceName, ClinicType8$.AttentionToStaffSID, ClinicType8$.CPRSStatus, TestInstitutionDIM$.InstitutionIEN, ClinicType8$.FileEntryVistaDate,
                      ClinicType8$.ConsultIEN ,TestInstitutionDIM$.InstitutionName,ClinicType8$.ToRequestServiceSID,ClinicType8$.PatientSID,ClinicType8$.OrderingInstitutionSID,
                      ClinicType8$.RoutingInstitutionSID
                      
INTO ClinicType18$
FROM          (ClinicType8$ 
                        JOIN
                      TestInstitutionDIM$ ON ClinicType8$.OrderingInstitutionSID = TestInstitutionDIM$.InstitutionSID)
                      
WHERE  (ClinicType8$.ToRequestServiceName LIKE '%MH%' OR ClinicType8$.ToRequestServiceName LIKE '%MENTAL%' OR ClinicType8$.ToRequestServiceName LIKE '%PSY%') 


GO


DROP TABLE ClinicType19$ SELECT ClinicType18$.STA3N,ClinicType18$.ConsultSID,ClinicType18$.ToRequestServiceSID,
ClinicType18$.ToRequestServiceName,
ClinicType18$.PatientLocationSID,ClinicType18$.RequestDateTime,ClinicType18$.FromLocationSID,
ClinicType18$.AttentionToStaffSID,ClinicType18$.CPRSStatus,
ClinicType18$.FileEntryVistaDate,ClinicType18$.ConsultIEN,
ClinicType18$.PatientSID,ClinicType18$.OrderingInstitutionSID,ClinicType18$.RoutingInstitutionSID

INTO ClinicType19$
FROM   (ClinicType18$
       LEFT JOIN ClinicType7$
       ON ClinicType18$.ConsultSID = ClinicType7$.ConsultSID)
       
WHERE ClinicType7$.PrimaryStopCode IS NULL

GO



DROP TABLE ClinicType20$ select cc.STA3N,cc.consultSID,da.StopCode,cc.ToRequestServiceName, da.StopCodeSID,
ll.PrimaryStopCode as ReferringPrimaryStopCode,
ll.SecondaryStopCode as ReferringSecondaryStopCode,cc.ToRequestServiceSID,
cc.PatientLocationSID,cc.RequestDateTime,cc.FromLocationSID,
cc.AttentionToStaffSID,cc.CPRSStatus,
cc.FileEntryVistaDate,cc.ConsultIEN,
cc.PatientSID,cc.OrderingInstitutionSID,cc.RoutingInstitutionSID
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
      ,[OrderingInstitutionSID]
      ,[RoutingInstitutionSID]
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

DROP TABLE ClinicType26$ SELECT [ConsultSID]
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
  INTO [consults].[dbo].ClinicType26$
  FROM [consults].[dbo].[ClinicType23$]

GO

DECLARE @EMPTY1 varchar(30) = '@NULL'
DECLARE @EMPTY2 varchar(30) = '@NULL'
DROP TABLE ClinicType21$ SELECT l26.STA3N, l26.ConsultSID,l26.PrimaryStopCode,
l26.ToRequestServiceName,l26.StopCodeSID,
l26.ToRequestServiceSID,l26.PatientLocationSID,l26.RequestDateTime,l26.FromLocationSID,l26.AttentionToStaffSID,
l26.CPRSStatus,l26.FileEntryVistaDate,l26.ConsultIEN,
l26.PatientSID,l26.OrderingInstitutionSID,l26.RoutingInstitutionSID,
l26.ConsultInitiationDate,l26.WaitTime,l26.WaitTimeGT15DaysWoVisit,l26.CancelledAppointmentYesNo,l26.DiscontinuedAppointmentYesNo

INTO ClinicType21$
FROM ClinicType26$ as l26
UNION
SELECT ClinicType25$.STA3N,ClinicType25$.ConsultSID,ClinicType25$.StopCode,
ClinicType25$.ToRequestServiceName, ClinicType25$.StopCodeSID,
ClinicType25$.ToRequestServiceSID,
ClinicType25$.PatientLocationSID,ClinicType25$.RequestDateTime,ClinicType25$.FromLocationSID,
ClinicType25$.AttentionToStaffSID,ClinicType25$.CPRSStatus,
ClinicType25$.FileEntryVistaDate,ClinicType25$.ConsultIEN,
ClinicType25$.PatientSID,ClinicType25$.OrderingInstitutionSID,ClinicType25$.RoutingInstitutionSID,
ClinicType25$.ConsultInitiationDate,ClinicType25$.WaitTime,ClinicType25$.WaitTimeGT15DaysWoVisit,
ClinicType25$.CancelledAppointmentYesNo,ClinicType25$.DiscontinuedAppointmentYesNo
FROM ClinicType25$

ORDER BY 2;

GO


DROP TABLE ClinicType24$ SELECT ClinicType21$.STA3N,ClinicType21$.ConsultSID,ClinicType21$.PrimaryStopCode,ClinicTypeStaticMap$.ClinicType,
ClinicType21$.ToRequestServiceName, ClinicType21$.StopCodeSID,
ClinicType21$.ToRequestServiceSID,
ClinicType21$.PatientLocationSID,ClinicType21$.RequestDateTime,ClinicType21$.FromLocationSID,
ClinicType21$.AttentionToStaffSID,ClinicType21$.CPRSStatus,
ClinicType21$.FileEntryVistaDate,ClinicType21$.ConsultIEN,
ClinicType21$.PatientSID,ClinicType21$.OrderingInstitutionSID,ClinicType21$.RoutingInstitutionSID,
ClinicType21$.ConsultInitiationDate,ClinicType21$.WaitTime,ClinicType21$.WaitTimeGT15DaysWoVisit,
ClinicType21$.CancelledAppointmentYesNo,ClinicType21$.DiscontinuedAppointmentYesNo
INTO ClinicType24$
FROM ClinicType21$
JOIN ClinicTypeStaticMap$
     ON ClinicType21$.PrimaryStopCode = ClinicTypeStaticMap$.StopCode
ORDER BY ClinicType21$.STA3N










