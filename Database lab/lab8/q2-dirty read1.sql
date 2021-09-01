/* run script 1 then script 2. */

begin tran;

update Person.Person
set FirstName = 'dirty read test'
where BusinessEntityID = 1;

waitfor delay '00:00:07'; 

rollback transaction;