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