/*create procedure update_academy(@Reg_Num varchar(25)
,@Found_Date date,@Founder_Name nvarchar(50)
,@Email varchar(40),@website varchar(40),@Tel char(11)
,@Address nvarchar(max),@Name nvarchar(30))
as 
begin
update academy 
set 
Name = @Name,Address = @Address,Email = @Email,
Found_Date = @Found_Date,
Founder_Name = @Founder_Name,
Website = @website,
Tel = @Tel
where Reg_Num = @Reg_Num;
return 1
 end
 */
 /*
 create procedure update_Attendance @sid char(8),@TermId tinyint
 ,@DateTime datetime,@Attendance bit,@Allowed bit
 as 
 begin 
 update Attendance
 set 
 Attendance = @Attendance,
 Allowed = @Allowed
 where
 SID = @sid and Term_ID = @TermId
 and Date_Time = @DateTime
 end*/
 /*
 create procedure update_Class @Number nvarchar(6),@day nvarchar(8)
 ,@hour nchar(5),@EID char(8),@Instr_name nvarchar(20),@sid char(8)
 as
 begin
 update Class
 set EID = @EID,
 Instr_Name = @Instr_name,
 SID = @sid
 where Number = @Number and day = @day and hour = @hour
 end
 */
 /*
 create procedure update_Employee @EID char(8),@Base_salary int,@Entrance_Date date
 ,@Exit_date date,@Job nvarchar(15),@OverTime tinyint,@Insurance_Num int
 as begin
 update Employee 
 set Base_Salary = @Base_salary,
 Entrance_Date = @Entrance_Date,Exit_Date = @Exit_date,
 Job = @Job,Overtime = @OverTime,Insurance_Num = @Insurance_Num
 where EID = @EID
 end
 */
 /*
 create procedure update_Employee_Pv @EID char(8),@FirstName nvarchar(20),
 @LastName nvarchar(30),@BirthDate date,@National_Code char(10),@Phone char(11)
 ,@Tel char(11),@Address nvarchar(max),@Marital bit
 as 
 begin
 update Employee_Pv 
 set
 First_Name = @FirstName
 ,Last_Name = @LastName
 ,Birth_Date = @BirthDate
 ,National_Code = @National_Code
 ,Phone = @Phone
 ,Tel = @Tel
 ,Address = @Address
 ,Marital = @Marital
 where EID = @EID
 end
 */
 /*
 create procedure update_student @SID char(8),@First_Name nvarchar(20)
 ,@Last_Name nvarchar(30),@BirthDate date,@NationalCode char(10)
 ,@Phone Char(11),@Tel char(11)	,@Address nvarchar(max)
 as 
 begin
 update Student 
 set 
 First_Name = @First_Name
 ,Last_Name = @Last_Name
 ,Birth_Date = @BirthDate
 ,National_Code = @NationalCode
 ,Phone = @Phone
 ,Tel = @Tel
 ,Address = @Address
 where SID = @SID
 end
 */
 /*
 create procedure update_Term @TermID tinyint ,@EID char(8),@Instr_name nvarchar(20)
 ,@Session_Count tinyint,@Session_price int,@Session_Time tinyint
 as 
 begin
 update Term
 set 
 EID = @EID,
 Instr_Name = @Instr_name
 ,Session_Count = @Session_Count
 ,Session_Price = @Session_price
 ,Session_Time = @Session_Time
 where Term_ID = @TermID
 end
 */

create procedure update_username @username varchar(25),@password varchar(22)
as
begin
update USERS
set username = @username
,password = @password
where username = @username	
end

