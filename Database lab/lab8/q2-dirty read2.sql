/* run script 1 then script 2.  */

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED; 

select *
from Person.Person
order by BusinessEntityID