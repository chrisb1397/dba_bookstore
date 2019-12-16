CREATE TABLE [VENTAS].[DEUDOR]
(
[ID_DEUDOR] [int] NOT NULL IDENTITY(1, 1),
[ID_CLIENTE] [int] NOT NULL,
[GARANTE] [int] NOT NULL,
[LIMITE_CREDITO] [numeric] (8, 2) NOT NULL,
[SALDO_DEUDOR] [numeric] (8, 2) NOT NULL
) ON [BS_VENTAS]
GO
ALTER TABLE [VENTAS].[DEUDOR] ADD CONSTRAINT [PK_DEUDOR] PRIMARY KEY NONCLUSTERED  ([ID_DEUDOR]) ON [BS_VENTAS]
GO
ALTER TABLE [VENTAS].[DEUDOR] ADD CONSTRAINT [FK_CLIENTE_RELATIONS_DEUDOR] FOREIGN KEY ([ID_CLIENTE]) REFERENCES [VENTAS].[CLIENTE] ([ID_CLIENTE])
GO
ALTER TABLE [VENTAS].[DEUDOR] ADD CONSTRAINT [FK_DEUDOR_RELATIONS_CLIENTE] FOREIGN KEY ([ID_CLIENTE]) REFERENCES [VENTAS].[CLIENTE] ([ID_CLIENTE])
GO