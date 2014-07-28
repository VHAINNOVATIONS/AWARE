DROP TABLE ClinicType15$ SELECT l7.STA3N, l7.ConsultSID,l7.PrimaryStopCode
INTO ClinicType15$
FROM ClinicType7$ as l7
UNION
SELECT ClinicType13$.STA3N,ClinicType13$.ConsultSID,ClinicType13$.StopCode
FROM ClinicType13$
ORDER BY 2;