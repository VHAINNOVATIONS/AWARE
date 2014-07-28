DROP TABLE ClinicType14$ SELECT ClinicType11$.STA3N,ClinicType11$.ConsultSID,ClinicType11$.ToRequestServiceSID,ClinicType11$.ToRequestServiceName,ClinicType11$.PatientLocationSID
INTO ClinicType14$
FROM   ClinicType11$
       LEFT JOIN ClinicType7$
       ON ClinicType11$.ConsultSID = ClinicType7$.ConsultSID
WHERE ClinicType7$.PrimaryStopCode IS NULL