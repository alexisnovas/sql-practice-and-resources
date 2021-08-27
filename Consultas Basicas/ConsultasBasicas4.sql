use TSQL2012

/*1- Realizar una consulta a la tabla orders mostrando el orderid,custid,empid, orderdate, requireddate y shippeddate.
adicional a esto usted debe hacer lo necesario para poder mostrar lo siguiente:
? Si la diferencia de días que existe entre el orderdate y required date es igual a 28 o 29 entonces mostrar 'SLA DE
3 SEMANAS', si es igual a 14 o 15 mostrar 'SLA 2 SEMANAS'.
? Si es igual a 42 mostrar 'SLA DE 4 SEMANAS' y si no cumple con ninguna de las anteriores mostrar 'N/A'*/
select case when DATEDIFF(day,orderdate,requireddate) in (28,29) then 'SLA DE 3 SEMANAS'
when DATEDIFF(day,orderdate,requireddate) in (14,15) then 'SLA DE 2 SEMANAS'
when DATEDIFF(day,orderdate,requireddate) in (42) then 'SLA DE 4 SEMANAS' 
else 'N/A'
END,
DATEDIFF(day,orderdate,requireddate),
orderid, custid,empid,orderdate,requireddate,shippeddate 
from Sales.Orders

/*2- Realizar una consulta mostrando los productos y su respectiva categoría (categoryName)*/
select productname, C.categoryName from Production.Products P
inner join Production.Categories C on P.categoryid = C.categoryid

/*3- mostrar el top de los 15 últimos productos creados mostrando el orderDate, requireddate y shippeddate utilizando un
formato de fecha distinto para cada uno*/
select top(15) FORMAT( orderdate,'dd/MM/yyyy'), FORMAT(requireddate,'MM/dd/yyyy'),FORMAT(shippeddate,'yyyy/MM/dd') from Sales.Orders

/*4- tomando en cuenta que tenemos la tabla sales.orders y sales.orderdetails usted debe hacer lo necesario para poder
mostrar el total de las ventas realizadas, agrupándolas de la siguiente forma:
AnoOrden, MesOrden, Total*/
select YEAR(orderdate) AnoOrden, MONTH(orderdate) as MesOrden, unitprice * qty as Total from Sales.OrderDetails D inner join Sales.Orders O 
on D.orderid = O.orderid

/*5- Dado los siguientes querys usted debe ejecutar cada uno si existe alguna diferencia entre los resultados debe
explicarla:*/
select Emp.empid,
Emp.firstname+' '+Emp.lastname as Empleado,
cust.contactname,
o.orderid,
O.orderdate
from hr.Employees Emp inner join sales.Orders O
on emp.empid = o.empid
left join sales.Customers Cust
on Cust.custid = o.custid
order by empid desc

--

select Emp.empid,
Emp.firstname+' '+Emp.lastname as Empleado,
cust.contactname,
o.orderid,
O.orderdate
from hr.Employees Emp inner join sales.Orders O
on emp.empid = o.empid
right join sales.Customers Cust
on o.custid = Cust.custid
order by empid asc

-- Haciendo un right join se cuentan los contactos que no estan vinculados a ninguna orden

--6- Mostrar la cantidad de meses que han pasado de enero a la fecha
select Count(S.studentid) as Estudiantes, S.testid, COUNT(case when s.score > 69 then 1 end) as Aprobados from Stats.Scores S
group by S.testid

--7
select MONTH(GETDATE())-1

/*8- Mostrar en un resultado los campos empid, FullName empleado (HR.EMPLOYEES) mostrando la primera y ultima
orden este empleado creo. Los empleados no deben salir duplicados.*/
select E.empid, CONCAT(E.firstname,' ',E.lastname) as Full_Name ,MAX(O.orderid) as Ultima_Creada, MIN(O.orderid) as Primera_Creada 
from HR.Employees E
inner join Sales.Orders O on O.empid = E.empid
group by E.empid, E.firstname, E.lastname

/*9- Mostrar en un resultado los campos empid, FullName empleado (HR.EMPLOYEES) mostrando el producto con el
precio mínimo y el producto con el precio máximo para la primera orden el empleado creo.*/
select E.empid, CONCAT(E.firstname,' ',E.lastname) as Full_Name ,MAX(d.unitprice) as PrecioMax, MIN(d.unitprice) as PrecioMin
from HR.Employees E
inner join Sales.Orders O on O.empid = E.empid
inner join Sales.OrderDetails D on D.orderid = O.orderid
inner join Production.Products P on D.productid = P.productid
group by E.empid, E.firstname, E.lastname, O.orderid
having O.orderid = (select MIN(O.orderid))

/*10- Mostrar los suplidores (Production.suppliers) cuando el campo contacttitle Contenga la literal
'Manag*/
select contactname, companyname, contacttitle from Production.Suppliers
where contacttitle like '%Manag%'

/*11- tomando la tabla suppliers nos fijamos el companyName viene bajo el patron supplier Codigo, tomando esto en
cuenta separar el companany name mostrando en una columna el Supplier y en otra el literal restante sin espacio.*/
select SUBSTRING(companyname,0,CHARINDEX(' ',companyname)),
	   SUBSTRING(companyname,CHARINDEX(' ',companyname)+1,LEN(companyname)-CHARINDEX(' ',companyname))
from Production.Suppliers

/*12- tomando la tabla products y Suppliers mostrar los campos supplierid, contactname, el producto con el precio mayor
para cada suplidor, la cantidad de productos total de ese suplidor y la cantidad de productos que poseen orden creada.*/
select s.supplierid, count(p.productid) as cant_prod, MAX(p.unitprice) as precio from Production.Products P
inner join Production.Suppliers S on p.supplierid = s.supplierid
group by s.supplierid
order by supplierid