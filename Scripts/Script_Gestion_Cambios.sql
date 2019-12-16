/*================================================================================*/
/* Crear copia de las tablas VENTAS.CLIENTE, VENTAS.COMPRA, VENTAS.DETALLE_COMPRA */		                                                */
/*================================================================================*/
SELECT * INTO VENTAS.CLIENTE_BCK FROM VENTAS.CLIENTE
SELECT * INTO VENTAS.COMPRA_BCK FROM VENTAS.COMPRA
SELECT * INTO VENTAS.DETALLE_COMPRA_BCK FROM VENTAS.DETALLE_COMPRA

/*================================================================================*/
/* Crear copia de las tablas VENTAS.CLIENTE, VENTAS.COMPRA, VENTAS.DETALLE_COMPRA */		                                                */
/*================================================================================*/

EXEC sp_table_privileges 'CLIENTE'
EXEC sp_table_privileges 'COMPRA'
EXEC sp_table_privileges 'DETALLE_COMPRA'