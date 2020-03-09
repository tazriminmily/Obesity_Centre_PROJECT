use Obesity_Centre_DB
go
--inserting data
--address_tbl
exec sp_address 'Shantinagar'
exec sp_address 'Dhanmondi'
exec sp_address 'Mohammodpur'
exec sp_address 'Mirpur'
exec sp_address 'kolabagan'
exec sp_address 'Ajimpur'
---bill_tbl
go
exec sp_bil 1200, 300
exec sp_bil 700, 0
exec sp_bil 1500, 200
exec sp_bil 2000, 400
exec sp_bil 1600, 300
exec sp_bil 600,0
--calorie_tbl
go

exec sp_calorie 1100
exec sp_calorie 1200
exec sp_calorie 1300
exec sp_calorie 1400
exec sp_calorie 1500
exec sp_calorie 1600
--disease_tbl
go
exec sp_disease 'Over Weight'
exec sp_disease 'Under Weight'
exec sp_disease 'Diabetes'
exec sp_disease 'Liver problem'
exec sp_disease 'Kidney problem'
exec sp_disease 'Hypothyroidism'
--dietitian
go
exec sp_dietitian 'Rashida begum ', '01711523652', 1
exec sp_dietitian 'Romena khanom' , '01716666521', 2
exec sp_dietitian 'Sazida akter'  , '01717866521', 4
exec sp_dietitian 'Omoni  sharif' , '01957766521', 6
---patient
go

exec sp_addPatient 'Aysha Ajim'     ,'01680678904', 26, 61, 95, 2, 1, 1, 1, 1
exec sp_addPatient 'Rabbi Rahat'	,'01700709840', 20, 70, 100, 6, 2, 3, 1, 4
exec sp_addPatient 'Jaman Ali'	    ,'01282070987', 56, 67, 70, 5, 2, 2, 2, 5
exec sp_addPatient 'Shayla Karim'   ,'01258877065', 25, 64, 112, 1, 3, 5, 1, 1
exec sp_addPatient 'Ebrahim Kabir'  ,'01965432187', 27, 69, 56, 3, 4, 5, 6, 2
exec sp_addPatient 'Rebeka Basir'   ,'01765439787', 36, 63, 96, 6, 3, 4, 1, 3
exec sp_addPatient 'Jarif Khan'     ,'01765799876', 29, 71, 88, 4, 1, 3, 2, 6
exec sp_addPatient 'Ishita Renu'    ,'01543290752', 30, 64,106, 1, 2, 4, 1, 4
exec sp_addPatient 'Nijam Chowdhery','01655677767', 24, 68, 70, 1, 4, 2, 2, 5
exec sp_addPatient 'Jerin Jannat'   ,'01569802882', 19, 60, 38, 6, 1, 4, 5, 2
go
select* from patient
select* from dietitian
select* from address_tbl
select* from disease_tbl
select* from calorie_tbl
select *from bill_tbl

go
--view all patient
select * from vw_PatientDetails
--view underweight patient
go
select * from vw_patient_underweight
---Call table valued function
select  * from FN_patient_details(1)
go
--all pay amount 
select dbo.fn_sumofnetbill()as pay_ammount

--search by sp
go
exec sp_PatientDetailsByID 2
--update sp
go
exec sp_patientupdateinfo 1, 85,2,2
--search patient by patient id number
go
exec sp_PatientDetailsByID 2
---index
go
exec sp_helpindex patient