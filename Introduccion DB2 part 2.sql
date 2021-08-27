--IN: podemos buscar un valor en una lista, seria un shortcut del comando or
USE TSQL2012

select * from sales.orders
where empid = 1 or empid = 2 or empid =3 or empid = 4 or empid =5

select * from sales.orders
where empid between 1 and 5

select * from sales.orders
where empid in (1,2,3,4,5)

select * from sales.orders
where empid <> 1 or empid <> 2 or empid <> 3 or empid <> 4 or empid <>5

select * from sales.orders
where empid not in (1,2,3,4,5)

select * from sales.orders
where empid not between 1 and 5

select * from sales.Orders
where shipregion is null

select * from sales.Orders
where shipregion is not null

create table pruebaBet(id INT, val DATETIME)
INSERT INTO pruebaBet VALUES (1,'2010-09-23 00:00:00.000') --Time 12:00 AM

INSERT INTO pruebaBet VALUES (2,'2010-09-24 00:00:00.000') --Time 12:00 AM

INSERT INTO pruebaBet VALUES (3,'2010-09-24 01:00:00.000') --Time NOT 12:00 AM

INSERT INTO pruebaBet VALUES (3,'2010-09-23 11:15:00.000') --Time NOT 12:00 AM


Select * from pruebaBet
WHERE val 
BETWEEN '2010-09-23' AND '2010-09-23' --Bug if Time 12:00 AM , it will be included

Select * from pruebaBet
WHERE val 
BETWEEN '2010-09-23 00:00:00.000' AND '2010-09-23 00:00:00.000' --Bug if Time 12:00 AM , it will be included


--si convertimos la fecha a date se puede evitar el error
Select * from pruebaBet
WHERE convert(date,val) 
BETWEEN '23-Sep-2010' AND '23-Sep-2010' --Bug if Time 12:00 AM , it will be included


Select * from pruebaBet
WHERE val BETWEEN '23-Sep-2010' AND dateadd(day,-1,'24-Sep-2010')


Select * from pruebaBet
WHERE val between '23-Sep-2010' AND '24-Sep-2010'

Select * from pruebaBet
WHERE val >= '2010-09-23' AND val < '2010-09-24'

/* Fuente:
https://www.jitendrazaa.com/blog/sql/sqlserver/between-clause-problem-in-date-comparison-sql-server/
*/

select * from sales.Orders
where year(orderdate) = 2007
and month(orderdate) = 2


--Round() : nos permite redondear un valor
select round(1234.1294,2) as '2 places on the right'
select round(1234.1294,-2) as '2 places on the left'
select round(1234.1294,2,1) as 'truncate 2'
select round(1234.1294,-2,1) as 'truncate -2'

decimal(18,4)
decimal(18,2)
money
varchar(30)

select convert(int, 25.9)

select rand()

	  select convert(int, rand() * 100)+1 Random,
	  convert(int, rand() * 900)+1 '900To1900',
	  convert(int, rand() * 5)+1 '1to5'


	select * from Production.Products
	order by unitprice

	select *  from sales.Orders

	select * from sales.Orders
	order by orderid
	offset 50 rows fetch next 50 rows only

--Funciones de administrador
select DB_NAME(),HOST_NAME(),HOST_ID(),CURRENT_USER,user_name(),app_name()

inner join
left  join
right join

select * from Production.Categories

select * from Production.Products

select Production.Products.productid, * 
from Production.Products  inner join Production.Categories
					on Production.Products.categoryid = production.Categories.categoryid

select p.productid,
	 p.productname,
	 p.categoryid,
	 c.categoryname,
	 c.description
from Production.Products as p  inner join Production.Categories as c
					on p.categoryid = c.categoryid

select p.productid,
	 p.productname,
	 p.supplierid,
	 s.companyname,
	 s.contactname
from Production.Products as p  inner join Production.Suppliers as s
					on p.supplierid = s.supplierid

select p.productid,
	 p.productname,
	 c.categoryname,
	 s.contactname
from Production.Products as p  
	inner join Production.Categories as c
					on p.categoryid = c.categoryid
	inner join Production.Suppliers as s
				on p.supplierid = s.supplierid

-- Trae los suplidores que tienen productos y los que no. (Pero no se refleja porque todos los suplidores tienen productos)
select p.productid,
	 p.productname,
	 p.supplierid,
	 s.companyname,
	 s.contactname
from Production.Products as p  right join Production.Suppliers as s
					on p.supplierid = s.supplierid

-- Trae los suplidores que tienen productos y los que no. (Pero no se refleja porque todos los suplidores tienen productos)
select 
s.companyname,
	 s.contactname,
p.productid,
	 p.productname,
	 p.supplierid
	 
from  Production.Suppliers as s left join Production.Products as p
					on p.supplierid = s.supplierid

/* Funciones de agregación:
COUNT: devuelve el número total de filas seleccionadas por la consulta.
MIN: devuelve el valor mínimo del campo que especifiquemos.
MAX: devuelve el valor máximo del campo que especifiquemos.
SUM: suma los valores del campo que especifiquemos. Sólo se puede utilizar en columnas numéricas.
AVG: devuelve el valor promedio del campo que especifiquemos. Sólo se puede utilizar en columnas numéricas.
*/

select count(productid) Cant,
		min(unitprice) Min,
		max(unitprice) Max,
		AVG(unitprice)average  
	from Production.Products


	--EStoy mostrando valores totales

	-- Este no funcionará porque necesita ser agrupado ya que hay más de un detalle por orderid.
	select orderid,  sum(unitPrice * qty) total,AVG(unitprice) average,min(unitprice) Min,
		max(unitprice) Max from sales.OrderDetails
		where orderid = 10248


			select  orderid,sum(unitPrice * qty) total,AVG(unitprice) average,min(unitprice) Min,
		max(unitprice) Max from sales.OrderDetails
		where orderid = 10248
		group by orderid


		

		select top 5 * from Production.Products
		select count (*) from sales.OrderDetails as OrderDetailsRowQty

		
		select p.productid,
			p.productname,
		sum(od.unitprice * od.qty) as Total,
		count(distinct od.orderid) cantidadOrdenes
			from Production.Products p
				inner join sales.OrderDetails od
					on p.productid = od.productid
			--where od.orderid = 10248
			group by p.productid, p.productname



	 select o.orderid,o.orderdate,
	 min (od.unitprice) minimo,max(od.unitprice) maximo, sum(od.unitprice * od.qty) total
	  from sales.Orders o
	 inner join sales.OrderDetails od
	 on o.orderId = od.orderid
	 group by o.orderid,o.orderdate

select	o.orderid, 
		min(od.unitprice) as PrecioMinimo,
		MAX(od.unitprice) as PrecioMaximo ,
		avg(od.unitprice) as Avegarege,
		count(od.productid) as CantidadProductos,
		sum(od.unitprice) as SumaTotal
		from sales.Orders o
			inner join sales.OrderDetails od
			on o.orderid = od.orderid
			--where o.orderid = 10248
		group by o.orderid

		
		select o.orderid,o.orderdate,
		sum(od.unitprice*od.qty) total,
		min(od.unitprice) PrecioMinimo,
		max(od.unitprice) PrecioMaximo
		from sales.Orders o
		inner join sales.OrderDetails od
		on o.orderid = od.orderid
		group by o.orderid,o.orderdate

/*Sub query o Sub consulta: un query contenido dentro de otro query, y estos querys pueden ser
correlacionado o no correlacionado*/


select productname, min(unitprice) from Production.Products
group by productname
order by min(unitprice)

select top 1 productname, unitprice from Production.Products
order by unitprice

select * from Production.Products
where unitprice = (select min(unitprice) precioMinimo from Production.Products
where discontinued = 1
)


SELECT productid, productname, unitprice
FROM Production.Products
WHERE unitprice =
(SELECT MIN(unitprice)
FROM sales.OrderDetails od
	where od.productid = Products.productid);


	select *,'productoMinimo','PrecioMinimo','productoMaximo','precioMaximo' 
	from Production.Categories

	select * from Production.Products

	select c.categoryid,
			c.categoryname,
			c.description,
			p.productname as ProductoMinimo,
			p.unitprice as PrecioMinimo,
			pm.productname as ProductoMaximo,
			pm.unitprice as PrecioMaximo
			from Production.Categories c
			inner join Production.Products p
				on c.categoryid = p.categoryid
				and p.unitprice = (select min(z.unitprice) from Production.Products z
										where z.categoryid = c.categoryid )
	inner join Production.Products pm
				on c.categoryid = pm.categoryid
				and pm.unitprice = (select max(z.unitprice) from Production.Products z
										where z.categoryid = c.categoryid )





--Tablas derivadas


select * from (select c.categoryid,
			c.categoryname,
			c.description,
			p.productname as ProductoMinimo,
			p.unitprice as PrecioMinimo,
			pm.productname as ProductoMaximo,
			pm.unitprice as PrecioMaximo
			from Production.Categories c
			inner join Production.Products p
				on c.categoryid = p.categoryid
				and p.unitprice = (select min(z.unitprice) from Production.Products z
										where z.categoryid = c.categoryid )
	inner join Production.Products pm
				on c.categoryid = pm.categoryid
				and pm.unitprice = (select max(z.unitprice) from Production.Products z
										where z.categoryid = c.categoryid )) derivada
			inner join Production.Products z
			on derivada.categoryid = z.categoryid

 hablar del orden de ejecucion de los querys:
		 FROM
		 where
		 Group BY
		 HAVING
		 SELECT
		 distinct
		 Order by
		 OFFSET
		 


		 use TSQL2012


--el union nos permite combinar el set de dos querys distintos
SELECT MIN(unitprice)
FROM Production.Products
union
SELECT Max(unitprice)
FROM Production.Products

--En el union solo retorna valores distintos, si hay valores iguales solo retorna uno de ellos
SELECT MIN(unitprice)
FROM Production.Products
union
SELECT Min(unitprice)
FROM Production.Products


--El Union ALL nos permite mantener los resultados de ambos set aunque los valores sean iguales
SELECT MIN(unitprice)
FROM Production.Products
union all
SELECT Min(unitprice)
FROM Production.Products

--declaracion de variables
declare @variable int,@variable2 int, @variable3 int

--Asignar valor a variable
set @variable = 2
select @variable=4

select @variable + 2

select @variable

create table tablatemporal
insert update delete 

--Creacion de tabla e insercion de datos en la #tablaTemporal
select * into #tablaTemporal from Production.Products

drop table #tablaTemporal

select * from #tablaTemporal

--Tabla temporal solo visible a nivel del usuario
select * from #tmpTabla

--Tabla temporal global visible para todos los usuarios
select * into ##tmpTablaGlobal from Production.Categories


		

		



