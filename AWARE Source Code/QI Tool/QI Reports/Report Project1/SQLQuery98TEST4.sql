USE consults
DROP TABLE ClinicType26B$ SELECT l26.STA3N, l26.ConsultSID,l26.PrimaryStopCode,
l26.ToRequestServiceName,l26.StopCodeSID,
l26.ToRequestServiceSID,l26.PatientLocationSID,l26.RequestDateTime,l26.FromLocationSID,l26.AttentionToStaffSID,
l26.CPRSStatus,l26.FileEntryVistaDate,l26.ConsultIEN,
l26.PatientSID,l26.OrderingInstitutionSID,l26.RoutingInstitutionSID,
l26.ConsultInitiationDate,l26.WaitTime,l26.WaitTimeGT15DaysWoVisit,l26.CancelledAppointmentYesNo,l26.DiscontinuedAppointmentYesNo

ROW_NUMBER() OVER (partition by l26.ConsultSID,l26.STA3N ORDER BY l26.ConsultSID,l26.STA3N,l26.ConsultInitiationDate ASC) AS ROWNUMBER
INTO ClinicType26B$
FROM ClinicType26A$ as l26

--WHERE ROWNUMBER=1
--GROUP BY ClinicType26A$.STA3N,ClinicType26A$.ConsultSID,ClinicType26A$.ConsultInitiationDate

GO
/* NEXT CHOOSE ONLY CHOOSE ROW NUMBER 1 AS EARLIEST ELEMENT FOR NEXT SCHEDULED APPT . FROM ClinicType24A TO ClinicType24B */

DROP TABLE ClinicType26$ SELECT l26.STA3N, l26.ConsultSID,l26.PrimaryStopCode,
l26.ToRequestServiceName,l26.StopCodeSID,
l26.ToRequestServiceSID,l26.PatientLocationSID,l26.RequestDateTime,l26.FromLocationSID,l26.AttentionToStaffSID,
l26.CPRSStatus,l26.FileEntryVistaDate,l26.ConsultIEN,
l26.PatientSID,l26.OrderingInstitutionSID,l26.RoutingInstitutionSID,
l26.ConsultInitiationDate,l26.WaitTime,l26.WaitTimeGT15DaysWoVisit,l26.CancelledAppointmentYesNo,l26.DiscontinuedAppointmentYesNo
l26.ROWNUMBER
INTO ClinicType26$
FROM ClinicType26B$ as l26
   
WHERE ROWNUMBER=1
--GROUP BY ClinicType26B$.STA3N,ClinicType26B$.ConsultSID,ClinicType26B$.ConsultInitiationDate