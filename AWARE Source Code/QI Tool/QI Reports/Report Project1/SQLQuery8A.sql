DROP TABLE ClinicType23$ SELECT DISTINCT   ClinicType22$.ConsultSID,ClinicType22$.STA3N,ClinicType22$.PatientLocationSID, ClinicType22$.RequestDateTime, ClinicType22$.FromLocationSID, 
                      ClinicType22$.ToRequestServiceName, ClinicType22$.AttentionToStaffSID, ClinicType22$.CPRSStatus, ClinicType22$.InstitutionIEN, ClinicType22$.FileEntryVistaDate,
                      ClinicType22$.ConsultIEN ,ClinicType22$.InstitutionName,ClinicType22$.ToRequestServiceSID,ClinicType22$.PatientSID,
                      ClinicType22$.VisitVistaDate,ClinicType22$.PrimaryStopCode,ClinicType22$.LocationName,
                      ClinicType22$.Sta3n1,ClinicType22$.PrimaryStopCodeSID,ClinicType22$.StopCodeSID,
                      ClinicType22$.StopCodeName,ClinicType22$.VisitSID,ClinicType22$.LocationSID,ClinicType22$.AppointmentDateTime,
                      ClinicType22$.VisitCreatedDate,ClinicType22$.OrderingInstitutionSID,ClinicType22$.RoutingInstitutionSID
                      
INTO ClinicType23$
FROM          ClinicType22$
                       
WHERE ((Cast (Substring(STR(ClinicType22$.VisitVistaDate,11,3),1,3)as INT)+1700) = YEAR(ClinicType22$.AppointmentDateTime))AND (Cast (Substring(STR(ClinicType22$.VisitVistaDate,11,3),4,2)as INT) = MONTH(ClinicType22$.AppointmentDateTime)) AND
      (Cast (Substring(STR(ClinicType22$.VisitVistaDate,11,3),6,2)as INT) = DAY(ClinicType22$.AppointmentDateTime)) AND
      (Cast (Substring(STR(ClinicType22$.VisitVistaDate,11,3),6,2)as INT) = DAY(ClinicType22$.AppointmentDateTime)) AND
      (dbo.ufnConfirmVistaHoursMinutes(ClinicType22$.VisitVistaDate,ClinicType22$.AppointmentDateTime)=1) 