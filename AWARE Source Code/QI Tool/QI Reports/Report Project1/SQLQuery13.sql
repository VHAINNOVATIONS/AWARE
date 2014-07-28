DROP TABLE ClinicType8$ SELECT DISTINCT   Consult$.STA3N,Consult$.ConsultSID,Consult$.PatientLocationSID, Consult$.RequestDateTime, Consult$.FromLocationSID, 
                      Consult$.ToRequestServiceName, Consult$.AttentionToStaffSID, Consult$.CPRSStatus, TestInstitutionDIM$.InstitutionIEN, Consult$.FileEntryVistaDate,
                      Consult$.ConsultIEN ,TestInstitutionDIM$.InstitutionName,Consult$.ToRequestServiceSID,Consult$.PatientSID,Consult$.OrderingInstitutionSID,
                      Consult$.RoutingInstitutionSID
                      
                      
INTO ClinicType8$
FROM          (Consult$ 
                        JOIN
                      TestInstitutionDIM$ ON Consult$.OrderingInstitutionSID = TestInstitutionDIM$.InstitutionSID)
                      
WHERE  (Consult$.ToRequestServiceName LIKE '%MH%' OR Consult$.ToRequestServiceName LIKE '%MENTAL%' OR Consult$.ToRequestServiceName LIKE '%PSY%') AND(TestInstitutionDIM$.InstitutionIEN = '580')
