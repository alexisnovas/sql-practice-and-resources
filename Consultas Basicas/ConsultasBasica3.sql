/*1- Crear un query que muestre los primeros 10 caracteres de la columna AddressLine1 de la
tabla person.Address.*/
select AddressLine1, SUBSTRING(AddressLine1,1,10) from person.Address
select AddressLine1, LEFT(AddressLine1,10) from person.Address

select * from person.Address

/*2- Crear un query que muestre los caracteres del 10 al 15 de la columna AddressLine1 de la
tabla person.Address.*/
select AddressLine1, SUBSTRING(AddressLine1,10,15) from person.Address

/*3- Mostrar el First y Last Name en mayúscula de la tabla Person.Person.*/
select UPPER(FirstName) AS FirstName, UPPER(LastName) AS LastName from person.Person

/*4- En la tabla Production.Products la columna Product.Number posee un símbolo de guion.,
Utilizando las funciones substring y charindex usted debe hacer lo necesario para mostrar la
parte del product number que esta luego del símbolo de guion., si el product number posee
mas de un guion debes ignorar el segundo., es decir AA-BB-CC,
Debe mostrarse BB. La parte que esta después del primer guion pero si hay otro cortar ahí.*/
select SUBSTRING(ProductNumber,CHARINDEX('-',ProductNumber)+1,
case when CHARINDEX('-',ProductNumber ,CHARINDEX('-',ProductNumber)+1) = 0 then LEN(ProductNumber)
else     CHARINDEX('-',ProductNumber ,CHARINDEX('-',ProductNumber)+1) - CHARINDEX('-',ProductNumber) -1
end)
from Production.Product

/*5- Escriba un query que muestre de la tabla sales.SalesOrderHeader el subtotal redondeado a
dos puntos decimales.*/
Select ROUND(SubTotal,2,0) AS SubTotal From sales.SalesOrderHeader

/*6- Escriba un query que genere un numero random del 1 al 10 cada vez ejecute.*/
select CAST(RAND(CHECKSUM(NEWID())) * 10 as INT) + 1

/*7- Escriba un query usando la tabla HummanResources.Employee para mostrar el
businessEntityId, usar la clausula clase para mostrar Par cuando el busniessEntityId sea par
o Impar cuando el numero sea Impar. Usar función MOD*/
select case when (BusinessEntityID % 2 != 0) then 'Impar'
else 'Par'
end as Paridad_ID
from HumanResources.Employee

/*8- Usando la tabla Sales.SalesOrderDetail mostrar los valores ‘Under 10’ o ’10-19’ o ’20-29’ 0
’30-39’ o ’40 and over’ basándose en la columna OrderQty con la clausula case.*/
select case 
when OrderQty < 10 then 'Under 10'
when OrderQty < 20 then '10-19'
when OrderQty < 30 then '20-29'
when OrderQty < 40 then '30-39'
else '40 and over'
end
from Sales.SalesOrderDetail