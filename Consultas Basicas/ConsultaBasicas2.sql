--1- El equipo de recursos humanos nos ha pedido identificar cuales empleados poseen mayor
--salida o ausencia en la empresa., para poder identificarlo un empleado debe tener el campo
--SickLeaveHours Mayor a 68 y VacationHours mayor a 98. Estas columnas se encuentran en
--la tabla Employee del esquema HumanResources.
select rowguid, BusinessEntityID, SickLeaveHours, VacationHours from HumanResources.Employee
where SickLeaveHours > 68 and VacationHours > 98--2- Su manager le ha pedido que está interesado en analizar todas las columnas de ciertas
--órdenes en específico, dado esto ella indica que está interesada en ordenes con el
--campo SalesOrderId entre 43702 y 43712.

select * from Sales.SalesOrderDetail
where SalesOrderID between 43702 and 43712

/*3- Porque se debe especificar los nombres de las columnas y no utilizar asterisco cuando
escribimos nuestra lista de select, indique 2 motivos.*/
select BusinessEntityID,LoginID,JobTitle from HumanResources.Employee
where JobTitle = 'Research and Development Engineer'

/*4- Crea un query que muestre a todos los empleados de la tabla Employees que tengan el titulo de
Research and Development Engineer., mostrando las columnas
BusinessEntityID,LoginID,JobTitle*/
select BusinessEntityID, CONCAT(FirstName,' ',MiddleName,' ', LastName) from Person.Person

/*5- Mostrar en un query a las personas de la tabla Person.Person cuando su Middle name sea
J., Mostrar el primer nombre concatenado con el last y middle name. Mostrar su ID
number.*/
select * from Production.ProductCostHistory
where ModifiedDate = '2013/05/16'

/*6- Mostrar todas las ordenes de la tabla Production.ProductCostHistory cuando la fecha de
modificación (modifiedDate) sea Mayo 16 del 2013*/
select BusinessEntityID,LoginID,JobTitle from HumanResources.Employee
where JobTitle is not null

/*7- Crea un query que muestre a todos los empleados de la tabla Employees que no posean ningún
titulo., mostrando las columnas BusinessEntityID,LoginID,JobTitle*/
select BusinessEntityID,LoginID,JobTitle from HumanResources.Employee
where JobTitle is not null

/*8- Crea un query que muestre a todos los empleados de la tabla Employees que no posean el
titulo Research and Development Engineer., mostrando las columnas
BusinessEntityID,LoginID,JobTitle*/
select BusinessEntityID,LoginID,JobTitle from HumanResources.Employee
where JobTitle != 'Research and Development Engineer'

/*9- Mostrar todas las personas de la tabla Person.Person cuando la fecha de modificación sea
luego de 1 de febrero del 2009.*/
select * from Person.Person
where ModifiedDate > '02/01/2009'

/*10- Mostrar todas las personas de la tabla Person.Person cuando la fecha de modificación no
sea 1 de febrero del 2009.*/
select * from Person.Person
where ModifiedDate != '02/01/2009'

/*11- Mostrar el top de las 5 personas que fueron modificadas durante el 2009.*/
select top(5) * from Person.Person
where year(ModifiedDate) = 2009

/*12- Mostrar el top de 5 personas que no fueron modificadas en el 2009.*/
select top(5) * from Person.Person
where year(ModifiedDate) != 2009

/*13- Crear un query que muestre el Id del producto y nombre para cada producto de la tabla
Production.Product que el nombre inicie con la palabra Chain.*/
select ProductID,Name from Production.Product
where name like 'Chain%'


/*14- Cree un query que despliegue los productos que contengan la palabra Helmet en su nombre.*/
select ProductID,Name from Production.Product
where name like '%Helmet%'

/*15- Modifique el query anterior para que se muestren los productos que no poseen la palabra
helmet en su nombre.*/
select ProductID,Name from Production.Product
where name not like '%Helmet%'

/*16- Cree un query mostrando el Id, first Name, middle name, y last Name de la table Person.Person
cuando solo posea la literal E o B en la columna middle Name.*/
select BusinessEntityID,FirstName,MiddleName,LastName from Person.Person
where MiddleName = 'e' or MiddleName ='b'

/*17- Crear un nuevo query mostrando el OrderId, Order Date, y total due de la tabla
Sales.SalesOrderHeader, mostrando solo las ordenes creadas durante el mes de septiembre del
2011 y que el total due sea mayor o igual a 1000.*/
select SalesOrderID, Orderdate, TotalDue from Sales.SalesOrderHeader 
where OrderDate between cast('2011-09-01 00:00:00'  as datetime) and cast('2011-09-30 00:00:00'  as datetime)
and TotalDue >= 1000
Order by OrderDate

/*18- Modificar el query anterior para mostrar solo las ordenes creadas durante los días 1,2,3 de
septiembre 2019., usted debe plantear 3 queries diferentes para lograr la misma solución.*/
--1)
select SalesOrderID, Orderdate, TotalDue from Sales.SalesOrderHeader 
where OrderDate between '20190901' and '20190903'

--2)
select SalesOrderID, Orderdate, TotalDue from Sales.SalesOrderHeader 
where OrderDate in ('20190901','20190902' ,'20190903')

--3)
select SalesOrderID, Orderdate, TotalDue from Sales.SalesOrderHeader 
where OrderDate >= '20190901' and  OrderDate <= '20190903'

/*19- Usted debe mostrar todas las ordenes que su total due sea mayor a 1000 cuando el
salespersonId sea 279 o el territorio sea el 6*/
Select * from Sales.SalesOrderHeader where TotalDue > 1000 and SalesPersonID = 279 or TerritoryID = 6

Select * from Sales.SalesOrderHeader

/*20- Cambia el query anterior para también incluir el territorio 4*/
Select * from Sales.SalesOrderHeader where TotalDue > 100 and SalesPersonID = 279 or TerritoryID in(4,6)


/*21- Explique cuando hace sentido usar la clausula IN*/
Nos permite filtrar por un grupo de valores que nosotros vayamos a establecer

/*22- Escriba un query que muestre de la tabla Production.Products los campos productId, Name y
color cuando no posean color asignado.*/
Select ProductID, Name, Color From Production.Product where color is null

/*23- Modifique el query anterior solo mostrando los productos cuando el color no sea azul.*/
Select ProductID, Name, Color From Production.Product where color <> 'Blue'

/*24- Cree un query mostrando ProductId,Name,Style,Size y color de la tabla Products cuando al
menos una de las columnas Style,Size o color tenga valor.*/
Select ProductID, Name, Style, Size, Color from Production.Product
where Style is not null
or Size is not null
or color is not null

/*25- Cree un query que retorne el BusinessEntityId y nombre de la tabla Person.Person ordenando
los resultados por LastName,FirstName y MiddleName.*/
Select BusinessEntityId, FirstName  From Person.Person
Order by LastName, FirstName, MiddleName

Select * from Person.Person

/*26- Modifica el query anterior para que la data se devuelva en el orden opuesto.*/
Select BusinessEntityId, FirstName  From Person.Person
Order by MiddleName, LastName, FirstName


/*27- Escriba un query que muestre de la tabla Production.Products los campos productId, Name y
color si no posee color mostrar ‘N/A’*/
Select productId, Name, case when Color is null then 'N/A'
else Color end From Production.Product  


/*28- Usando la tabla Sales.SpecialOffer se debe mostrar la diferencia entre MinQty y MaxQty en
conjunto a las columnas SpecialOfferId y description.*/
Select MaxQty, MinQty, MaxQty-MinQty AS DifferenciaMaxMin,
SpecialOfferId, description From Sales.SpecialOffer

/*29- Usando la tabla sales.SpecialOffer Multiplicar los valores de MinQty por DiscountPCT y mostrar
en conjunto a las columnas SpecialOfferId y description.*/
Select MinQty, DiscountPCT, MinQty*DiscountPCT AS Result,
SpecialOfferId, description From Sales.SpecialOffer

/*30- Usando la tabla sales.SpecialOffer Multiplicar los valores de maxQty por DiscountPCT si el
maxqty es null entonces sustituir por el valor 10 y mostrar en conjunto a las columnas
SpecialOfferId y description.*/
Select maxQty,DiscountPCT, maxQty*DiscountPCT AS Result,
case when maxQty is null then 10 else maxQty end AS ChangeMaxqty,
SpecialOfferId, description
From Sales.SpecialOffer