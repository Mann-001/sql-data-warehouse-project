/*
==================================================
DDL Script: Create Bronze Tables
==================================================
Script Purpose:
  This script creates tables in the 'bronze' schema,
  dropping existing tables if already exist.
  Run this script to re-define the DDL structure of 'bronze' table.
==================================================
*/

If object_id('bronze.crm_cust_info', 'U') is not null
	drop table bronze.crm_cust_info;
create table bronze.crm_cust_info(
	cst_id Int,
	cst_key Nvarchar(50),
	cst_firstname nvarchar (50),
	cst_lastname nvarchar (50),
	cst_material_status nvarchar (50),
	cst_gndr nvarchar (50),
	cst_create_date Date
);
if object_id('bronze.crm_prd_info', 'U') is not null
	drop table bronze.crm_prd_info;
create table bronze.crm_prd_info(
	prd_id			Int,
	prd_key			Nvarchar(50),
	prd_nm			nvarchar (50),
	prd_cost		INT,
	prd_line		nvarchar (50),
	prd_start_dt	Date,
	prd_end_dt		Date
);

if object_id('bronze.crm_sales_details', 'U') is not null
	drop table bronze.crm_sales_details;
create table bronze.crm_sales_details(
	sls_ord_num		Nvarchar(50),
	sls_prd_key		Nvarchar(50),
	sls_cust_id		INT ,
	sls_order_dt	INT ,
	sls_ship_dt		INT ,
	sls_due_dt		INT,
	sls_sales		INT,
	sls_quantity	INT,
	sls_price		Int
);

if object_id('bronze.erp_loc_a101', 'U') is not null
	drop table bronze.erp_loc_a101;
create table bronze.erp_loc_a101(
  cid		nvarchar(50),
  centrty	nvarchar(50)
);

if object_id('bronze.erp_cust_az12', 'U') is not null
	drop table bronze.erp_cust_az12;
create table bronze.erp_cust_az12(
  cid	nvarchar(50),
  bdate Date,
  gen	nvarchar(50)
);

if object_id('bronze.erp_px_cat_g1v2', 'U') is not null
	drop table bronze.erp_px_cat_g1v2;
create table bronze.erp_px_cat_g1v2(
  id			nvarchar(50),
  cat			nvarchar(50),
  subcat		nvarchar(50),
  maintenance	nvarchar(50)
);





