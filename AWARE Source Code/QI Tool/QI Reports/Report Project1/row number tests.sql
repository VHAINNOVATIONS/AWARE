







DROP TABLE ClinicType24$ SELECT ClinicType21$.STA3N,ClinicType21$.ConsultSID,ClinicType21$.PrimaryStopCode,ClinicTypeStaticMap$.ClinicType,
ClinicType21$.ToRequestServiceName, ClinicType21$.StopCodeSID,
ClinicType21$.ToRequestServiceSID,
ClinicType21$.PatientLocationSID,ClinicType21$.RequestDateTime,ClinicType21$.FromLocationSID,
ClinicType21$.AttentionToStaffSID,ClinicType21$.CPRSStatus,
ClinicType21$.FileEntryVistaDate,ClinicType21$.ConsultIEN,
ClinicType21$.PatientSID,ClinicType21$.OrderingInstitutionSID,ClinicType21$.RoutingInstitutionSID,
ClinicType21$.ConsultInitiationDate,ClinicType21$.WaitTime,ClinicType21$.WaitTimeGT15DaysWoVisit,
ClinicType21$.CancelledAppointmentYesNo,ClinicType21$.DiscontinuedAppointmentYesNo,ClinicType21$.NextScheduledAppt,
ROW_NUMBER() OVER (partition by ClinicType21$.STA3N,ClinicType21$.ConsultSID,ClinicType21$.NextScheduledAppt ORDER BY ClinicType21$.STA3N,ClinicType21$.ConsultSID,ClinicType21$.NextScheduledAppt ASC) AS ROWNUMBER
INTO ClinicType24$
FROM ClinicType21$
WHERE ROWNUMBER=1
GROUP BY ClinicType21$.STA3N,ClinicType21$.ConsultSID,ClinicType21$.NextScheduledAppt


SELECT *, ROW_NUMBER() OVER (partition by A ORDER BY B desc) AS RowNumber 
FROM T

/*
PK	A	B	C	RowNumber
1	0	1	8	1
2	0	3	6	2
3	0	5	4	3
4	0	7	2	4
5	0	9	0	5
6	1	0	9	1
7	1	2	7	2
8	1	4	5	3
9	1	6	3	4
10	1	8	1	5
*/

select *
  from (
    select PK, A, B, C
            group by A
            Having A=MAX(A) 
        )  
        
go


SELECT *, ROW_NUMBER() OVER (partition by A ORDER BY B desc) AS RowNumber 
FROM T        

SELECT *, ROW_NUMBER() OVER (partition by A ORDER BY PK) AS RowNumber 
FROM T        
       
        
  