DROP TABLE ClinicType17$ SELECT ClinicType15$.STA3N,ClinicType15$.ConsultSID,ClinicType15$.PrimaryStopCode as StopCode,ClinicTypeStaticMap$.ClinicType
INTO ClinicType17$
FROM ClinicType15$
JOIN ClinicTypeStaticMap$
     ON ClinicType15$.PrimaryStopCode = ClinicTypeStaticMap$.StopCode