
DROP TABLE ClinicType19$ SELECT ClinicType18$.STA3N,ClinicType18$.ConsultSID,ClinicType18$.ToRequestServiceSID,
ClinicType18$.ToRequestServiceName,
ClinicType18$.PatientLocationSID,ClinicType18$.RequestDateTime,ClinicType18$.FromLocationSID,
ClinicType18$.AttentionToStaffSID,ClinicType18$.CPRSStatus,
ClinicType18$.FileEntryVistaDate,ClinicType18$.ConsultIEN,
ClinicType18$.PatientSID,ClinicType18$.OrderingInstitutionSID,ClinicType18$.RoutingInstitutionSID

INTO ClinicType19$
FROM   (ClinicType18$
       LEFT JOIN ClinicType23$
       ON ClinicType18$.ConsultSID = ClinicType23$.ConsultSID)
       
WHERE ClinicType23$.PrimaryStopCode IS NULL

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
DROP TABLE ClinicType21A$ SELECT l26.STA3N, l26.ConsultSID,l26.PrimaryStopCode,
l26.ToRequestServiceName,l26.StopCodeSID,
l26.ToRequestServiceSID,l26.PatientLocationSID,l26.RequestDateTime,l26.FromLocationSID,l26.AttentionToStaffSID,
l26.CPRSStatus,l26.FileEntryVistaDate,l26.ConsultIEN,
l26.PatientSID,l26.OrderingInstitutionSID,l26.RoutingInstitutionSID,
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
ClinicType25$.PatientSID,ClinicType25$.OrderingInstitutionSID,ClinicType25$.RoutingInstitutionSID,
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
-- if any outpatient encounter  found in next 90 days return DateTime
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


DROP TABLE ClinicType21B$ SELECT ClinicType21A$.STA3N,ClinicType21A$.ConsultSID,ClinicType21A$.PrimaryStopCode,
ClinicType21A$.ToRequestServiceName, ClinicType21A$.StopCodeSID,
ClinicType21A$.ToRequestServiceSID,
ClinicType21A$.PatientLocationSID,ClinicType21A$.RequestDateTime,ClinicType21A$.FromLocationSID,
ClinicType21A$.AttentionToStaffSID,ClinicType21A$.CPRSStatus,
ClinicType21A$.FileEntryVistaDate,ClinicType21A$.ConsultIEN,
ClinicType21A$.PatientSID,ClinicType21A$.OrderingInstitutionSID,ClinicType21A$.RoutingInstitutionSID,
ClinicType21A$.ConsultInitiationDate,ClinicType21A$.WaitTime,ClinicType21A$.WaitTimeGT15DaysWoVisit,
ClinicType21A$.CancelledAppointmentYesNo,ClinicType21A$.DiscontinuedAppointmentYesNo,
dbo.ufnNextScheduledAppt(ClinicType21A$.ConsultInitiationDate,TestAppointment$.AppointmentDateTime,ClinicType21A$.RequestDateTime)as NextScheduledAppt
                      
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

DROP TABLE ClinicType21C$ SELECT ClinicType21B$.STA3N,ClinicType21B$.ConsultSID,ClinicType21B$.PrimaryStopCode,
ClinicType21B$.ToRequestServiceName, ClinicType21B$.StopCodeSID,
ClinicType21B$.ToRequestServiceSID,
ClinicType21B$.PatientLocationSID,ClinicType21B$.RequestDateTime,ClinicType21B$.FromLocationSID,
ClinicType21B$.AttentionToStaffSID,ClinicType21B$.CPRSStatus,
ClinicType21B$.FileEntryVistaDate,ClinicType21B$.ConsultIEN,
ClinicType21B$.PatientSID,ClinicType21B$.OrderingInstitutionSID,ClinicType21B$.RoutingInstitutionSID,
ClinicType21B$.ConsultInitiationDate,ClinicType21B$.WaitTime,ClinicType21B$.WaitTimeGT15DaysWoVisit,
ClinicType21B$.CancelledAppointmentYesNo,ClinicType21B$.DiscontinuedAppointmentYesNo,
ClinicType21B$.NextScheduledAppt
                      
INTO ClinicType21C$
FROM ClinicType21B$ 
ORDER BY ClinicType21B$.STA3N,ClinicType21B$.ConsultSID,ClinicType21B$.PrimaryStopCode,ClinicType21B$.NextScheduledAppt

GO

/* ADD NULL NEXT SCHEDULED APPT TO WHOLE LIST ClinicType21A TO MAKE ClinicType21AA */

DROP TABLE ClinicType21AA$ SELECT ClinicType21A$.STA3N,ClinicType21A$.ConsultSID,ClinicType21A$.PrimaryStopCode,
ClinicType21A$.ToRequestServiceName, ClinicType21A$.StopCodeSID,
ClinicType21A$.ToRequestServiceSID,
ClinicType21A$.PatientLocationSID,ClinicType21A$.RequestDateTime,ClinicType21A$.FromLocationSID,
ClinicType21A$.AttentionToStaffSID,ClinicType21A$.CPRSStatus,
ClinicType21A$.FileEntryVistaDate,ClinicType21A$.ConsultIEN,
ClinicType21A$.PatientSID,ClinicType21A$.OrderingInstitutionSID,ClinicType21A$.RoutingInstitutionSID,
ClinicType21A$.ConsultInitiationDate,ClinicType21A$.WaitTime,ClinicType21A$.WaitTimeGT15DaysWoVisit,
ClinicType21A$.CancelledAppointmentYesNo,ClinicType21A$.DiscontinuedAppointmentYesNo,
NULL AS NextScheduledAppt
                      
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
ClinicType21AA$.PatientSID,ClinicType21AA$.OrderingInstitutionSID,ClinicType21AA$.RoutingInstitutionSID,
ClinicType21AA$.ConsultInitiationDate,ClinicType21AA$.WaitTime,ClinicType21AA$.WaitTimeGT15DaysWoVisit,
ClinicType21AA$.CancelledAppointmentYesNo,ClinicType21AA$.DiscontinuedAppointmentYesNo,
ClinicType21AA$.NextScheduledAppt
                      
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
ClinicType21AB$.PatientSID,ClinicType21AB$.OrderingInstitutionSID,ClinicType21AB$.RoutingInstitutionSID,
ClinicType21AB$.ConsultInitiationDate,ClinicType21AB$.WaitTime,ClinicType21AB$.WaitTimeGT15DaysWoVisit,
ClinicType21AB$.CancelledAppointmentYesNo,ClinicType21AB$.DiscontinuedAppointmentYesNo,
ClinicType21AB$.NextScheduledAppt

INTO ClinicType21D$
FROM   (ClinicType21AB$
       LEFT JOIN ClinicType21C$
       ON ClinicType21AB$.ConsultSID = ClinicType21C$.ConsultSID)
       
WHERE ClinicType21C$.PrimaryStopCode IS NULL

GO
/* DO UNION OF ClinicType21C AND ClinicType21D INTO ClinicType21 */

DROP TABLE ClinicType21$ Select ClinicType21C$.STA3N,ClinicType21C$.ConsultSID,ClinicType21C$.PrimaryStopCode,
ClinicType21C$.ToRequestServiceName, ClinicType21C$.StopCodeSID,
ClinicType21C$.ToRequestServiceSID,
ClinicType21C$.PatientLocationSID,ClinicType21C$.RequestDateTime,ClinicType21C$.FromLocationSID,
ClinicType21C$.AttentionToStaffSID,ClinicType21C$.CPRSStatus,
ClinicType21C$.FileEntryVistaDate,ClinicType21C$.ConsultIEN,
ClinicType21C$.PatientSID,ClinicType21C$.OrderingInstitutionSID,ClinicType21C$.RoutingInstitutionSID,
ClinicType21C$.ConsultInitiationDate,ClinicType21C$.WaitTime,ClinicType21C$.WaitTimeGT15DaysWoVisit,
ClinicType21C$.CancelledAppointmentYesNo,ClinicType21C$.DiscontinuedAppointmentYesNo,
ClinicType21C$.NextScheduledAppt

INTO ClinicType21$
FROM ClinicType21C$ 
UNION
SELECT ClinicType21D$.STA3N,ClinicType21D$.ConsultSID,ClinicType21D$.PrimaryStopCode,
ClinicType21D$.ToRequestServiceName, ClinicType21D$.StopCodeSID,
ClinicType21D$.ToRequestServiceSID,
ClinicType21D$.PatientLocationSID,ClinicType21D$.RequestDateTime,ClinicType21D$.FromLocationSID,
ClinicType21D$.AttentionToStaffSID,ClinicType21D$.CPRSStatus,
ClinicType21D$.FileEntryVistaDate,ClinicType21D$.ConsultIEN,
ClinicType21D$.PatientSID,ClinicType21D$.OrderingInstitutionSID,ClinicType21D$.RoutingInstitutionSID,
ClinicType21D$.ConsultInitiationDate,ClinicType21D$.WaitTime,ClinicType21D$.WaitTimeGT15DaysWoVisit,
ClinicType21D$.CancelledAppointmentYesNo,ClinicType21D$.DiscontinuedAppointmentYesNo,
ClinicType21D$.NextScheduledAppt
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
ClinicType21$.PatientSID,ClinicType21$.OrderingInstitutionSID,ClinicType21$.RoutingInstitutionSID,
ClinicType21$.ConsultInitiationDate,ClinicType21$.WaitTime,ClinicType21$.WaitTimeGT15DaysWoVisit,
ClinicType21$.CancelledAppointmentYesNo,ClinicType21$.DiscontinuedAppointmentYesNo,ClinicType21$.NextScheduledAppt,
ROW_NUMBER() OVER (partition by ClinicType21$.STA3N,ClinicType21$.ConsultSID,ClinicType21$.PrimaryStopCode ORDER BY ClinicType21$.STA3N,ClinicType21$.ConsultSID,ClinicType21$.PrimaryStopCode,ClinicType21$.NextScheduledAppt ASC) AS ROWNUMBER
INTO ClinicType24A$
FROM ClinicType21$
        JOIN ClinicTypeStaticMap$
           ON ClinicType21$.PrimaryStopCode = ClinicTypeStaticMap$.StopCode
--WHERE ROWNUMBER=1
--GROUP BY ClinicType21$.STA3N,ClinicType21$.ConsultSID,ClinicType21$.PrimaryStopCode,ClinicTypeStaticMap$.ClinicType,ClinicType21$.NextScheduledAppt

GO
/* NEXT CHOOSE ONLY CHOOSE ROW NUMBER 1 AS EARLIEST LEMENT FOR NEXT SCHEDULED APPT . FROM ClinicType24A TO ClinicType24B */

DROP TABLE ClinicType24$ SELECT ClinicType24A$.STA3N,ClinicType24A$.ConsultSID,ClinicType24A$.PrimaryStopCode,ClinicType24A$.ClinicType,
ClinicType24A$.ToRequestServiceName, ClinicType24A$.StopCodeSID,
ClinicType24A$.ToRequestServiceSID,
ClinicType24A$.PatientLocationSID,ClinicType24A$.RequestDateTime,ClinicType24A$.FromLocationSID,
ClinicType24A$.AttentionToStaffSID,ClinicType24A$.CPRSStatus,
ClinicType24A$.FileEntryVistaDate,ClinicType24A$.ConsultIEN,
ClinicType24A$.PatientSID,ClinicType24A$.OrderingInstitutionSID,ClinicType24A$.RoutingInstitutionSID,
ClinicType24A$.ConsultInitiationDate,ClinicType24A$.WaitTime,ClinicType24A$.WaitTimeGT15DaysWoVisit,
ClinicType24A$.CancelledAppointmentYesNo,ClinicType24A$.DiscontinuedAppointmentYesNo,ClinicType24A$.NextScheduledAppt,
ClinicType24A$.ROWNUMBER
INTO ClinicType24$
FROM ClinicType24A$
   
WHERE ROWNUMBER=1
--GROUP BY ClinicType24A$.STA3N,ClinicType24A$.ConsultSID,ClinicType24A$.NextScheduledAppt


GO



