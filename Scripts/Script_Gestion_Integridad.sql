select * from ventas.COMPRA
GO

ALTER TABLE VENTAS.COMPRA 
ADD TIPO_FACT VARCHAR(10)
GO

ALTER TABLE VENTAS.COMPRA 
ADD MONTO_TOTAL NUMERIC(8,2)
GO

select * from ventas.COMPRA
GO



ALTER TABLE VENTAS.CLIENTE
ADD 
LIMITE_CREDITO NUMERIC (8,2),
GARANTE INT
GO

ALTER TABLE VENTAS.CLIENTE
ADD
NUM_TARJETA BIGINT
GO

ALTER TABLE VENTAS.COMPRA
ADD 
NUM_TARJETA BIGINT
GO

SELECT * FROM VENTAS.CLIENTE
GO


select * from VENTAS.COMPRA
GO
/*
VALORES PERMITIDOS
CONTADO - CREDITO
*/

/*======================================================*/
/* Valores permitidos: Contado - Credito                */
/*======================================================*/

ALTER TABLE VENTAS.COMPRA
ADD CONSTRAINT CHECK_TIPO_FACT 
CHECK (TIPO_FACT = 'CONTADO' OR TIPO_FACT = 'CREDITO')
GO

/*======================================================*/
/* Valor por defecto: Contado                           */
/*======================================================*/

ALTER TABLE VENTAS.COMPRA
ADD CONSTRAINT DEFAULT_TIPO_FACT
DEFAULT 'CONTADO' FOR TIPO_FACT
GO

/*======================================================*/
/* Actualizar Monto Total                               */
/*======================================================*/

CREATE TRIGGER ACTUALIZAR_MONTO
ON VENTAS.DETALLE_COMPRA
AFTER INSERT
AS
BEGIN
	DECLARE @PRECIO_UNITARIO FLOAT, @CANTIDAD INT, @ID_COMPRA INT
	SELECT @PRECIO_UNITARIO = PRECIO_UNITARIO, @CANTIDAD = CANTIDAD, @ID_COMPRA = ID_COMPRA
	FROM INSERTED;

	UPDATE VENTAS.COMPRA
	SET MONTO_TOTAL = MONTO_TOTAL + (@CANTIDAD * @PRECIO_UNITARIO)
	WHERE ID_COMPRA = @ID_COMPRA;
END
GO


CREATE TRIGGER TRIGGER_ACTUALIZAR_TARJETA
ON VENTAS.COMPRA
AFTER INSERT, UPDATE
AS 
BEGIN
	DECLARE @MONTO_TOTAL NUMERIC(8,2), @NUM_TARJETA BIGINT	
	SELECT @NUM_TARJETA = NUM_TARJETA, @MONTO_TOTAL = MONTO_TOTAL
	FROM INSERTED;

	UPDATE VENTAS.COMPRA 
	SET MONTO_TOTAL = MONTO_TOTAL + @MONTO_TOTAL 
	WHERE NUM_TARJETA = @NUM_TARJETA

END
GO



	SELECT * FROM VENTAS.COMPRA


SELECT * FROM SYS.triggers




ALTER TABLE CATALOGO.AUTOR
ADD 
NOMBRE_AUTOR VARCHAR (50),
APELLIDO_AUTOR VARCHAR (50)
GO

ALTER TABLE CATALOGO.AUTOR
DROP COLUMN NOMBRE_CLIENT


SELECT * FROM VENTAS.CLIENTE
SELECT * FROM VENTAS.COMPRA

GO

/*======================================================*/
/* CREACION DE TRIGGER: TRIGGER_DEUDA                   */
/*======================================================*/
CREATE TRIGGER TRIGGER_DEUDA
ON VENTAS.COMPRA
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


/*======================================================*/
/* CREACION DE TRIGGER: TRIGGER_PAGO                   */
/*======================================================*/
CREATE TRIGGER TRIGGER_PAGO
ON VENTAS.PAGOS
AFTER INSERT
AS
BEGIN
	/*======================================================*/
	/* DECLARACION Y ASIGNACION DE VARIABLES                */
	/*======================================================*/
	DECLARE @ID_CLIENTE INT,
			@SALDO_DEUDOR NUMERIC(8,2),
			@VALOR_PAGO NUMERIC(8,2);

	SELECT @ID_CLIENTE = ID_CLIENTE,
		   @VALOR_PAGO = VALOR_PAGO
	FROM INSERTED;

	SELECT @SALDO_DEUDOR = SALDO_DEUDOR
	FROM VENTAS.DEUDOR 
	WHERE ID_CLIENTE = @ID_CLIENTE

	/*======================================================*/
	/* COMPROBAR SI EXISTEN DEUDORES                        */
	/*======================================================*/
	IF EXISTS (SELECT * FROM VENTAS.DEUDOR WHERE ID_CLIENTE = @ID_CLIENTE)
		BEGIN
			UPDATE VENTAS.DEUDOR SET SALDO_DEUDOR = SALDO_DEUDOR - @VALOR_PAGO
			WHERE ID_CLIENTE = @ID_CLIENTE
		END

		/*======================================================*/
		/* COMPROBAR SI LA DEUDA YA FUE CANCELADA EN TOTALIDAD  */
		/*======================================================*/
		IF @SALDO_DEUDOR - @VALOR_PAGO = 0
			BEGIN
				DELETE FROM VENTAS.DEUDOR 
				WHERE ID_CLIENTE = @ID_CLIENTE
				PRINT 'EL CLIENTE HA CANCELADO TODAS SUS DEUDAS'
			END

	ELSE
		BEGIN
			PRINT 'EL CLIENTE NO DEBE NADA'
		END
END
GO


SELECT * FROM VENTAS.DEUDOR
SELECT * FROM VENTAS.COMPRA
SELECT * FROM VENTAS.PAGOS


/*======================================================*/
/* COMPROBACION TRIGGER: PAGO							*/
/*======================================================*/
INSERT INTO VENTAS.PAGOS VALUES (2, '06/12/2019', 11.15)
GO


/*======================================================*/
/* COMPROBACION TRIGGER: DEUDA							*/
/*======================================================*/
INSERT INTO VENTAS.COMPRA VALUES (26, 1, '06/12/2019', 'CREDITO', 20.00)

