
CREATE DATABASE [MARDOM_DEV]
GO
USE [MARDOM_DEV]
GO
/****** Object:  Trigger [trFechaActuTipoProductos]    Script Date: 2/26/2021 11:12:48 AM ******/
DROP TRIGGER [dbo].[trFechaActuTipoProductos]
GO
/****** Object:  Trigger [trFechaActuCompras]    Script Date: 2/26/2021 11:12:48 AM ******/
DROP TRIGGER [dbo].[trFechaActuCompras]
GO
/****** Object:  Trigger [trFechaActuCategoria]    Script Date: 2/26/2021 11:12:48 AM ******/
DROP TRIGGER [dbo].[trFechaActuCategoria]
GO
/****** Object:  StoredProcedure [dbo].[sp_SecuencialProducto]    Script Date: 2/26/2021 11:12:48 AM ******/
DROP PROCEDURE [dbo].[sp_SecuencialProducto]
GO
/****** Object:  StoredProcedure [dbo].[sp_NotificacionEmail]    Script Date: 2/26/2021 11:12:48 AM ******/
DROP PROCEDURE [dbo].[sp_NotificacionEmail]
GO
ALTER TABLE [dbo].[Productos] DROP CONSTRAINT [FK_Productos_tipo]
GO
ALTER TABLE [dbo].[Compras] DROP CONSTRAINT [FK_Compras_idProducto]
GO
ALTER TABLE [dbo].[Compras] DROP CONSTRAINT [FK_Compras_idCategoria]
GO
ALTER TABLE [dbo].[Tipo_Productos] DROP CONSTRAINT [DF__Tipo_Prod__fecha__4E88ABD4]
GO
ALTER TABLE [dbo].[HistNotificaciones_Emails] DROP CONSTRAINT [DF__HistNotif__Fecha__76969D2E]
GO
ALTER TABLE [dbo].[Compras] DROP CONSTRAINT [DF__Compras__fecha_c__534D60F1]
GO
ALTER TABLE [dbo].[Categoria] DROP CONSTRAINT [DF__Categoria__fecha__37A5467C]
GO
/****** Object:  Index [UQ_Tipo_Productos_tipo]    Script Date: 2/26/2021 11:12:48 AM ******/
ALTER TABLE [dbo].[Tipo_Productos] DROP CONSTRAINT [UQ_Tipo_Productos_tipo]
GO
/****** Object:  Table [dbo].[tipoPruebaSec]    Script Date: 2/26/2021 11:12:48 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tipoPruebaSec]') AND type in (N'U'))
DROP TABLE [dbo].[tipoPruebaSec]
GO
/****** Object:  Table [dbo].[Tipo_Productos]    Script Date: 2/26/2021 11:12:48 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tipo_Productos]') AND type in (N'U'))
DROP TABLE [dbo].[Tipo_Productos]
GO
/****** Object:  Table [dbo].[pruebaSec]    Script Date: 2/26/2021 11:12:48 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pruebaSec]') AND type in (N'U'))
DROP TABLE [dbo].[pruebaSec]
GO
/****** Object:  Table [dbo].[Productos]    Script Date: 2/26/2021 11:12:48 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Productos]') AND type in (N'U'))
DROP TABLE [dbo].[Productos]
GO
/****** Object:  Table [dbo].[HistNotificaciones_Emails]    Script Date: 2/26/2021 11:12:48 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HistNotificaciones_Emails]') AND type in (N'U'))
DROP TABLE [dbo].[HistNotificaciones_Emails]
GO
/****** Object:  Index [IX_Compras_fecha_creacion]    Script Date: 2/26/2021 11:12:48 AM ******/
DROP INDEX [IX_Compras_fecha_creacion] ON [dbo].[Compras] WITH ( ONLINE = OFF )
GO
/****** Object:  Table [dbo].[Compras]    Script Date: 2/26/2021 11:12:48 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Compras]') AND type in (N'U'))
DROP TABLE [dbo].[Compras]
GO
/****** Object:  Table [dbo].[Categoria]    Script Date: 2/26/2021 11:12:48 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Categoria]') AND type in (N'U'))
DROP TABLE [dbo].[Categoria]
GO
/****** Object:  UserDefinedFunction [dbo].[fnConsultaHistEmails]    Script Date: 2/26/2021 11:12:48 AM ******/
DROP FUNCTION [dbo].[fnConsultaHistEmails]
GO
/****** Object:  UserDefinedFunction [dbo].[fnConsultaHistEmails]    Script Date: 2/26/2021 11:12:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fnConsultaHistEmails] (@Email NVARCHAR(100)='', @notificacion NVARCHAR(500)='', @usuario NVARCHAR(50)='')
RETURNS NVARCHAR(MAX)
BEGIN

DECLARE @resultado NVARCHAR(MAX);

IF exists (SELECT CONCAT('Usuario:', Usuario,'     ','Fecha creación:',
	convert(VARCHAR(35),Fecha_Creacion),'   ','Notificación; ',Notificacion) AS [Histórico Email]
	FROM [dbo].[HistNotificaciones_Emails]
	WHERE Notificacion = @notificacion OR Email = @Email OR usuario = @usuario)
BEGIN

	SET @resultado = (SELECT CONCAT('Usuario:', Usuario,'     ','Fecha creación:',
		convert(VARCHAR(35),Fecha_Creacion),'   ','Notificación; ',Notificacion) AS [Histórico Email]
		FROM [dbo].[HistNotificaciones_Emails]
		WHERE Notificacion = @notificacion OR Email = @Email OR usuario = @usuario)

	
END
ELSE
BEGIN

	SET @resultado = (SELECT 'El correo de notificación no existe o debe introducir argumentos válidos.')
	
END

	RETURN @resultado

END
GO
/****** Object:  Table [dbo].[Categoria]    Script Date: 2/26/2021 11:12:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Categoria](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[nombre] [nvarchar](60) NOT NULL,
	[descripcion] [nvarchar](max) NOT NULL,
	[fecha_creacion] [datetime] NOT NULL,
	[fecha_actualizacion] [datetime] NULL,
	[estatus] [bit] NOT NULL,
 CONSTRAINT [PK__Categori__3213E83FB7CB94AD] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Compras]    Script Date: 2/26/2021 11:12:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Compras](
	[idProducto] [int] NOT NULL,
	[fecha_compra] [datetime] NOT NULL,
	[cantidad] [int] NOT NULL,
	[idCategoria] [int] NULL,
	[fecha_creacion] [datetime] NOT NULL,
	[fecha_actualizacion] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Index [IX_Compras_fecha_creacion]    Script Date: 2/26/2021 11:12:48 AM ******/
CREATE CLUSTERED INDEX [IX_Compras_fecha_creacion] ON [dbo].[Compras]
(
	[fecha_creacion] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[HistNotificaciones_Emails]    Script Date: 2/26/2021 11:12:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HistNotificaciones_Emails](
	[Notificacion] [nvarchar](500) NULL,
	[Email] [nvarchar](100) NOT NULL,
	[Usuario] [nvarchar](50) NOT NULL,
	[Fecha_Creacion] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Productos]    Script Date: 2/26/2021 11:12:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Productos](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[nombre] [nvarchar](80) NOT NULL,
	[estatus] [bit] NOT NULL,
	[tipo] [nvarchar](60) NULL,
 CONSTRAINT [PK__Producto__3213E83F14DAC3A0] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pruebaSec]    Script Date: 2/26/2021 11:12:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pruebaSec](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[producto1] [varchar](45) NULL,
	[producto2] [varchar](45) NULL,
	[producto3] [varchar](45) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Tipo_Productos]    Script Date: 2/26/2021 11:12:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Tipo_Productos](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[tipo] [nvarchar](60) NOT NULL,
	[fecha_creacion] [datetime] NOT NULL,
	[fecha_actualizacion] [datetime] NULL,
 CONSTRAINT [PK__Tipo_Pro__3213E83F350AD903] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tipoPruebaSec]    Script Date: 2/26/2021 11:12:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tipoPruebaSec](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[producto1] [varchar](45) NULL,
	[producto2] [varchar](45) NULL,
	[producto3] [varchar](45) NULL
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[Categoria] ON 
GO
INSERT [dbo].[Categoria] ([id], [nombre], [descripcion], [fecha_creacion], [fecha_actualizacion], [estatus]) VALUES (1, N'Tecnología y Electrónicos', N'Estos artículos suelen funcionar con electricidad, como celulares, dispositivos musicales eléctricos, neveras inteligentes y otros tipos de computadores.', CAST(N'2021-02-24T19:49:26.157' AS DateTime), NULL, 1)
GO
INSERT [dbo].[Categoria] ([id], [nombre], [descripcion], [fecha_creacion], [fecha_actualizacion], [estatus]) VALUES (2, N'Textiles y Calzados', N'Camisas, blusas, abrigos, pantalones, zapatos, chancletas, t-shirts y ropa interior', CAST(N'2021-02-24T21:21:45.307' AS DateTime), CAST(N'2021-02-24T21:28:33.370' AS DateTime), 1)
GO
INSERT [dbo].[Categoria] ([id], [nombre], [descripcion], [fecha_creacion], [fecha_actualizacion], [estatus]) VALUES (3, N'Joyería', N'Esta categoria incluye relojes, collares, anillos, aretes, entre otras prendas', CAST(N'2021-02-24T21:21:45.307' AS DateTime), NULL, 0)
GO
INSERT [dbo].[Categoria] ([id], [nombre], [descripcion], [fecha_creacion], [fecha_actualizacion], [estatus]) VALUES (4, N'Carnes y Lácteos', N'Varios tipos de leches, carnes como la de ganado vacuno y caprina', CAST(N'2021-02-24T21:21:45.307' AS DateTime), NULL, 1)
GO
SET IDENTITY_INSERT [dbo].[Categoria] OFF
GO
INSERT [dbo].[Compras] ([idProducto], [fecha_compra], [cantidad], [idCategoria], [fecha_creacion], [fecha_actualizacion]) VALUES (9, CAST(N'2021-02-23T00:00:00.000' AS DateTime), 46, 1, CAST(N'2021-02-25T01:47:23.543' AS DateTime), NULL)
GO
INSERT [dbo].[Compras] ([idProducto], [fecha_compra], [cantidad], [idCategoria], [fecha_creacion], [fecha_actualizacion]) VALUES (6, CAST(N'2021-02-23T00:00:00.000' AS DateTime), 33, 3, CAST(N'2021-02-25T01:46:45.863' AS DateTime), NULL)
GO
INSERT [dbo].[Compras] ([idProducto], [fecha_compra], [cantidad], [idCategoria], [fecha_creacion], [fecha_actualizacion]) VALUES (10, CAST(N'2021-02-22T00:00:00.000' AS DateTime), 95, 4, CAST(N'2021-02-25T01:45:43.103' AS DateTime), NULL)
GO
INSERT [dbo].[Compras] ([idProducto], [fecha_compra], [cantidad], [idCategoria], [fecha_creacion], [fecha_actualizacion]) VALUES (8, CAST(N'2021-02-22T00:00:00.000' AS DateTime), 63, 3, CAST(N'2021-02-25T01:44:48.003' AS DateTime), NULL)
GO
INSERT [dbo].[Compras] ([idProducto], [fecha_compra], [cantidad], [idCategoria], [fecha_creacion], [fecha_actualizacion]) VALUES (7, CAST(N'2021-02-22T00:00:00.000' AS DateTime), 45, 4, CAST(N'2021-02-25T01:44:02.257' AS DateTime), NULL)
GO
INSERT [dbo].[Compras] ([idProducto], [fecha_compra], [cantidad], [idCategoria], [fecha_creacion], [fecha_actualizacion]) VALUES (3, CAST(N'2021-02-22T00:00:00.000' AS DateTime), 13, 1, CAST(N'2021-02-25T01:42:41.590' AS DateTime), NULL)
GO
INSERT [dbo].[Compras] ([idProducto], [fecha_compra], [cantidad], [idCategoria], [fecha_creacion], [fecha_actualizacion]) VALUES (5, CAST(N'2021-02-22T00:00:00.000' AS DateTime), 34, 2, CAST(N'2021-02-25T01:41:05.387' AS DateTime), NULL)
GO
INSERT [dbo].[Compras] ([idProducto], [fecha_compra], [cantidad], [idCategoria], [fecha_creacion], [fecha_actualizacion]) VALUES (4, CAST(N'2021-02-22T00:00:00.000' AS DateTime), 96, 2, CAST(N'2021-02-25T01:39:10.417' AS DateTime), NULL)
GO
INSERT [dbo].[Compras] ([idProducto], [fecha_compra], [cantidad], [idCategoria], [fecha_creacion], [fecha_actualizacion]) VALUES (2, CAST(N'2021-02-21T00:00:00.000' AS DateTime), 54, 1, CAST(N'2021-02-25T01:37:50.320' AS DateTime), NULL)
GO
INSERT [dbo].[Compras] ([idProducto], [fecha_compra], [cantidad], [idCategoria], [fecha_creacion], [fecha_actualizacion]) VALUES (1, CAST(N'2021-02-21T00:00:00.000' AS DateTime), 6, 2, CAST(N'2021-02-25T01:36:20.023' AS DateTime), NULL)
GO
INSERT [dbo].[HistNotificaciones_Emails] ([Notificacion], [Email], [Usuario], [Fecha_Creacion]) VALUES (N'Hola este es un correo de prueba para los destinatarios: e.j.dominguez.castro@gmail.com', N'e.j.dominguez.castro@gmail.com', N'Edwin', CAST(N'2021-02-26T05:16:15.817' AS DateTime))
GO
INSERT [dbo].[HistNotificaciones_Emails] ([Notificacion], [Email], [Usuario], [Fecha_Creacion]) VALUES (N'Hola este es un correo de prueba para los destinatarios: e.j.dominguez.castro@gmail.com', N'e.j.dominguez.castro@gmail.com', N'Edwin', CAST(N'2021-02-26T05:26:29.593' AS DateTime))
GO
INSERT [dbo].[HistNotificaciones_Emails] ([Notificacion], [Email], [Usuario], [Fecha_Creacion]) VALUES (N'Hola este es un correo de prueba para los destinatarios: estoico1928@gmail.com', N'estoico1928@gmail.com', N'Edwin', CAST(N'2021-02-26T07:45:44.063' AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[Productos] ON 
GO
INSERT [dbo].[Productos] ([id], [nombre], [estatus], [tipo]) VALUES (1, N'Converse All Star', 1, N'Calzado')
GO
INSERT [dbo].[Productos] ([id], [nombre], [estatus], [tipo]) VALUES (2, N'Samsung Galaxy Note 10', 1, N'Electrónico')
GO
INSERT [dbo].[Productos] ([id], [nombre], [estatus], [tipo]) VALUES (3, N'Nevera Mabe', 0, N'Electrodoméstico')
GO
INSERT [dbo].[Productos] ([id], [nombre], [estatus], [tipo]) VALUES (4, N'Nautica shirt', 1, N'Textil')
GO
INSERT [dbo].[Productos] ([id], [nombre], [estatus], [tipo]) VALUES (5, N'Nike clasicos', 0, N'Calzado')
GO
INSERT [dbo].[Productos] ([id], [nombre], [estatus], [tipo]) VALUES (6, N'Reloj Casio', 1, N'Joya')
GO
INSERT [dbo].[Productos] ([id], [nombre], [estatus], [tipo]) VALUES (7, N'Leche Milex 360gr', 1, N'Lácteo')
GO
INSERT [dbo].[Productos] ([id], [nombre], [estatus], [tipo]) VALUES (8, N'Collar Chanel', 1, N'Joya')
GO
INSERT [dbo].[Productos] ([id], [nombre], [estatus], [tipo]) VALUES (9, N'Lenovo V330', 1, N'Electrónico')
GO
INSERT [dbo].[Productos] ([id], [nombre], [estatus], [tipo]) VALUES (10, N'Salami Induveca', 1, N'Carnes o embutido')
GO
SET IDENTITY_INSERT [dbo].[Productos] OFF
GO
SET IDENTITY_INSERT [dbo].[pruebaSec] ON 
GO
INSERT [dbo].[pruebaSec] ([id], [producto1], [producto2], [producto3]) VALUES (1, N'Ropa', N'Banano', N'Gas Propano')
GO
SET IDENTITY_INSERT [dbo].[pruebaSec] OFF
GO
SET IDENTITY_INSERT [dbo].[Tipo_Productos] ON 
GO
INSERT [dbo].[Tipo_Productos] ([id], [tipo], [fecha_creacion], [fecha_actualizacion]) VALUES (1, N'Electrónico', CAST(N'2021-02-24T22:40:56.490' AS DateTime), NULL)
GO
INSERT [dbo].[Tipo_Productos] ([id], [tipo], [fecha_creacion], [fecha_actualizacion]) VALUES (2, N'Electrodoméstico', CAST(N'2021-02-24T22:40:56.493' AS DateTime), NULL)
GO
INSERT [dbo].[Tipo_Productos] ([id], [tipo], [fecha_creacion], [fecha_actualizacion]) VALUES (3, N'Textil', CAST(N'2021-02-24T22:40:56.493' AS DateTime), NULL)
GO
INSERT [dbo].[Tipo_Productos] ([id], [tipo], [fecha_creacion], [fecha_actualizacion]) VALUES (4, N'Calzado', CAST(N'2021-02-24T22:40:56.493' AS DateTime), NULL)
GO
INSERT [dbo].[Tipo_Productos] ([id], [tipo], [fecha_creacion], [fecha_actualizacion]) VALUES (5, N'Joya', CAST(N'2021-02-24T22:40:56.493' AS DateTime), NULL)
GO
INSERT [dbo].[Tipo_Productos] ([id], [tipo], [fecha_creacion], [fecha_actualizacion]) VALUES (6, N'Lácteo', CAST(N'2021-02-24T22:40:56.493' AS DateTime), NULL)
GO
INSERT [dbo].[Tipo_Productos] ([id], [tipo], [fecha_creacion], [fecha_actualizacion]) VALUES (7, N'Carnes o embutido', CAST(N'2021-02-24T22:40:56.493' AS DateTime), NULL)
GO
SET IDENTITY_INSERT [dbo].[Tipo_Productos] OFF
GO
SET IDENTITY_INSERT [dbo].[tipoPruebaSec] ON 
GO
INSERT [dbo].[tipoPruebaSec] ([id], [producto1], [producto2], [producto3]) VALUES (1, N'Seco', N'Frio', N'Peligroso')
GO
SET IDENTITY_INSERT [dbo].[tipoPruebaSec] OFF
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ_Tipo_Productos_tipo]    Script Date: 2/26/2021 11:12:48 AM ******/
ALTER TABLE [dbo].[Tipo_Productos] ADD  CONSTRAINT [UQ_Tipo_Productos_tipo] UNIQUE NONCLUSTERED 
(
	[tipo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Categoria] ADD  CONSTRAINT [DF__Categoria__fecha__37A5467C]  DEFAULT (getdate()) FOR [fecha_creacion]
GO
ALTER TABLE [dbo].[Compras] ADD  DEFAULT (getdate()) FOR [fecha_creacion]
GO
ALTER TABLE [dbo].[HistNotificaciones_Emails] ADD  DEFAULT (getdate()) FOR [Fecha_Creacion]
GO
ALTER TABLE [dbo].[Tipo_Productos] ADD  CONSTRAINT [DF__Tipo_Prod__fecha__4E88ABD4]  DEFAULT (getdate()) FOR [fecha_creacion]
GO
ALTER TABLE [dbo].[Compras]  WITH NOCHECK ADD  CONSTRAINT [FK_Compras_idCategoria] FOREIGN KEY([idCategoria])
REFERENCES [dbo].[Categoria] ([id])
GO
ALTER TABLE [dbo].[Compras] CHECK CONSTRAINT [FK_Compras_idCategoria]
GO
ALTER TABLE [dbo].[Compras]  WITH NOCHECK ADD  CONSTRAINT [FK_Compras_idProducto] FOREIGN KEY([idProducto])
REFERENCES [dbo].[Productos] ([id])
GO
ALTER TABLE [dbo].[Compras] CHECK CONSTRAINT [FK_Compras_idProducto]
GO
ALTER TABLE [dbo].[Productos]  WITH NOCHECK ADD  CONSTRAINT [FK_Productos_tipo] FOREIGN KEY([tipo])
REFERENCES [dbo].[Tipo_Productos] ([tipo])
GO
ALTER TABLE [dbo].[Productos] CHECK CONSTRAINT [FK_Productos_tipo]
GO
/****** Object:  StoredProcedure [dbo].[sp_NotificacionEmail]    Script Date: 2/26/2021 11:12:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[sp_NotificacionEmail] @correoElectronico NVARCHAR(100),  @notificacion NVARCHAR(300) AS

BEGIN

DECLARE @saludo VARCHAR(400) = 'Hola este es un correo de prueba para los destinatarios: ' + @correoElectronico


INSERT INTO [dbo].[HistNotificaciones_Emails] VALUES (@saludo, @correoElectronico, SYSTEM_USER, getdate())

DECLARE @HTMLbody NVARCHAR(450);
SET @HTMLbody = '<!DOCTYPE html>
<html>
<head>
	<title></title>
	<style>
		body{
			Background-color: #DEDFDC;
		}
	</style>
</head>
<body>
<h3>' + @saludo + '</h3>
<h4>' +  @notificacion + '</h4>

</body>
</html>';
  
		 
	EXEC msdb.dbo.sp_send_dbmail
		 @profile_name = 'DBA_DEV_PRUEBA'
        ,@recipients = @correoElectronico
		--,@copy_recipients = 'e.d.c19@hotmail.com' ---CORREOS EN COPIA
		,@body = @HTMLbody
		,@body_format = 'HTML'
		,@subject = 'Prueba'		
END
GO
/****** Object:  StoredProcedure [dbo].[sp_SecuencialProducto]    Script Date: 2/26/2021 11:12:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[sp_SecuencialProducto] @tipoProducto varchar(45), @producto varchar(45)
as

if ((@tipoProducto = 'Seco' or @tipoProducto = 'Frio' or @tipoProducto = 'Peligroso') and (@producto = 'Ropa' or @producto = 'Banano' or @producto = 'Gas Propano'))
begin
	declare @contador int;
	set @contador = NEXT VALUE FOR dbo.contador1;
	
	select 'MAP' + convert(varchar,@contador) + '-' + 
	case when @tipoProducto = 'Seco' then tp.producto1
	when @tipoProducto = 'frio' then tp.producto2 
	when @tipoProducto = 'Peligroso' then tp.producto3
	end
	+ '-' + 
	case when @producto = 'Ropa' then p.producto1
	when @producto = 'Banano' then p.producto2
	when @producto = 'Gas Propano' then p.producto3
	end
	+ '-' + 
	CONVERT(varchar, CONVERT(date, getdate())) as CódigoSecuencial
	from pruebaSec as p 
	inner join tipoPruebaSec as tp 
	on (p.id = tp.id)
end
else
begin
	print 'Debe introducir uno de los siguientes valores en el primer parámetro:';
	print '"Seco", "Frio" o "Peligroso".';
	print 'Y en el segundo parámetro:';
	print '"Ropa", "Banano" o "Gas Propano"';

/*
--Debe ejecutar la siguiente sentencia para iniciar el contador y así poder ejecutar correctamente el SP.
CREATE SEQUENCE dbo.contador1  
    START WITH 1  
    INCREMENT BY 1;  
GO  

--Stored procedure para generar código secuencial. Debe recibir dos parámetros.
exec sp_SecuencialProducto 'Seco', 'Gas Propano'; */
end
GO
/****** Object:  Trigger [dbo].[trFechaActuCategoria]    Script Date: 2/26/2021 11:12:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create TRIGGER [dbo].[trFechaActuCategoria]
   ON  [dbo].[Categoria]
   AFTER UPDATE
AS
BEGIN
	IF NOT UPDATE(fecha_actualizacion) 
        UPDATE Categoria SET fecha_actualizacion=GETDATE() 
        WHERE id IN (SELECT id FROM inserted) 
END
GO
ALTER TABLE [dbo].[Categoria] ENABLE TRIGGER [trFechaActuCategoria]
GO
/****** Object:  Trigger [dbo].[trFechaActuCompras]    Script Date: 2/26/2021 11:12:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create TRIGGER [dbo].[trFechaActuCompras]
   ON  [dbo].[Compras]
   AFTER UPDATE
AS
BEGIN
	IF NOT UPDATE(fecha_actualizacion) 
        UPDATE Compras SET fecha_actualizacion=GETDATE() 
        WHERE idProducto IN (SELECT idProducto FROM inserted) 
END
GO
ALTER TABLE [dbo].[Compras] ENABLE TRIGGER [trFechaActuCompras]
GO
/****** Object:  Trigger [dbo].[trFechaActuTipoProductos]    Script Date: 2/26/2021 11:12:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create TRIGGER [dbo].[trFechaActuTipoProductos]
   ON  [dbo].[Tipo_Productos]
   AFTER UPDATE
AS
BEGIN
	IF NOT UPDATE(fecha_actualizacion) 
        UPDATE Tipo_Productos SET fecha_actualizacion=GETDATE() 
        WHERE id IN (SELECT id FROM inserted) 
END
GO
ALTER TABLE [dbo].[Tipo_Productos] ENABLE TRIGGER [trFechaActuTipoProductos]
GO

