/*
=================================================================================
Quality Checks
=================================================================================
Script Purpose:
    This script performs various quality checks for data consistency, accuracy,
    and standardization across the 'silver' schema. It includes checks for:
    -Null or Duplicate Primary Keys.
    -Unwanted Spaces in the String fields.
    -Data Standardization and Consistency.
    -Invalid Date ranges and orders.
    -Data Consistency between related Fields.

Usage Notes:
    -Run these checks after data loading silver layer.
    -Investigate and resolve any discrepancies found during the checks.
==================================================================================
*/


--Check For duplicates or Null in Primary Key
--Expectation: No Result
Select 
	cst_id,
	Count(*)
From silver.crm_cust_info
Group by cst_id
Having Count(*)>1 or cst_id is Null


-- Check For Unwanted Spaces
--expectation: No result
Select
cst_firstname
From silver.crm_cust_info
where cst_firstname != Trim(cst_firstname)

--Data Standardization and Consistancy
Select Distinct cst_gndr
From silver.crm_cust_info
--Similar for marital status

Select * From silver.crm_cust_info
=========================================================================================


--Quality check for silver layer

--Check For duplicates or Null in Primary Key
--Expectation: No Result
Select 
	prd_id,
	Count(*)
From silver.crm_prd_info
Group by prd_id
having Count(*)>1 Or prd_id is null

--Check For Unwanted Spaces
--Expectation: No Result
Select
prd_nm
From silver.crm_prd_info
where prd_nm != Trim(prd_nm)

--Check for Nulls or Negative prices
--Expectations: No Result
Select 
	prd_cost
From silver.crm_prd_info
Where prd_cost <0 or prd_cost is Null

--Data Standardization & Consistency
Select Distinct
prd_line
From silver.crm_prd_info

--Check For Invalid Date Orders
Select *
From silver.crm_prd_info
Where prd_end_dt<prd_start_dt
--Also end of the history must be younger than the start of the next record
--(No overlapping date for the price)

Select * From silver.crm_prd_info
===========================================================================================


--QUALITY CHECK fOR SILVER TABLE		

--Check For Invalid Dates
Select 
NullIf(sls_order_dt,0) sls_order_dt
From silver.crm_sales_details
Where sls_order_dt<=0 
Or Len(sls_order_dt)!=8
Or sls_order_dt>20500101
Or sls_order_dt<19900101

/*		Select 
		NullIf(sls_ship_dt,0) sls_ship_dt
		From bronze.crm_sales_details
		Where sls_ship_dt<=0 
		Or Len(sls_ship_dt)!=8
		Or sls_ship_dt>20500101
		Or sls_ship_dt<19900101

		Select 
		NullIf(sls_due_dt,0) sls_due_dt
		From bronze.crm_sales_details
		Where sls_due_dt<=0 
		Or Len(sls_due_dt)!=8
		Or sls_due_dt>20500101
		Or sls_due_dt<19900101
*/
--Check for Invalid Date Orders
select sls_order_dt
From silver.crm_sales_details
Where sls_order_dt> sls_ship_dt Or sls_order_dt> sls_due_dt

--Check Data Consistency: Between Sales, Quantity And price
-->>Sales=Quantity*Price
-->>Values must not be Null, Zero Or Negative

Select Distinct
	 sls_sales,
	sls_quantity,
	sls_price
From silver.crm_sales_details
Where sls_sales != sls_quantity * sls_price
Or sls_sales Is Null Or sls_quantity Is Null Or sls_price Is Null
Or sls_sales <=0 Or sls_quantity <=0 Or sls_price <=0
Order By sls_sales, sls_quantity, sls_price


Select * From silver.crm_sales_details 
=======================================================================================



--Check with the data joining other tables 
Select 
	cid
From silver.erp_cust_az12
	Where Case When cid Like 'NAS%' then Substring(cid,4,Len(cid))
			 Else cid
		End Not In (Select cst_key From silver.crm_cust_info)
/*Select *
  From silver.crm_cust_info
 */

--Identifying out of range Bdates
Select 
	bdate
from silver.erp_cust_az12
where bdate<'1926-01-01'Or bdate> GetDate()--BIRTHDATE IN FUTURE AND CUSTOMER OVER 100 YRS OLD

--Data standardization and Consistency
select Distinct
gen 
From silver.erp_cust_az12

Select * From silver.erp_cust_az12
================================================================================================



Select
	replace(cid,'-','') as cid,
	centrty
From silver.erp_loc_a101
Where replace(cid,'-','') Not In (Select cst_key From silver.crm_cust_info)

--Data Standardization and Consistency
Select Distinct
	centrty as old_centrty,
	Case When Trim(centrty)= 'DE' Then 'Germany'
		 When Trim(centrty) In ('US','USA') Then 'United States'
		 When Trim(centrty)='' Or centrty Is Null Then 'n/a'
		Else centrty
	End as centry
From silver.erp_loc_a101
Order by centrty

Select * From silver.erp_loc_a101
===================================================================================================




--Check For Unwanted Spaces
Select 
	*
From silver.erp_px_cat_g1v2
Where Trim(cat) != cat Or Trim(subcat) !=subcat Or maintenance != Trim(maintenance)


Select Distinct
	Maintenance,
	cat,
	subcat
From silver.erp_px_cat_g1v2
======================================================================================================
