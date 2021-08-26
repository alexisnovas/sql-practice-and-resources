/* 
	Alexis Novas (1086316)
	Proyecto 5:Programación SQL
	Bases de Datos 2 - Prof. Enmanuel Madrigal
*/

-- Ejecución de los Stored Procedures y Funciones

EXEC spIngresarProducto 'Pañuelo Azul', 'Bandana', 1000,3,7 -- Parámetros: Nombre del Producto, Descripcion, Precio, Cantidad, Categoria.

EXEC spActualizarProducto 1010,'Tennis Reebok X12','Deportivos', 5000, 16, 1 -- Parámetros: ID Producto, Nombre del Producto, Descripcion, Precio, Cantidad, Categoria.

EXEC spEliminarProducto 1008 -- Parámetros: ID Producto.

EXEC spRegistrarOrden 2,9,3 --Parámetros: ID Cliente, ID Producto, Cantidad a Comprar

EXEC spActualizarCliente 1,'Alexis','Novas','alexisnovas8@yahoo.com',0821,'calle la manzanita', '109762', 'Santo Domingo', '8096651829' -- Parámetros: Email, Nombre, Apellido, Contraseña, Direccion, Codigo Postal, Ciudad, Telefono, Descuento, Puntos.

select * from FN_Obtener_Top5_Productos_Vendidos()

select * from FN_Obtener_Top_Productos_Comprados(1) -- Parámetros: ID Cliente

EXEC spDescuentoClienteTop 10 -- Parámetros: Porcentaje del descuento que se desea aplicar.

select * from FN_Top_Categorias_Vendidas ()

select * from FN_Top_Productos_Vendidos_Por_Categoria (3) -- Parámetros: ID Categoría


--DESARROLLO DE STORED PROCEDURES Y FUNCIONES.

--1. SP Ingresar nuevos Productos
ALTER PROCEDURE spIngresarProducto
    @prod_Name AS NVARCHAR(100),
    @prod_Desc AS NVARCHAR(MAX),
    @price AS DECIMAL(10,2),
    @stock AS INT,
    @categoryId AS INT

AS
BEGIN

    SET NOCOUNT ON;

    BEGIN TRAN TaddProduct

    BEGIN TRY

        INSERT INTO [dbo].[Product] (Product_Name, Product_Description, Price, Stock, Category_Id) VALUES (@prod_Name, @prod_Desc, @price, @stock, @categoryId)

		SELECT 'El producto fue ingresado exitosamente.' [Status]

        COMMIT TRAN TaddProduct

    END TRY
    BEGIN CATCH
		SELECT ERROR_MESSAGE() AS error
        ROLLBACK TRAN TaddProduct

    END CATCH

END
GO


--2. SP Eliminar Productos
CREATE PROCEDURE spEliminarProducto @productID INT
AS
BEGIN
	SET NOCOUNT ON;

	IF NOT EXISTS(SELECT 1 FROM Product WHERE Product_Id = @productID)
	BEGIN
		SELECT 'El producto no existe.' [Status]
		RETURN
	END

    BEGIN TRAN TdeleteProduct

    BEGIN TRY

        DELETE FROM Product WHERE Product_Id = @productID

		SELECT 'El producto fue eliminado exitosamente.' [Status]

        COMMIT TRAN TdeleteProduct

    END TRY
    BEGIN CATCH
		SELECT ERROR_MESSAGE() AS error
        ROLLBACK TRAN TdeleteProduct

    END CATCH

END
GO


--3. SP Actualizar Productos
CREATE PROCEDURE spActualizarProducto 
	@productID INT, 
	@prod_Name NVARCHAR(100), 
	@prod_Desc NVARCHAR(MAX), 
	@price DECIMAL(10,2),
    @stock INT,
    @categoryId INT
AS
BEGIN
	SET NOCOUNT ON;

	IF NOT EXISTS(SELECT 1 FROM Product WHERE Product_Id = @productID)
	BEGIN
		SELECT 'El producto no existe.' [Status]
		RETURN
	END

    BEGIN TRAN TupdateProduct

    BEGIN TRY

        UPDATE [dbo].[Product] SET Product_Name = @prod_Name, Product_Description = @prod_Desc, 
		Price = @price, Stock = @stock, Category_Id = @categoryId WHERE Product_Id = @productID

		SELECT 'El producto fue actualizado exitosamente.' [Status]

        COMMIT TRAN TupdateProduct

    END TRY
    BEGIN CATCH
		SELECT ERROR_MESSAGE() AS error
        ROLLBACK TRAN TupdateProduct

    END CATCH

END
GO


--4. Registrar compras teniendo en cuenta los impuestos (Tienen que separar el
--neto de los impuestos. Si revisan cualquier factura se darán cuenta de que
--siempre se muestra separado).
--Nota: No debe aceptar datos erróneos ni vacíos, no se pueden procesar
--compras si no hay mercancía suficiente (Por ejemplo: Un cliente puede pedir 3
--correas pero solo hay 1 disponible, debe enviar un mensaje para notificarle al
--cliente)

--Aqui tambien esta incluido  el punto 7. Por cada 100 pesos de compra, a los 
--clientes se le da un crédito en la tienda.
ALTER PROCEDURE spRegistrarOrden @customerId INT, @productId INT, @productQty INT
AS
BEGIN
	SET NOCOUNT ON

	DECLARE @Orden INT
	--DECLARE Registros INT
	DECLARE @nueva_existencia INT
	DECLARE @existencia_actual INT
	DECLARE @Precio DECIMAL(10,2)
	DECLARE @Subtotal DECIMAL(10,2)
	DECLARE @ITBIS DECIMAL(4,2)
	DECLARE @PorcentajeDescuento INT
	DECLARE @TotalDescuentos INT = 0
	DECLARE @TotalNeto DECIMAL(10,2) = 0
	DECLARE @SubtotalDescontado DECIMAL(10,2) = 0
	DECLARE @CreditoActual INT= 0
	DECLARE @CreditoNuevo INT= 0
	DECLARE @CreditoCompra INT= 0

	SET @existencia_actual = (SELECT Stock FROM [dbo].[Product] WHERE Product_Id = @productId)
	SET @CreditoActual = (SELECT Points FROM [dbo].[Customer] WHERE Customer_Id = @customerId)

	IF NOT EXISTS(SELECT Customer_Id FROM [dbo].[Customer] WHERE Customer_Id = @customerId) OR @customerId IS NULL
		BEGIN
			Select 'El cliente ingresado no existe.'
			RETURN
		END
	ELSE IF NOT EXISTS(SELECT Product_Id FROM [dbo].[Product] WHERE Product_Id = @productId) OR @productId IS NULL
		BEGIN
			Select 'El producto ingresado no existe.'
			RETURN
		END
	ELSE IF @productQty < 1
		BEGIN
			Select 'No es posible registrar una cantidad de productos negativa.'
			RETURN
		END
	ELSE IF @existencia_actual < @productQty
		BEGIN
			Select 'No hay productos en Stock suficientes para realizar esta compra.'
			RETURN
		END

	BEGIN TRAN TregistrarCompra
	BEGIN TRY
		SET @ITBIS = 0.18;
		SET @Precio = (SELECT Price FROM [dbo].[Product] WHERE Product_Id = @productId);
		Set @PorcentajeDescuento = (SELECT ISNULL(Discount,0) FROM [dbo].[Customer] WHERE Customer_Id = @customerId);
		SET @Subtotal = SUM(@Precio * @productQty);
		SET @TotalDescuentos = ((@Subtotal * @PorcentajeDescuento)/100)
		SET @SubtotalDescontado = @Subtotal - @TotalDescuentos
		SET @TotalNeto = (@SubtotalDescontado + (@SubtotalDescontado*@ITBIS));
		SET @CreditoCompra = @TotalNeto/100
		
		INSERT INTO [dbo].[Order] VALUES (GETDATE(), @customerId, DATEADD(DAY, 3, GETDATE()), '1');
		SET @Orden = SCOPE_IDENTITY();
		INSERT INTO [dbo].[Order_Detail] VALUES (@productId, @productQty, @Precio, @Subtotal, @Orden, @ITBIS, @TotalNeto);
		
		SET @nueva_existencia = @existencia_actual - @productQty;
		UPDATE [dbo].[Product] SET Stock = @nueva_existencia WHERE Product_Id = @productId;

		SET @CreditoNuevo = ISNULL(@CreditoActual,0) + @CreditoCompra;
		UPDATE [dbo].[Customer] SET Points = @CreditoNuevo WHERE Customer_Id = @customerId;
	
		COMMIT TRAN TregistrarCompra

	END TRY
	BEGIN CATCH
		SELECT ERROR_MESSAGE() AS error
		ROLLBACK TRAN TregistrarCompra
	END CATCH
END
GO


--5. Mostrar los 5 productos mas vendidos

ALTER FUNCTION FN_Obtener_Top5_Productos_Vendidos () RETURNS @Top5 TABLE(
ProductId Int,
ProductName nvarchar(100),
CantidadVendida Int
)
AS
BEGIN
	INSERT INTO @Top5
	SELECT TOP (5) P.Product_Id [IDProducto], P.Product_Name [NombreProducto], SUM(OD.Product_Qty) [CantidadVendida] from [dbo].[Product] AS P
	INNER JOIN [dbo].[Order_Detail] AS OD ON OD.Product_Id = P.Product_Id
	GROUP BY P.Product_Name, P.Product_Id
	ORDER BY CantidadVendida DESC
	RETURN;
END


--6. Mostrar los productos mas vendidos para un cliente en específico.

ALTER FUNCTION FN_Obtener_Top_Productos_Comprados (@idCustomer INT) RETURNS @TopProductosComprados TABLE(
ProductId Int,
ProductName nvarchar(100),
CantidadComprada Int
)
AS
BEGIN
	INSERT INTO @TopProductosComprados
	SELECT TOP(10) P.Product_Id [IDProducto], P.Product_Name [NombreProducto], 
	SUM(OD.Product_Qty) [Cantidad_Comprada] from [dbo].[Product] AS P
	INNER JOIN [dbo].[Order_Detail] AS OD ON OD.Product_Id = P.Product_Id
	INNER JOIN [dbo].[Order] AS O ON O.Order_No = OD.Order_No WHERE Customer_Id = @idCustomer
	GROUP BY P.Product_Name, P.Product_Id
	ORDER BY Cantidad_Comprada DESC
	RETURN;
END


--8. Obtener el cliente con más puntos en la tienda para que pueda obtener un descuento.ALTER PROCEDURE spDescuentoClienteTop @porciento_descuento INT
AS
BEGIN
	SET NOCOUNT ON;

    BEGIN TRAN TdescuentoClienteTop

    BEGIN TRY

		DECLARE @TopCustomerId INT
		SET @TopCustomerId = (SELECT TOP(1) C.Customer_Id FROM [dbo].[Customer] AS C
		ORDER BY C.Points DESC)

		UPDATE [dbo].[Customer] SET Discount = @porciento_descuento WHERE Customer_Id = @TopCustomerId

		SELECT TOP(1) C.Customer_Id, CONCAT_WS(' ', C.First_Name, C.Last_Name) [Nombre Cliente],
		C.Points [Puntos], C.Discount [% Descuento Aplicado], 'El descuento fue aplicado exitosamente.' [Status]
		FROM [dbo].[Customer] AS C ORDER BY C.Points DESC

        COMMIT TRAN TdescuentoClienteTop

    END TRY
    BEGIN CATCH
		SELECT ERROR_MESSAGE() AS error
        ROLLBACK TRAN TdescuentoClienteTop

    END CATCH

END
GO


-- 10. Actualizar Cliente
ALTER PROCEDURE spActualizarCliente
	@customerID INT, 
	@email NVARCHAR(50),
	@firstName NVARCHAR(50), 
	@lastName NVARCHAR(50), 
	@password NVARCHAR(50),
    @adress NVARCHAR(MAX),
    @postCode NVARCHAR(50),
	@city NVARCHAR(50),
	@phone NVARCHAR(50)
AS
BEGIN
	SET NOCOUNT ON;

	IF NOT EXISTS(SELECT 1 FROM Customer WHERE Customer_Id = @customerID)
	BEGIN
		SELECT 'El cliente no existe.' [Status]
		RETURN
	END

    BEGIN TRAN TupdateCliente

    BEGIN TRY

        UPDATE [dbo].[Customer] SET First_Name = @firstName, Last_Name = @lastName,
		Customer_Email=@email, [Password] = @password, [Address] = @adress, PostCode = @postCode,
		City = @city, Phone = @phone WHERE Customer_Id = @customerID

		SELECT 'El cliente fue actualizado exitosamente.' [Status]

        COMMIT TRAN TupdateCliente

    END TRY
    BEGIN CATCH
		SELECT ERROR_MESSAGE() AS error
        ROLLBACK TRAN TupdateCliente

    END CATCH

END
GO


-- 10-Debe registrar al menos 500 ventas de productos para que pueda
--realizar un ranking utilizando las funciones pertinentes donde se muestren
--un ranking de las categorías más vendidas, y un ranking de los productos
--más vendidos por categorías.

 -- Top Categorías Vendidas
ALTER FUNCTION FN_Top_Categorias_Vendidas () RETURNS @TopCategoriasVendidas TABLE(
IdCategoria Int,
NombreCategoria nvarchar(100),
CantidadProductosVendidos Int
)
AS
BEGIN
	INSERT INTO @TopCategoriasVendidas
		SELECT TOP (7) C.Category_Id [ID Categoría], C.Category_Name [NombreCategoria], 
		SUM(OD.Product_Qty) [Cantidad_Productos_Vendidos] from [dbo].[Product] AS P
		INNER JOIN [dbo].[Order_Detail] AS OD ON OD.Product_Id = P.Product_Id
		INNER JOIN [dbo].[Category] AS C ON C.Category_Id = P.Category_Id
		GROUP BY C.Category_Name, C.Category_Id
		ORDER BY Cantidad_Productos_Vendidos DESC

	RETURN;
END

 -- Top Productos Más Vendidos Por Categoría Vendidas
ALTER FUNCTION FN_Top_Productos_Vendidos_Por_Categoria (@idCategoria INT) RETURNS @TopProductosXCategoria TABLE(
IdProducto Int,
NombreProducto nvarchar(100),
CantidadVendidos Int
)
AS
BEGIN
	INSERT INTO @TopProductosXCategoria
		SELECT TOP (7) P.Product_Id [ID Producto], P.Product_Name [Nombre Producto],SUM(OD.Product_Qty) [Cantidad_Productos_Vendidos] from [dbo].[Product] AS P
		INNER JOIN [dbo].[Order_Detail] AS OD ON OD.Product_Id = P.Product_Id
		WHERE P.Category_Id = @idCategoria
		GROUP BY P.Product_Id, P.Product_Name
		ORDER BY Cantidad_Productos_Vendidos DESC

	RETURN;
END


-- Poblar Compras
ALTER PROCEDURE Poblar_Compras
AS
BEGIN
	DECLARE @IdCliente INT
	DECLARE @IdProducto INT
	DECLARE @IdCantidad INT
	DECLARE @CantidadVentas INT 
	SET @CantidadVentas = 0

	WHILE ( @CantidadVentas <= 730)
	BEGIN
		SET @IdCliente = (SELECT ROUND(((10 - 1) * RAND() + 1),0))
		SET @IdProducto = (SELECT ROUND(((1027 - 1002) * RAND() + 1002),0))
		SET @IdCantidad = (SELECT ROUND(((5 - 1) * RAND() + 1),0))

		EXEC spRegistrarOrden @idCliente,@IdProducto,@IdCantidad
		SET @CantidadVentas  = (SELECT COUNT(Order_No) from [dbo].[Order])
	END
END


-- PD: Hice mi grupo con Dios :)
