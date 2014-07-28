/* NEXT ORDER FROM ClinicType24II TO ClinicType24JJ */

DROP TABLE ClinicType24JJ$ SELECT ClinicType24II$.STA3N,ClinicType24II$.ConsultSID,ClinicType24II$.PrimaryStopCode,ClinicType24II$.ClinicType,
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
INTO ClinicType24JJ$
FROM ClinicType24II$
ORDER BY ClinicType24II$.STA3N,ClinicType24II$.ConsultSID,ClinicType24II$.PrimaryStopCode
GO
 
/* NEXT, FUNCTION FOR RETURN PROVIDER FOR Outpatient Encounter  */

IF OBJECT_ID (N'dbo.ufnOutpatientEncounterProvider', N'FN') IS NOT NULL
    DROP FUNCTION ufnOutpatientEncounterProvider;
GO
CREATE FUNCTION dbo.ufnOutpatientEncounterProvider(@VistaSID1 int)
RETURNS int
AS 
--- Determine Patient "New" or "Establihed" status 
-- Returns comparison of date ( year, month, day and hours and minutes) for 2 dates passed as 'true' or 'false'
-- if any Appt  found in previous last 90 days return datetime(True (1)) else '' date as False (0))
BEGIN
    DECLARE @ret int;
    SET @ret =
    CASE 
        WHEN 
            (@VistaSID1 != -1) 
        THEN  1 /* SUBQUERY (Select TestVProviders$.VProviderSID FROM TestVProviders$ JOIN TestOutpatientEncounter$ ON TestVProviders$.VisitSID = TestOutpatientEncounter.VisitSID WHEN TestOutpatientEncounter.VisitSID = @VistaSID1)*/
        ELSE -1  
    END
    return @ret 
END;

GO


DROP TABLE ClinicType24KK$ SELECT ClinicType24JJ$.STA3N,ClinicType24JJ$.ConsultSID,ClinicType24JJ$.PrimaryStopCode,ClinicType24JJ$.ClinicType,
ClinicType24JJ$.ToRequestServiceName, ClinicType24JJ$.StopCodeSID,
ClinicType24JJ$.ToRequestServiceSID,
ClinicType24JJ$.PatientLocationSID,ClinicType24JJ$.RequestDateTime,ClinicType24JJ$.FromLocationSID,
ClinicType24JJ$.AttentionToStaffSID,ClinicType24JJ$.CPRSStatus,
ClinicType24JJ$.FileEntryVistaDate,ClinicType24JJ$.ConsultIEN,
ClinicType24JJ$.PatientSID,ClinicType24JJ$.OrderingInstitutionSID,ClinicType24JJ$.RoutingInstitutionSID,ClinicType24JJ$.LocationName,ClinicType24JJ$.VistaSID1,
ClinicType24JJ$.ConsultInitiationDate,ClinicType24JJ$.WaitTime,ClinicType24JJ$.WaitTimeGT15DaysWoVisit,
ClinicType24JJ$.CancelledAppointmentYesNo,ClinicType24JJ$.DiscontinuedAppointmentYesNo,ClinicType24JJ$.NextScheduledAppt,ClinicType24JJ$.NextSchedLocationName,
ClinicType24JJ$.PatientNewEstablish,ClinicType24JJ$.PatientEstablishDT,
TestVProviders$.VProviderSID as VProvider
/*dbo.ufnOutpatientEncounterProvider(ClinicType24JJ$.VistaSID1) as VProvider*/
/*ClinicType24HH$.ROWNUMBER*/
INTO ClinicType24KK$
FROM (ClinicType24JJ$
            JOIN TestOutpatientEncounter$
            ON ClinicType24JJ$.VistaSID1 = TestOutpatientEncounter$.VisitSID
            JOIN TestVProviders$
                       ON TestOutpatientEncounter$.VisitSID = TestVProviders$.VisitSID)

            
--Select TestVProvider$.VProviderSID FROM TestVProvider$ JOIN TestOutpatientEncounter$ ON TestVProvider$.VisitSID = TestOutpatientEncounter.VisitSID WHEN TestOutpatientEncounter.VisitSID = @VistaSID1

GO

/* FIND 1ST PROVIDER IF MULTIPLE PROVIDERS FOUND. USE ROW NUMBER RULE. TAKE FROM 
ClinicType24KK to ClinicType24MM*/
USE consults
DROP TABLE ClinicType24MM$ SELECT ClinicType24KK$.STA3N,ClinicType24KK$.ConsultSID,ClinicType24KK$.PrimaryStopCode,ClinicType24KK$.ClinicType,
ClinicType24KK$.ToRequestServiceName, ClinicType24KK$.StopCodeSID,
ClinicType24KK$.ToRequestServiceSID,
ClinicType24KK$.PatientLocationSID,ClinicType24KK$.RequestDateTime,ClinicType24KK$.FromLocationSID,
ClinicType24KK$.AttentionToStaffSID,ClinicType24KK$.CPRSStatus,
ClinicType24KK$.FileEntryVistaDate,ClinicType24KK$.ConsultIEN,
ClinicType24KK$.PatientSID,ClinicType24KK$.OrderingInstitutionSID,ClinicType24KK$.RoutingInstitutionSID,ClinicType24KK$.LocationName,ClinicType24KK$.VistaSID1,
ClinicType24KK$.ConsultInitiationDate,ClinicType24KK$.WaitTime,ClinicType24KK$.WaitTimeGT15DaysWoVisit,
ClinicType24KK$.CancelledAppointmentYesNo,ClinicType24KK$.DiscontinuedAppointmentYesNo,ClinicType24KK$.NextScheduledAppt,ClinicType24KK$.NextSchedLocationName,
ClinicType24KK$.PatientNewEstablish,ClinicType24KK$.PatientEstablishDT,
ClinicType24KK$.VProvider,
ROW_NUMBER() OVER (partition by ClinicType24KK$.STA3N,ClinicType24KK$.ConsultSID,ClinicType24KK$.PrimaryStopCode ORDER BY ClinicType24KK$.STA3N,ClinicType24KK$.ConsultSID,
ClinicType24KK$.PrimaryStopCode,ClinicType24KK$.VProvider ASC) AS ROWNUMBER
INTO ClinicType24MM$
FROM ClinicType24KK$
--WHERE ROWNUMBER=1
--GROUP BY ClinicType21$.STA3N,ClinicType21$.ConsultSID,ClinicType21$.PrimaryStopCode,ClinicTypeStaticMap$.ClinicType,ClinicType21$.NextScheduledAppt

GO
/* PICK ROW NUMBER 1 AS FIRST OF ANY MULTIPLE PROVIDERS FOUND . FROM ClinicType24MM TO ClinicType24NN */

DROP TABLE ClinicType24NN$ SELECT ClinicType24MM$.STA3N,ClinicType24MM$.ConsultSID,ClinicType24MM$.PrimaryStopCode,ClinicType24MM$.ClinicType,
ClinicType24MM$.ToRequestServiceName, ClinicType24MM$.StopCodeSID,
ClinicType24MM$.ToRequestServiceSID,
ClinicType24MM$.PatientLocationSID,ClinicType24MM$.RequestDateTime,ClinicType24MM$.FromLocationSID,
ClinicType24MM$.AttentionToStaffSID,ClinicType24MM$.CPRSStatus,
ClinicType24MM$.FileEntryVistaDate,ClinicType24MM$.ConsultIEN,
ClinicType24MM$.PatientSID,ClinicType24MM$.OrderingInstitutionSID,ClinicType24MM$.RoutingInstitutionSID,ClinicType24MM$.LocationName,ClinicType24MM$.VistaSID1,
ClinicType24MM$.ConsultInitiationDate,ClinicType24MM$.WaitTime,ClinicType24MM$.WaitTimeGT15DaysWoVisit,
ClinicType24MM$.CancelledAppointmentYesNo,ClinicType24MM$.DiscontinuedAppointmentYesNo,ClinicType24MM$.NextScheduledAppt,ClinicType24MM$.NextSchedLocationName,
ClinicType24MM$.PatientNewEstablish,ClinicType24MM$.PatientEstablishDT,
ClinicType24MM$.VProvider,
ClinicType24MM$.ROWNUMBER
INTO ClinicType24NN$
FROM ClinicType24MM$
   
WHERE ROWNUMBER=1
/*ORDER BY ClinicType24HH$.STA3N,ClinicType24HH$.ConsultSID,ClinicType24HH$.PrimaryStopCode*/

GO

/* Find Excluded elements for V providers found with left join ClinicType24JJ with ClinicType24NN INTO ClinicType24LL */

DROP TABLE ClinicType24LL$ SELECT ClinicType24JJ$.STA3N,ClinicType24JJ$.ConsultSID,ClinicType24JJ$.PrimaryStopCode,ClinicType24JJ$.ClinicType,
ClinicType24JJ$.ToRequestServiceName, ClinicType24JJ$.StopCodeSID,
ClinicType24JJ$.ToRequestServiceSID,
ClinicType24JJ$.PatientLocationSID,ClinicType24JJ$.RequestDateTime,ClinicType24JJ$.FromLocationSID,
ClinicType24JJ$.AttentionToStaffSID,ClinicType24JJ$.CPRSStatus,
ClinicType24JJ$.FileEntryVistaDate,ClinicType24JJ$.ConsultIEN,
ClinicType24JJ$.PatientSID,ClinicType24JJ$.OrderingInstitutionSID,ClinicType24JJ$.RoutingInstitutionSID,ClinicType24JJ$.LocationName,ClinicType24JJ$.VistaSID1,
ClinicType24JJ$.ConsultInitiationDate,ClinicType24JJ$.WaitTime,ClinicType24JJ$.WaitTimeGT15DaysWoVisit,
ClinicType24JJ$.CancelledAppointmentYesNo,ClinicType24JJ$.DiscontinuedAppointmentYesNo,ClinicType24JJ$.NextScheduledAppt,ClinicType24JJ$.NextSchedLocationName,
ClinicType24JJ$.PatientNewEstablish,ClinicType24JJ$.PatientEstablishDT,
-1 as VProvider

INTO ClinicType24LL$
FROM   (ClinicType24JJ$
       LEFT JOIN ClinicType24NN$
       ON ClinicType24JJ$.ConsultSID = ClinicType24NN$.ConsultSID)
       
WHERE ClinicType24NN$.ConsultSID IS NULL

GO

/* DO UNION OF ClinicType24LL AND ClinicType24KK INTO ClinicType24*/

DROP TABLE ClinicType24$ SELECT ClinicType24NN$.STA3N,ClinicType24NN$.ConsultSID,ClinicType24NN$.PrimaryStopCode,ClinicType24NN$.ClinicType,
ClinicType24NN$.ToRequestServiceName, ClinicType24NN$.StopCodeSID,
ClinicType24NN$.ToRequestServiceSID,
ClinicType24NN$.PatientLocationSID,ClinicType24NN$.RequestDateTime,ClinicType24NN$.FromLocationSID,
ClinicType24NN$.AttentionToStaffSID,ClinicType24NN$.CPRSStatus,
ClinicType24NN$.FileEntryVistaDate,ClinicType24NN$.ConsultIEN,
ClinicType24NN$.PatientSID,ClinicType24NN$.OrderingInstitutionSID,ClinicType24NN$.RoutingInstitutionSID,ClinicType24NN$.LocationName,ClinicType24NN$.VistaSID1,
ClinicType24NN$.ConsultInitiationDate,ClinicType24NN$.WaitTime,ClinicType24NN$.WaitTimeGT15DaysWoVisit,
ClinicType24NN$.CancelledAppointmentYesNo,ClinicType24NN$.DiscontinuedAppointmentYesNo,ClinicType24NN$.NextScheduledAppt,ClinicType24NN$.NextSchedLocationName,
ClinicType24NN$.PatientNewEstablish,ClinicType24NN$.PatientEstablishDT,
ClinicType24NN$.VProvider

INTO ClinicType24$
FROM ClinicType24NN$ 
UNION
SELECT ClinicType24LL$.STA3N,ClinicType24LL$.ConsultSID,ClinicType24LL$.PrimaryStopCode,ClinicType24LL$.ClinicType,
ClinicType24LL$.ToRequestServiceName, ClinicType24LL$.StopCodeSID,
ClinicType24LL$.ToRequestServiceSID,
ClinicType24LL$.PatientLocationSID,ClinicType24LL$.RequestDateTime,ClinicType24LL$.FromLocationSID,
ClinicType24LL$.AttentionToStaffSID,ClinicType24LL$.CPRSStatus,
ClinicType24LL$.FileEntryVistaDate,ClinicType24LL$.ConsultIEN,
ClinicType24LL$.PatientSID,ClinicType24LL$.OrderingInstitutionSID,ClinicType24LL$.RoutingInstitutionSID,ClinicType24LL$.LocationName,ClinicType24LL$.VistaSID1,
ClinicType24LL$.ConsultInitiationDate,ClinicType24LL$.WaitTime,ClinicType24LL$.WaitTimeGT15DaysWoVisit,
ClinicType24LL$.CancelledAppointmentYesNo,ClinicType24LL$.DiscontinuedAppointmentYesNo,ClinicType24LL$.NextScheduledAppt,ClinicType24LL$.NextSchedLocationName,
ClinicType24LL$.PatientNewEstablish,ClinicType24LL$.PatientEstablishDT,
ClinicType24LL$.VProvider

FROM ClinicType24LL$


GO