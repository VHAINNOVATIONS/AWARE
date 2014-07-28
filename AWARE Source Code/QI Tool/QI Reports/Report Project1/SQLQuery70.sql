DROP TABLE ClinicType6$ SELECT DISTINCT   ClinicType5$.ConsultSID,ClinicType5$.STA3N,ClinicType5$.PatientLocationSID, ClinicType5$.RequestDateTime, ClinicType5$.FromLocationSID, 
                      ClinicType5$.ToRequestServiceName, ClinicType5$.AttentionToStaffSID, ClinicType5$.CPRSStatus, ClinicType5$.InstitutionIEN, ClinicType5$.FileEntryVistaDate,
                      ClinicType5$.ConsultIEN ,ClinicType5$.InstitutionName,ClinicType5$.ToRequestServiceSID,ClinicType5$.PatientSID,
                      ClinicType5$.VisitVistaDate,ClinicType5$.PrimaryStopCode,ClinicType5$.LocationName,
                      ClinicType5$.Sta3n1,ClinicType5$.PrimaryStopCodeSID,ClinicType5$.StopCodeSID,
                      ClinicType5$.StopCodeName,ClinicType5$.VisitSID,ClinicType5$.LocationSID,ClinicType5$.AppointmentDateTime,
                      ClinicType5$.VisitCreatedDate
                      
INTO ClinicType6$
FROM          ClinicType5$
                       
WHERE ((Cast (Substring(STR(ClinicType5$.VisitVistaDate,11,3),1,3)as INT)+1700) = YEAR(ClinicType5$.AppointmentDateTime))AND (Cast (Substring(STR(ClinicType5$.VisitVistaDate,11,3),4,2)as INT) = MONTH(ClinicType5$.AppointmentDateTime)) AND
      (Cast (Substring(STR(ClinicType5$.VisitVistaDate,11,3),6,2)as INT) = DAY(ClinicType5$.AppointmentDateTime)) AND
      (Substring(STR(ClinicType5$.VisitVistaDate,11,3),9,2) = Substring(Cast(Convert(time,ClinicType5$.AppointmentDateTime)as NVARCHAR),1,2))
      AND (Substring(STR(ClinicType5$.VisitVistaDate,11,3),11,1) = Substring(Cast(Convert(time,ClinicType5$.AppointmentDateTime)as NVARCHAR),4,1))