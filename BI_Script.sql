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
@borrarTablas  += N'IF OBJECT_ID (''[BI_AguanteMySql36].' + QUOTENAME(name) + ''') IS NOT NULL DROP TABLE [BI_AguanteMySql36].' + QUOTENAME(name) + ';'
from sys.tables
where name LIKE 'BI_%'
group by name

print @borrarTablas
EXEC sp_executesql @borrarTablas 

GO

-- Dropeo de Stored Procedures

IF EXISTS(	select
		*
	from sys.sysobjects
	where xtype = 'P' and name like '%migracion_BI%'
	)
	BEGIN
	
	
	PRINT 'Existen procedures de una ejecuci�n pasada'
	PRINT 'Se procede a borrarlos...'

	DECLARE @sql NVARCHAR(MAX) = N'';

	SELECT @sql += N'
	DROP PROCEDURE [BI_AguanteMySql36].'
	  + QUOTENAME(name) + ';'
	FROM sys.sysobjects
	WHERE xtype = 'P' and name like '%migracion_BI%'

	--PRINT @sql;

	EXEC sp_executesql @sql

	
	END

GO


GO

IF EXISTS(
SELECT * FROM sys.schemas where name = 'BI_AguanteMySql36'
)
BEGIN
	DROP SCHEMA [BI_AguanteMySql36]

END
GO
CREATE SCHEMA [BI_AguanteMySql36];
GO

CREATE TABLE [BI_AguanteMySql36].[BI_Tiempo] (
  [id] integer identity(1,1),
  [anio] decimal(19,2),
  [mes] decimal(19,2),
  PRIMARY KEY ([id])
);

CREATE TABLE [BI_AguanteMySql36].[BI_provincias] (
  [id] integer,
  [nombre] nvarchar(255),
  PRIMARY KEY ([id])
);

CREATE TABLE [BI_AguanteMySql36].[BI_Rango_Etario] (
  [id] integer identity(1,1),
  [rango] nvarchar(32),
  PRIMARY KEY ([id])
);

CREATE TABLE [BI_AguanteMySql36].[BI_Canal_venta] (
  [id] integer,
  [nombre] nvarchar(255),
  PRIMARY KEY ([id])
);

CREATE TABLE [BI_AguanteMySql36].[BI_Medios_de_pago_venta] (
  [id] integer,
  [tipo] varchar(2255),
  PRIMARY KEY ([id])
);

CREATE TABLE [BI_AguanteMySql36].[BI_Categoria] (
  [categoria_id] integer,
  [nombre] varchar(255),
  PRIMARY KEY ([categoria_id])
);

CREATE TABLE [BI_AguanteMySql36].[BI_Producto] (
  [producto_id] nvarchar(50),
  [categoria_id] integer,
  [nombre] nvarchar(50),
  [descripcion] nvarchar(50),
  PRIMARY KEY ([producto_id]),
  CONSTRAINT [FK_BI_Producto.categoria_id]
    FOREIGN KEY ([categoria_id])
      REFERENCES [BI_AguanteMySql36].[BI_Categoria]([categoria_id])
);

CREATE TABLE [BI_AguanteMySql36].[BI_Tipo_Descuento] (
  [id] int identity(1,1),
  [tipo_descuento] nvarchar(255),
  PRIMARY KEY ([id])
);

CREATE TABLE [BI_AguanteMySql36].[BI_Tipo_envio] (
  [id] integer,
  [nombre_medio_envio] varchar(255),
  PRIMARY KEY ([id])
);

CREATE TABLE [BI_AguanteMySql36].[BI_Compra_Venta] (
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
  [proveedor_id] int,
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
      REFERENCES [BI_AguanteMySql36].[BI_Tipo_envio]([id]),
  CONSTRAINT [FK_BI_Compra_Venta.id_tipo_descuento]
    FOREIGN KEY ([id_tipo_descuento])
      REFERENCES [BI_AguanteMySql36].[BI_Tipo_Descuento]([id]),
  CONSTRAINT [FK_BI_Compra_Venta.id_producto]
    FOREIGN KEY ([id_producto])
      REFERENCES [BI_AguanteMySql36].[BI_Producto]([producto_id]),
  CONSTRAINT [FK_BI_Compra_Venta.id_canal_venta]
    FOREIGN KEY ([id_canal_venta])
      REFERENCES [BI_AguanteMySql36].[BI_Canal_venta]([id]),
  CONSTRAINT [FK_BI_Compra_Venta.id_medio_pago_venta]
    FOREIGN KEY ([id_medio_pago_venta])
      REFERENCES [BI_AguanteMySql36].[BI_Medios_de_pago_venta]([id]),
  CONSTRAINT [FK_BI_Compra_Venta.id_tiempo]
    FOREIGN KEY ([id_tiempo])
      REFERENCES [BI_AguanteMySql36].[BI_Tiempo]([id]),
  CONSTRAINT [FK_BI_Compra_Venta.id_provincia]
    FOREIGN KEY ([id_provincia])
      REFERENCES [BI_AguanteMySql36].[BI_provincias]([id]),
  CONSTRAINT [FK_BI_Compra_Venta.id_rango_etario]
    FOREIGN KEY ([id_rango_etario])
      REFERENCES [BI_AguanteMySql36].[BI_Rango_Etario]([id])
);

GO


CREATE PROCEDURE [BI_AguanteMySql36].migracion_BI_Canal_venta
AS 
BEGIN
	INSERT INTO [BI_AguanteMySql36].BI_Canal_venta (id, nombre)
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

CREATE PROCEDURE [BI_AguanteMySql36].migracion_BI_Categoria
AS
BEGIN
	INSERT INTO [BI_AguanteMySql36].BI_Categoria
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

CREATE PROCEDURE [BI_AguanteMySql36].migracion_BI_Producto
AS
BEGIN
	INSERT INTO [BI_AguanteMySql36].BI_Producto(producto_id, categoria_id, nombre, descripcion)
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

CREATE PROCEDURE [BI_AguanteMySql36].migracion_BI_Provincia
AS
BEGIN
	INSERT INTO [BI_AguanteMySql36].BI_provincias(id, nombre)
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

CREATE PROCEDURE [BI_AguanteMySql36].migracion_BI_Rango_Etario
AS
BEGIN
	INSERT INTO [BI_AguanteMySql36].BI_Rango_Etario(rango) VALUES
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

CREATE PROCEDURE [BI_AguanteMySql36].migracion_BI_Tiempo 
AS
BEGIN
	INSERT INTO [BI_AguanteMySql36].BI_Tiempo(anio, mes)
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

CREATE PROCEDURE [BI_AguanteMySql36].migracion_BI_Tipo_Descuento
AS
BEGIN
	insert into [BI_AguanteMySql36].BI_Tipo_Descuento(tipo_descuento)
	Select distinct dv.concepto from AguanteMySql36.Descuento_venta dv
	WHERE dv.concepto is not null
	union
	select distinct c.tipo from AguanteMySql36.Cupon c
	where c.tipo is not null
	
	IF @@ERROR != 0
		PRINT('BI_Tipo_Descuento FAIL!')
	ELSE
		PRINT('BI_Tipo_Descuento OK!')

END

GO

CREATE PROCEDURE [BI_AguanteMySql36].migracion_BI_Tipo_Envio
AS
BEGIN
	INSERT INTO [BI_AguanteMySql36].BI_Tipo_envio(id, nombre_medio_envio)
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

CREATE PROCEDURE [BI_AguanteMySql36].migracion_BI_Medios_de_pago_venta
AS
BEGIN

	INSERT INTO BI_AguanteMySql36.BI_Medios_de_pago_venta(id, tipo)
	SELECT
	id_medio_pago,
	tipo
	FROM AguanteMySql36.Medios_de_pago_venta

		IF @@ERROR != 0
		PRINT('BI_Medios_de_pago_venta FAIL!')
	ELSE
		PRINT('BI_Medios_de_pago_venta OK!')

END

GO


CREATE PROCEDURE [BI_AguanteMySql36].migracion_BI_Compra_Venta
AS
BEGIN

	INSERT INTO [BI_AguanteMySql36].BI_Compra_Venta (
		num_venta,
		id_rango_etario,
		id_provincia,
		id_tiempo,
		id_canal_venta,
		id_producto,
		id_medio_pago_venta,
		id_tipo_envio
		--, tipo_envio              TODO!
	)
	SELECT
		v.num_venta,
		(
			SELECT
				id
			FROM [BI_AguanteMySql36].BI_Rango_Etario re
			where re.rango = (
			CASE 
				WHEN datediff(YY,c.fecha_nacimiento,getdate()) < 25 THEN '<25'
				WHEN datediff(YY,c.fecha_nacimiento,getdate()) >= 25 AND datediff(YY,c.fecha_nacimiento,getdate()) < 35 THEN '25 - 35'
				WHEN datediff(YY,c.fecha_nacimiento,getdate()) >= 35 AND datediff(YY,c.fecha_nacimiento,getdate()) <= 55 THEN '35 - 55'
				WHEN datediff(YY,c.fecha_nacimiento,getdate()) > 55 THEN '>55'
			END
			)
		)  as rango_etario
		,
		p.id as provincia_id,
		t.id as tiempo_id,
		v.canal_venta as canal_venta_id,
		pv.producto_id,
		-- tipo_descuento, TODO!!!!!!!!!!!!!!!!!!11
		v.id_medio_pago,
		e.medio_envio_id as id_tipo_envio
	FROM [AguanteMySql36].Venta v
	join [AguanteMySql36].Productos_por_Venta ppv
	on ppv.num_venta = v.num_venta  -- TODO! OJO ACA, REVISAR SI ESTA BIEN ESO! (mirar tabla pvv)
	join [AguanteMySql36].producto_variante pv
	on pv.producto_variante_id = ppv.producto_variante_id -- IDEM ACA, REVISAR SI ESTA BIEN ESO! (mirar tabla pvv)
	join [AguanteMySql36].Cliente c
	on v.cliente_id = c.cliente_id
	join [AguanteMySql36].Envio e
	on e.envio_id = v.envio_id
	join [AguanteMySql36].Barrio b
	on b.id_barrio = e.id_barrio
	join [AguanteMySql36].provincias p
	on p.id = b.provincia_id
	join [BI_AguanteMySql36].BI_Tiempo t
	on t.anio = YEAR(v.fecha_venta) and t.mes = MONTH(v.fecha_venta)
	order by num_venta


	INSERT INTO BI_AguanteMySql36.BI_Compra_Venta(num_compra, proveedor_id, id_tiempo, id_producto)
	SELECT
		c.num_compra,
		p.id_proveedor,
		ti.id as id_tiempo,
		pv.producto_id
	FROM AguanteMySql36.Compra c
	JOIN AguanteMySql36.Producto_por_compra ppc
	on c.num_compra = ppc.num_compra
	JOIN [AguanteMySql36].producto_variante pv
	on pv.producto_variante_id = ppc.producto_variante_id 
	JOIN AguanteMySql36.Proveedor p
	on p.id_proveedor = c.proveedor_id
	JOIN BI_AguanteMySql36.BI_Tiempo ti
	on ti.anio = YEAR(c.fecha) and ti.mes = MONTH(c.fecha)


	IF @@ERROR != 0
		PRINT('BI_Compra_Venta FAIL!')
	ELSE
		PRINT('BI_Compra_Venta OK!')


END

GO

EXEC [BI_AguanteMySql36].migracion_BI_Canal_venta
EXEC [BI_AguanteMySql36].migracion_BI_Categoria
EXEC [BI_AguanteMySql36].migracion_BI_Producto
EXEC [BI_AguanteMySql36].migracion_BI_Provincia
EXEC [BI_AguanteMySql36].migracion_BI_Rango_Etario
EXEC [BI_AguanteMySql36].migracion_BI_Tiempo
EXEC [BI_AguanteMySql36].migracion_BI_Tipo_Descuento
EXEC [BI_AguanteMySql36].migracion_BI_Tipo_Envio
EXEC [BI_AguanteMySql36].migracion_BI_Medios_de_pago_venta
EXEC [BI_AguanteMySql36].migracion_BI_Compra_Venta


select * from [BI_AguanteMySql36].BI_Tipo_Descuento

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
Los 5 productos con mayor rentabilidad anual, con sus respectivos %
Se entiende por rentabilidad a los ingresos generados por el producto
(ventas) durante el periodo menos la inversión realizada en el producto
(compras) durante el periodo, todo esto sobre dichos ingresos.
Valor expresado en porcentaje.
Para simplificar, no es necesario tener en cuenta los descuentos aplicados.12
*/
CREATE VIEW top_5_productos_mayor_rentabilidad AS
SELECT 
FROM table_name
WHERE condition;


/*
Las ganancias mensuales de cada canal de venta.
Se entiende por ganancias al total de las ventas, menos el total de las
compras, menos los costos de transacción totales aplicados asociados los
medios de pagos utilizados en las mismas.
*/

