///////////////////////////////* q2 *////////////////////////////


with RegionName (territory, region) as (
					select T.[name], T.[Group]
					from sales.SalesTerritory as T) 

select 
case GROUPING(T.[name])
when 0 then T.[Name] 
when 1 then 'All Territories'
end as TerritoryName, 
case GROUPING(T.[Group])
when 0 then T.[Group]
when 1 then case GROUPING(T.[name]) 
					when 0 then (select	R.region	from RegionName as R	where R.territory = T.[name])
					when 1 then 'All Regions'
					end
end as Region,
sum(H.SubTotal) as SalesTotal, count(H.SalesOrderID) as SalesCount
from Sales.SalesOrderHeader as H inner join sales.SalesTerritory as T on (H.TerritoryID = T.TerritoryID)
group by grouping sets ( T.[name], T.[group], ())
order by region, TerritoryName



///////////////////////////////* q3 *////////////////////////////


with CatSub (subcat, cat) as (
					select S.[name], C.[Name]
					from Production.ProductCategory as C , Production.ProductSubcategory as S where S.ProductCategoryID = C.ProductCategoryID ) 

select 
case GROUPING(S.[name])
when 0 then S.[Name] 
when 1 then 'All Sub'
end as SubCat, 
case GROUPING(C.[Name])
when 0 then C.[Name]
when 1 then case GROUPING(S.[name]) 
					when 0 then (select	CatSub.cat	from CatSub	where CatSub.subcat = S.[Name])
					when 1 then 'All Cat'
					end
end as Cat,
sum(D.LineTotal) as SalesTotal, count(D.OrderQty) as SalesCount
from Sales.SalesOrderDetail as D inner join Production.Product as P on (D.ProductID = P.ProductID)
							     inner join Production.ProductSubcategory as S on (S.ProductSubcategoryID = P.ProductSubcategoryID)
								 inner join Production.ProductCategory as C on (C.ProductCategoryID = S.ProductCategoryID)
group by grouping sets (S.[Name], C.[Name], ())
order by SubCat, Cat
