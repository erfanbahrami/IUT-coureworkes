--------------------------------------------------------------------------------
--procedure getting the name of teacher (input: EID of teacher)
create procedure GetTeacher (@ID char(8))
as
begin 
select First_Name , Last_Name from Employee_Pv where Employee_Pv.EID=@ID
end

--select * from Employee_Pv
--Execute GetTeacher 10010101

--------------------------------------------------------------------------------
--procedure add to salary ( input: percent of adding to salary)

create procedure add_base_salary (@percent smallint)
as
begin
update Employee
set Base_Salary = Base_Salary + (Base_Salary * @percent / 100) 
end

--select * from Employee 
--execute add_base_salary 10
--select * from Employee

--------------------------------------------------------------------------------
--function (input: EID and day		output: list of classes of teacher)

create function class_info(@ID char(8),@d nvarchar(9)) returns table
as

return (
select	*
from	Class
where	EID=@ID and Class.day=@d 
)

--select * from Class
--select * from class_info(10010101,'شنبه')
--------------------------------------------------------------------------------
-- promote ( + or -) for a special employee by increase/decrease salary

create procedure promotion ( @ID char(8), @percent tinyint)
as
begin
update Employee 
set Base_Salary = Base_Salary + ( Base_Salary * @percent /100 )
where EID=@ID
end

--select * from Employee
--exec promotion 10040103 , 10 
--select * from Employee
