s/*==============================================================*/
/* DBMS name:      Microsoft SQL Server 2008                    */
/* Created on:     24/11/2019 17:17:51                          */
/*==============================================================*/

/*
if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('AUTOR_LIBRO') and o.name = 'FK_AUTOR_LI_RELATIONS_AUTOR')
alter table AUTOR_LIBRO
   drop constraint FK_AUTOR_LI_RELATIONS_AUTOR
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('AUTOR_LIBRO') and o.name = 'FK_AUTOR_LI_RELATIONS_LIBRO')
alter table AUTOR_LIBRO
   drop constraint FK_AUTOR_LI_RELATIONS_LIBRO
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('COMPRA') and o.name = 'FK_COMPRA_RELATIONS_CLIENTE')
alter table COMPRA
   drop constraint FK_COMPRA_RELATIONS_CLIENTE
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('COMPRA_LIBRO') and o.name = 'FK_COMPRA_L_RELATIONS_COMPRA')
alter table COMPRA_LIBRO
   drop constraint FK_COMPRA_L_RELATIONS_COMPRA
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('COMPRA_LIBRO') and o.name = 'FK_COMPRA_L_RELATIONS_LIBRO')
alter table COMPRA_LIBRO
   drop constraint FK_COMPRA_L_RELATIONS_LIBRO
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('EDICION') and o.name = 'FK_EDICION_RELATIONS_LIBRO')
alter table EDICION
   drop constraint FK_EDICION_RELATIONS_LIBRO
go

if exists (select 1
            from  sysobjects
           where  id = object_id('AUTOR')
            and   type = 'U')
   drop table AUTOR
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('AUTOR_LIBRO')
            and   name  = 'RELATIONSHIP_2_FK'
            and   indid > 0
            and   indid < 255)
   drop index AUTOR_LIBRO.RELATIONSHIP_2_FK
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('AUTOR_LIBRO')
            and   name  = 'RELATIONSHIP_1_FK'
            and   indid > 0
            and   indid < 255)
   drop index AUTOR_LIBRO.RELATIONSHIP_1_FK
go

if exists (select 1
            from  sysobjects
           where  id = object_id('AUTOR_LIBRO')
            and   type = 'U')
   drop table AUTOR_LIBRO
go

if exists (select 1
            from  sysobjects
           where  id = object_id('CLIENTE')
            and   type = 'U')
   drop table CLIENTE
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('COMPRA')
            and   name  = 'RELATIONSHIP_4_FK'
            and   indid > 0
            and   indid < 255)
   drop index COMPRA.RELATIONSHIP_4_FK
go

if exists (select 1
            from  sysobjects
           where  id = object_id('COMPRA')
            and   type = 'U')
   drop table COMPRA
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('COMPRA_LIBRO')
            and   name  = 'RELATIONSHIP_6_FK'
            and   indid > 0
            and   indid < 255)
   drop index COMPRA_LIBRO.RELATIONSHIP_6_FK
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('COMPRA_LIBRO')
            and   name  = 'RELATIONSHIP_5_FK'
            and   indid > 0
            and   indid < 255)
   drop index COMPRA_LIBRO.RELATIONSHIP_5_FK
go

if exists (select 1
            from  sysobjects
           where  id = object_id('COMPRA_LIBRO')
            and   type = 'U')
   drop table COMPRA_LIBRO
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('EDICION')
            and   name  = 'RELATIONSHIP_3_FK'
            and   indid > 0
            and   indid < 255)
   drop index EDICION.RELATIONSHIP_3_FK
go

if exists (select 1
            from  sysobjects
           where  id = object_id('EDICION')
            and   type = 'U')
   drop table EDICION
go

if exists (select 1
            from  sysobjects
           where  id = object_id('LIBRO')
            and   type = 'U')
   drop table LIBRO
go

*/

/*==============================================================*/
/* Schemas		                                                */
/*==============================================================*/
create schema CATALOGO authorization DBO
go

create schema VENTAS authorization DBO
go


drop table dbo.AUTOR
go


/*==============================================================*/
/* Table: AUTOR                                                 */
/*==============================================================*/
create table CATALOGO.AUTOR (
   ID_AUTOR             int                  not null,
   NOMBRE_CLIENT        varchar(50)             not null,
   FECHA_NAC            varchar(15)             not null,
   NACIONALIDAD         varchar(50)             not null,
   --constraint PK_AUTOR primary key nonclustered (ID_AUTOR)
)
on BS_CATALOGO
go

/*==============================================================*/
/* Table: DETALLE_COMPRA                                                 */
/*==============================================================*/
create table VENTAS.DETALLE_COMPRA (
	ID_DETALLE			int				not null,
	ID_COMPRA			int				not null,
	ID_EDICION			int				not null,
	PRECIO_UNITARIO		float(5)		not null,
	CANTIDAD			int				not null,
	DESCRIPCION			varchar(100)	not null,
	constraint PK_DETALLE_COMPRA primary key nonclustered(ID_DETALLE)
)
on BS_VENTAS
go

alter table VENTAS.DETALLE_COMPRA
   add constraint FK_DETALLE_COMPRA_RELATIONS_COMPRA foreign key (ID_COMPRA)
      references VENTAS.COMPRA (ID_COMPRA)
go

alter table VENTAS.DETALLE_COMPRA
   add constraint FK_DETALLE_COMPRA_RELATIONS_EDICION foreign key (ID_EDICION)
      references CATALOGO.EDICION (ID_EDICION)
go

/*==============================================================*/
/* Table: AUTOR_LIBRO                                           */
/*==============================================================*/
create table CATALOGO.AUTOR_LIBRO (
   ID_AUTOR             int                  not null,
   ID_LIBRO             int                  not null,
   --constraint PK_AUTOR_LIBRO primary key (ID_AUTOR, ID_LIBRO)
)
on BS_CATALOGO
go

/*==============================================================*/
/* Index: RELATIONSHIP_1_FK                                     */
/*==============================================================*/
/*create index RELATIONSHIP_1_FK on AUTOR_LIBRO (
ID_AUTOR ASC
)
go*/

/*==============================================================*/
/* Index: RELATIONSHIP_2_FK                                     */
/*==============================================================*/
/*create index RELATIONSHIP_2_FK on AUTOR_LIBRO (
ID_LIBRO ASC
)
go*/

/*==============================================================*/
/* Table: CLIENTE                                               */
/*==============================================================*/
create table VENTAS.CLIENTE (
   ID_CLIENTE           int                  not null,
   NOMBRE_CLIENTE       varchar(50)             not null,
   APELLIDO_CLIENTE     varchar(50)             not null,
   TELEFONO_CLIENTE     varchar(10)             not null,
   FECHA_NAC_CLIENTE    varchar(15)             not null,
   NACIONALIDAD_CLIENTE varchar(50)             not null,
   --constraint PK_CLIENTE primary key nonclustered (ID_CLIENTE)
)
on BS_VENTAS
go

/*==============================================================*/
/* Table: COMPRA                                                */
/*==============================================================*/
create table VENTAS.COMPRA (
   ID_COMPRA            int                  not null,
   ID_CLIENTE           int                  not null,
   FECHA_COMPRA         varchar(15)             not null,
   --constraint PK_COMPRA primary key nonclustered (ID_COMPRA)
)
on BS_VENTAS
go

/*==============================================================*/
/* Index: RELATIONSHIP_4_FK                                     */
/*==============================================================*/
/*create index RELATIONSHIP_4_FK on COMPRA (
ID_CLIENTE ASC
)
go*/

/*==============================================================*/
/* Table: COMPRA_LIBRO                                          */
/*==============================================================*/
create table VENTAS.COMPRA_LIBRO (
   ID_COMPRA            int                  not null,
   ID_LIBRO             int                  not null,
   --constraint PK_COMPRA_LIBRO primary key (ID_COMPRA, ID_LIBRO)
)
on BS_VENTAS
go

/*==============================================================*/
/* Index: RELATIONSHIP_5_FK                                     */
/*==============================================================*/
/*create index RELATIONSHIP_5_FK on COMPRA_LIBRO (
ID_COMPRA ASC
)
go*/

/*==============================================================*/
/* Index: RELATIONSHIP_6_FK                                     */
/*==============================================================*/
/*create index RELATIONSHIP_6_FK on COMPRA_LIBRO (
ID_LIBRO ASC
)
go*/

/*==============================================================*/
/* Table: EDICION                                               */
/*==============================================================*/
create table CATALOGO.EDICION (
   ID_EDICION           int                  not null,
   ID_LIBRO             int                  not null,
   ANIO_EDICION         int                  not null,
   PRECIO_EDICION       float(5)             not null,
   ISBN                 bigint               not null,
   --constraint PK_EDICION primary key nonclustered (ID_EDICION)
)
on BS_CATALOGO
go

/*==============================================================*/
/* Index: RELATIONSHIP_3_FK                                     */
/*==============================================================*/
/*create index RELATIONSHIP_3_FK on EDICION (
ID_LIBRO ASC
)
go*/

/*==============================================================*/
/* Table: LIBRO                                                 */
/*==============================================================*/
create table CATALOGO.LIBRO (
   TITULO_LIBRO         varchar(50)             not null,
   IDIOMA_LIBRO         varchar(50)             not null,
   ID_LIBRO             int                  not null,
   --constraint PK_LIBRO primary key nonclustered (ID_LIBRO)
)
on BS_CATALOGO
go


create table VENTAS.DEUDOR (
	ID_DEUDOR			int				identity(1,1),
	ID_CLIENTE			int				not null,
	GARANTE				int				not null,
	LIMITE_CREDITO		numeric(8,2)	not null,
	SALDO_DEUDOR		numeric(8,2)	not null,
	constraint PK_DEUDOR primary key nonclustered (ID_DEUDOR)
)
on BS_VENTAS
go


create table VENTAS.PAGOS (
	ID_PAGO 			int				identity(1,1),
	ID_CLIENTE			int				not null,
	FECHA_PAGO			varchar(15)		not null,
	VALOR_PAGO  		numeric(8,2)	not null,
	constraint PK_PAGOS primary key nonclustered (ID_PAGO)
)
on BS_VENTAS
go

create table VENTAS.TARJETA_CREDITO (
	NUM_TARJETA			bigint			not null,
	EMISOR				varchar(30)		not null,
	FECHA_VENCIMIENTO	varchar(15)		not null,
	COD_SEGURIDAD		varchar(3)		not null,
	constraint PK_TARJETA primary key nonclustered (NUM_TARJETA)
)
on BS_VENTAS
go



alter table CATALOGO.AUTOR
	add constraint PK_AUTOR primary key nonclustered (ID_AUTOR)
go

alter table CATALOGO.AUTOR_LIBRO
	add constraint PK_AUTOR_LIBRO primary key (ID_AUTOR, ID_LIBRO)
go

alter table CATALOGO.EDICION
	add constraint PK_EDICION primary key nonclustered (ID_EDICION)
go

alter table CATALOGO.LIBRO
	add constraint PK_LIBRO primary key nonclustered (ID_LIBRO)
go

alter table VENTAS.CLIENTE
	add constraint PK_CLIENTE primary key nonclustered (ID_CLIENTE)
go

alter table VENTAS.COMPRA
	add constraint PK_COMPRA primary key nonclustered (ID_COMPRA)
go

alter table VENTAS.COMPRA_LIBRO
	add constraint PK_COMPRA_LIBRO primary key (ID_COMPRA, ID_LIBRO)
go




alter table VENTAS.DEUDOR
   add constraint FK_DEUDOR_RELATIONS_CLIENTE foreign key (ID_CLIENTE)
      references VENTAS.CLIENTE (ID_CLIENTE)
go

alter table VENTAS.DEUDOR
   add constraint FK_CLIENTE_RELATIONS_DEUDOR foreign key (ID_CLIENTE)
      references VENTAS.CLIENTE (ID_CLIENTE)
	     on delete no action
		 on update no action
go 

alter table VENTAS.PAGOS
   add constraint FK_PAGOS_RELATIONS_CLIENTE foreign key (ID_CLIENTE)
      references VENTAS.CLIENTE (ID_CLIENTE)
	     on delete no action
		 on update no action
go 


SELECT * FROM VENTAS.CLIENTE
go

alter table CATALOGO.AUTOR_LIBRO
   add constraint FK_AUTOR_LI_RELATIONS_AUTOR foreign key (ID_AUTOR)
      references CATALOGO.AUTOR (ID_AUTOR)
go

alter table CATALOGO.AUTOR_LIBRO
   add constraint FK_AUTOR_LI_RELATIONS_LIBRO foreign key (ID_LIBRO)
      references CATALOGO.LIBRO (ID_LIBRO)
go

alter table VENTAS.COMPRA
   add constraint FK_COMPRA_RELATIONS_CLIENTE foreign key (ID_CLIENTE)
      references VENTAS.CLIENTE (ID_CLIENTE)
go

alter table VENTAS.COMPRA_LIBRO
   add constraint FK_COMPRA_L_RELATIONS_COMPRA foreign key (ID_COMPRA)
      references VENTAS.COMPRA (ID_COMPRA)
go

alter table VENTAS.COMPRA_LIBRO
   add constraint FK_COMPRA_L_RELATIONS_LIBRO foreign key (ID_LIBRO)
      references CATALOGO.LIBRO (ID_LIBRO)
go

alter table CATALOGO.EDICION
   add constraint FK_EDICION_RELATIONS_LIBRO foreign key (ID_LIBRO)
      references CATALOGO.LIBRO (ID_LIBRO)
go

alter table VENTAS.CLIENTE
	add constraint FK_CLIENTE_RELATIONS_CLIENTE foreign key (GARANTE)
	references VENTAS.CLIENTE (ID_CLIENTE)
go

alter table VENTAS.CLIENTE
	add constraint FK_CLIENTE_RELATIONS_TARJETA foreign key (NUM_TARJETA)
	references VENTAS.TARJETA_CREDITO (NUM_TARJETA)
go




select * from VENTAS.CLIENTE














/*==============================================================*/
/* Table: INFO_LIBROS                                           */
/*==============================================================*/
create table CATALOGO.INFO_LIBRO (
   TITULO_LIBRO         varchar(50)             not null,
   IDIOMA_LIBRO         varchar(50)             not null,
   ID_LIBRO             int						not null,
   ID_EDICION           int						not null,
   ANIO_EDICION         int						not null,
   PRECIO_EDICION       float(5)				not null,
   ISBN                 bigint					not null,
) on BS_CATALOGO
go


create trigger UD_LIBRO on CATALOGO.INFO_LIBRO
after INSERT, UPDATE, DELETE
as 
begin
set nocount on;
insert into CATALOGO.INFO_LIBRO 
(TITULO_LIBRO, IDIOMA_LIBRO, ID_LIBRO, ID_EDICION, ANIO_EDICION, PRECIO_EDICION, ISBN) 
from CATALOGO.LIBRO union all from CATALOGO.EDICION
end


select * from CATALOGO.INFO_LIBRO

SELECT * FROM VENTAS.DETALLE_COMPRA