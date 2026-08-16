/* 
Create Databases and Schemas

Script Purpose:
    This script creates a new database named 'DataWarehouse" after checking if it already exists.
    If the database exists, it is dropped and recreated.Additionally, the script sets up three schemas within the database: 'bronze', 'silver' and 'gold'.

Warning:
    Running this script will drop the entire''DataWarehouse' databse if it exists.
    All data in the database will be permanently deleted.Proceed with caution and ensure you have proper backups before rummimg the script
*/

--Create database "Data Warehouse"

Use master;
--Drop and recreate the 'DataWarehouse database
If Exists (Select 1 from sys.databases where name='DataWarehouse')
Begin
	ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE DataWarehouse;
End;
Go
--CREATE THE DataWarehouse DATABASE
Create database DataWarehouse;
GO
Use datawarehouse;
GO
--CREATE SCHEMAS
Create Schema bronze;
Go
Create Schema silver;
Go
Create Schema gold;
Go
