DROP TABLE ClinicType18$ SELECT DISTINCT   ClinicType8$.STA3N,ClinicType8$.ConsultSID,ClinicType8$.PatientLocationSID, ClinicType8$.RequestDateTime, ClinicType8$.FromLocationSID, 
                      ClinicType8$.ToRequestServiceName, ClinicType8$.AttentionToStaffSID, ClinicType8$.CPRSStatus, TestInstitutionDIM$.InstitutionIEN, ClinicType8$.FileEntryVistaDate,
                      ClinicType8$.ConsultIEN ,TestInstitutionDIM$.InstitutionName,ClinicType8$.ToRequestServiceSID,ClinicType8$.PatientSID,ClinicType8$.OrderingInstitutionSID,
                      ClinicType8$.RoutingInstitutionSID
                      
INTO ClinicType18$
FROM          (ClinicType8$ 
                        JOIN
                      TestInstitutionDIM$ ON ClinicType8$.OrderingInstitutionSID = TestInstitutionDIM$.InstitutionSID)
                      
WHERE  (ClinicType8$.ToRequestServiceName LIKE '%MH%' OR ClinicType8$.ToRequestServiceName LIKE '%MENTAL%' OR ClinicType8$.ToRequestServiceName LIKE '%PSY%') AND(TestInstitutionDIM$.InstitutionIEN = '580')
