DROP TABLE ClinicType1$ SELECT DISTINCT   Consult$.ConsultSID,Consult$.STA3N,Consult$.PatientLocationSID, Consult$.RequestDateTime, Consult$.FromLocationSID, ConsultActivity$.ActivityDateTime, ConsultActivity$.Activity, 
                      Consult$.ToRequestServiceName, Consult$.AttentionToStaffSID, Consult$.CPRSStatus, TestInstitutionDIM$.InstitutionIEN, Consult$.FileEntryVistaDate,
                      ConsultActivity$.ActivityEntryVistaDate,Consult$.ConsultIEN ,TestInstitutionDIM$.InstitutionName,Consult$.ToRequestServiceSID,Consult$.PatientSID,
                      TestOutpatientEncounter$.VisitVistaDate
INTO ClinicType1$
FROM          (Consult$ INNER JOIN
                      ConsultActivity$ ON Consult$.ConsultSID = ConsultActivity$.ConsultSID
                        INNER JOIN
                      TestOutpatientEncounter$ on Consult$.PatientSID = TestOutpatientEncounter$.PatientSID
                        JOIN
                      TestInstitutionDIM$ ON Consult$.OrderingInstitutionSID = TestInstitutionDIM$.InstitutionSID)
WHERE  (Consult$.ToRequestServiceName LIKE '%MH%' OR Consult$.ToRequestServiceName LIKE '%MENTAL%') AND(TestInstitutionDIM$.InstitutionIEN = '580') AND (TestOutpatientEncounter$.VisitVistaDate<(Consult$.FileEntryVistaDate +30))
                      AND (TestOutpatientEncounter$.VisitVistaDate>=(Consult$.FileEntryVistaDate))       
ORDER BY ConsultActivity$.ActivityDateTime