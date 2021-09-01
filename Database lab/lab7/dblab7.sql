sp_configure 'show advanced options', 1;
RECONFIGURE;
Go
sp_configure 'Ad Hoc Distributed Queries', 1;
RECONFIGURE;
GO
exec sp_configure 'Advanced', 1 RECONFIGURE
exec sp_configure 'Ad Hoc Distributed Queries', 1
RECONFIGURE
EXEC master.dbo.sp_MSset_oledb_prop N'Microsoft.ACE.OLEDB.12.0',
N'AllowInProcess', 1
EXEC master.dbo.sp_MSset_oledb_prop N'Microsoft.ACE.OLEDB.12.0',
N'DynamicParameters', 1
GO

-- To enable the feature.
EXEC sp_configure 'xp_cmdshell', 1
GO
-- To update the currently configured value for this feature.
RECONFIGURE
GO


/* q1 */

select *
from openrowset('Microsoft.ACE.OLEDB.12.0', 'D:\erfan\term-7\database\DBLAB\import.accdb';'admin';'', 'select * from Users')


/* q2 */

exec xp_cmdshell 'bcp "select TerritoryID, Name from AdventureWorks2012.Sales.SalesTerritory" queryout D:\erfan\term-7\database\DBLAB\Territory.txt -T -c -q -t;'


/* q3 */

exec xp_cmdshell 'bcp AdventureWorks2012.Production.Location out D:\erfan\term-7\database\DBLAB\location.dat -T -c -t;'


/* q4 */

exec xp_cmdshell 'bcp "select [Name], Demographics.query(''declare default element namespace \"http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/StoreSurvey\";for $p in /StoreSurvey return <AnnualSales> {$p/AnnualSales } </AnnualSales>'') as AnnualSales , Demographics.query(''declare default element namespace \"http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/StoreSurvey\";for $p in /StoreSurvey return  <YearOpened> {$p/YearOpened } </YearOpened> '') as YearOpened , Demographics.query(''declare default element namespace \"http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/StoreSurvey\";for $p in /StoreSurvey return <NumberEmployees> {$p/NumberEmployees } </NumberEmployees>'') as NumberEmployees from AdventureWorks2012.Sales.Store" queryout D:\erfan\term-7\database\DBLAB\xml.txt -T -c -q -t;'