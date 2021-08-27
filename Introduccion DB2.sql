
USE TSQL2012
--Sentencia Select

--Comentario de una linea
/*comentarios de multiples lineas*/
--select 1

/*select 1+1 as Suma
select 2*2 as Multiplicacion
select 5-2 as Resta
select 6/2 as Division*/

select 1+1 as Suma, 2*2 as Multiplicacion, 5-2 as Resta, 6/2 as Division

select 'Hola mundo' as AliasColumna

select 'Hola '+'Pedro' as Concatenando

/*Consulta de datos de una tabla, usamos el from para especificar de que tabla vamos a cargar los datos, y en el select usamos el simbolo de *
para indicar que queremos todas las columnas.*/

select productid as Id,
    productname as Nombre,
    supplierid as CodigoSuplidor,
    categoryid as CodigoCategoria,
    unitprice [precio unitario], --Podemos poner entre brackets cuando queremos un nombre separado.
    unitprice + (unitprice * 0.18) as unitpriceWithItbis, --Podemos realizar calculos como este.
    Descontinuado = discontinued --Esta es otra manera de renombrar la columna utilizando '='
from Production.Products

select top 5 * from Production.Products
order by unitprice desc --Para ordenar en base a una columna específica.
--asc | desc



select 'Hola ' + null
select top 1 isnull(null,0) from Production.Products

select 'Hola'+null

select shipcity,
    shipregion, shipcity +' ' +isnull(shipregion,'') concatenacion,
    CONCAT(shipcity,' ',shipregion) as Concatenacion -- CONCAT sirve para concatenar columnas en una sola.
from sales.Orders


-- ejemplo: si la columna 1, es nula entonces pongan el valor de columna 2, si la columna 2 es nula entonces la oclumna 3

select isnull(columna1,columna2,columna3,columna4)

select isnull('columna1',isnull('columna2','columna3'))
select isnull(null,isnull('columna2','columna3'))
select isnull(null,isnull(null,'columna3'))

--En sql, es posible anidar funciones como en este caso usamos isnull
select isnull(null,isnull(null,isnull('columna3','columna4')))
select isnull(null,isnull(null,isnull(null,'columna4')))

--Coalesce hace lo mismo que isnull pero puede procesar multiples condiciones a diferencia del isnull que solo acepta dos parametros
select coalesce(null,null,null,'columna4') /*Coalesce es lo mismo que isnull pero acepta multiples parámetros.*/


--Manipulacion de fecha y texto
select top 20 percent * from sales.Orders --Para realiza busquedas a través de un porcentaje.

select distinct shipcountry,shipcity from sales.Orders --Distinc es para que no traiga campos duplicados.

select top 10 * from sales.Orders

select getdate()

select year(getdate()) as Year,month(getdate()) as Month,day(getdate()) as day -- Se pueden extraer las propiedad de getdate de esta manera.

select DATEPART(YEAR,getdate()) year,DATEPART(month,getdate())as  month,DATEPART(day,getdate()) as day -- Datepart hace la misma función que lo anterior.

select orderid,
		GETDATE() [getdate], ---devuelve la fecha actual del sistema.
		CURRENT_TIMESTAMP [Timestamp], --Lo mismo que el anterior.
		orderdate, --A continuación descomponemos los elementos del orderdate utilizando datepart
		datepart(year,orderdate) [year], -- Año
		datepart(month,orderdate) [mes], -- Mes
		datepart(day,orderdate) [day], -- Día
		DATEPART(dayofyear,orderdate) diaAno, -- Día del año
		DATEPART(weekday,orderdate) diaSemana -- Día de la Semana
from Sales.Orders

--https://docs.microsoft.com/en-us/sql/t-sql/functions/datepart-transact-sql?view=sql-server-2017

select GETDATE() as FechaOrden,GETDATE()+2 FechaShipping -- Se pueden hacer operaciones con la función
-- getdate de esta manera.

--Anadir intervalos de fecha

select DATEADD(year,4,getdate()) as Year, -- DateAdd nos ayuda a incrementar alguna fecha y cualquiera de sus elementos.
		DATEADD(month,4,getdate()) as Month,
		DATEADD(day,4,getdate()) as day,
		DATEADD(hour,4,getdate()) as hour

select orderid,orderdate,
	DATEDIFF(year,orderdate,getdate()) as Anos, -- Diferencia en años entre un elemento fecha y otro.
	DATEDIFF(month,orderdate,getdate()) as Meses, -- Diferencia en meses entre un elemento fecha y otro.
	DATEDIFF(day,orderdate,getdate()) as Dias, -- Diferencia en dias entre un elemento fecha y otro.
	DATEDIFF(hour,orderdate,getdate()) as Horas -- Diferencia en horas entre un elemento fecha y otro.
from sales.Orders
order by orderid ASC

select * from sales.Orders

select convert(int,'5') --convert nos ayuda a hacer conversiones de un tipo de dato a otro.
2020-08-11 18:30:24.993
select GETDATE()
select convert(varchar(15),GETDATE(),103) -- El 103 es el formato de fecha dd/mm/yy
select orderid, convert(varchar(15),orderdate,101) as [Fecha de orden] from Sales.Orders -- El 101 es el formato de fecha mm/dd/yy
order by orderdate DESC
dd/mm/yyyy
mm/dd/yyyy

25/07/2020
Jul 25 2020  2:
--formatos de fecha en sql
--https://www.mssqltips.com/sqlservertip/1145/date-and-time-conversions-using-sql-server/

select FORMAT(55, 'Hola')
select CAST()

select orderid,
		custid,
		empid,
		orderdate,
		--Retorna la fecha actual del sistema
		getdate() as FechaActual
		--,CURRENT_TIMESTAMP
		,year(orderdate) AnoOrden
		,year(GETDATE()) AnoOrden
		,month(orderdate) Mes
		,day(orderdate) Dia
		--Para obtener los intervalos dayofyear y weekday es obligatorio usar datepart
		,DATEPART(DAYOFYEAR,orderdate) DiaAno
		,DATEPART(WEEKDAY,orderdate) DiaSemana
			--devuelve el nombre del mes 
		,datename(month,orderdate) NombreMes 
		,DATEPART(WEEKDAY,orderdate) DiaSemana
		,datename(WEEKDAY,orderdate) as NombreDiaSemana 
		,DATEADD(MONTH,4,DATEADD(year,4,getdate())),
		datediff(year, orderdate, getdate()) DiferenciaEnAños
 from sales.Orders
 
 'Descontinuado' activo

 select productid,
		productname,
		unitprice,
		discontinued,
	case when discontinued = 1 then 'Descontinuado' end as Descontinuado	
 from Production.Products

  select productid,
		productname,
		unitprice,
	case when discontinued = 1 then 'Descontinuado' else 'Activo' end as Descontinuado	
 from Production.Products

  select productid,
		productname,
		unitprice,
	case when discontinued = 1 then 'Descontinuado' else 'Activo' end as Descontinuado	
 from Production.Products
 order by unitprice


  0-30 basic
 30 - 60 Standard
 60 > Premium

   select productid,
		productname,
		unitprice,
	case when unitprice <= 30 then 'BASIC'
	     when unitprice <= 60 then 'STANDARD'
		 when unitprice > 60 then 'PREMIUM' end as ProductTier	
 from Production.Products
 order by unitprice

   select productid,
		productname,
		unitprice,
	case when unitprice <= 30 then 'BASIC'
	     when unitprice <= 60 then 'STANDARD'
		 else 'PREMIUM' end as ProductTier	
 from Production.Products
 order by unitprice

 -- Este código te indica en que semana del mes estamos en base al día en en el que estamos.
  select case 
	when datepart(day,GETDATE()) < 7
	then 'Primera semana'
	when datepart(day,GETDATE()) < 14
	then 'segunda Semana'
	when  datepart(day,GETDATE()) < 21
	then 'tercera semana'
  else 'cuarta Semana' end as NumeroSemana

    --EOMONTH: devuelve el ultimo dia en que se hizo una orden por cada mes
  select distinct Eomonth(orderdate),DATEPART(month,orderdate) 
  from sales.orders

  --Realiza un parse o cambio de tipo de datos
  SELECT CAST('dos' AS INT);
  select convert(int,'dos');


  /*Realiza un parse o cambio de tipo de datos si el mismo falla,
podemos manejar la excepcion y capturarla como un NULL*/
 SELECT try_CAST('abc' AS INT);
  select try_convert(int,'abc');

  SELECT isnull(try_CAST('abc' AS INT),0);
  select isnull(try_convert(int,'abc'),0);


  select SUBSTRING('El covid esta acabando con el dominicano',9,30)

  select left('El covid esta acabando con el dominicano',9) --El covid esta
  select right('El covid esta acabando con el dominicano',27) -- acabando con el dominicano.

  select CHARINDEX('t','El covid esta acabando con el dominicano')

  select custid,
		companyname,
		CHARINDEX(' ',companyname),
		SUBSTRING(companyname,CHARINDEX(' ',companyname)+1,len(companyname)) 
	from sales.Customers

  select REPLACE('El covid esta acabando con el dominicano','covid','PLD')
 

 select replace('Tranf a @ACCOUNT-TO@','@ACCOUNT-TO@','****7676')
 
 select replace('Desde @ACCOUNT-FROM@','@ACCOUNT-FROM@','****2332')

 select len('El covid esta acabando con el dominicano')

 select SUBSTRING('El covid esta acabando con el dominicano',9,len('El covid esta acabando con el dominicano'))


  select custid,companyname,CHARINDEX(' ',companyname),SUBSTRING(companyname,CHARINDEX(' ',companyname)+1,len(companyname)) from sales.Customers

 select custid,
	companyname,
	CHARINDEX(' ',companyname),
	SUBSTRING(companyname,CHARINDEX(' ',companyname)+1,len(companyname))
 from sales.Customers

 select companyname,
--LEFT:Se coloca a la izquierda del texto y retorna la cantidad de caracteres
		left(companyname,8) [left],
--RIGHT:Se coloca a la derecha del texto y retorna la cantidad de caracteres
		right(companyname,5) [right],
--CHARINDEX: Retorna la primera posicion donde se encuentre el texto indicado		
		CHARINDEX(' ',companyname) [CHARINDEX],
--len: Devuelve la cantidad de caracteres posee el texto
		len(companyname) [LENGTH]
 from sales.Customers

 select replicate('0',8)
 select REPLICATE('0',6-len('10')) + '10'  -- lo mismo que select replicate(0,4) + '10'

 '000000'
 '000001'
 '000010'
 '000100'
 
 select FORMAT(9,'D6')
 select FORMAT(1, 'd6')
 select FORMAT(10, 'd6')
 select FORMAT(100, 'd6') 
 select FORMAT(1000, 'd6') 

 select upper('juan Carlos') AS [UPPER]
 select lower('PEDRO PEREZ') AS [LOWER]
 SELECT LTRIM('          JUANITA         ') AS [LTRIM]
 SELECT RTRIM('       JUANITA            ') AS [RTRIM]
 SELECT TRIM('       JUANITA            ') AS [TRIM]

 'JUANITA'

  select custid,
		companyname,
		CHARINDEX(' ',companyname),
		trim(SUBSTRING(companyname,CHARINDEX(' ',companyname),len(companyname))) -- con el trim ya no es necesario ponerle el +1 despues del espacio
 from sales.Customers

 
 /*
 Operadores Logicos
 igual: =
 mayor: >
 Mayor o igual: >=
 Menor <
 Menor o Igual <=
 Diferente: !=, <>
 like
 Not Like
 in
 not in
is null
not null
between
*/

 and
 or

 boolean 1 = true
		 0 = false


select distinct shipcountry from sales.Orders

select * from sales.Orders
where shipcountry ='USA'


select * from sales.Orders
where shipcountry ='Mexico'

select distinct freight from sales.Orders

select * from sales.Orders
where freight > 700


select * from sales.Orders
where freight >= 700 and freight <=900
order by freight ASC


--mal --Ya que el hecho de tener dos paises en el mismo campo es imposible.
select * from sales.Orders
where shipcountry ='USA' 
	and shipcountry ='Mexico'
--bien
select * from sales.Orders
where shipcountry ='USA' 
	or shipcountry ='Mexico'

--mal --La primera condición debe colocarse entre paréntesis.
	select * from sales.Orders
where shipcountry ='USA' or shipcountry ='Mexico'
	and freight >= 50
--bien
select * from sales.Orders
where (shipcountry ='USA' or shipcountry ='Mexico')
	and freight >= 50

select * from sales.Orders
where freight between 700 and 900

select * from sales.Orders
where orderdate >='2006-07-04 00:00:00.000'
		and orderdate <= '2006-10-14 00:00:00.000'
order by orderdate

select * from sales.Orders
where year(orderdate) = 2006 and month(orderdate) = 7

like

select * from sales.Customers
where contactname like 'A%'

select * from sales.Customers
where substring(contactname,1,1)=  'A'

-- El anterior también podría ser así:
select * from sales.Customers
where left(contactname,1)=  'A'

select * from sales.Customers
where contactname like '%an'

select * from sales.Customers
where contactname like '%n'

-- Una forma para extraer el primer y segundo nombre de los customers.
select contactname,
		SUBSTRING(contactname, CHARINDEX(',', contactname) + 2, LEN(contactname)) FirstName,
		SUBSTRING(contactname, 1, CHARINDEX(',', contactname) - 1) SecondNames
from sales.Customers
where contactname like '%n'

select * from  sales.Orders
where (orderid between 1 and 100) and shipaddress like '%Ave.%' -- Aqui comparamos con los que contienen
-- Ave. en alguna parte del dato.


