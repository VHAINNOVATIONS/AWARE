DROP TABLE ClinicType8$ SELECT DISTINCT   Consult$.STA3N,Consult$.ConsultSID,Consult$.PatientLocationSID, Consult$.RequestDateTime, Consult$.FromLocationSID, 
                      Consult$.ToRequestServiceName, Consult$.AttentionToStaffSID, Consult$.CPRSStatus, TestInstitutionDIM$.InstitutionIEN, Consult$.FileEntryVistaDate,
                      Consult$.ConsultIEN ,TestInstitutionDIM$.InstitutionName,Consult$.ToRequestServiceSID,Consult$.PatientSID,Consult$.OrderingInstitutionSID,
                      Consult$.RoutingInstitutionSID
                      
                      
INTO ClinicType8$
FROM          (Consult$ 
                        JOIN
                      TestInstitutionDIM$ ON Consult$.OrderingInstitutionSID = TestInstitutionDIM$.InstitutionSID)
                      
WHERE  (Consult$.ToRequestServiceName LIKE '%MH%' OR Consult$.ToRequestServiceName LIKE '%MENTAL%' OR Consult$.ToRequestServiceName LIKE '%PSY%') AND(TestInstitutionDIM$.InstitutionIEN = '580')



DROP TABLE ClinicType5$ SELECT DISTINCT   Consult$.ConsultSID,Consult$.STA3N,Consult$.PatientLocationSID, Consult$.RequestDateTime, Consult$.FromLocationSID, 
                      Consult$.ToRequestServiceName, Consult$.AttentionToStaffSID, Consult$.CPRSStatus, TestInstitutionDIM$.InstitutionIEN, Consult$.FileEntryVistaDate,
                      Consult$.ConsultIEN ,TestInstitutionDIM$.InstitutionName,Consult$.ToRequestServiceSID,Consult$.PatientSID,
                      TestOutpatientEncounter$.VisitVistaDate,TestOutpatientEncounter$.PrimaryStopCode,TestLocationDim$.LocationName,
                      TestOutpatientEncounter$.Sta3n1,TestOutpatientEncounter$.PrimaryStopCodeSID,TestAssociatedStopCodes$.StopCodeSID,
                      TestStopCOdeDim$.StopCodeName,TestAppointment$.VisitSID,TestAppointment$.LocationSID,TestAppointment$.AppointmentDateTime,
                      TestOutpatientEncounter$.VisitCreatedDate,Consult$.OrderingInstitutionSID,Consult$.RoutingInstitutionSID
                      
INTO ClinicType5$
FROM          (Consult$ 
                        INNER JOIN
                      TestOutpatientEncounter$ on Consult$.PatientSID = TestOutpatientEncounter$.PatientSID
                        INNER JOIN
                      TestAppointment$  ON TestOutpatientEncounter$.LocationSID =  TestAppointment$.LocationSID
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
                      AND ((Consult$.CPRSStatus  !='DISCONTINUED' ) AND (Consult$.CPRSStatus != 'CANCELLED' ) AND (TestAppointment$.PatientSID = Consult$.PatientSID) )
ORDER BY
       Consult$.ConsultSID,TestOutpatientEncounter$.PrimaryStopCode,TestAppointment$.AppointmentDateTime
GO
DROP TABLE ClinicType6$ SELECT DISTINCT   ClinicType5$.ConsultSID,ClinicType5$.STA3N,ClinicType5$.PatientLocationSID, ClinicType5$.RequestDateTime, ClinicType5$.FromLocationSID, 
                      ClinicType5$.ToRequestServiceName, ClinicType5$.AttentionToStaffSID, ClinicType5$.CPRSStatus, ClinicType5$.InstitutionIEN, ClinicType5$.FileEntryVistaDate,
                      ClinicType5$.ConsultIEN ,ClinicType5$.InstitutionName,ClinicType5$.ToRequestServiceSID,ClinicType5$.PatientSID,
                      ClinicType5$.VisitVistaDate,ClinicType5$.PrimaryStopCode,ClinicType5$.LocationName,
                      ClinicType5$.Sta3n1,ClinicType5$.PrimaryStopCodeSID,ClinicType5$.StopCodeSID,
                      ClinicType5$.StopCodeName,ClinicType5$.VisitSID,ClinicType5$.LocationSID,ClinicType5$.AppointmentDateTime,
                      ClinicType5$.VisitCreatedDate,ClinicType5$.OrderingInstitutionSID,ClinicType5$.RoutingInstitutionSID
                      
INTO ClinicType6$
FROM          ClinicType5$
                       
WHERE ((Cast (Substring(STR(ClinicType5$.VisitVistaDate,11,3),1,3)as INT)+1700) = YEAR(ClinicType5$.AppointmentDateTime))AND (Cast (Substring(STR(ClinicType5$.VisitVistaDate,11,3),4,2)as INT) = MONTH(ClinicType5$.AppointmentDateTime)) AND
      (Cast (Substring(STR(ClinicType5$.VisitVistaDate,11,3),6,2)as INT) = DAY(ClinicType5$.AppointmentDateTime)) AND
      (Substring(STR(ClinicType5$.VisitVistaDate,11,3),9,2) = Substring(Cast(Convert(time,ClinicType5$.AppointmentDateTime)as NVARCHAR),1,2))
      AND (Substring(STR(ClinicType5$.VisitVistaDate,11,3),11,1) = Substring(Cast(Convert(time,ClinicType5$.AppointmentDateTime)as NVARCHAR),4,1)) 
GO
DROP TABLE ClinicType7$ SELECT DISTINCT ClinicType6$.STA3N,ClinicType6$.ConsultSID,ClinicType6$.PrimaryStopCode
INTO  ClinicType7$
FROM  ClinicType6$

DROP TABLE ClinicType11$ SELECT DISTINCT   ClinicType8$.STA3N,ClinicType8$.ConsultSID,ClinicType8$.ToRequestServiceSID,ClinicType8$.ToRequestServiceName,ClinicType8$.PatientLocationSID
                      
                      
INTO ClinicType11$
FROM          ClinicType8$ 
      
     
DROP TABLE ClinicType14$ SELECT ClinicType11$.STA3N,ClinicType11$.ConsultSID,ClinicType11$.ToRequestServiceSID,ClinicType11$.ToRequestServiceName,ClinicType11$.PatientLocationSID
INTO ClinicType14$
FROM   ClinicType11$
       LEFT JOIN ClinicType7$
       ON ClinicType11$.ConsultSID = ClinicType7$.ConsultSID
WHERE ClinicType7$.PrimaryStopCode IS NULL     

DROP TABLE ClinicType13$ select cc.STA3N,cc.consultSID,da.StopCode,cc.ToRequestServiceName, da.StopCodeSID,ll.PrimaryStopCode as ReferringPrimaryStopCode,ll.SecondaryStopCode as ReferringSecondaryStopCode
INTO ClinicType13$
FROM ClinicType14$ as cc 

      join 
      TestRequestServiceDim$ on
      cc.ToRequestServiceSID = TestRequestServiceDim$.RequestServiceSID
      join 
     TestAssociatedStopCodes$ as da on
     (TestRequestServiceDim$.RequestServiceSID= da.RequestServiceSID )/*and da.StopCode between 500 and 600*/
     join 
     TestLocationDim$ as ll
     on cc.PatientLocationSID = ll.LocationSID
WHERE     (((da.StopCode > 499) and (da.stopcode <601))OR ((da.StopCode >210) AND (da.StopCode <231))) and (cc.Sta3n='580')
           AND (cc.ToRequestServiceName LIKE '%MH%' OR cc.ToRequestServiceName LIKE '%MENTAL%' OR cc.ToRequestServiceName LIKE '%PSY%')

DROP TABLE ClinicType15$ SELECT l7.STA3N, l7.ConsultSID,l7.PrimaryStopCode
INTO ClinicType15$
FROM ClinicType7$ as l7
UNION
SELECT ClinicType13$.STA3N,ClinicType13$.ConsultSID,ClinicType13$.StopCode
FROM ClinicType13$
ORDER BY 2; 

DROP TABLE ClinicType17$ SELECT ClinicType15$.STA3N,ClinicType15$.ConsultSID,ClinicType15$.PrimaryStopCode as StopCode,ClinicType16$.ClinicType
INTO ClinicType17$
FROM ClinicType15$
JOIN ClinicType16$
     ON ClinicType15$.PrimaryStopCode = ClinicType16$.StopCode            