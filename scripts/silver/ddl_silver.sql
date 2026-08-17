/* 
===================================================================================
DDL Script: Create Silver Tables
===================================================================================
Script Purpose:
        This script creates table in the 'silver' schema, droping existing tables
        if they already exist.
        Run this script to re-define th DDL structure of 'bronze' tables.
====================================================================================
*/

If Object_Id(silver.crm_cust_info,'U') Is Not Null
      Drop Table silver.crm_cust_info;
Go

  Create Table silver.crm_cust_info (
        cst_id                 INT,
        cst_key                Nvarchar(50),
        cst_firstname          Nvarchar(50,
        cst_lastname           Nvarchar(50,
        cst_marital_status     Nvarchar(50,
        cst_gndr               Nvarchar(50),
        cst_create_date        Date,
        dwh_create_date        DateTime2 Default GetDate()
  );
Go

If Object_id('silver.crm_prd_info','U') is not Null
			Drop Table silver.crm_prd_info;
Go
  
		Create Table silver.crm_prd_info(
			prd_id			INT,
			cat_id			Nvarchar(50),
			prd_key			Nvarchar(50),
			prd_nm			Nvarchar(50),
			prd_cost		INT,
			prd_line		Nvarchar(50),
			prd_start_dt	Date,
			prd_end_dt		Date,
			dwh_create_dt   dateTime2 Default GetDate()
  );
Go

If Object_id('silver.crm_sales_details','U') is not Null
					Drop Table silver.crm_sales_details;
Go 

		Create Table silver.crm_sales_details(
			sls_ord_num		Nvarchar(50),
			sls_prd_key		Nvarchar(50),
			sls_cust_id		INT,
			sls_order_dt	Date,
			sls_ship_dt		Date,
			sls_due_dt		Date,
			sls_sales		INT,
			sls_quantity	INT,
			sls_price		INT,
			dwh_create_date DateTime2 Default GetDate() 
		);
Go

If Object_id('silver.erp_cust_az12','U') is not Null
					Drop Table silver.erp_cust_az12;
Go 

		Create Table silver.erp_cust_az12(
			cid      Nvarchar(50),
      		bdate    Date,
      		gen      Nvarchar(50)
			dwh_create_date DateTime2 Default GetDate() 
		);
Go

If Object_id('silver.erp_loc_a101','U') is not Null
					Drop Table silver.erp_loc_a101;
Go 

		Create Table silver.erp_loc_a101(
			cid      Nvarchar(50),
      		centrty  Nvarchar(50)
			dwh_create_date DateTime2 Default GetDate() 
		);
Go

If Object_id('silver.erp_px_cat_g1v2','U') is not Null
					Drop Table silver.erp_px_cat_g1v2;
Go 

		Create Table silver.erp_px_cat_g1v2(
			id             Nvarchar(50),
      cat            Nvarchar(50),
      subcat         Nvarchar(50),
      maintenance    Nvarchar(50),
			dwh_create_date DateTime2 Default GetDate() 
		);
Go


