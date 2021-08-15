///////////////////////////////* q1 *////////////////////////////


/* create a copy of product table to not to change datas in product table */

CREATE TABLE [Production].[copy](

	[ProductID] [int]  NOT NULL,
	[Name] [dbo].[Name] NOT NULL,
	[ProductNumber] [nvarchar](25) NOT NULL,
	[MakeFlag] [dbo].[Flag] NOT NULL,
	[FinishedGoodsFlag] [dbo].[Flag] NOT NULL,
	[Color] [nvarchar](15) NULL,
	[SafetyStockLevel] [smallint] NOT NULL,
	[ReorderPoint] [smallint] NOT NULL,
	[StandardCost] [money] NOT NULL,
	[ListPrice] [money] NOT NULL,
	[Size] [nvarchar](5) NULL,
	[SizeUnitMeasureCode] [nchar](3) NULL,
	[WeightUnitMeasureCode] [nchar](3) NULL,
	[Weight] [decimal](8, 2) NULL,
	[DaysToManufacture] [int] NOT NULL,
	[ProductLine] [nchar](2) NULL,
	[Class] [nchar](2) NULL,
	[Style] [nchar](2) NULL,
	[ProductSubcategoryID] [int] NULL,
	[ProductModelID] [int] NULL,
	[SellStartDate] [datetime] NOT NULL,
	[SellEndDate] [datetime] NULL,
	[DiscontinuedDate] [datetime] NULL,
	[rowguid] [uniqueidentifier] ROWGUIDCOL  NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
)

insert  into [Production].[copy] 
select *
from [Production].[Product] 



/* create changes table for recodrding changes in product table */

CREATE TABLE [Production].[ProductChanges](

	[ProductID] [int]  NOT NULL,
	[Name] [dbo].[Name] NOT NULL,
	[ProductNumber] [nvarchar](25) NOT NULL,
	[MakeFlag] [dbo].[Flag] NOT NULL,
	[FinishedGoodsFlag] [dbo].[Flag] NOT NULL,
	[Color] [nvarchar](15) NULL,
	[SafetyStockLevel] [smallint] NOT NULL,
	[ReorderPoint] [smallint] NOT NULL,
	[StandardCost] [money] NOT NULL,
	[ListPrice] [money] NOT NULL,
	[Size] [nvarchar](5) NULL,
	[SizeUnitMeasureCode] [nchar](3) NULL,
	[WeightUnitMeasureCode] [nchar](3) NULL,
	[Weight] [decimal](8, 2) NULL,
	[DaysToManufacture] [int] NOT NULL,
	[ProductLine] [nchar](2) NULL,
	[Class] [nchar](2) NULL,
	[Style] [nchar](2) NULL,
	[ProductSubcategoryID] [int] NULL,
	[ProductModelID] [int] NULL,
	[SellStartDate] [datetime] NOT NULL,
	[SellEndDate] [datetime] NULL,
	[DiscontinuedDate] [datetime] NULL,
	[rowguid] [uniqueidentifier] ROWGUIDCOL  NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
	Change	varchar(6)
)


/* create trigger to record changes in Productchanges table */

create trigger	ChangeLog on [Production].[copy]
after insert, delete, update
as
begin
	
	insert into [Production].[ProductChanges]

		select * , 'Insert' as Change
		from inserted

		union all

		select * , 'Delete' as Change
		from deleted	
end



/* make some changes */

delete from  [Production].[copy] 
where ProductID = 1 


insert  into [Production].[copy] 
select *
from [Production].[Product] as p
where ProductID = 1


update [Production].[copy]
set ProductID = 222222
where ProductID = 1

select * from [Production].[ProductChanges]



////////////////////////////////* q2 *///////////////////////////
/* copy of product changes in log table  and change one of rows */

select *
into [Production].[Log]
from [Production].[ProductChanges]


select *
from [Production].[Log]


update [Production].[Log]
set MakeFlag = 1
where ProductID = 555555



/////////////////////////////* q3 *//////////////////////////////

/* create table named diffrences to record the differences between changes and log table */

CREATE TABLE [Production].[Diffrences](

	[ProductID] [int]  NOT NULL,
	[Name] [dbo].[Name] NOT NULL,
	[ProductNumber] [nvarchar](25) NOT NULL,
	[MakeFlag] [dbo].[Flag] NOT NULL,
	[FinishedGoodsFlag] [dbo].[Flag] NOT NULL,
	[Color] [nvarchar](15) NULL,
	[SafetyStockLevel] [smallint] NOT NULL,
	[ReorderPoint] [smallint] NOT NULL,
	[StandardCost] [money] NOT NULL,
	[ListPrice] [money] NOT NULL,
	[Size] [nvarchar](5) NULL,
	[SizeUnitMeasureCode] [nchar](3) NULL,
	[WeightUnitMeasureCode] [nchar](3) NULL,
	[Weight] [decimal](8, 2) NULL,
	[DaysToManufacture] [int] NOT NULL,
	[ProductLine] [nchar](2) NULL,
	[Class] [nchar](2) NULL,
	[Style] [nchar](2) NULL,
	[ProductSubcategoryID] [int] NULL,
	[ProductModelID] [int] NULL,
	[SellStartDate] [datetime] NOT NULL,
	[SellEndDate] [datetime] NULL,
	[DiscontinuedDate] [datetime] NULL,
	[rowguid] [uniqueidentifier] ROWGUIDCOL  NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
	Change	varchar(6)
)

/* procedure to fill differences table */

create procedure LogDifferences
as
begin

	INSERT INTO [Production].[Diffrences]
	
		SELECT *
		FROM [Production].[ProductChanges]

		EXCEPT

		SELECT *
		FROM [Production].[Log]
	
end


exec LogDifferences

select * from [Production].[Diffrences]