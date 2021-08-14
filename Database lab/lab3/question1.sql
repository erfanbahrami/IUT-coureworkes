create login erfan_bahrami
with password = '1234'

create server role role5

alter server role dbcreator
add member role5

grant alter any database
to role5

alter server role role5
add member erfan_bahrami
