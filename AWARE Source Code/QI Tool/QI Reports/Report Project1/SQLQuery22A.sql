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