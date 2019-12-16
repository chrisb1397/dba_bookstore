CREATE TABLE [VENTAS].[COMPRA]
(
[ID_COMPRA] [int] NOT NULL,
[ID_CLIENTE] [int] NOT NULL,
[FECHA_COMPRA] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TIPO_FACT] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DEFAULT_TIPO_FACT] DEFAULT ('CONTADO'),
[MONTO_TOTAL] [numeric] (8, 2) NULL,
[NUM_TARJETA] [bigint] NULL
) ON [BS_VENTAS]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*======================================================*/
/* CREACION DE TRIGGER: TRIGGER_DEUDA                   */
/*======================================================*/
CREATE TRIGGER [VENTAS].[TRIGGER_DEUDA]
ON [VENTAS].[COMPRA]
AFTER INSERT
AS BEGIN
	/*======================================================*/
	/* DECLARACION Y ASIGNACION DE VARIABLES                */
	/*======================================================*/
	DECLARE @ID_CLIENTE INT, 
			@TIPO_FACT VARCHAR(10),
			@MONTO_TOTAL NUMERIC(8,2),
			@GARANTE INT,
			@LIMITE_CREDITO NUMERIC(8,2),
			@SALDO_DEUDOR NUMERIC(8,2);

	SELECT  @ID_CLIENTE = ID_CLIENTE,
			@TIPO_FACT = TIPO_FACT,
			@MONTO_TOTAL = MONTO_TOTAL
	FROM INSERTED;

	SELECT @GARANTE = GARANTE 
	FROM VENTAS.CLIENTE
	WHERE ID_CLIENTE = @ID_CLIENTE;

	SELECT @LIMITE_CREDITO = LIMITE_CREDITO
	FROM VENTAS.CLIENTE
	WHERE ID_CLIENTE = @ID_CLIENTE

	SELECT @SALDO_DEUDOR = SALDO_DEUDOR
	FROM VENTAS.DEUDOR
	WHERE ID_CLIENTE = @ID_CLIENTE
	
	/*======================================================*/
	/* VERIFICAR CLIENTES CON DEUDAS                        */
	/*======================================================*/
	IF @TIPO_FACT = 'CREDITO'
		BEGIN
		/*======================================================*/
		/* COMPROBAR SI EL GARANTE NO TIENE DEUDAS              */
		/*======================================================*/
		IF EXISTS (SELECT * FROM VENTAS.DEUDOR WHERE ID_CLIENTE = @GARANTE)
			BEGIN
				PRINT 'EL GARANTE TIENE DEUDAS!!!'
				ROLLBACK
			END
		ELSE
			BEGIN
				/*========================================================*/
				/* SI EL CLIENTE EXISTE: SUMAR LA CANTIDAD                */
				/* VERIFICAR SI MONTO TOTAL ES MENOR QUE LIMITE DE CREDITO*/
				/*========================================================*/
				IF EXISTS (SELECT * FROM VENTAS.DEUDOR WHERE ID_CLIENTE = @ID_CLIENTE)
					BEGIN
						IF (@MONTO_TOTAL + @SALDO_DEUDOR) <= @LIMITE_CREDITO
							BEGIN
								UPDATE VENTAS.DEUDOR SET SALDO_DEUDOR = SALDO_DEUDOR + @MONTO_TOTAL
								WHERE ID_CLIENTE = @ID_CLIENTE
							END
						ELSE
							BEGIN
								PRINT 'DEUDA MAYOR AL LIMITE DE CREDITO'
								ROLLBACK
							END
					END

				/*========================================================*/
				/* SI EL CLIENTE NO EXISTE: INGRESAR NUEVO REGISTRO       */
				/* VERIFICAR SI MONTO TOTAL ES MENOR QUE LIMITE DE CREDITO*/
				/*========================================================*/
				ELSE
					BEGIN
						IF @MONTO_TOTAL <= @LIMITE_CREDITO
							BEGIN
								INSERT INTO VENTAS.DEUDOR VALUES (@ID_CLIENTE,
																  @GARANTE,
																  @LIMITE_CREDITO,
																  @MONTO_TOTAL)
							END
						ELSE
							BEGIN
								PRINT 'DEUDA MAYOR AL LIMITE DE CREDITO'
								ROLLBACK
							END
					END 
				END
			END

		/*========================================================*/
		/* CLIENTE SIN DEUDAS: CONTADO                            */
		/*========================================================*/
		ELSE
			BEGIN
				PRINT 'EL CLLIENTE NO DEBE NADA!!!'
				ROLLBACK
			END
		
END		
GO
ALTER TABLE [VENTAS].[COMPRA] ADD CONSTRAINT [CHECK_TIPO_FACT] CHECK (([TIPO_FACT]='CONTADO' OR [TIPO_FACT]='CREDITO'))
GO
ALTER TABLE [VENTAS].[COMPRA] ADD CONSTRAINT [PK_COMPRA] PRIMARY KEY NONCLUSTERED  ([ID_COMPRA]) ON [BS_VENTAS]
GO
ALTER TABLE [VENTAS].[COMPRA] ADD CONSTRAINT [FK_COMPRA_RELATIONS_CLIENTE] FOREIGN KEY ([ID_CLIENTE]) REFERENCES [VENTAS].[CLIENTE] ([ID_CLIENTE])
GO
