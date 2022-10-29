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
IF OBJECT_ID ('AguanteMySql36.Modelo') IS NOT NULL DROP TABLE AguanteMySql36.Modelo;
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



-- Dropeo de Stored Procedures

IF EXISTS(	select
		*
	from sys.sysobjects
	where xtype = 'P' and name like '%migrar_%'
	)
	BEGIN
	
	
	PRINT 'Existen procedures de una ejecuci�n pasada'
	PRINT 'Se procede a borrarlos...'

	DECLARE @sql NVARCHAR(MAX) = N'';

	SELECT @sql += N'
	DROP PROCEDURE [AguanteMySql36].'
	  + QUOTENAME(name) + ';'
	FROM sys.sysobjects
	WHERE xtype = 'P' and name like '%migrar_%'

	--PRINT @sql;

	EXEC sp_executesql @sql

	
	END

GO


-- DROP SCHEMA

IF EXISTS(
SELECT * FROM sys.schemas where name = 'AguanteMySql36'
)
BEGIN
	DROP SCHEMA [AguanteMySql36]

END
GO
CREATE SCHEMA [AguanteMySql36];
GO


CREATE TABLE [AguanteMySql36].[Canal_venta] (
  [id] int IDENTITY(1,1),
  [nombre] nvarchar(255),
  PRIMARY KEY ([id])
);


CREATE TABLE [AguanteMySql36].[Cliente] (
  [cliente_id] INT IDENTITY(1,1),
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
  [id_barrio] INT IDENTITY(1,1),
  [codigo_postal] DECIMAL(18,0),
  [provincia_id] int,
  [nombre] nvarchar(255),
  PRIMARY KEY ([id_barrio]),
  CONSTRAINT [FK_Barrio.provincia_id]
    FOREIGN KEY ([provincia_id])
      REFERENCES [AguanteMySql36].[provincias]([id])
);

CREATE TABLE [AguanteMySql36].[Envio] (
  [envio_id] int IDENTITY(1,1),
  [id_barrio] int,
  [medio_envio_id] int,
  [precio_envio] decimal(18,2),
  PRIMARY KEY ([envio_id]),
  CONSTRAINT [FK_Envio.medio_envio_id]
    FOREIGN KEY ([medio_envio_id])
      REFERENCES [AguanteMySql36].[Medio_envio]([id]),
  CONSTRAINT [FK_Envio.codigo_postal]
    FOREIGN KEY ([id_barrio])
      REFERENCES [AguanteMySql36].[Barrio]([id_barrio])
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
	[id_concepto] int identity(1,1), 
  [medio_pago] nvarchar(255),
  [importe] decimal(18,0),
  PRIMARY KEY ([id_concepto])
);

CREATE TABLE [AguanteMySql36].[Tipo_variante] (
  [tipo_variante_id] Int IDENTITY(1,1),
  [descripcion] nvarchar(50),
  PRIMARY KEY ([tipo_variante_id])
);

CREATE TABLE [AguanteMySql36].[Modelo] (
  [modelo_id] Int IDENTITY(1,1),
  [descripcion] nvarchar(50),
  PRIMARY KEY ([modelo_id])
);

CREATE TABLE [AguanteMySql36].[variante] (
  [variante_id] int identity(1,1),
  [tipo_variante_id] Int,
  [modelo_id] int,
  PRIMARY KEY ([variante_id]),
  CONSTRAINT [FK_variante.tipo_variante_id]
    FOREIGN KEY ([tipo_variante_id])
      REFERENCES [AguanteMySql36].[Tipo_variante]([tipo_variante_id]),
  CONSTRAINT [FK_variante.modelo_id]
    FOREIGN KEY ([modelo_id])
      REFERENCES [AguanteMySql36].[Modelo]([modelo_id])
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
  [producto_variante_id] int IDENTITY(1,1),
  [producto_variante_codigo] nvarchar(50),
  [producto_id] nvarchar(50),
  [variante_id] int,
  [precio_unitario] decimal(18,2),
  [stock] int,
  PRIMARY KEY ([producto_variante_id]),
  CONSTRAINT [FK_producto_variante.variante_id]
    FOREIGN KEY ([variante_id])
      REFERENCES [AguanteMySql36].[variante]([variante_id]),
  CONSTRAINT [FK_producto_variante.producto_id]
    FOREIGN KEY ([producto_id])
      REFERENCES [AguanteMySql36].[Producto]([producto_id])
);

CREATE TABLE [AguanteMySql36].[Medios_de_pago_compra] (
  [id_medio_pago] int IDENTITY(1,1),
  descripcion nvarchar(255),
  PRIMARY KEY ([id_medio_pago])
);

CREATE TABLE [AguanteMySql36].[Proveedor] (
  [id_proveedor] int IDENTITY(1,1),
  [provincia_id] int,
  [CUIT] nvarchar(50),
  [razon_social] nvarchar(50),
  [domicilio] nvarchar(50),
  [telefono] nvarchar(50) null,
  [mail] nvarchar(50),
  [localidad] nvarchar(255),
  [codigo_postal] decimal(18,0),
  PRIMARY KEY ([id_proveedor]),
  CONSTRAINT [FK_proveedor.provincia_id]
  FOREIGN KEY ([provincia_id])
  REFERENCES [AguanteMySql36].[Provincias]([id])
);

CREATE TABLE [AguanteMySql36].[Compra] (
  [num_compra] decimal(19,0),
  [proveedor_id] int,
  [id_medio_pago] int,
  [fecha] DATE,
  [total] decimal(18,2),
  [medio_pago_costo] nvarchar(255),
  PRIMARY KEY ([num_compra]),
  CONSTRAINT [FK_Compra.id_medio_pago]
    FOREIGN KEY ([id_medio_pago])
      REFERENCES [AguanteMySql36].[Medios_de_pago_compra]([id_medio_pago]),
  CONSTRAINT [FK_Compra.proveedor_id]
    FOREIGN KEY ([proveedor_id])
      REFERENCES [AguanteMySql36].[Proveedor]([id_proveedor])
);


CREATE TABLE [AguanteMySql36].[Producto_por_compra] (
  [producto_por_compra_id] int IDENTITY(1,1),
  [num_compra] decimal(19,0),
  [producto_variante_id] int,
  [cantidad_comprada] decimal(18,0),
  [precio_unitario] decimal(18,2),
  [total] decimal(18,2),
  PRIMARY KEY ([producto_por_compra_id]),
  CONSTRAINT [FK_Producto_por_compra.producto_variante_id]
    FOREIGN KEY ([producto_variante_id])
      REFERENCES [AguanteMySql36].[producto_variante]([producto_variante_id]),
  CONSTRAINT [FK_Producto_por_compra.num_compra]
    FOREIGN KEY ([num_compra])
      REFERENCES [AguanteMySql36].[Compra]([num_compra])
);


CREATE TABLE [AguanteMySql36].[Productos_por_Venta] (
  [num_venta] decimal(19,0),
  [producto_variante_id] int,
  [cantidad_vendida] decimal(18,0),
  [total] decimal(18,2),
  PRIMARY KEY ([num_venta]),
  CONSTRAINT [FK_Productos_por_Venta.producto_variante_id]
    FOREIGN KEY ([producto_variante_id])
      REFERENCES [AguanteMySql36].[producto_variante]([producto_variante_id]),
  CONSTRAINT [FK_Productos_por_Venta.num_venta]
    FOREIGN KEY ([num_venta])
      REFERENCES [AguanteMySql36].[Venta]([num_venta])
);

CREATE TABLE [AguanteMySql36].[Descuento_x_venta] (
  [id_descuento] int,
  [num_venta] decimal(19,0),
  [importe_descuento] decimal(18,2),
  [descuento_concepto] decimal(18,0),
  PRIMARY KEY([id_descuento],[num_venta]),
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

CREATE PROCEDURE [AguanteMySql36].migrar_cliente
AS 
BEGIN
	INSERT INTO [AguanteMySql36].Cliente(nombre,
										apellido,
										dni, 
										provincia,
										codigo_postal, 
										direccion, 
										telefono,
										mail, 
										fecha_nacimiento, 
										localidad)
	SELECT DISTINCT
	CLIENTE_NOMBRE,
	CLIENTE_APELLIDO,
	CLIENTE_DNI,
	CLIENTE_PROVINCIA,
	CLIENTE_CODIGO_POSTAL,
	CLIENTE_DIRECCION,
	CLIENTE_TELEFONO,
	CLIENTE_MAIL,
	CLIENTE_FECHA_NAC,
	CLIENTE_LOCALIDAD
	FROM gd_esquema.Maestra
	WHERE	CLIENTE_NOMBRE is not null and
			CLIENTE_APELLIDO is not null and
			CLIENTE_DNI is not null and
			CLIENTE_PROVINCIA is not null and
			CLIENTE_CODIGO_POSTAL is not null and
			CLIENTE_DIRECCION is not null and
			CLIENTE_TELEFONO is not null and
			CLIENTE_MAIL is not null and
			CLIENTE_FECHA_NAC is not null and
			CLIENTE_LOCALIDAD is not null 

	IF @@ERROR != 0
	PRINT('CLIENTE FAIL!')
	ELSE
	PRINT('CLIENTE OK!')
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

	INSERT INTO [AguanteMySql36].Cupon(cupon_codigo,fecha_desde, fecha_hasta,tipo,valor)
	  SELECT DISTINCT
		  VENTA_CUPON_CODIGO as cupon_codigo,
		  VENTA_CUPON_FECHA_DESDE as fecha_desde,
		  VENTA_CUPON_FECHA_HASTA as fecha_hasta,
		  VENTA_CUPON_TIPO as tipo,
		  VENTA_CUPON_VALOR as valor
      	FROM gd_esquema.Maestra
      WHERE VENTA_CUPON_FECHA_DESDE is not null
	  AND VENTA_CUPON_VALOR is not null
	  AND VENTA_CUPON_FECHA_HASTA is not null 
	  AND VENTA_CUPON_TIPO is not null
	  AND VENTA_CUPON_CODIGO is not null
	  
  
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
	INSERT INTO [AguanteMySql36].Medios_de_pago_compra(descripcion) -- , costo_transaccion
	SELECT DISTINCT
		COMPRA_MEDIO_PAGO as descripcion
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
	INSERT INTO [AguanteMySql36].Descuento_venta(medio_pago, importe) 
	SELECT DISTINCT
      VENTA_DESCUENTO_CONCEPTO as medio_pago,
    	VENTA_DESCUENTO_IMPORTE as importe
	FROM gd_esquema.Maestra
	WHERE VENTA_DESCUENTO_CONCEPTO is not null

	IF @@ERROR != 0
	PRINT('Descuento_venta FAIL!')
	ELSE
	PRINT('Descuento_venta OK!')
END
GO


CREATE PROCEDURE [AguanteMySql36].migrar_modelo
AS 
BEGIN

	INSERT INTO AguanteMySql36.Modelo(descripcion)
	select distinct
		PRODUCTO_VARIANTE
	from gd_esquema.Maestra m
	WHERE PRODUCTO_VARIANTE is not null
	
		IF @@ERROR != 0
		PRINT('modelo FAIL!')
	ELSE
		PRINT('modelo OK!')

END
GO

CREATE PROCEDURE [AguanteMySql36].migrar_variante
AS 
BEGIN

	select * from AguanteMySql36.Tipo_variante

	insert into AguanteMySql36.variante(tipo_variante_id, modelo_id)
	select distinct
		t.tipo_variante_id,
		mo.modelo_id
	from gd_esquema.Maestra m
	join AguanteMySql36.Tipo_variante t
	on t.descripcion = m.PRODUCTO_TIPO_VARIANTE
	join AguanteMySql36.Modelo mo
	on mo.descripcion = m.PRODUCTO_VARIANTE
	WHERE PRODUCTO_VARIANTE_CODIGO is not null
	
	IF @@ERROR != 0
		PRINT('variante FAIL!')
	ELSE
		PRINT('variante OK!')
END

GO

CREATE PROCEDURE [AguanteMySql36].migrar_barrio
AS
BEGIN
	INSERT INTO [AguanteMySql36].Barrio(provincia_id, codigo_postal, nombre)
	SELECT DISTINCT
		p.id,
		CLIENTE_CODIGO_POSTAL,
		CLIENTE_LOCALIDAD
	FROM gd_esquema.Maestra m
	JOIN [AguanteMySql36].provincias p
	ON p.nombre = m.CLIENTE_PROVINCIA
	WHERE VENTA_CODIGO IS NOT NULL
		AND VENTA_MEDIO_ENVIO IS NOT NULL
		AND VENTA_ENVIO_PRECIO IS NOT NULL
		AND CLIENTE_PROVINCIA IS NOT NULL
		AND CLIENTE_CODIGO_POSTAL IS NOT NULL
		AND CLIENTE_LOCALIDAD IS NOT NULL

	IF @@ERROR != 0
		PRINT('BARRIO FAIL!')
	ELSE
		PRINT('BARRIO OK!')

END

GO

CREATE PROCEDURE [AguanteMySql36].migrar_envio
AS
BEGIN
	INSERT INTO AguanteMySql36.Envio(id_barrio,medio_envio_id,precio_envio)
	SELECT DISTINCT
		b.id_barrio as id_barrio,
		me.id as medio_envio_id,
		m.VENTA_ENVIO_PRECIO as precio_envio
	FROM gd_esquema.Maestra m
	JOIN AguanteMySql36.provincias p
	ON p.nombre = m.CLIENTE_PROVINCIA
	JOIN AguanteMySql36.Barrio b
	ON b.codigo_postal = m.CLIENTE_CODIGO_POSTAL AND
	   b.provincia_id = p.id AND
	   b.nombre = m.CLIENTE_LOCALIDAD
	JOIN AguanteMySql36.Medio_envio me
	ON me.nombre_medio_envio = m.VENTA_MEDIO_ENVIO
	WHERE VENTA_CODIGO IS NOT NULL

	IF @@ERROR != 0
		PRINT('ENVIO FAIL!')
	ELSE
		PRINT('ENVIO OK!')

END

GO

CREATE PROCEDURE [AguanteMySql36].migrar_proveedor
AS
BEGIN
	INSERT INTO AguanteMySql36.Proveedor(CUIT,razon_social,domicilio,mail,provincia_id,localidad,codigo_postal)
	SELECT DISTINCT
	maestra.PROVEEDOR_CUIT as CUIT,
	maestra.PROVEEDOR_RAZON_SOCIAL as razon_social,
	maestra.PROVEEDOR_DOMICILIO as domicilio,
	maestra.PROVEEDOR_MAIL as mail,
	prov.id as prov,
	maestra.PROVEEDOR_LOCALIDAD as localidad,
	maestra.PROVEEDOR_CODIGO_POSTAL as codigo_postal
	FROM gd_esquema.Maestra maestra
	JOIN [AguanteMySql36].provincias prov
	ON prov.nombre = maestra.PROVEEDOR_PROVINCIA

	IF @@ERROR != 0
		PRINT('PROVEEDOR FAIL!')
	ELSE
		PRINT('PROVEEDOR OK!')

END

GO

CREATE PROCEDURE [AguanteMySql36].migrar_producto
AS
BEGIN
	
	INSERT INTO AguanteMySql36.Producto(producto_id,marca_id,categoria_id,material_id,nombre,descripcion)
	SELECT distinct
		PRODUCTO_CODIGO,
		ma.marca_id,
		c.categoria_id,
		mat.material_id,
		PRODUCTO_NOMBRE,
		PRODUCTO_DESCRIPCION
	FROM gd_esquema.Maestra m
	JOIN AguanteMySql36.Marca ma
	ON ma.nombre = m.PRODUCTO_MARCA
	JOIN AguanteMySql36.Categoria c
	ON c.nombre = m.PRODUCTO_CATEGORIA
	JOIN AguanteMySql36.material mat
	ON mat.nombre = m.PRODUCTO_MATERIAL
	WHERE PRODUCTO_CODIGO IS NOT NULL

		IF @@ERROR != 0
		PRINT('PRODUCTO FAIL!')
	ELSE
		PRINT('PRODUCTO OK!')

END
go

CREATE PROCEDURE [AguanteMySql36].migrar_compra
AS
BEGIN
	INSERT INTO AguanteMySql36.Compra(num_compra,proveedor_id,id_medio_pago,fecha,total,medio_pago_costo)
	SELECT DISTINCT
	maestra.COMPRA_NUMERO as num_compra,
	prov.id_proveedor as proveedor,
	mp.id_medio_pago as medio_pago,
	maestra.COMPRA_FECHA as fecha,
	maestra.COMPRA_TOTAL AS total_compra,
	maestra.COMPRA_MEDIO_PAGO AS medio_pago
	FROM gd_esquema.Maestra maestra
	JOIN [AguanteMySql36].Proveedor prov
	ON prov.CUIT = maestra.PROVEEDOR_CUIT
	JOIN [AguanteMySql36].Medios_de_pago_compra mp
	ON mp.descripcion = maestra.COMPRA_MEDIO_PAGO


			IF @@ERROR != 0
		PRINT('COMPRA FAIL!')
	ELSE
		PRINT('COMPRA OK!')

END

GO

CREATE PROCEDURE [AguanteMySql36].migrar_descuento_x_compra
AS
BEGIN
	INSERT INTO AguanteMySql36.Descuento_x_compra(id_descuento, num_compra,descuento_aplicado)
	SELECT DISTINCT
	maestra.DESCUENTO_COMPRA_CODIGO as id_descuento,
	comp.num_compra as num_compra,
	maestra.DESCUENTO_COMPRA_VALOR as valor_descuento
	FROM gd_esquema.Maestra maestra
	JOIN [AguanteMySql36].Compra comp
	ON comp.num_compra = maestra.COMPRA_NUMERO
	JOIN [AguanteMySql36].Descuento_compra dc
	ON dc.id_descuento = maestra.DESCUENTO_COMPRA_CODIGO

	IF @@ERROR != 0
		PRINT('DESCUENTO_X_COMPRA FAIL!')
	ELSE
		PRINT('DESCUENTO_X_COMPRA OK!')
END

GO
CREATE PROCEDURE [AguanteMySql36].migrar_producto_variante
AS
BEGIN
	INSERT INTO AguanteMySql36.producto_variante(producto_variante_codigo,producto_id,variante_id,precio_unitario,stock)
	SELECT DISTINCT
	maestra.PRODUCTO_VARIANTE_CODIGO,
	prod.producto_id,
	va.variante_id,
	maestra.COMPRA_PRODUCTO_PRECIO,
	maestra.COMPRA_PRODUCTO_CANTIDAD
	FROM gd_esquema.Maestra maestra
	JOIN [AguanteMySql36].Producto prod
	ON prod.producto_id = maestra.PRODUCTO_CODIGO
	JOIN [AguanteMySql36].Modelo mo
	ON mo.descripcion = maestra.PRODUCTO_VARIANTE
	JOIN [AguanteMySql36].Tipo_variante tipo_var
	ON tipo_var.descripcion = maestra.PRODUCTO_TIPO_VARIANTE
	JOIN [AguanteMySql36].variante va
	ON va.tipo_variante_id = tipo_var.tipo_variante_id AND
	   va.modelo_id = mo.modelo_id  



	IF @@ERROR != 0
		PRINT('PRODUCTO_VARIANTE FAIL!')
	ELSE
		PRINT('PRODUCTO_VARIANTE OK!')
END

GO
CREATE PROCEDURE [AguanteMySql36].migrar_producto_por_compra
AS
BEGIN
	INSERT INTO AguanteMySql36.Producto_por_compra(num_compra,producto_variante_id,cantidad_comprada,precio_unitario,total)
	SELECT DISTINCT
	maestra.COMPRA_NUMERO,
	prod_var.producto_variante_id,
	maestra.COMPRA_PRODUCTO_CANTIDAD,
	maestra.COMPRA_PRODUCTO_PRECIO,
	maestra.COMPRA_TOTAL
	FROM gd_esquema.Maestra maestra
	JOIN [AguanteMySql36].Producto prod
	ON prod.producto_id = maestra.PRODUCTO_CODIGO
	JOIN [AguanteMySql36].Modelo mo
	ON mo.descripcion = maestra.PRODUCTO_VARIANTE
	JOIN [AguanteMySql36].Tipo_variante tipo_var
	ON tipo_var.descripcion = maestra.PRODUCTO_TIPO_VARIANTE
	JOIN [AguanteMySql36].variante va
	ON va.tipo_variante_id = tipo_var.tipo_variante_id AND
	   va.modelo_id = mo.modelo_id  
	JOIN [AguanteMySql36].producto_variante prod_var
	ON va.variante_id = prod_var.variante_id AND
	prod_var.producto_variante_codigo = maestra.PRODUCTO_VARIANTE_CODIGO AND
	prod_var.producto_id = maestra.PRODUCTO_CODIGO AND
	prod_var.stock = maestra.COMPRA_PRODUCTO_CANTIDAD AND 
	prod_var.precio_unitario = maestra.COMPRA_PRODUCTO_PRECIO

	IF @@ERROR != 0
		PRINT('PRODUCTO_POR_COMPRA FAIL!')
	ELSE
		PRINT('PRODUCTO_POR_COMPRA  OK!')
END


SELECT DISTINCT
	PRODUCTO_CODIGO,
	PRODUCTO_VARIANTE_CODIGO,
	PRODUCTO_VARIANTE,
	PRODUCTO_TIPO_VARIANTE,
	t.tipo_variante_id
FROM gd_esquema.Maestra m
JOIN [AguanteMySql36].Tipo_variante t
ON t.descripcion = m.PRODUCTO_TIPO_VARIANTE
WHERE PRODUCTO_TIPO_VARIANTE is not null
ORDER BY PRODUCTO_VARIANTE_CODIGO




GO
EXEC AguanteMySql36.migrar_canal_venta
GO
EXEC AguanteMySql36.migrar_categoria
GO
EXEC AguanteMySql36.migrar_cliente
GO
EXEC AguanteMySql36.migrar_cupon
GO
EXEC AguanteMySql36.migrar_Descuento_compra
GO
EXEC AguanteMySql36.migrar_Descuento_venta
GO
EXEC AguanteMySql36.migrar_marca
GO
EXEC AguanteMySql36.migrar_material
GO
EXEC AguanteMySql36.migrar_Medio_envio
GO
EXEC AguanteMySql36.migrar_Medios_de_pago_compra
GO
EXEC AguanteMySql36.migrar_Medios_de_pago_venta
GO
EXEC AguanteMySql36.migrar_provincias
GO
EXEC AguanteMySql36.migrar_tipo_variante
GO
EXEC AguanteMySql36.migrar_modelo
go
EXEC AguanteMySql36.migrar_variante
GO
EXEC AguanteMySql36.migrar_barrio
GO
EXEC [AguanteMySql36].migrar_envio
GO
EXEC AguanteMySql36.migrar_producto
go
EXEC [AguanteMySql36].migrar_proveedor
GO
EXEC [AguanteMySql36].migrar_compra
GO
EXEC [AguanteMySql36].migrar_descuento_x_compra
GO
EXEC [AguanteMySql36].migrar_producto_variante
GO
EXEC [AguanteMySql36].migrar_producto_por_compra