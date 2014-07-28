

IF OBJECT_ID (N'dbo.ufnConfirmEstablishedPatient', N'FN') IS NOT NULL
    DROP FUNCTION ufnConfirmEstablishedPatient;
GO
CREATE FUNCTION dbo.ufnConfirmEstablishedPatient(@RequestDateTime datetime,@AppointmentDateTime datetime)
RETURNS int
AS 
-- Returns comparison of date ( year, month, day and hours and minutes) for 2 dates passed as 'true' or 'false'
-- if any Appt  found in previous last 90 days return True (1) else false (0)
BEGIN
    DECLARE @ret in;
    SET @ret =
    CASE 
        WHEN 
            (@RequestDateTime !='') AND (@AppointmentDateTime<@RequestDateTime) AND (@AppointmentDateTime>=DATEADD(month,-3,@RequestDateTime))
        THEN 1
        ELSE 0    
    END
    return @ret 
END;

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
        WHEN 
            (@ConsultInitiationDate !='') AND (@AppointmentDateTime>@ConsultInitiationDate) AND (@AppointmentDateTime<DATEADD(month,3,@ConsultInitiationDate))
        THEN @AppointmentDateTime
        WHEN 
            (@ConsultInitiationDate ='') AND (@AppointmentDateTime>@RequestDateTime) AND (@AppointmentDateTime<DATEADD(month,3,@RequestDateTime))
        THEN @AppointmentDateTime
        ELSE ''    
    END
    return @ret 
END;

GO


DROP TABLE ClinicType21$ SELECT ClinicType21A$.STA3N,ClinicType21A$.ConsultSID,ClinicType21A$.PrimaryStopCode,
ClinicType21A$.ToRequestServiceName, ClinicType21A$.StopCodeSID,
ClinicType21A$.ToRequestServiceSID,
ClinicType21A$.PatientLocationSID,ClinicType21A$.RequestDateTime,ClinicType21A$.FromLocationSID,
ClinicType21A$.AttentionToStaffSID,ClinicType21A$.CPRSStatus,
ClinicType21A$.FileEntryVistaDate,ClinicType21A$.ConsultIEN,
ClinicType21A$.PatientSID,ClinicType21A$.OrderingInstitutionSID,ClinicType21A$.RoutingInstitutionSID,
ClinicType21A$.ConsultInitiationDate,ClinicType21A$.WaitTime,ClinicType21A$.WaitTimeGT15DaysWoVisit,
ClinicType21A$.CancelledAppointmentYesNo,ClinicType21A$.DiscontinuedAppointmentYesNo,
dbo.ufnNextScheduledAppt(ClinicType21A$.ConsultInitiationDate,TestAppointment$.AppointmentDateTime,ClinicType21A$.RequestDateTime)as NextScheduledAppt,
dbo.ufnConfirmEstablishedPatient(ClinicType21A$.RequestDateTime datetime,TestAppointment$.AppointmentDateTime datetime) as EstablishedPatient                      
INTO ClinicType21$
FROM (ClinicType21A$ 
                       
                        JOIN
                      TestAppointment$  ON ClinicType21A$.PatientSID =  TestAppointment$.PatientSID
                        JOIN
                      TestLocationDim$  ON TestAppointment$.LocationSID = TestLocationDim$.LocationSID)
                      
WHERE  (TestAppointment$.PatientSID = ClinicType21A$.PatientSID)
       AND (dbo.ufnNextScheduledAppt(ClinicType21A$.ConsultInitiationDate,TestAppointment$.AppointmentDateTime,ClinicType21A$.RequestDateTime)!='')
       AND (((TestLocationDim$.PrimaryStopCodeIEN >499) AND (TestLocationDim$.PrimaryStopCodeIEN <600))OR ((TestLocationDim$.PrimaryStopCodeIEN >210) AND (TestLocationDim$.PrimaryStopCodeIEN <231)))
       
     

GO


DROP TABLE ClinicType24$ SELECT ClinicType21$.STA3N,ClinicType21$.ConsultSID,ClinicType21$.PrimaryStopCode,ClinicTypeStaticMap$.ClinicType,
ClinicType21$.ToRequestServiceName, ClinicType21$.StopCodeSID,
ClinicType21$.ToRequestServiceSID,
ClinicType21$.PatientLocationSID,ClinicType21$.RequestDateTime,ClinicType21$.FromLocationSID,
ClinicType21$.AttentionToStaffSID,ClinicType21$.CPRSStatus,
ClinicType21$.FileEntryVistaDate,ClinicType21$.ConsultIEN,
ClinicType21$.PatientSID,ClinicType21$.OrderingInstitutionSID,ClinicType21$.RoutingInstitutionSID,
ClinicType21$.ConsultInitiationDate,ClinicType21$.WaitTime,ClinicType21$.WaitTimeGT15DaysWoVisit,
ClinicType21$.CancelledAppointmentYesNo,ClinicType21$.DiscontinuedAppointmentYesNo,ClinicType21$.NextScheduledAppt
INTO ClinicType24$
FROM ClinicType21$
JOIN ClinicTypeStaticMap$
     ON ClinicType21$.PrimaryStopCode = ClinicTypeStaticMap$.StopCode
ORDER BY ClinicType21$.STA3N,ClinicType21$.NextScheduledAppt






