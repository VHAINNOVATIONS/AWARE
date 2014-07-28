SELECT  DISTINCT   Consult$.ConsultSID,Consult$.STA3N,Consult$.PatientLocationSID, 
Consult$.RequestDateTime, Consult$.FromLocationSID, 
ConsultActivity$.ActivityDateTime, ConsultActivity$.Activity, 
                      Consult$.ToRequestServiceName, Consult$.AttentionToStaffSID, 
Consult$.CPRSStatus, TestInstitutionDIM$.InstitutionIEN, 
TestOutpatientEncounter$.VisitVistaDate, Consult$.FileEntryVistaDate,
                      ConsultActivity$.ActivityEntryVistaDate
FROM         Consult$ INNER JOIN
                      ConsultActivity$ ON Consult$.ConsultSID = 
ConsultActivity$.ConsultSID
                      JOIN
                      TestInstitutionDIM$ ON Consult$.OrderingInstitutionSID = 
TestInstitutionDIM$.InstitutionSID
             TestOutpatientEncounter$
WHERE  (Consult$.ToRequestServiceName LIKE '%MH%' OR Consult$.ToRequestServiceName 
LIKE '%MENTAL%') AND(TestInstitutionDIM$.InstitutionIEN = '580') AND
       (TestOutpatientEncounter$.VisitVistaDate 
IN (Fields!Consult$.FileEntryVistaDate.Value,Fields!ConsultActivity$.ActivityEntryVi
staDate.Value)
ORDER BY ConsultActivity$.ActivityDateTime