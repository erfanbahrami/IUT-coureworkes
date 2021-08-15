/////////////////////////////* q1 *//////////////////////////////


select	*
from (
		select P.[Name], D.OrderQty, T.[Group]
		from Sales.SalesOrderHeader as H inner join Sales.SalesOrderDetail as D on (H.SalesOrderID = D.SalesOrderID)
										 inner join Sales.SalesTerritory as T on (H.TerritoryID = T.TerritoryID)
										 inner join Production.product as P on (D.ProductID = P.ProductID)
		) as A
		pivot
		(
			count(OrderQty)
			for [Group] in ([Europe], [Pacific], [North America])
		)as PVT



/////////////////////////////* q2 *//////////////////////////////

select *
from (
	select Person.BusinessEntityID, PersonType, Gender
	from Person.Person join HumanResources.Employee on (Person.BusinessEntityID = Employee.BusinessEntityID)
	) as B

	pivot
	(	
		count(BusinessEntityID)
		for Gender in ([M], [F])

	) as PVT


/////////////////////////////* q3 */////////////////////////////

select P.[name]
from Production.Product as P
where LEN(p.[Name]) < 15 and SUBSTRING(P.[Name], LEN(P.[name])-1, 1) = 'e'



/////////////////////////////* q4 *//////////////////////////////

create function sales.FormatCheck (@date varchar(10))
returns varchar(40)
as
begin
	declare @invalid varchar(15);
	set @invalid = 'invalid input';
	declare @valid varchar(40);

	if (SUBSTRING(@date, 5, 1) <> '/')
		return @invalid;

	if (SUBSTRING(@date, 8, 1) <> '/')
		return @invalid;

	if (MONTH(@date) >= 1 and MONTH(@date) <= 6)
		if (DAY(@date) < 1 or DAY(@date) > 30)
			return @invalid;

	if (MONTH(@date) >= 7 and MONTH(@date) <= 12)
	if (DAY(@date) < 1 or DAY(@date) > 31)
		return @invalid;

	
	if (MONTH(@date) = 1)
		set @valid = convert(varchar,DAY(@date)) + ' farvardind mahe' + convert(varchar,YEAR(@date)) + ' shamsi';
	
	if (MONTH(@date) = 2)
		set @valid = convert(varchar,DAY(@date)) + ' ordibehesht mahe' + convert(varchar,YEAR(@date)) + ' shamsi';

	if (MONTH(@date) = 3)
		set @valid = convert(varchar,DAY(@date)) + ' khordad mahe' + convert(varchar,YEAR(@date)) + ' shamsi';

	if (MONTH(@date) = 4)
		set @valid = convert(varchar,DAY(@date)) + ' tir mahe' + convert(varchar,YEAR(@date)) + ' shamsi';

	if (MONTH(@date) = 5)
		set @valid = convert(varchar,DAY(@date)) + ' mordad mahe' + convert(varchar,YEAR(@date)) + ' shamsi';

	if (MONTH(@date) = 6)
		set @valid = convert(varchar,DAY(@date)) + ' shahrivar mahe' + convert(varchar,YEAR(@date)) + ' shamsi';

	if (MONTH(@date) = 7)
		set @valid = convert(varchar,DAY(@date)) + ' mehr mahe' + convert(varchar,YEAR(@date)) + ' shamsi';

	if (MONTH(@date) = 8)
		set @valid = convert(varchar,DAY(@date)) + ' aban mahe' + convert(varchar,YEAR(@date)) + ' shamsi';

	if (MONTH(@date) = 9)
		set @valid = convert(varchar,DAY(@date)) + ' azar mahe' + convert(varchar,YEAR(@date)) + ' shamsi';

	if (MONTH(@date) = 10)
		set @valid = convert(varchar, DAY(@date)) + ' dey mahe' + convert(varchar, YEAR(@date)) + ' shamsi';

	if (MONTH(@date) = 11)
		set @valid = convert(varchar,DAY(@date)) + ' bahman mahe' + convert(varchar,YEAR(@date)) + ' shamsi';

	if (MONTH(@date) = 12)
		set @valid = convert(varchar,DAY(@date)) + ' esfand mahe' + convert(varchar,YEAR(@date)) + ' shamsi';

	return @valid;
end



select Sales.FormatCheck('1377/12/24')


/////////////////////////////* q5 *//////////////////////////////

create function Sales.DateSale (@year int, @month int, @product varchar(30))
	returns table 		
as
return
(
	select distinct T.Name
	from Production.Product as P inner join Sales.SalesOrderDetail as D on (P.ProductID = D.ProductID)
								 inner join Sales.SalesOrderHeader as H on (H.SalesOrderID = D.SalesOrderID)
								 inner join Sales.SalesTerritory as T on (T.TerritoryID = H.TerritoryID)
	where @year = year(H.OrderDate) and @month = month(H.OrderDate) and @product = P.[Name]

);

select *
from Sales.DateSale (2005, 7, 'AWC Logo Cap')