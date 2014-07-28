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
ROW_NUMBER() OVER (partition by ClinicType21$.STA3N,ClinicType21$.ConsultSID,ClinicType21$.NextScheduledAppt ORDER BY ClinicType21$.STA3N,ClinicType21$.ConsultSID,ClinicType21$.NextScheduledAppt ASC) AS ROWNUMBER
INTO ClinicType24A$
FROM ClinicType21$
        JOIN ClinicTypeStaticMap$
           ON ClinicType21$.PrimaryStopCode = ClinicTypeStaticMap$.StopCode
--WHERE ROWNUMBER=1
--GROUP BY ClinicType21$.STA3N,ClinicType21$.ConsultSID,ClinicType21$.PrimaryStopCode,ClinicTypeStaticMap$.ClinicType,ClinicType21$.NextScheduledAppt

GO

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