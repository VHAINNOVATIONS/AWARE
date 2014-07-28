DROP TABLE ClinicType12$ SELECT DISTINCT TestStopCOdeDim$.StopCodeSID,TestStopCOdeDim$.StopCode,TestStopCOdeDim$.Sta3n,TestStopCOdeDim$.StopCodeName,
                         TestAssociatedStopCodes$.StopCodeSID as StopCodeSID1,ClinicType11$.ConsultSID,ClinicType11$.ToRequestServiceName
                                         
INTO      ClinicType12$                      
FROM         TestStopCOdeDim$
                      INNER JOIN
                      TestAssociatedStopCodes$ ON TestStopCOdeDim$.StopCodeSID = TestAssociatedStopCodes$.StopCodeSID 
                      RIGHT OUTER JOIN
                      ClinicType11$ ON TestAssociatedStopCodes$.RequestServiceSID = ClinicType11$.ToRequestServiceSID
WHERE     ((TestStopCOdeDim$.StopCode BETWEEN 500 AND 600)and(TestStopCOdeDim$.Sta3n=580))
          AND (ClinicType11$.ToRequestServiceName LIKE '%MH%' OR ClinicType11$.ToRequestServiceName LIKE '%MENTAL%' OR ClinicType11$.ToRequestServiceName LIKE '%PSY%')
          