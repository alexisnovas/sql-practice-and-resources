use AdventureWorks2012

/*1-Escriba un subquery que muestre el nombre de los productos y product ID de la tabla
Production.Product, esta tabla debe estar ordenada.*/

select ProductID, Name from Production.Product
where ProductID in (Select ProductID Name from Production.Product) order by ProductID


/*2- Cambie el query anterior para mostrar los productos que no han sido ordenados.*/
select ProductID, Name from Production.Product
where ProductID in (Select ProductID Name from Production.Product) order by Name
 
/*3- Escriba un query usando unión que combine las columnas ModifiedDate de la tabla
Person.Person y el HiredDate de la tabla HumanResources.Employee.*/
select ModifiedDate from Person.Person
union
select HireDate from HumanResources.Employee


/*4- Usando una tabla Derivada combine las tablas Sales.SalesOrderHeader a la tabla
Sales.SalesOrderDetails., muestre las columnas SalesOrderID,OrderDate y ProductID.
La tabla Sales.SalesOrderDetail debe estar dentro de la tabla derivada.*/
select * from
(select h.SalesOrderID, h.ModifiedDate, d.ProductID from sales.SalesOrderHeader H
inner join Sales.SalesOrderDetail D on D.SalesOrderID = H.SalesOrderID) derivada

/*5- Reescriba el query anterior usando un CTE.*/
with derivada(SalesOrder,ModifiedDate,ProductID) as (select h.SalesOrderID, h.ModifiedDate, d.ProductID from sales.SalesOrderHeader H
inner join Sales.SalesOrderDetail D on D.SalesOrderID = H.SalesOrderID)
select * from derivada


/*6- Escriba un query que muestre todos los clientes junto con las ordenes creadas en el
2009. use un cte y incluya el CustomerID, SalesOrderID y orderDate en el resultado.*/

with cte as (select O.SalesOrderID, c.CustomerID, O.OrderDate from Sales.SalesOrderHeader O 
inner join Sales.Customer C on O.CustomerID = C.CustomerID
where YEAR(O.OrderDate) = 2011)
select * from cte


