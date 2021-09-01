/*  run this queries one by one

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
--function (input: EID and day		output: list of classes of teacher)

create function class_info(@ID char(8),@d nvarchar(9)) returns table

as
return 
(
	select	*
	from	Class
	where	EID=@ID and Class.day=@d 
)


