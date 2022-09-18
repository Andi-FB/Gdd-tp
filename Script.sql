USE GD2C2022;


CREATE TABLE [Cliente] (
  [cliente_id] INT,
  [nombre] varchar(255),
  [dni] INT,
  [provincia] varchar(255),
  [codigo_postal] INT,
  PRIMARY KEY ([cliente_id])
);

CREATE TABLE [Envio] (
  [id] INT IDENTITY(1,1),
  [medio_envio] varchar(30),
  [codigo_postal] INT,
  [importe] DECIMAL(18,2),
  PRIMARY KEY ([id])
);

CREATE TABLE [Venta] (
  [num_venta] Int,
  [cliente_id] INT,
  [envio_id] INT,
  [id_medio_pago] INT,
  [fecha_venta] date,
  [canal_venta] varchar(255),
  [medio_pago_costo] decimal(18,2),
  [total] varchar(30),
  PRIMARY KEY ([num_venta]),
  CONSTRAINT [FK_Venta.cliente_id]
    FOREIGN KEY ([cliente_id])
      REFERENCES [Cliente](cliente_id),
  CONSTRAINT [FK_Venta.envio_id]
    FOREIGN KEY ([envio_id])
      REFERENCES [Envio]([id])
);

CREATE TABLE [Tipo_variante] (
  [tipo_variante_id] Int,
  [nombre] varchar(255),
  PRIMARY KEY ([tipo_variante_id])
);

CREATE TABLE [Producto] (
  [producto_id] INT,
  [tipo_variante_id] Int,
  PRIMARY KEY ([producto_id]),
  CONSTRAINT [FK_Producto.producto_id]
    FOREIGN KEY ([producto_id])
      REFERENCES [Tipo_variante]([tipo_variante_id])
);

CREATE TABLE [Producto_venta_por_Venta] (
  [num_venta] int,
  [id_producto] int,
  [cantidad_vendida] decimal(18,2),
  [precio_unitario] decimal(18,2),
  [total] decimal(18,2),
  PRIMARY KEY ([num_venta], [id_producto]),
  CONSTRAINT [FK_Producto_venta_por_Venta.num_venta]
    FOREIGN KEY ([num_venta])
      REFERENCES [Venta]([num_venta]),
  CONSTRAINT [FK_Producto_venta_por_Venta.id_producto]
    FOREIGN KEY ([id_producto])
      REFERENCES [Producto]([producto_id])
);

CREATE TABLE [variante] (
  [variante_id] int,
  [tipo_variante_id] Int,
  [nombre] varchar(255),
  PRIMARY KEY ([variante_id])
);

CREATE TABLE [Medios_de_pago] (
  [id_medio_pago] Int,
  [tipo] varchar(50),
  [costo_transacccion] decimal(18,2),
  [descuento_medio] decimal(3,1),
  PRIMARY KEY ([id_medio_pago])
);

CREATE TABLE [Variantes_por_Producto] (
  [tipo_variante] int,
  [nombre_id] varchar(255),
  [variante_id] int,
  PRIMARY KEY ([tipo_variante], [variante_id])
);

CREATE TABLE [Descuento] (
  [id_descuento] Int,
  [importe] decimal(18,2),
  PRIMARY KEY ([id_descuento])
);

CREATE TABLE [Cupon] (
  [cupon_codigo] INT,
  [fecha_desde] date,
  [fecha_hasta] date,
  [tipo] varchar(50),
  [valor] decimal(10,2),
  PRIMARY KEY ([cupon_codigo])
);

CREATE TABLE [Proveedor] (
  [id] int,
  [CUIT] varchar(50),
  [razon_social] varchar(50),
  [domicilio] varchar(50),
  [localidad] varchar(50),
  [mail] varchar(50),
  [provincia] varchar(255),
  [codigo_postal] decimal(18,0),
  PRIMARY KEY ([id])
);

CREATE TABLE [Compra] (
  [num_compra] int,
  [fecha_compra] DATETIME,
  [proveedor_id] int,
  [total] decimal(18,2),
  PRIMARY KEY ([num_compra]),
  CONSTRAINT [FK_Compra.num_compra]
    FOREIGN KEY ([num_compra])
      REFERENCES [Proveedor]([id])
);

CREATE TABLE [Descuento_x_venta] (
  [id_descuento] Int,
  [num_venta] Int
);

CREATE TABLE [Cupon_x_venta] (
  [num_venta] Int,
  [cupon_codigo] Int,
  CONSTRAINT [FK_Cupon_x_venta.num_venta]
    FOREIGN KEY ([num_venta])
      REFERENCES [Venta]([num_venta])
);

CREATE TABLE [Producto_venta_por_compra] (
  [num_compra] int,
  [id_producto] int,
  [cantidad_comprada] decimal(18,2),
  [precio_unitario] decimal(18,2),
  [total] decimal(18,2),
  PRIMARY KEY ([num_compra], [id_producto])
);

CREATE TABLE [Descuento_x_compra] (
  [id_descuento] Int,
  [num_compra] Int,
  CONSTRAINT [FK_Descuento_x_compra.id_descuento]
    FOREIGN KEY ([id_descuento])
      REFERENCES [Compra]([num_compra])
);


