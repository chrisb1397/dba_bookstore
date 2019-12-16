CREATE TABLE [VENTAS].[CLIENTE]
(
[ID_CLIENTE] [int] NOT NULL,
[NOMBRE_CLIENTE] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[APELLIDO_CLIENTE] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TELEFONO_CLIENTE] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[FECHA_NAC_CLIENTE] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[NACIONALIDAD_CLIENTE] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[LIMITE_CREDITO] [numeric] (8, 2) NULL,
[GARANTE] [int] NULL,
[NUM_TARJETA] [bigint] NULL
) ON [BS_VENTAS]
GO
ALTER TABLE [VENTAS].[CLIENTE] ADD CONSTRAINT [PK_CLIENTE] PRIMARY KEY NONCLUSTERED  ([ID_CLIENTE]) ON [BS_VENTAS]
GO
ALTER TABLE [VENTAS].[CLIENTE] ADD CONSTRAINT [FK_CLIENTE_RELATIONS_CLIENTE] FOREIGN KEY ([GARANTE]) REFERENCES [VENTAS].[CLIENTE] ([ID_CLIENTE])
GO
ALTER TABLE [VENTAS].[CLIENTE] ADD CONSTRAINT [FK_CLIENTE_RELATIONS_TARJETA] FOREIGN KEY ([NUM_TARJETA]) REFERENCES [VENTAS].[TARJETA_CREDITO] ([NUM_TARJETA])
GO
