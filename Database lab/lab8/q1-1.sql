/* run script 1 then script 2. selectt query will not return result til update transaction be commited */

begin transaction;

update Person.Person
set FirstName = 'Ken'
where BusinessEntityID = 1;

waitfor delay '00:00:07';

commit;
