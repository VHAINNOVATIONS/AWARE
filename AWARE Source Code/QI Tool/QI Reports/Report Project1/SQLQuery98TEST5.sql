/* NEXT CHOOSE ONLY CHOOSE ROW NUMBER 1 AS EARLIEST LEMENT FOR NEXT SCHEDULED APPT . FROM ClinicType24A TO ClinicType24B */

DROP TABLE ClinicType24B$ SELECT ClinicType24A$.STA3N,ClinicType24A$.ConsultSID,ClinicType24A$.PrimaryStopCode,ClinicType24A$.ClinicType,
ClinicType24A$.ToRequestServiceName, ClinicType24A$.StopCodeSID,
ClinicType24A$.ToRequestServiceSID,
ClinicType24A$.PatientLocationSID,ClinicType24A$.RequestDateTime,ClinicType24A$.FromLocationSID,
ClinicType24A$.AttentionToStaffSID,ClinicType24A$.CPRSStatus,
ClinicType24A$.FileEntryVistaDate,ClinicType24A$.ConsultIEN,
ClinicType24A$.PatientSID,ClinicType24A$.OrderingInstitutionSID,ClinicType24A$.RoutingInstitutionSID,
ClinicType24A$.ConsultInitiationDate,ClinicType24A$.WaitTime,ClinicType24A$.WaitTimeGT15DaysWoVisit,
ClinicType24A$.CancelledAppointmentYesNo,ClinicType24A$.DiscontinuedAppointmentYesNo,ClinicType24A$.NextScheduledAppt,
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
ClinicType24B$.PatientSID,ClinicType24B$.OrderingInstitutionSID,ClinicType24B$.RoutingInstitutionSID,
ClinicType24B$.ConsultInitiationDate,ClinicType24B$.WaitTime,ClinicType24B$.WaitTimeGT15DaysWoVisit,
ClinicType24B$.CancelledAppointmentYesNo,ClinicType24B$.DiscontinuedAppointmentYesNo,ClinicType24B$.NextScheduledAppt
INTO ClinicType24C$
FROM ClinicType24B$


GO

/* NEXT, FUNCTION FOR RETURN ESTABLISHED(1) NEW PATIENT (0) FROM APPTS IN LAST 3 MONTHS OR  */
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


DROP TABLE ClinicType24D$ SELECT ClinicType24C$.STA3N,ClinicType24C$.ConsultSID,ClinicType24C$.PrimaryStopCode,ClinicType24C$.ClinicType,
ClinicType24C$.ToRequestServiceName,ClinicType24C$.StopCodeSID,
ClinicType24C$.ToRequestServiceSID,
ClinicType24C$.PatientLocationSID,ClinicType24C$.RequestDateTime,ClinicType24C$.FromLocationSID,
ClinicType24C$.AttentionToStaffSID,ClinicType24C$.CPRSStatus,
ClinicType24C$.FileEntryVistaDate,ClinicType24C$.ConsultIEN,
ClinicType24C$.PatientSID,ClinicType24C$.OrderingInstitutionSID,ClinicType24C$.RoutingInstitutionSID,
ClinicType24C$.ConsultInitiationDate,ClinicType24C$.WaitTime,ClinicType24C$.WaitTimeGT15DaysWoVisit,
ClinicType24C$.CancelledAppointmentYesNo,ClinicType24C$.DiscontinuedAppointmentYesNo,ClinicType24C$.NextScheduledAppt,
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
ClinicType24D$.PatientSID,ClinicType24D$.OrderingInstitutionSID,ClinicType24D$.RoutingInstitutionSID,
ClinicType24D$.ConsultInitiationDate,ClinicType24D$.WaitTime,ClinicType24D$.WaitTimeGT15DaysWoVisit,
ClinicType24D$.CancelledAppointmentYesNo,ClinicType24D$.DiscontinuedAppointmentYesNo,
ClinicType24D$.NextScheduledAppt,ClinicType24D$.PatientNewEstablish,ClinicType24D$.PatientEstablishDT
                      
INTO ClinicType24E$
FROM ClinicType24D$ 
ORDER BY ClinicType24D$.STA3N,ClinicType24D$.ConsultSID,ClinicType24D$.PrimaryStopCode,ClinicType24D$.PatientEstablishDT

GO

/* ADD A "NULLED" PatientEstablishDT, and 0 PatientNewEstablish as  TO A WHOLE LIST ClinicType24C TO MAKE ClinicType24DD */

DROP TABLE ClinicType24DD$ SELECT ClinicType24C$.STA3N,ClinicType24C$.ConsultSID,ClinicType24C$.PrimaryStopCode,ClinicType24C$.ClinicType,
ClinicType24C$.ToRequestServiceName, ClinicType24C$.StopCodeSID,
ClinicType24C$.ToRequestServiceSID,
ClinicType24C$.PatientLocationSID,ClinicType24C$.RequestDateTime,ClinicType24C$.FromLocationSID,
ClinicType24C$.AttentionToStaffSID,ClinicType24C$.CPRSStatus,
ClinicType24C$.FileEntryVistaDate,ClinicType24C$.ConsultIEN,
ClinicType24C$.PatientSID,ClinicType24C$.OrderingInstitutionSID,ClinicType24C$.RoutingInstitutionSID,
ClinicType24C$.ConsultInitiationDate,ClinicType24C$.WaitTime,ClinicType24C$.WaitTimeGT15DaysWoVisit,
ClinicType24C$.CancelledAppointmentYesNo,ClinicType24C$.DiscontinuedAppointmentYesNo,ClinicType24C$.NextScheduledAppt,
0 AS PatientNewEstablish,NULL AS PatientEstablishDT
                      
INTO ClinicType24DD$
FROM ClinicType24C$ 

GO

/*AND DO ORDER BY TO MAKE ClinicType24EE */

DROP TABLE ClinicType24EE$ SELECT ClinicType24DD$.STA3N,ClinicType24DD$.ConsultSID,ClinicType24DD$.PrimaryStopCode,ClinicType24DD$.ClinicType,
ClinicType24DD$.ToRequestServiceName, ClinicType24DD$.StopCodeSID,
ClinicType24DD$.ToRequestServiceSID,
ClinicType24DD$.PatientLocationSID,ClinicType24DD$.RequestDateTime,ClinicType24DD$.FromLocationSID,
ClinicType24DD$.AttentionToStaffSID,ClinicType24DD$.CPRSStatus,
ClinicType24DD$.FileEntryVistaDate,ClinicType24DD$.ConsultIEN,
ClinicType24DD$.PatientSID,ClinicType24DD$.OrderingInstitutionSID,ClinicType24DD$.RoutingInstitutionSID,
ClinicType24DD$.ConsultInitiationDate,ClinicType24DD$.WaitTime,ClinicType24DD$.WaitTimeGT15DaysWoVisit,
ClinicType24DD$.CancelledAppointmentYesNo,ClinicType24DD$.DiscontinuedAppointmentYesNo,
ClinicType24DD$.NextScheduledAppt,ClinicType24DD$.PatientNewEstablish,ClinicType24DD$.PatientEstablishDT
                      
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
ClinicType24EE$.PatientSID,ClinicType24EE$.OrderingInstitutionSID,ClinicType24EE$.RoutingInstitutionSID,
ClinicType24EE$.ConsultInitiationDate,ClinicType24EE$.WaitTime,ClinicType24EE$.WaitTimeGT15DaysWoVisit,
ClinicType24EE$.CancelledAppointmentYesNo,ClinicType24EE$.DiscontinuedAppointmentYesNo,
ClinicType24EE$.NextScheduledAppt,ClinicType24EE$.PatientNewEstablish,ClinicType24EE$.PatientEstablishDT

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
ClinicType24FF$.PatientSID,ClinicType24FF$.OrderingInstitutionSID,ClinicType24FF$.RoutingInstitutionSID,
ClinicType24FF$.ConsultInitiationDate,ClinicType24FF$.WaitTime,ClinicType24FF$.WaitTimeGT15DaysWoVisit,
ClinicType24FF$.CancelledAppointmentYesNo,ClinicType24FF$.DiscontinuedAppointmentYesNo,
ClinicType24FF$.NextScheduledAppt,ClinicType24FF$.PatientNewEstablish,ClinicType24FF$.PatientEstablishDT

INTO ClinicType24GG$
FROM ClinicType24FF$ 
UNION
SELECT ClinicType24E$.STA3N,ClinicType24E$.ConsultSID,ClinicType24E$.PrimaryStopCode,ClinicType24E$.ClinicType,
ClinicType24E$.ToRequestServiceName, ClinicType24E$.StopCodeSID,
ClinicType24E$.ToRequestServiceSID,
ClinicType24E$.PatientLocationSID,ClinicType24E$.RequestDateTime,ClinicType24E$.FromLocationSID,
ClinicType24E$.AttentionToStaffSID,ClinicType24E$.CPRSStatus,
ClinicType24E$.FileEntryVistaDate,ClinicType24E$.ConsultIEN,
ClinicType24E$.PatientSID,ClinicType24E$.OrderingInstitutionSID,ClinicType24E$.RoutingInstitutionSID,
ClinicType24E$.ConsultInitiationDate,ClinicType24E$.WaitTime,ClinicType24E$.WaitTimeGT15DaysWoVisit,
ClinicType24E$.CancelledAppointmentYesNo,ClinicType24E$.DiscontinuedAppointmentYesNo,
ClinicType24E$.NextScheduledAppt,ClinicType24E$.PatientNewEstablish,ClinicType24E$.PatientEstablishDT

FROM ClinicType24E$


GO

/*DO ADD ROW NUMBER TO BE ABLE TO FIND EARLIEST PREVIOUS SCHEDULED APPT IN PAST. TAKE FROM ClinicType24GG INTO ClinicType24HH */

USE consults
DROP TABLE ClinicType24HH$ SELECT ClinicType24GG$.STA3N,ClinicType24GG$.ConsultSID,ClinicType24GG$.PrimaryStopCode,ClinicType24GG$.ClinicType,
ClinicType24GG$.ToRequestServiceName, ClinicType24GG$.StopCodeSID,
ClinicType24GG$.ToRequestServiceSID,
ClinicType24GG$.PatientLocationSID,ClinicType24GG$.RequestDateTime,ClinicType24GG$.FromLocationSID,
ClinicType24GG$.AttentionToStaffSID,ClinicType24GG$.CPRSStatus,
ClinicType24GG$.FileEntryVistaDate,ClinicType24GG$.ConsultIEN,
ClinicType24GG$.PatientSID,ClinicType24GG$.OrderingInstitutionSID,ClinicType24GG$.RoutingInstitutionSID,
ClinicType24GG$.ConsultInitiationDate,ClinicType24GG$.WaitTime,ClinicType24GG$.WaitTimeGT15DaysWoVisit,
ClinicType24GG$.CancelledAppointmentYesNo,ClinicType24GG$.DiscontinuedAppointmentYesNo,ClinicType24GG$.NextScheduledAppt,
ClinicType24GG$.PatientNewEstablish,ClinicType24GG$.PatientEstablishDT,
ROW_NUMBER() OVER (partition by ClinicType24GG$.STA3N,ClinicType24GG$.ConsultSID,ClinicType24GG$.PrimaryStopCode ORDER BY ClinicType24GG$.STA3N,ClinicType24GG$.ConsultSID,
ClinicType24GG$.PrimaryStopCode,ClinicType24GG$.PatientEstablishDT ASC) AS ROWNUMBER
INTO ClinicType24HH$
FROM ClinicType24GG$
--WHERE ROWNUMBER=1
--GROUP BY ClinicType21$.STA3N,ClinicType21$.ConsultSID,ClinicType21$.PrimaryStopCode,ClinicTypeStaticMap$.ClinicType,ClinicType21$.NextScheduledAppt

GO
/* NEXT ONLY CHOOSE ROW NUMBER 1 AS EARLIEST ELEMENT FOR PREVIOUS SCHEDULED APPT . FROM ClinicType24HH TO ClinicType24 */

DROP TABLE ClinicType24II$ SELECT ClinicType24HH$.STA3N,ClinicType24HH$.ConsultSID,ClinicType24HH$.PrimaryStopCode,ClinicType24HH$.ClinicType,
ClinicType24HH$.ToRequestServiceName, ClinicType24HH$.StopCodeSID,
ClinicType24HH$.ToRequestServiceSID,
ClinicType24HH$.PatientLocationSID,ClinicType24HH$.RequestDateTime,ClinicType24HH$.FromLocationSID,
ClinicType24HH$.AttentionToStaffSID,ClinicType24HH$.CPRSStatus,
ClinicType24HH$.FileEntryVistaDate,ClinicType24HH$.ConsultIEN,
ClinicType24HH$.PatientSID,ClinicType24HH$.OrderingInstitutionSID,ClinicType24HH$.RoutingInstitutionSID,
ClinicType24HH$.ConsultInitiationDate,ClinicType24HH$.WaitTime,ClinicType24HH$.WaitTimeGT15DaysWoVisit,
ClinicType24HH$.CancelledAppointmentYesNo,ClinicType24HH$.DiscontinuedAppointmentYesNo,ClinicType24HH$.NextScheduledAppt,
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
ClinicType24II$.PatientSID,ClinicType24II$.OrderingInstitutionSID,ClinicType24II$.RoutingInstitutionSID,
ClinicType24II$.ConsultInitiationDate,ClinicType24II$.WaitTime,ClinicType24II$.WaitTimeGT15DaysWoVisit,
ClinicType24II$.CancelledAppointmentYesNo,ClinicType24II$.DiscontinuedAppointmentYesNo,ClinicType24II$.NextScheduledAppt,
ClinicType24II$.PatientNewEstablish,ClinicType24II$.PatientEstablishDT
/*ClinicType24HH$.ROWNUMBER*/
INTO ClinicType24$
FROM ClinicType24II$
ORDER BY ClinicType24II$.STA3N,ClinicType24II$.ConsultSID,ClinicType24II$.PrimaryStopCode
GO