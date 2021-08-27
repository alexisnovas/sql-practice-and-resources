/*1- La tabla HumanResources.Employee no contiene el nombre de los empleados., usted
debe crear un join con la tabla Person.Person con la columna BusinessEntityID.
Mostrando el job title, Birth Date, First name y Last Name.*/
select CONCAT(p.FirstName,' ',p.LastName) as NombreEmpleado, e.JobTitle, e.BirthDate
from HumanResources.Employee e, Person.Person p
where e.BusinessEntityID = p.BusinessEntityID

/*2- El nombre de los clientes tambien aparece en la tabla Person.Person usando la columna
BusinessEntityId este se machea con la columna PersonID de la de la tabla
Sales.Customer. CustomerID, StoreID, y TerritoryID.*/
select c.CustomerID, c.StoreID, c.TerritoryID, * from Person.Person p, Sales.Customer c
where p.BusinessEntityID = c.PersonID


/*3- Actualice el query anterior para incluir Sales.SalesOrderHeader para mostrar el
SalesOrderID con las columnas PersonID de la de la tabla Sales.Customer. CustomerID,
StoreID, y TerritoryID de la tabla customerID.*/
select c.CustomerID, c.StoreID, c.TerritoryID, s.SalesOrderID,* 
from Person.Person p, Sales.Customer c, Sales.SalesOrderHeader s
where p.BusinessEntityID = c.PersonID
and c.CustomerID = s.CustomerID


/*4- Escriba un Query que combine las tablas Sales.SalesOrderHeader y la tabla
Sales.SalesPerson. Combine el BusinessEntityID de la tabla Sales.SalesPerson con la
columna SalesPersonID de la tabla Sales.SalesOrderHeader table. Muestre el
SalesOrderID con las cuotas de la columna SalesQuota y Bonus.*/
select h.SalesOrderID, p.SalesQuota, p.Bonus  
from Sales.SalesOrderHeader h, Sales.SalesPerson p
where p.BusinessEntityID = h.SalesPersonID

/*5- Anada el nombre del cliente al query anterior.*/
select h.SalesOrderID, p.SalesQuota, p.Bonus, CONCAT(e.FirstName,' ',e.LastName) as NombreCliente 
from Sales.SalesOrderHeader h, Sales.SalesPerson p, Person.Person e
where p.BusinessEntityID = h.SalesPersonID
and p.BusinessEntityID = e.BusinessEntityID


/*6- La descripción del catalogo (catalog description) para cada producto esta almacenado
en la tabla Production.ProductModel., despliegue las columnas que muestran la
información del producto tales como Color, size con la descripción del catalogo de cada
producto.*/
select o.Color, o.Size,  p.CatalogDescription 
from Production.ProductModel p, Production.Product o
where o.ProductModelID = p.ProductModelID



/*7- Escriba un query que muestre el nombre de los clientes y el nombre de los productos
que ellos han comprado. Serán requeridas 5 tablas.*/
select p.FirstName, o.Name 
from Person.Person p, sales.SalesPerson s, Production.Product o, Production.ProductModel m
where p.BusinessEntityID = s.BusinessEntityID
and (
	o.ProductModelID = m.ProductModelID
)

/*8- Escriba un query que muestre todos los productos junto con la columna SalesOrderID
aunque el producto no posea ordenes., el join se hara contra la tabla
sales.SalesOrderDetail usando la columna ProductID.*/
SELECT SalesOrderID, P.ProductID, P.Name
FROM Production.Product AS P
LEFT OUTER JOIN Sales.SalesOrderDetail
AS SOD ON P.ProductID = SOD.ProductID

/*9- Modifique el query anterior para que solo muestre productos que no tengan ordenes.*/
SELECT SalesOrderID, P.ProductID, P.Name
FROM Production.Product AS P
LEFT OUTER JOIN Sales.SalesOrderDetail
         AS SOD ON P.ProductID = SOD.ProductID
WHERE SalesOrderID IS NULL


/*10- Escriba un query que muestre todas las filas de la tabla Sales.SalesPerson haciendo join
contra la tabla Sales.SalesOrderHeader usando el SalesOrderID aunque la persona no
tenga ordenes. Incluya el SalesPersonID y las ventas YTD (ventas de todo el ano) en el
resultado.*/
SELECT SalesOrderID, SalesPersonID, SalesYTD, SOH.SalesOrderID
FROM Sales.SalesPerson AS SP
LEFT OUTER JOIN Sales.SalesOrderHeader AS SOH
      ON SP.BusinessEntityID = SOH.SalesPersonID


/*11- Modifique el query anterior para incluir el nombre de la persona que hizo la venta.*/
SELECT SalesOrderID, SalesPersonID, SalesYTD, SOH.SalesOrderID,
            FirstName, MiddleName, LastName
FROM Sales.SalesPerson AS SP
LEFT OUTER JOIN Sales.SalesOrderHeader AS SOH
        ON SP.BusinessEntityID = SOH.SalesPersonID
LEFT OUTER JOIN Person.Person AS P
          ON P.BusinessEntityID = SP.BusinessEntityID

/*12- La tabla Sales.SalesOrderHeader contiene un campo foreign Key a la tabla
Sales.CurrencyRate y Purchasing.ShipMethod. escriba un query que una las 3 tablas y
asegurese que contenga todas las filas de la tabla Sales.SalesOrderHeader. Incluya las
columnas CurrencyRateID,AverageRate,SalesOrderID y ShipBase.*/
SELECT CR.CurrencyRateID, CR.AverageRate,
          SM.ShipBase, SalesOrderID
FROM Sales.SalesOrderHeader AS SOH
LEFT OUTER JOIN Sales.CurrencyRate AS CR
          ON SOH.CurrencyRateID = CR.CurrencyRateID
LEFT OUTER JOIN Purchasing.ShipMethod AS SM
          ON SOH.ShipMethodID = SM.ShipMethodID

/*13- Escriba un query que retorne el BusinessEntityID column de la tabla Sales.SalesPerson
junto con todos los productID de la tabla Production.Product.*/
SELECT SP.BusinessEntityID, P.ProductID
FROM Sales.SalesPerson AS SP
CROSS JOIN Production.Product AS P