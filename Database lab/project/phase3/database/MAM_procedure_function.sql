/*create procedure GetStuNum(@name nvarchar(50),@ID integer output)
as
begin
select @ID = SID from Student where CONCAT(First_Name, ' ' ,Last_Name) = @name;
end
*/
/*   run this queries one by one
create procedure add_price_percentage(@percent int)
as begin
update Term
Set Session_Price = Session_Price + (Session_Price * @percent /100);
end


create function attendance_state(@name nvarchar(50),@TermId tinyint) returns integer
as
begin 
declare @student_Id integer;
declare @session_count integer;
declare @attendance_count integer;
select @student_Id = SID from Student where CONCAT(First_Name, ' ' ,Last_Name) = @name;
select @attendance_count = count(Attendance.Attendance) from Attendance 
where Term_Id = @TermId and SID = @student_Id ;
select @session_count = Session_Count from Term where Term_ID = @TermId;
return (@attendance_count % @session_count)
end


create function attendance_state_ByCode(@student_Id char(8),@TermId tinyint) returns int
as 
begin 
declare @attendance_count int;
declare @session_count int;
select @attendance_count = count(Attendance.Attendance) from Attendance 
where Term_Id = @TermId and SID = @student_Id ;
select @session_count = Session_Count from Term where Term_ID = @TermId;
return (@attendance_count % @session_count)
end
*/


create procedure update_username @username varchar(15),@password varchar(12)
as
begin
update USERS
set username = @username
,password = @password
where username = @username  
end




-- drop function attendance_state_ByCode
-- drop function attendance_state
-- drop procedure GetStuNum
-- drop procedure add_price_percentage

