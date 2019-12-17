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

/*==================================*/
/* Comprobar constraints de PK y FK */		                                                
/*==================================*/

SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME = 'CLIENTE'
SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME = 'COMPRA'
SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME = 'DETALLE_COMPRA'

/*===================*/
/* Verificar indices */		                                                
/*===================*/

EXEC sp_helpindex 'VENTAS.CLIENTE'
EXEC sp_helpindex 'VENTAS.COMPRA'
EXEC sp_helpindex 'VENTAS.DETALLE_COMPRA'

/*====================*/
/* Verificar Triggers */		                                                
/*====================*/

SELECT * FROM SYS.triggers

/*======================================*/
/* Verificar Procedimientos almacenados */		                                                
/*======================================*/

SELECT * FROM SYS.procedures

/*==================*/
/* Verificar Vistas */		                                                
/*==================*/

SELECT * FROM SYS.views


