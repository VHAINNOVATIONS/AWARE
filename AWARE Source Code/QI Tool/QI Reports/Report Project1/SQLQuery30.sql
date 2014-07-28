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
