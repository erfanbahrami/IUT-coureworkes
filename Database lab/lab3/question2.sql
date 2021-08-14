revoke create table, insert, select
on database :: AdventureWorks2012
to erfan_bahrami


use AdventureWorks2012

create role role2

alter role db_securityadmin
add member role2

alter role role2
add member erfan

alter role db_datareader
add member role2
