USE [GD2C2022];

-- Elimino FKs de ejecuciones pasadas...
DECLARE @borrarFKs NVARCHAR(MAX) = N'';

SELECT @borrarFKs  += N'
ALTER TABLE ' + QUOTENAME(OBJECT_SCHEMA_NAME(parent_object_id))
    + '.' + QUOTENAME(OBJECT_NAME(parent_object_id)) + 
    ' DROP CONSTRAINT ' + QUOTENAME(name) + ';'
FROM sys.foreign_keys;
EXEC sp_executesql @borrarFKs 
GO

-- DROP TABLES

IF OBJECT_ID ('AguanteMySql36.Descuento') IS NOT NULL DROP TABLE AguanteMySql36.Descuento;
IF OBJECT_ID ('AguanteMySql36.Descuento_x_compra') IS NOT NULL DROP TABLE AguanteMySql36.Descuento_x_compra;
IF OBJECT_ID ('AguanteMySql36.Descuento_x_venta') IS NOT NULL DROP TABLE AguanteMySql36.Descuento_x_venta;
IF OBJECT_ID ('AguanteMySql36.Descuento_compra') IS NOT NULL DROP TABLE AguanteMySql36.Descuento_compra;
IF OBJECT_ID ('AguanteMySql36.Descuento_venta') IS NOT NULL DROP TABLE AguanteMySql36.Descuento_venta;
IF OBJECT_ID ('AguanteMySql36.variante') IS NOT NULL DROP TABLE AguanteMySql36.variante;
IF OBJECT_ID ('AguanteMySql36.Cupon_x_venta') IS NOT NULL DROP TABLE AguanteMySql36.Cupon_x_venta;
IF OBJECT_ID ('AguanteMySql36.Producto') IS NOT NULL DROP TABLE AguanteMySql36.Producto;
IF OBJECT_ID ('AguanteMySql36.Tipo_variante') IS NOT NULL DROP TABLE AguanteMySql36.Tipo_variante;
IF OBJECT_ID ('AguanteMySql36.Venta') IS NOT NULL DROP TABLE AguanteMySql36.Venta;
IF OBJECT_ID ('AguanteMySql36.Cliente') IS NOT NULL DROP TABLE AguanteMySql36.Cliente;
IF OBJECT_ID ('AguanteMySql36.Envio') IS NOT NULL DROP TABLE AguanteMySql36.Envio;
IF OBJECT_ID ('AguanteMySql36.Compra') IS NOT NULL DROP TABLE AguanteMySql36.Compra;
IF OBJECT_ID ('AguanteMySql36.Proveedor') IS NOT NULL DROP TABLE AguanteMySql36.Proveedor;
IF OBJECT_ID ('AguanteMySql36.Canal_venta') IS NOT NULL DROP TABLE AguanteMySql36.Canal_venta;
IF OBJECT_ID ('AguanteMySql36.Medio_envio') IS NOT NULL DROP TABLE AguanteMySql36.Medio_envio;
IF OBJECT_ID ('AguanteMySql36.Medios_de_pago_venta') IS NOT NULL DROP TABLE AguanteMySql36.Medios_de_pago_venta;
IF OBJECT_ID ('AguanteMySql36.Barrio') IS NOT NULL DROP TABLE AguanteMySql36.Barrio;
IF OBJECT_ID ('AguanteMySql36.Categoria') IS NOT NULL DROP TABLE AguanteMySql36.Categoria;
IF OBJECT_ID ('AguanteMySql36.Marca') IS NOT NULL DROP TABLE AguanteMySql36.Marca;
IF OBJECT_ID ('AguanteMySql36.Material') IS NOT NULL DROP TABLE AguanteMySql36.Material;
IF OBJECT_ID ('AguanteMySql36.Medios_de_pago_compra') IS NOT NULL DROP TABLE AguanteMySql36.Medios_de_pago_compra;
IF OBJECT_ID ('AguanteMySql36.Cupon') IS NOT NULL DROP TABLE AguanteMySql36.Cupon;
IF OBJECT_ID ('AguanteMySql36.provincias') IS NOT NULL DROP TABLE AguanteMySql36.provincias;
IF OBJECT_ID ('AguanteMySql36.Producto_por_compra') IS NOT NULL DROP TABLE AguanteMySql36.Producto_por_compra;
IF OBJECT_ID ('AguanteMySql36.producto_variante') IS NOT NULL DROP TABLE AguanteMySql36.producto_variante;
IF OBJECT_ID ('AguanteMySql36.Productos_por_Venta') IS NOT NULL DROP TABLE AguanteMySql36.Productos_por_Venta;
GO

-- DROP SCHEMA

IF EXISTS(
SELECT * FROM sys.schemas where name = 'AguanteMySql36'
)
BEGIN
	DROP SCHEMA [AguanteMySql36]

END
GO
CREATE SCHEMA AguanteMySql36;
GO


CREATE TABLE [AguanteMySql36].[Canal_venta] (
  [id] int IDENTITY(1,1),
  [nombre] nvarchar(255),
  PRIMARY KEY ([id])
);

CREATE TABLE [AguanteMySql36].[Cliente] (
  [cliente_id] INT,
  [nombre] nvarchar(255),
  [apellido] nvarchar(255),
  [dni] decimal(18,0),
  [provincia] nvarchar(255),
  [codigo_postal] decimal(18,0),
  [direccion] nvarchar(255),
  [telefono] decimal(18,0),
  [mail] nvarchar(255),
  [fecha_nacimiento] date,
  [localidad] nvarchar(255),
  PRIMARY KEY ([cliente_id])
);

CREATE TABLE [AguanteMySql36].[Medios_de_pago_venta] (
  [id_medio_pago] Int IDENTITY(1,1),
  [tipo] nvarchar(2255), -- TODO! Checkear si el tipo de dato est� bien
  [costo_transaccion] decimal(18,2),
  [descuento_medio] decimal(3,1),
  PRIMARY KEY ([id_medio_pago])
);

CREATE TABLE [AguanteMySql36].[Medio_envio] (
  [id] int IDENTITY(1,1),
  [nombre_medio_envio] nvarchar(255),
  PRIMARY KEY ([id])
);

CREATE TABLE [AguanteMySql36].[provincias] (
  [id] int IDENTITY(1,1),
  [nombre] nvarchar(255),
  PRIMARY KEY ([id])
);

CREATE TABLE [AguanteMySql36].[Barrio] (
  [codigo_postal] int,
  [provincia_id] int,
  [nombre] varchar,
  PRIMARY KEY ([codigo_postal]),
  CONSTRAINT [FK_Barrio.provincia_id]
    FOREIGN KEY ([provincia_id])
      REFERENCES [AguanteMySql36].[provincias]([id])
);

CREATE TABLE [AguanteMySql36].[Envio] (
  [envio_id] int IDENTITY(1,1),
  [codigo_postal] INT,
  [medio_envio_id] int,
  [precio_envio] decimal(18,2),
  PRIMARY KEY ([envio_id]),
  CONSTRAINT [FK_Envio.medio_envio_id]
    FOREIGN KEY ([medio_envio_id])
      REFERENCES [AguanteMySql36].[Medio_envio]([id]),
  CONSTRAINT [FK_Envio.codigo_postal]
    FOREIGN KEY ([codigo_postal])
      REFERENCES [AguanteMySql36].[Barrio]([codigo_postal])
);

CREATE TABLE [AguanteMySql36].[Venta] (
  [num_venta] decimal(19,0),
  [cliente_id] int,
  [envio_id] int,
  [id_medio_pago] Int,
  [fecha_venta] DATE,
  [medio_pago_costo] decimal(18,2),
  [medio_pago_descuento] decimal(18,2),
  [envio_costo] decimal(18,2),
  [canal_venta_costo] decimal(18,2),
  [total] decimal(18,2),
  [canal_venta] int,
  PRIMARY KEY ([num_venta]),
  CONSTRAINT [FK_Venta.canal_venta]
    FOREIGN KEY ([canal_venta])
      REFERENCES [AguanteMySql36].[Canal_venta]([id]),
  CONSTRAINT [FK_Venta.cliente_id]
    FOREIGN KEY ([cliente_id])
      REFERENCES [AguanteMySql36].[Cliente]([cliente_id]),
  CONSTRAINT [FK_Venta.id_medio_pago]
    FOREIGN KEY ([id_medio_pago])
      REFERENCES [AguanteMySql36].[Medios_de_pago_venta]([id_medio_pago]),
  CONSTRAINT [FK_Venta.envio_id]
    FOREIGN KEY ([envio_id])
      REFERENCES [AguanteMySql36].[Envio]([envio_id])
);

CREATE TABLE [AguanteMySql36].[Cupon] (
  [cupon_codigo] nvarchar(255),
  [fecha_desde] DATE,
  [fecha_hasta] DATE,
  [tipo] nvarchar(50),
  [valor] decimal(18,2),
  PRIMARY KEY ([cupon_codigo])
);

CREATE TABLE [AguanteMySql36].[Cupon_x_venta] (
  [cupon_codigo] nvarchar(255),
  [num_venta] decimal(19,0),
  CONSTRAINT [FK_Cupon_x_venta.num_venta]
    FOREIGN KEY ([num_venta])
      REFERENCES [AguanteMySql36].[Venta]([num_venta]),
  CONSTRAINT [FK_Cupon_x_venta.cupon_codigo]
    FOREIGN KEY ([cupon_codigo])
      REFERENCES [AguanteMySql36].[Cupon]([cupon_codigo])
);

CREATE TABLE [AguanteMySql36].[Descuento_venta] (
  [id_concepto] decimal(18,2),
  [importe] decimal(18,0),
  PRIMARY KEY ([id_concepto])
);

CREATE TABLE [AguanteMySql36].[Tipo_variante] (
  [tipo_variante_id] Int IDENTITY(1,1),
  [descripcion] nvarchar(50),
  PRIMARY KEY ([tipo_variante_id])
);

CREATE TABLE [AguanteMySql36].[variante] (
  [variante_id] int IDENTITY(1,1),
  [tipo_variante_id] Int,
  PRIMARY KEY ([variante_id]),
  CONSTRAINT [FK_variante.tipo_variante_id]
    FOREIGN KEY ([tipo_variante_id])
      REFERENCES [AguanteMySql36].[Tipo_variante]([tipo_variante_id])
);

CREATE TABLE [AguanteMySql36].[material] (
  [material_id] Int IDENTITY(1,1),
  [nombre] nvarchar(255),
  PRIMARY KEY ([material_id])
);

CREATE TABLE [AguanteMySql36].[Categoria] (
  [categoria_id] Int IDENTITY(1,1),
  [nombre] nvarchar(255),
  PRIMARY KEY ([categoria_id])
);

CREATE TABLE [AguanteMySql36].[Marca] (
  [marca_id] Int IDENTITY(1,1),
  [nombre] nvarchar(255),
  PRIMARY KEY ([marca_id])
);

CREATE TABLE [AguanteMySql36].[Producto] (
  [producto_id] nvarchar(50),
  [marca_id] int,
  [categoria_id] int,
  [material_id] int,
  [nombre] nvarchar(50),
  [descripcion] nvarchar(50),
  PRIMARY KEY ([producto_id]),
  CONSTRAINT [FK_Producto.material_id]
    FOREIGN KEY ([material_id])
      REFERENCES [AguanteMySql36].[material]([material_id]),
  CONSTRAINT [FK_Producto.categoria_id]
    FOREIGN KEY ([categoria_id])
      REFERENCES [AguanteMySql36].[Categoria]([categoria_id]),
  CONSTRAINT [FK_Producto.marca_id]
    FOREIGN KEY ([marca_id])
      REFERENCES [AguanteMySql36].[Marca]([marca_id])
);

CREATE TABLE [AguanteMySql36].[producto_variante] (
  [producto_variante_codigo] int IDENTITY(1,1),
  [producto_id] nvarchar(50),
  [variante_id] Int,
  [precio_unitario] decimal(18,0),
  [stock] int,
  PRIMARY KEY ([producto_variante_codigo]),
  CONSTRAINT [FK_producto_variante.variante_id]
    FOREIGN KEY ([variante_id])
      REFERENCES [AguanteMySql36].[variante]([variante_id]),
  CONSTRAINT [FK_producto_variante.producto_id]
    FOREIGN KEY ([producto_id])
      REFERENCES [AguanteMySql36].[Producto]([producto_id])
);

CREATE TABLE [AguanteMySql36].[Medios_de_pago_compra] (
  [id_medio_pago] nvarchar(255),
  [tipo] nvarchar(50),
  [costo_transaccion] decimal(18,2),
  PRIMARY KEY ([id_medio_pago])
);

CREATE TABLE [AguanteMySql36].[Proveedor] (
  [id_proveedor] int IDENTITY(1,1),
  [CUIT] nvarchar(50),
  [razon_social] nvarchar(50),
  [domicilio] nvarchar(50),
  [telefono] nvarchar(50) null,
  [mail] nvarchar(50),
  [provincia_id] int,
  [localidad] nvarchar(255),
  [codigo_postal] decimal(18,0),
  PRIMARY KEY ([id_proveedor])
);

CREATE TABLE [AguanteMySql36].[Compra] (
  [num_compra] decimal(19,0),
  [proveedor_id] int,
  [id_medio_pago] nvarchar(255),
  [fecha] DATE,
  [total] decimal(18,2),
  [medio_pago_costo] decimal(18,2),
  PRIMARY KEY ([num_compra]),
  CONSTRAINT [FK_Compra.id_medio_pago]
    FOREIGN KEY ([id_medio_pago])
      REFERENCES [AguanteMySql36].[Medios_de_pago_compra]([id_medio_pago]),
  CONSTRAINT [FK_Compra.proveedor_id]
    FOREIGN KEY ([proveedor_id])
      REFERENCES [AguanteMySql36].[Proveedor]([id_proveedor])
);


CREATE TABLE [AguanteMySql36].[Producto_por_compra] (
  [num_compra] decimal(19,0),
  [producto_variante_codigo] int,
  [cantidad_comprada] decimal(18,0),
  [precio_unitario] decimal(18,2),
  [total] decimal(18,2),
  PRIMARY KEY ([num_compra]),
  CONSTRAINT [FK_Producto_por_compra.producto_variante_codigo]
    FOREIGN KEY ([producto_variante_codigo])
      REFERENCES [AguanteMySql36].[producto_variante]([producto_variante_codigo]),
  CONSTRAINT [FK_Producto_por_compra.num_compra]
    FOREIGN KEY ([num_compra])
      REFERENCES [AguanteMySql36].[Compra]([num_compra])
);

CREATE TABLE [AguanteMySql36].[Productos_por_Venta] (
  [num_venta] decimal(19,0),
  [producto_variante_codigo] int,
  [cantidad_vendida] decimal(18,0),
  [total] decimal(18,2),
  PRIMARY KEY ([num_venta]),
  CONSTRAINT [FK_Productos_por_Venta.producto_variante_codigo]
    FOREIGN KEY ([producto_variante_codigo])
      REFERENCES [AguanteMySql36].[producto_variante]([producto_variante_codigo]),
  CONSTRAINT [FK_Productos_por_Venta.num_venta]
    FOREIGN KEY ([num_venta])
      REFERENCES [AguanteMySql36].[Venta]([num_venta])
);

CREATE TABLE [AguanteMySql36].[Descuento_x_venta] (
  [id_descuento] Int IDENTITY(1,1),
  [num_venta] decimal(19,0),
  [importe_descuento] decimal(18,2),
  [descuento_concepto] decimal(18,0),
  CONSTRAINT [FK_Descuento_x_venta.id_descuento]
    FOREIGN KEY ([id_descuento])
      REFERENCES [AguanteMySql36].[Descuento_venta]([id_concepto]),
  CONSTRAINT [FK_Descuento_x_venta.num_venta]
    FOREIGN KEY ([num_venta])
      REFERENCES [AguanteMySql36].[Venta]([num_venta])
);

CREATE TABLE [AguanteMySql36].[Descuento_compra] (
  [id_descuento] decimal(19,0),
  [porcentaje] decimal(18,2),
  PRIMARY KEY ([id_descuento])
);

CREATE TABLE [AguanteMySql36].[Descuento_x_compra] (
  [id_descuento] decimal(19,0),
  [num_compra] decimal(19,0),
  [descuento_aplicado] decimal(18,2),
  CONSTRAINT [FK_Descuento_x_compra.id_descuento]
    FOREIGN KEY ([id_descuento])
      REFERENCES [AguanteMySql36].[Descuento_compra]([id_descuento]),
  CONSTRAINT [FK_Descuento_x_compra.num_compra]
    FOREIGN KEY ([num_compra])
      REFERENCES [AguanteMySql36].[Compra]([num_compra])
);

GO

CREATE PROCEDURE [AguanteMySql36].migrar_material
AS 
BEGIN
	INSERT INTO [AguanteMySql36].material(nombre)
	SELECT DISTINCT
		PRODUCTO_MATERIAL as nombre
	FROM gd_esquema.Maestra
	WHERE PRODUCTO_MATERIAL is not null

	IF @@ERROR != 0
	PRINT('MATERIAL FAIL!')
	ELSE
	PRINT('MATERIAL OK!')
END

GO
-- EXEC [AguanteMySql36].migrar_material

CREATE PROCEDURE [AguanteMySql36].migrar_provincias
AS 
BEGIN
	INSERT INTO [AguanteMySql36].provincias(nombre)
	SELECT
	CLIENTE_PROVINCIA
	from gd_esquema.Maestra
	WHERE CLIENTE_PROVINCIA is not null 
	UNION
	SELECT
	PROVEEDOR_PROVINCIA
	from gd_esquema.Maestra
	WHERE PROVEEDOR_PROVINCIA is not null 

	IF @@ERROR != 0
	PRINT('PROVINCIA FAIL!')
	ELSE
	PRINT('PROVINCIA OK!')
END

-- MATERIA, PROVICNIAS, MARCA
GO


CREATE PROCEDURE [AguanteMySql36].migrar_marca
AS 
BEGIN
	INSERT INTO [AguanteMySql36].Marca(nombre)
	SELECT DISTINCT
	PRODUCTO_MARCA
	from gd_esquema.Maestra
	WHERE PRODUCTO_MARCA is not null 
	ORDER BY PRODUCTO_MARCA

	IF @@ERROR != 0
	PRINT('MARCA FAIL!')
	ELSE
	PRINT('MARCA OK!')
END

GO

-- TODO: Investigar como DROPEAR los stored procedures
-- DROP PROCEDURE [<stored procedure name>];
-- GO

--Categoria

GO

CREATE PROCEDURE [AguanteMySql36].migrar_categoria
AS 
BEGIN
	INSERT INTO [AguanteMySql36].Categoria(nombre)
	SELECT DISTINCT
		PRODUCTO_CATEGORIA as nombre
	FROM gd_esquema.Maestra
	WHERE PRODUCTO_MATERIAL is not null

	IF @@ERROR != 0
	PRINT('CATEGORIA FAIL!')
	ELSE
	PRINT('CATEGORIA OK!')
END

--Variante
GO

CREATE PROCEDURE [AguanteMySql36].migrar_tipo_variante
AS 
BEGIN
	INSERT INTO [AguanteMySql36].Tipo_variante(descripcion)
	SELECT DISTINCT
		PRODUCTO_TIPO_VARIANTE as descripcion
	FROM gd_esquema.Maestra
	WHERE PRODUCTO_TIPO_VARIANTE is not null

	IF @@ERROR != 0
	PRINT('CATEGORIA FAIL!')
	ELSE
	PRINT('CATEGORIA OK!')
END

--Cupon


GO

CREATE PROCEDURE [AguanteMySql36].migrar_cupon
AS 
BEGIN

	INSERT INTO [AguanteMySql36].Cupon(fecha_desde)
	  SELECT DISTINCT
		  PRODUCTO_CUPON_FECHA_DESDE as fecha_desde
      WHERE PRODUCTO_CUPON_FECHA_DESDE is not null
	INSERT INTO [AguanteMySql36].Cupon(fecha_hasta)
  	SELECT DISTINCT
	  	PRODUCTO_CUPON_FECHA_HASTA as fecha_hasta
    	WHERE PRODUCTO_CUPON_FECHA_HASTA is not null 
  INSERT INTO [AguanteMySql36].Cupon(tipo)
	  SELECT DISTINCT
	  	PRODUCTO_CUPON_TIPO as tipo
       	WHERE PRODUCTO_CUPON_TIPO is fnot null
  INSERT INTO [AguanteMySql36].Cupon(valor)
	  SELECT DISTINCT
	  	PRODUCTO_CUPON_VALOR as valor
       	WHERE PRODUCTO_CUPON_VALOR is not null
  
	FROM gd_esquema.Maestra
  
	IF @@ERROR != 0
	PRINT('CUPON FAIL!')
	ELSE
	PRINT('CUPON OK!')
END

-- Canal de venta 
GO

CREATE PROCEDURE [AguanteMySql36].migrar_canal_venta
AS 
BEGIN
	INSERT INTO [AguanteMySql36].Canal_venta(nombre)
	SELECT DISTINCT
		VENTA_CANAL as nombre 
	FROM gd_esquema.Maestra
	WHERE VENTA_CANAL is not null

	IF @@ERROR != 0
	PRINT('CANAL DE VENTA FAIL!')
	ELSE
	PRINT('CANAL DE VENTA OK!')
END

GO

-- Medio_envio 
GO

CREATE PROCEDURE [AguanteMySql36].migrar_Medio_envio
AS 
BEGIN
	INSERT INTO [AguanteMySql36].Medio_envio(nombre_medio_envio)
	SELECT DISTINCT
		VENTA_MEDIO_ENVIO as nombre_medio_envio 
	FROM gd_esquema.Maestra
	WHERE VENTA_MEDIO_ENVIO is not null

	IF @@ERROR != 0
	PRINT('Medio_envio FAIL!')
	ELSE
	PRINT('Medio_envio OK!')
END
GO

-- Medios_de_pago_ventas
GO

CREATE PROCEDURE [AguanteMySql36].migrar_Medios_de_pago_venta
AS 
BEGIN
	INSERT INTO [AguanteMySql36].Medios_de_pago_venta(tipo, costo_transaccion)
	SELECT DISTINCT
		VENTA_MEDIO_PAGO as tipo,
    VENTA_MEDIO_PAGO_COSTO as costo_transaccion
	FROM gd_esquema.Maestra
	WHERE VENTA_MEDIO_PAGO is not null

	IF @@ERROR != 0
	PRINT('Medios_de_pago_venta FAIL!')
	ELSE
	PRINT('Medios_de_pago_venta OK!')
END
GO

-- Medios_de_pago_compra
GO
CREATE PROCEDURE [AguanteMySql36].migrar_Medios_de_pago_compra
AS 
BEGIN
	INSERT INTO [AguanteMySql36].Medios_de_pago_compra(tipo) -- , costo_transaccion
	SELECT DISTINCT
		COMPRA_MEDIO_PAGO as tipo,
    --VENTA_MEDIO_PAGO_COSTO as costo_transaccion
	FROM gd_esquema.Maestra
	WHERE COMPRA_MEDIO_PAGO is not null

	IF @@ERROR != 0
	PRINT('Medios_de_pago_compra FAIL!')
	ELSE
	PRINT('Medios_de_pago_compra OK!')
END
GO

-- Descuento_compra
GO
CREATE PROCEDURE [AguanteMySql36].migrar_Descuento_compra
AS 
BEGIN
	INSERT INTO [AguanteMySql36].Descuento_compra(id_descuento, porcentaje) 
	SELECT DISTINCT
		DESCUENTO_COMPRA_CODIGO as id_descuento,
    DESCUENTO_COMPRA_VALOR as porcentaje
	FROM gd_esquema.Maestra
	WHERE DESCUENTO_COMPRA_CODIGO is not null

	IF @@ERROR != 0
	PRINT('Descuento_compra FAIL!')
	ELSE
	PRINT('Descuento_compra OK!')
END
GO

-- Descuento_venta
GO
CREATE PROCEDURE [AguanteMySql36].migrar_Descuento_venta
AS 
BEGIN
	INSERT INTO [AguanteMySql36].Descuento_venta(id_concepto, valor) 
	SELECT DISTINCT
      VENTA_DESCUENTO_CONCEPTO as id_concepto,
    	VENTA_DESCUENTO_IMPORTE as valor
	FROM gd_esquema.Maestra
	WHERE VENTA_DESCUENTO_CONCEPTO is not null

	IF @@ERROR != 0
	PRINT('Descuento_venta FAIL!')
	ELSE
	PRINT('Descuento_venta OK!')
END
GO