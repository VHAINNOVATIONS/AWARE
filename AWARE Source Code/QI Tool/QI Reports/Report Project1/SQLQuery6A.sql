IF OBJECT_ID (N'dbo.ufnConfirmVistaDateGTDateTime', N'FN') IS NOT NULL
    DROP FUNCTION ufnConfirmVistaDateGTDateTime;
GO
CREATE FUNCTION dbo.ufnConfirmVistaDateGTDateTime(@VisitVistaDate float,@AppointmentDateTime datetime)
RETURNS int
AS 
-- Returns comparison of date ( year, month, day and hours and minutes) for 2 dates passed as 'true' or 'false'
BEGIN
    DECLARE @ret int;
   /* DECLARE @monthday1 int;
    DECLARE @monthday2 int;*/
    /*SET @monthday1=Cast (Substring(STR(@VisitVistaDate,11,3),4,2)as INT)*100+Cast (Substring(STR(@VisitVistaDate,11,3),6,2)as INT)
    SET @monthday2=(MONTH(@AppointmentDateTime)+100)+DAY(@AppointmentDateTime)
    */
    SET @ret =0
    /*CASE 
        WHEN 
            ((Cast (Substring(STR(@VisitVistaDate,11,3),1,3)as INT)+1700) = YEAR(@AppointmentDateTime))AND (@monthday2>=@monthday1) AND ((@monthday2-@monthday1)<130)
        THEN 1
        WHEN 
            ((Cast (Substring(STR(@VisitVistaDate,11,3),1,3)as INT)+1700) = (YEAR(@AppointmentDateTime)-1)) AND (((@monthday2+1200)-@monthday1)<130)
        THEN 1
        ELSE 0    
    END*/
    return @ret 
END;

GO

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
WHERE  (Consult$.ToRequestServiceName LIKE '%MH%' OR Consult$.ToRequestServiceName LIKE '%MENTAL%' OR Consult$.ToRequestServiceName LIKE '%PSY%') AND (YEAR(Consult$.RequestDateTime)=2000) AND (MONTH(Consult$.RequestDateTime)<=3) AND (dbo.ufnConfirmVistaDateGTDateTime(TestOutpatientEncounter$.VisitVistaDate,Consult$.RequestDateTime)=1)  
                     AND (((TestOutpatientEncounter$.PrimaryStopCode >499) AND (TestOutpatientEncounter$.PrimaryStopCode <600))OR ((TestOutpatientEncounter$.PrimaryStopCode >210) AND (TestOutpatientEncounter$.PrimaryStopCode <231)))
                      AND ((Consult$.CPRSStatus  !='DISCONTINUED' ) AND (Consult$.CPRSStatus != 'CANCELLED' ) AND (TestAppointment$.PatientSID = Consult$.PatientSID) ) 
ORDER BY
       Consult$.ConsultSID,TestOutpatientEncounter$.PrimaryStopCode,TestAppointment$.AppointmentDateTime
