use master
go

if DB_ID('Obesity_Centre_DB') is not null
	drop database Obesity_Centre_DB
go

create database Obesity_Centre_DB
go

use Obesity_Centre_DB
go

create table address_tbl
(
id				int identity primary key,
[address]		varchar (30)
)
go

create table bill_tbl
(
id			    int identity primary key,
amount			money,
discount	    money
)
go

create table calorie_tbl
(
id					 int identity primary key,
prescribed_calorie	 int
)
go

create table disease_tbl
(
id				int identity primary key,
diseasename		varchar(25)
)
go

create table dietitian
(
id					int identity primary key,
dietitianname		varchar(60),
phone				varchar(11),
addressid		    int references address_tbl(id)
)

create table patient
(
id				int identity primary key,
pname			varchar(40),
phone			varchar(11),
age				int,
height			int,
[weight]		int,
addressid		int references address_tbl(id),
dietitianid		int references dietitian(id),
billid			int references bill_tbl(id),
cid				int references calorie_tbl(id),
diseaseid	    int references disease_tbl(id)
)
GO

--sproc
create proc sp_address
@address varchar(30)
as
begin
	insert into address_tbl([address]) values(@address)
end
go

create proc sp_bil
@amount money, @discount money
as
begin
	insert into bill_tbl(amount, discount) values(@amount, @discount)
end
go

create proc sp_calorie
@pCalorie int
as
begin
	insert into calorie_tbl(prescribed_calorie) values(@pCalorie)
end
go


create proc sp_disease
@disease varchar(25)
as
begin
	insert into disease_tbl(diseasename) values(@disease)
end
go

create proc sp_dietitian
@dName varchar(60), @phone varchar(11), @address int
as
begin
	insert into dietitian(dietitianname, phone, addressid) values(@dName, @phone, @address)
end
go

create proc sp_addPatient
@pName varchar(40), @phone varchar(11), @age int, @height int, @weight int, @pAddress int, @dietitian int, @bill int, @calorie int, @disease int
as
begin
	insert into patient(pname, phone, age, height, [weight], addressid, dietitianid, billid, cid, diseaseid) values(@pName, @phone, @age, @height, @weight, @pAddress, @dietitian, @bill, @calorie, @disease)
end
go

create view vw_PatientDetails
as
select pt.id PatientID,
		pname PatientName,
		ad.address Address,
		pt.phone PatientPhone,
		age Age,
		height [Height(inch)],
		[weight] [Weight(kg) ],
		diseasename DiseaseName,
		prescribed_calorie Calorie,
		amount Amount,
		discount Discount,
		amount-discount NetBill,
		dietitianname DietitianName,
		dt.phone DietitianPhone
from address_tbl ad
inner join patient pt
on ad.id=pt.addressid
inner join dietitian dt
on dt.id=pt.dietitianid
inner join bill_tbl bill
on bill.id=pt.billid
inner join calorie_tbl cal
on cal.id=pt.cid
inner join disease_tbl dis
on dis.id=pt.diseaseid
go
create view vw_patient_underweight
as
select pname,age,height,weight
from
patient
where weight<70
go

create proc sp_PatientDetailsByID
@id int
as
begin
	select pt.id PatientID,
		pname PatientName,
		ad.address Address,
		pt.phone PatientPhone,
		age Age,
		height [Height (inch)],
		[weight] [Weight (kg)],
		diseasename DiseaseName,
		prescribed_calorie Calorie,
		amount Amount,
		discount Discount,
		amount-discount NetBill,
		dietitianname DietitianName,
		dt.phone DietitianPhone
	from address_tbl ad
	inner join patient pt
	on ad.id=pt.addressid
	inner join dietitian dt
	on dt.id=pt.dietitianid
	inner join bill_tbl bill
	on bill.id=pt.billid
	inner join calorie_tbl cal
	on cal.id=pt.cid
	inner join disease_tbl dis
	on dis.id=pt.diseaseid
	where pt.id = @id
end

--update sp
GO
create proc sp_patientupdateinfo
@pid int,@we int,@bi money,@pcal int
as
begin 
	update patient 
	set weight=@we,billid=@bi,cid=@pcal	
	where id=@pid
end
---TRIGGER
go
Create trigger Tr_bill
On bill_tbl
Instead of Insert
As
Begin
	declare	@amo int
	select @amo=amount from inserted
	if @amo>=700
		Begin
		Begin tran
			Begin try				
					insert into bill_tbl	
					select  amount,discount from inserted
				Commit tran
			end try
			begin catch
				print 'Error occured for ' + Error_Message()
				rollback tran
			end catch
		End
		else	
			print 'bill not excepted'
End
go
---scaler function
go
create function fn_sumofnetbill()
returns money
as
begin
       declare @total money
	   select @total= sum(amount-discount) from bill_tbl
	   where amount>700
	   return @total
end
go
--table function
create function FN_patient_details (@pid int)
Returns table
as
return
	Select * from vw_PatientDetails where PatientID=@pid
---index
go
create index in_pname
on patient (pname asc)


