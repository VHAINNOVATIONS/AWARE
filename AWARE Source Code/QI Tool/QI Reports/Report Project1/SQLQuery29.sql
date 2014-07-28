DROP TABLE ClinicType20$ select cc.STA3N,cc.consultSID,da.StopCode,cc.ToRequestServiceName, da.StopCodeSID,
ll.PrimaryStopCode as ReferringPrimaryStopCode,
ll.SecondaryStopCode as ReferringSecondaryStopCode,cc.ToRequestServiceSID,
cc.PatientLocationSID,cc.RequestDateTime,cc.FromLocationSID,
cc.AttentionToStaffSID,cc.CPRSStatus,
cc.FileEntryVistaDate,cc.ConsultIEN,
cc.PatientSID,cc.OrderingInstitutionSID,cc.RoutingInstitutionSID
INTO ClinicType20$
FROM ClinicType19$ as cc 

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
