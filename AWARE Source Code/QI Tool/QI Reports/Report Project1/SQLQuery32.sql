DROP TABLE ClinicType22$ SELECT DISTINCT ClinicType5$.STA3N,ClinicType5$.ConsultSID,ClinicType5$.PrimaryStopCode,
                      ClinicType5$.PatientLocationSID, ClinicType5$.RequestDateTime, ClinicType5$.FromLocationSID, 
                      ClinicType5$.ToRequestServiceName, ClinicType5$.AttentionToStaffSID, ClinicType5$.CPRSStatus,
                      ClinicType5$.InstitutionIEN, ClinicType5$.FileEntryVistaDate,
                      ClinicType5$.ConsultIEN ,ClinicType5$.InstitutionName,ClinicType5$.ToRequestServiceSID,
                      ClinicType5$.PatientSID,
                      ClinicType5$.VisitVistaDate,ClinicType5$.LocationName,
                      ClinicType5$.Sta3n1,ClinicType5$.PrimaryStopCodeSID,ClinicType5$.StopCodeSID,
                      ClinicType5$.StopCodeName,ClinicType5$.VisitSID,ClinicType5$.LocationSID,ClinicType5$.AppointmentDateTime,
                      ClinicType5$.VisitCreatedDate,ClinicType5$.OrderingInstitutionSID,ClinicType5$.RoutingInstitutionSID
INTO  ClinicType22$
FROM  ClinicType5$