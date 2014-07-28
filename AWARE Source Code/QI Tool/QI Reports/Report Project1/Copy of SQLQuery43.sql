DROP TABLE ClientType12$ SELECT DISTINCT TestStopC0deDim$.StopCodeSID,TestStopC0deDim$.StopCode,TestStopC0deDim$.Sta3n,TestStopC0deDim$.StopCodeName,Consult$.RequestDateTime, Consult$.RequestType, 
                      Consult$.DisplayTextOfItemOrdered, Consult$.InpatOutpat, Consult$.ProcedureRequestType, Consult$.Result, Consult$.Urgency, 
                      TestAssociatedStopCodes$.StopCodeSID
INTO      ClientType12$                      
FROM         TestStopCOdeDim$ INNER JOIN
                      TestAssociatedStopCodes$ ON TestStopCOdeDim$.StopCodeSID = TestAssociatedStopCodes$.StopCodeSID
                      RIGHT OUTER JOIN
                      Consult$ ON TestAssociatedStopCodes$.RequestServiceSID = Consult$.ToRequestServiceSID
WHERE     (Consult$.RequestDateTime > CONVERT(DATETIME, '2012-08-01 00:00:00', 102)) AND ((TestStopCOdeDim$.StopCode BETWEEN 500 AND 600)and(TestStopCodeDim$.Sta3n=580))
          AND (Consult$.ToRequestServiceName LIKE '%MH%' OR Consult$.ToRequestServiceName LIKE '%MENTAL%' OR Consult$.ToRequestServiceName LIKE '%PSY%')