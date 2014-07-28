DROP TABLE ConsultSTation2$ SELECT DISTINCT   ConsultStation1$.ConsultSID,ConsultStation1$.STA3N,ConsultStation1$.PatientLocationSID, ConsultStation1$.RequestDateTime, ConsultStation1$.FromLocationSID, ConsultStation1$.ActivityDateTime, ConsultStation1$.Activity, 
                      ConsultStation1$.ToRequestServiceName, ConsultStation1$.AttentionToStaffSID, ConsultStation1$.CPRSStatus, ConsultStation1$.InstitutionIEN, ConsultStation1$.FileEntryVistaDate,
                      ConsultStation1$.ActivityEntryVistaDate,ConsultStation1$.ConsultIEN ,ConsultStation1$.InstitutionName,ConsultStation1$.ToRequestServiceSID,TestConsults$.PatientSID
INTO ConsultStation2$
FROM          ConsultStation1$
                      JOIN
                      TestConsults$ ON ConsultStation1$.ToRequestServiceSID = TestConsults$.ToRequestServiceSID
