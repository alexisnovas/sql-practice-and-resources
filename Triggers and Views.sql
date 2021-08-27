
-- TRIGGERS
/* Propiedades: as begin, for operation, instead of operation, Before statement: Antes de ejecutar la sentencia de disparo.

-Before row: Antes de modificar cada fila afectada por la sentencia de disparo,y antes de chequear las restricciones de integridad apropiadas .

-After statement: Después de ejecutar la sentencia de disparo,y después de chequear las restricciones de integridad apropiadas.

-After row:  Después de modificar cada fila afectada por la sentencia de disparo y posiblemente aplicando las restricciones de integridad apropiadas . */

-- Ej. 1
ALTER TRIGGER [Production].[tr_InsertProduct]
on [Production].[Products]
for insert 
as
print 'hubo un cambio en la tabla products'

-- Ej. 2
CREATE TRIGGER TR_ARTICULO
	ON ARTICULOS 
	AFTER UPDATE 
		AS 
			BEGIN
				INSERT INTO HCO_ARTICULO 
				(IDARTICULO, STOCK, FECHA)
				SELECT ID_ARTICULO, STOCK, GETDATE()
				FROM INSERTED 
			END 
			
INSERT INTO ARTICULOS VALUES (1, 'MEMORIA', 12, '12/03/2014')

SELECT * FROM ARTICULOS

UPDATE ARTICULOS
SET STOCK = STOCK - 20
WHERE ID_ARTICULO = 1

SELECT * FROM HCO_ARTICULO


-- VIEWS

-- Ej. 1
CREATE VIEW CustomerWithLetterB
AS
SELECT   custid, contactname, contacttitle
FROM         Sales.Customers
WHERE     (SUBSTRING(contactname, CHARINDEX(',', contactname) + 2, 1) = 'B')


