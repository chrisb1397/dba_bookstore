use master
go

ALTER DATABASE BDD_BOOKSTORE
SET SINGLE_USER
WITH ROLLBACK IMMEDIATE;
GO

ALTER DATABASE BDD_BOOKSTORE
SET READ_ONLY;
GO

ALTER DATABASE BDD_BOOKSTORE
SET MULTI_USER
GO