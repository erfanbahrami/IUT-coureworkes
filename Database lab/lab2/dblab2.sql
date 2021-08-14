//////////////////////////////* q1 */////////////////////////////

select H.SalesOrderID, H.OrderDate, H.[Status], H.CustomerID, H.TerritoryID, H.SubTotal, H.TotalDue, T.[Name], T.[Group]
from Sales.SalesOrderHeader as H inner join Sales.SalesTerritory as T on (H.TerritoryID = T.TerritoryID)
where H.SubTotal > 100000 and H.SubTotal < 500000 and (T.CountryRegionCode = 'FR' or T.[Group] = 'North America') and H.[Status] = '5'


//////////////////////////////* q2 */////////////////////////////


select H.SalesOrderID, H.CustomerID,  H.OrderDate, H.SubTotal, s.Name
from Sales.SalesOrderHeader as H inner join Sales.Customer as C on (H.CustomerID = C.CustomerID) inner join Sales.Store as S on (C.StoreID = S.BusinessEntityID)
order by SalesOrderID


//////////////////////////////* q3 */////////////////////////////


with sale_total (PID, SaleCount, TID) as
	(select  D.ProductID, SUM(D.OrderQty) as SalesNum, H.TerritoryID
			from Sales.SalesOrderHeader as H inner join Sales.SalesOrderDetail as D on (H.SalesOrderID = D.SalesOrderID)
			group by H.TerritoryID, D.ProductID) ,

	sale_final(PID, SaleCount) as 
	(select A.PID, max(A.SaleCount)
	from sale_total as A
	group by A.PID
	)

select	S1.PID, S1.SaleCount, S1.TID
from sale_total as S1 inner join sale_final as S2 on (S1.SaleCount = S2.SaleCount and S1.PID = S2.PID)
order by S1.PID 


/////////////////////////////* q4 *//////////////////////////////

with table_copy (SaleOrderId, OrderDate, [Status], CustomerID, TerritoryID, SubTotal, TotalDue, [Name], [Group]) as 
					( select H.SalesOrderID, H.OrderDate, H.[Status], H.CustomerID, H.TerritoryID, H.SubTotal, H.TotalDue, T.[Name], T.[Group]
						from Sales.SalesOrderHeader as H inner join Sales.SalesTerritory as T on (H.TerritoryID = T.TerritoryID)
						where H.SubTotal > 100000 and H.SubTotal < 500000 and (T.CountryRegionCode = 'FR' or T.[Group] = 'North America') and H.[Status] = '5'
					),
					
	temp ([avg]) as (select  AVG(H.SubTotal)
										from Sales.SalesOrderHeader as H inner join Sales.SalesTerritory as T on (H.TerritoryID = T.TerritoryID)
										group by T.[Group]
										having  T.[Group] = 'North America')

SELECT * INTO NAmerica_Sales
FROM table_copy
WHERE [Group] = 'North America'; 


alter table dbo.NAmerica_Sales
add SaleRange char(4) check (SaleRange in ('LOW', 'HIGH', 'MID'))



update dbo.NAmerica_Sales
set SaleRange = case
	when (dbo.NAmerica_Sales.SubTotal = (select temp.[avg] from temp))		then 'MID'

	when (dbo.NAmerica_Sales.SubTotal > (select temp.[avg] from temp))		then 'HIGH'

	when (dbo.NAmerica_Sales.SubTotal < (select temp.[avg] from temp))		then 'LOW'

	end



/////////////////////////////* q5 *//////////////////////////////

with Salaries (ID, Salary) as (
		SELECT BusinessEntityID ,max(Rate)FROM HumanResources.EmployeePayHistory
		GROUP BY BusinessEntityID
		)


select  Salaries.ID,  case 

	when ( Salary <= (select AVG(Salaries.Salary)/2 from Salaries)  ) then Salaries.Salary  * 1.2
						
	when ( Salary > (select AVG(Salaries.Salary)/2 from Salaries) and   Salary <= (select AVG(Salaries.Salary) from Salaries)) then Salaries.Salary  * 1.15

	when ( Salary > (select AVG(Salaries.Salary) from Salaries) and   Salary <= (select AVG(Salaries.Salary)*0.75 from Salaries)) then Salaries.Salary  * 1.1

	else	Salaries.Salary * 1.05

	end  as "NewSalary" ,

case
	
	when (Salaries.Salary < 29) then '3'
	when (Salaries.Salary >= 29 and Salaries.Salary < 50) then '2'
	else	'1'
end as "Level"

from Salaries			



