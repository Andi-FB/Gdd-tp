USE [GD2C2022];

-- Elimino FKs de ejecuciones pasadas...
DECLARE @borrarFKs NVARCHAR(MAX) = N'';

SELECT @borrarFKs  += N'
ALTER TABLE ' + QUOTENAME(OBJECT_SCHEMA_NAME(parent_object_id))
    + '.' + QUOTENAME(OBJECT_NAME(parent_object_id)) + 
    ' DROP CONSTRAINT ' + QUOTENAME(name) + ';'
FROM sys.foreign_keys
where OBJECT_NAME(parent_object_id) LIKE 'BI_%';
print @borrarFKs
EXEC sp_executesql @borrarFKs 



DECLARE @borrarTablas NVARCHAR(MAX) = N'';

select
@borrarTablas  += N'IF OBJECT_ID (''[AguanteMySql36].' + QUOTENAME(name) + ''') IS NOT NULL DROP TABLE [AguanteMySql36].' + QUOTENAME(name) + ';'
from sys.tables
where name LIKE 'BI_%'
group by name

print @borrarTablas
EXEC sp_executesql @borrarTablas 



CREATE TABLE [AguanteMySql36].[BI_Tiempo] (
  [id] integer identity(1,1),
  [anio] decimal(19,2),
  [mes] decimal(19,2),
  PRIMARY KEY ([id])
);

CREATE TABLE [AguanteMySql36].[BI_provincias] (
  [id] integer,
  [nombre] nvarchar(255),
  PRIMARY KEY ([id])
);

CREATE TABLE [AguanteMySql36].[BI_Rango_Etario] (
  [id] integer identity(1,1),
  [rango] nvarchar(32),
  PRIMARY KEY ([id])
);

CREATE TABLE [AguanteMySql36].[BI_Canal_venta] (
  [id] integer,
  [nombre] nvarchar(255),
  PRIMARY KEY ([id])
);

CREATE TABLE [AguanteMySql36].[BI_Medios_de_pago_venta] (
  [id] integer,
  [tipo] varchar(50),
  PRIMARY KEY ([id])
);

CREATE TABLE [AguanteMySql36].[BI_Categoria] (
  [categoria_id] integer,
  [nombre] varchar(255),
  PRIMARY KEY ([categoria_id])
);

CREATE TABLE [AguanteMySql36].[BI_Producto] (
  [producto_id] nvarchar(50),
  [categoria_id] integer,
  [nombre] nvarchar(50),
  [descripcion] nvarchar(50),
  PRIMARY KEY ([producto_id]),
  CONSTRAINT [FK_BI_Producto.categoria_id]
    FOREIGN KEY ([categoria_id])
      REFERENCES [AguanteMySql36].[BI_Categoria]([categoria_id])
);

CREATE TABLE [AguanteMySql36].[BI_Tipo_Descuento] (
  [id] integer,
  [tipo_descuento] nvarchar(255),
  PRIMARY KEY ([id])
);

CREATE TABLE [AguanteMySql36].[BI_Tipo_envio] (
  [id] integer,
  [nombre_medio_envio] varchar(255),
  PRIMARY KEY ([id])
);

CREATE TABLE [AguanteMySql36].[BI_Compra_Venta] (
  [id] integer identity(1,1),
  [num_venta] decimal(19,0),
  [id_rango_etario] integer,
  [id_provincia] integer,
  [id_tiempo] integer,
  [id_medio_pago_venta] integer,
  [id_canal_venta] integer,
  [id_producto] nvarchar(50),
  [id_tipo_descuento] integer,
  [id_tipo_envio] integer,
  [num_compra] decimal(19,0),
  [ganancia_mensual_canal_venta] decimal(19,2),
  [porcentaje_rentabilidad_anual] decimal(19,2),
  [ingreso_mensual_medio_pago] decimal(19,2),
  [porcentaje_mensual_envio_provincia] decimal(19,2),
  [valor_promedio_envio_provincia_anual] decimal(19,2),
  [valor_aumento_promedio_proveedor_anual] decimal(19,2),
  [producto_mayor_reposicion_mes] varchar(2),
  PRIMARY KEY ([id]),
  CONSTRAINT [FK_BI_Compra_Venta.id_tipo_envio]
    FOREIGN KEY ([id_tipo_envio])
      REFERENCES [AguanteMySql36].[BI_Tipo_envio]([id]),
  CONSTRAINT [FK_BI_Compra_Venta.id_tipo_descuento]
    FOREIGN KEY ([id_tipo_descuento])
      REFERENCES [AguanteMySql36].[BI_Tipo_Descuento]([id]),
  CONSTRAINT [FK_BI_Compra_Venta.id_producto]
    FOREIGN KEY ([id_producto])
      REFERENCES [AguanteMySql36].[BI_Producto]([producto_id]),
  CONSTRAINT [FK_BI_Compra_Venta.id_canal_venta]
    FOREIGN KEY ([id_canal_venta])
      REFERENCES [AguanteMySql36].[BI_Canal_venta]([id]),
  CONSTRAINT [FK_BI_Compra_Venta.id_medio_pago_venta]
    FOREIGN KEY ([id_medio_pago_venta])
      REFERENCES [AguanteMySql36].[BI_Medios_de_pago_venta]([id]),
  CONSTRAINT [FK_BI_Compra_Venta.id_tiempo]
    FOREIGN KEY ([id_tiempo])
      REFERENCES [AguanteMySql36].[BI_Tiempo]([id]),
  CONSTRAINT [FK_BI_Compra_Venta.id_provincia]
    FOREIGN KEY ([id_provincia])
      REFERENCES [AguanteMySql36].[BI_provincias]([id]),
  CONSTRAINT [FK_BI_Compra_Venta.id_rango_etario]
    FOREIGN KEY ([id_rango_etario])
      REFERENCES [AguanteMySql36].[BI_Rango_Etario]([id])
);

GO


CREATE PROCEDURE [AguanteMySql36].migrar_BI_Canal_venta
AS 
BEGIN
	INSERT INTO [AguanteMySql36].BI_Canal_venta (id, nombre)
	SELECT
		id,
		nombre
	FROM AguanteMySql36.Canal_venta

	IF @@ERROR != 0
	PRINT('BI_Canal_venta FAIL!')
	ELSE
	PRINT('BI_Canal_venta OK!')

END

GO

CREATE PROCEDURE [AguanteMySql36].migrar_BI_Categoria
AS
BEGIN
	INSERT INTO [AguanteMySql36].BI_Categoria
	SELECT
		[categoria_id]
		,[nombre]
	FROM [GD2C2022].[AguanteMySql36].[Categoria]

	IF @@ERROR != 0
	PRINT('BI_Canal_venta FAIL!')
	ELSE
	PRINT('BI_Canal_venta OK!')

END

GO

CREATE PROCEDURE [AguanteMySql36].migrar_BI_Producto
AS
BEGIN
	INSERT INTO BI_Producto(producto_id, categoria_id, nombre, descripcion)
	SELECT
	producto_id,
	categoria_id,
	nombre,
	descripcion
	FROM [AguanteMySql36].Producto

	
	IF @@ERROR != 0
	PRINT('BI_Producto FAIL!')
	ELSE
	PRINT('BI_Producto OK!')
END

GO

CREATE PROCEDURE [AguanteMySql36].migrar_BI_Provincia
AS
BEGIN
	INSERT INTO [AguanteMySql36].BI_provincias(id, nombre)
	SELECT
	id,
	nombre
	FROM [AguanteMySql36].provincias

	IF @@ERROR != 0
	PRINT('BI_Producto FAIL!')
	ELSE
	PRINT('BI_Producto OK!')

END

GO

CREATE PROCEDURE [AguanteMySql36].migrar_BI_Rango_Etario
AS
BEGIN
	INSERT INTO [AguanteMySql36].BI_Rango_Etario(rango) VALUES
	('<25'),
	('25 - 35'),
	('35 - 55'),
	('>55')

	IF @@ERROR != 0
	PRINT('BI_Rango_Etario FAIL!')
	ELSE
	PRINT('BI_Rango_Etario OK!')
END

GO

CREATE PROCEDURE [AguanteMySql36].migrar_BI_Tiempo 
AS
BEGIN
	INSERT INTO [AguanteMySql36].BI_Tiempo(anio, mes)
	SELECT DISTINCT
		YEAR(v.fecha_venta),
		MONTH(v.fecha_venta)
	FROM [AguanteMySql36].Venta v
	UNION 
	SELECT DISTINCT
		YEAR(c.fecha),
		MONTH(c.fecha)
	FROM [AguanteMySql36].Compra c
	ORDER BY 1, 2 ASC

	IF @@ERROR != 0
	PRINT('BI_Tiempo FAIL!')
	ELSE
	PRINT('BI_Tiempo OK!')

END

GO

CREATE PROCEDURE [AguanteMySql36].migrar_BI_Tipo_Descuento
AS
BEGIN

	PRINT 'TODO!!! Tipo Descuento!'

END

GO

CREATE PROCEDURE [AguanteMySql36].migrar_BI_Tipo_Envio
AS
BEGIN
	INSERT INTO [AguanteMySql36].BI_Tipo_envio(id, nombre_medio_envio)
	SELECT
	id,
	nombre_medio_envio
	FROM [AguanteMySql36].Medio_envio

	IF @@ERROR != 0
		PRINT('BI_Tipo_Envio FAIL!')
	ELSE
		PRINT('BI_Tipo_Envio OK!')

END

GO


EXEC [AguanteMySql36].migrar_BI_Canal_venta
EXEC [AguanteMySql36].migrar_BI_Categoria
EXEC [AguanteMySql36].migrar_BI_Producto
EXEC [AguanteMySql36].migrar_BI_Provincia
EXEC [AguanteMySql36].migrar_BI_Rango_Etario
EXEC [AguanteMySql36].migrar_BI_Tiempo
EXEC [AguanteMySql36].migrar_BI_Tipo_Descuento
EXEC [AguanteMySql36].migrar_BI_Tipo_Envio




	  -- ESTA LOGICA VA EN LA FACT TABLE

	/*
	SELECT
	cliente_id,
	CASE 
		WHEN datediff(YY,fecha_nacimiento,getdate()) < 25 THEN '<25'
		WHEN datediff(YY,fecha_nacimiento,getdate()) >= 25 AND datediff(YY,fecha_nacimiento,getdate()) <= 35 THEN '25 - 35'
		WHEN datediff(YY,fecha_nacimiento,getdate()) >= 35 AND datediff(YY,fecha_nacimiento,getdate()) <= 55 THEN '35 - 55'
		WHEN datediff(YY,fecha_nacimiento,getdate()) > 55 THEN '>55'
		END
	FROM [AguanteMySql36].Cliente
	*/

/*
Las ganancias mensuales de cada canal de venta.
Se entiende por ganancias al total de las ventas, menos el total de las
compras, menos los costos de transacción totales aplicados asociados los
medios de pagos utilizados en las mismas.
*/

