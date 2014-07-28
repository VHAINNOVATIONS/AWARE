IF OBJECT_ID (N'dbo.ufnConfirmVistaHoursMinutes', N'FN') IS NOT NULL
    DROP FUNCTION ufnConfirmVistaHoursMinutes;
GO
GO
CREATE FUNCTION dbo.ufnConfirmVistaHoursMinutes(@VisitVistaDate float,@AppointmentDateTime datetime)
RETURNS int
AS 
-- Returns comparison of hours and minutes 'true' or 'false'
BEGIN
    DECLARE @ret int;
    SET @ret =
    CASE 
        WHEN (LEN(STR(@VisitVistaDate,12,4))=9) AND (Cast(Substring(STR(@VisitVistaDate,12,4),9,1)AS INT) = Cast(Substring(Cast(Convert(time,@AppointmentDateTime)as NVARCHAR),1,2) AS INT)) AND 
           (Substring(Cast(Convert(time,@AppointmentDateTime)as NVARCHAR),4,2) ='00') THEN 1
        WHEN  (LEN(STR(@VisitVistaDate,12,4))=10)  AND (Cast(Substring(STR(@VisitVistaDate,12,4),9,2) as INT) = Cast(Substring(Cast(Convert(time,@AppointmentDateTime)as NVARCHAR),1,2) AS INT) AND
                  (Substring(Cast(Convert(time,@AppointmentDateTime)as NVARCHAR),4,2)) ='00')   THEN 1
        WHEN  (LEN(STR(@VisitVistaDate,12,4))=11)  AND (Cast(Substring(STR(@VisitVistaDate,12,4),9,2) as INT) = Cast(Substring(Cast(Convert(time,@AppointmentDateTime)as NVARCHAR),1,2) AS INT)) AND
                         (Cast((Substring(STR(@VisitVistaDate,12,4),11,1)+'0') AS INT) =Cast(Substring(Cast(Convert(time,@AppointmentDateTime)as NVARCHAR),4,2) as INT))         THEN 1
        WHEN  (LEN(STR(@VisitVistaDate,12,4))>=12) AND (Substring(STR(@VisitVistaDate,12,4),9,4) = Substring(Cast(Convert(time,@AppointmentDateTime)as NVARCHAR),1,2)+ Substring(Cast(Convert(time,@AppointmentDateTime)as NVARCHAR),4,2))       THEN 1
        ELSE 0    
    END
    return @ret 
END;