
GO
IF OBJECT_ID (N'dbo.ufnConfirmVistaHoursMinutes', N'FN') IS NOT NULL
    DROP FUNCTION ufnConfirmVistaHoursMinutes;
GO
CREATE FUNCTION dbo.ufnConfirmVistaHoursMinutes(@VistaDateProductID int)
RETURNS int 
AS 
-- Returns the stock level for the product.
BEGIN
    DECLARE @ret int;
    SELECT @ret = SUM(p.Quantity) 
    FROM Production.ProductInventory p 
    WHERE p.ProductID = @ProductID 
        AND p.LocationID = '6';
     IF (@ret IS NULL) 
        SET @ret = 0;
    RETURN @ret;
END;
GO


DROP TABLE ClinicType23$ SELECT DISTINCT   ClinicType22$.ConsultSID,ClinicType22$.STA3N,ClinicType22$.PatientLocationSID, ClinicType22$.RequestDateTime, ClinicType22$.FromLocationSID, 
                      ClinicType22$.ToRequestServiceName, ClinicType22$.AttentionToStaffSID, ClinicType22$.CPRSStatus, ClinicType22$.InstitutionIEN, ClinicType22$.FileEntryVistaDate,
                      ClinicType22$.ConsultIEN ,ClinicType22$.InstitutionName,ClinicType22$.ToRequestServiceSID,ClinicType22$.PatientSID,
                      ClinicType22$.VisitVistaDate,ClinicType22$.PrimaryStopCode,ClinicType22$.LocationName,
                      ClinicType22$.Sta3n1,ClinicType22$.PrimaryStopCodeSID,ClinicType22$.StopCodeSID,
                      ClinicType22$.StopCodeName,ClinicType22$.VisitSID,ClinicType22$.LocationSID,ClinicType22$.AppointmentDateTime,
                      ClinicType22$.VisitCreatedDate,ClinicType22$.OrderingInstitutionSID,ClinicType22$.RoutingInstitutionSID
                      
INTO ClinicType23$
FROM          ClinicType22$
                       
WHERE ((Cast (Substring(STR(ClinicType22$.VisitVistaDate,11,3),1,3)as INT)+1700) = YEAR(ClinicType22$.AppointmentDateTime))AND (Cast (Substring(STR(ClinicType22$.VisitVistaDate,11,3),4,2)as INT) = MONTH(ClinicType22$.AppointmentDateTime)) AND
      (Cast (Substring(STR(ClinicType22$.VisitVistaDate,11,3),6,2)as INT) = DAY(ClinicType22$.AppointmentDateTime)) AND
      (CASE WHEN
           (LEN(STR(ClinicType22$.VisitVistaDate,12,4))=9) AND (Cast(Substring(STR(ClinicType22$.VisitVistaDate,12,4),9,1)AS INT) = Cast(Substring(Cast(Convert(time,ClinicType22$.AppointmentDateTime)as NVARCHAR),1,2) AS INT)) AND 
           (Substring(Cast(Convert(time,ClinicType22$.AppointmentDateTime)as NVARCHAR),4,2) ='00')
        THEN 
        'true'
        ELSE 
             (CASE WHEN
                  (LEN(STR(ClinicType22$.VisitVistaDate,12,4))=10)  AND (Cast(Substring(STR(ClinicType22$.VisitVistaDate,12,4),9,2) as INT) = Cast(Substring(Cast(Convert(time,ClinicType22$.AppointmentDateTime)as NVARCHAR),1,2) AS INT) AND
                  (Substring(Cast(Convert(time,ClinicType22$.AppointmentDateTime)as NVARCHAR),4,2)) ='00')
              THEN 
              'true'
               ELSE 
                     (CASE WHEN
                         (LEN(STR(ClinicType22$.VisitVistaDate,12,4))=11)  AND (Cast(Substring(STR(ClinicType22$.VisitVistaDate,12,4),9,2) as INT) = Cast(Substring(Cast(Convert(time,ClinicType22$.AppointmentDateTime)as NVARCHAR),1,2) AS INT)) AND
                         (Cast((Substring(STR(ClinicType22$.VisitVistaDate,12,4),11,1)+'0') AS INT) =Cast(Substring(Cast(Convert(time,ClinicType22$.AppointmentDateTime)as NVARCHAR),4,2) as INT))
                      THEN 
                      'true'
                      ELSE
                           (CASE WHEN
                                 (LEN(STR(ClinicType22$.VisitVistaDate,12,4))>=12) AND (Substring(STR(ClinicType22$.VisitVistaDate,12,4),9,4) = Substring(Cast(Convert(time,ClinicType22$.AppointmentDateTime)as NVARCHAR),1,2)+ Substring(Cast(Convert(time,ClinicType22$.AppointmentDateTime)as NVARCHAR),4,2))
                           THEN 
                            'true'
                           ELSE 
                           'false'
                           END)
                      END)
              END)
        
       
        END) 
      