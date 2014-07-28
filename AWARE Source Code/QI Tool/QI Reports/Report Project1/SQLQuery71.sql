


DROP TABLE ConsultSTation1$ SELECT DISTINCT   Consult$.ConsultSID,Consult$.STA3N,Consult$.PatientLocationSID, Consult$.RequestDateTime, Consult$.FromLocationSID, ConsultActivity$.ActivityDateTime, ConsultActivity$.Activity, 
                      Consult$.ToRequestServiceName, Consult$.AttentionToStaffSID, Consult$.CPRSStatus, TestInstitutionDIM$.InstitutionIEN, Consult$.FileEntryVistaDate,
                      ConsultActivity$.ActivityEntryVistaDate,Consult$.ConsultIEN ,TestInstitutionDIM$.InstitutionName,Consult$.ToRequestServiceSID,Consult$.PatientSID
INTO ConsultStation1$
FROM          (Consult$ INNER JOIN
                      ConsultActivity$ ON Consult$.ConsultSID = ConsultActivity$.ConsultSID
                      JOIN
                      TestInstitutionDIM$ ON Consult$.OrderingInstitutionSID = TestInstitutionDIM$.InstitutionSID)
                      JOIN
                      TestOutpatientEncounter$ ON Consult$.PatientSID = TestOutpatientEncounter$.PatientSID
WHERE  (Consult$.ToRequestServiceName LIKE '%MH%' OR Consult$.ToRequestServiceName LIKE '%MENTAL%') AND(TestInstitutionDIM$.InstitutionIEN = '580')
       
ORDER BY ConsultActivity$.ActivityDateTime