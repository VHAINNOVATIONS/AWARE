DROP TABLE ClinicType3$ SELECT DISTINCT   Consult$.ConsultSID,Consult$.STA3N,Consult$.PatientLocationSID, Consult$.RequestDateTime, Consult$.FromLocationSID, 
                      Consult$.ToRequestServiceName, Consult$.AttentionToStaffSID, Consult$.CPRSStatus, TestInstitutionDIM$.InstitutionIEN, Consult$.FileEntryVistaDate,
                      Consult$.ConsultIEN ,TestInstitutionDIM$.InstitutionName,Consult$.ToRequestServiceSID,Consult$.PatientSID,
                      TestOutpatientEncounter$.VisitVistaDate,TestOutpatientEncounter$.PrimaryStopCode,TestLocationDim$.LocationName,
                      TestOutpatientEncounter$.Sta3n1,TestOutpatientEncounter$.PrimaryStopCodeSID,TestAssociatedStopCodes$.StopCodeSID,
                      TestStopCOdeDim$.StopCodeName,ConsultActivity$.Activity,TestAppointment$.VisitSID
INTO ClinicType3$
FROM          (Consult$ 
                        INNER JOIN
                      ConsultActivity$ on Consult$.ConsultSID =  ConsultActivity$.ConsultSID 
                        INNER JOIN
                      TestOutpatientEncounter$ on Consult$.PatientSID = TestOutpatientEncounter$.PatientSID
                        INNER JOIN
                      TestAppointment$  ON TestOutpatientEncounter$.VisitSID =  TestAppointment$.VisitSID
                        JOIN
                      TestLocationDim$  ON TestOutpatientEncounter$.LocationSID = TestLocationDim$.LocationSID
                        JOIN
                      TestInstitutionDIM$ ON Consult$.OrderingInstitutionSID = TestInstitutionDIM$.InstitutionSID
                        JOIN
                      TestAssociatedStopCodes$ ON TestOutpatientEncounter$.PrimaryStopCodeSID = TestAssociatedStopCodes$.StopCodeSID
                        JOIN
                      TestStopCOdeDim$ ON TestAssociatedStopCodes$.StopCodeSID = TestStopCOdeDim$.StopCodeSID)
WHERE  (Consult$.ToRequestServiceName LIKE '%MH%' OR Consult$.ToRequestServiceName LIKE '%MENTAL%' OR Consult$.ToRequestServiceName LIKE '%PSY%') AND(TestInstitutionDIM$.InstitutionIEN = '580') AND (TestOutpatientEncounter$.VisitVistaDate<(Consult$.FileEntryVistaDate +130))
                      AND (TestOutpatientEncounter$.VisitVistaDate>=(Consult$.FileEntryVistaDate)) AND (((TestOutpatientEncounter$.PrimaryStopCode >499) AND (TestOutpatientEncounter$.PrimaryStopCode <600))OR ((TestOutpatientEncounter$.PrimaryStopCode >210) AND (TestOutpatientEncounter$.PrimaryStopCode <231)))
                      AND ((Consult$.CPRSStatus  !='DISCONTINUED' ) AND (Consult$.CPRSStatus != 'CANCELLED' ))
ORDER BY
       Consult$.ConsultSID,ConsultActivity$.Activity,TestOutpatientEncounter$.PrimaryStopCode                      
