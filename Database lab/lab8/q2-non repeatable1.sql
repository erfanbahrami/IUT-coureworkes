/* run script1 then script2. */

begin tran;

select NameStyle 
from Person.Person 
where BusinessEntityID = 1;

waitfor delay '00:00:07';

select NameStyle 
from Person.Person 
where BusinessEntityID = 1;

commit;