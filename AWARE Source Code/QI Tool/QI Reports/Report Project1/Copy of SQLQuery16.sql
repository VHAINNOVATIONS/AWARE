DROP TABLE ClinicType9$ SELECT DISTINCT ClinicType8$.STA3N,ClinicType7$.ConsultSID as ConsultSID1
INTO  ClinicType9$
FROM  ClinicType8$,ClinicType7$
                                            
WHERE  ClinicType8$.ConsultSID != ClinicType7$.ConsultSID 