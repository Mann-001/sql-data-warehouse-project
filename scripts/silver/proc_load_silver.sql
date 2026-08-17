/*
========================================================================================
Stored Procedure: Load Silver Layer(bronze->silver)
========================================================================================
Script Purpose:
        This stored procedure perfors the ETL (Extract, Transform, Load) process to
        populate the 'silver' schema tables from the 'bronze' schema.
Actions Performed:
        -Truncate Silver Tables.
        -Inserts Transformed and Cleansed Data from tha Bronze into Silver Tables.

Parameters:
        None.
        This stored Procedure does not accept any parameters or return any values.

Usage Example:
        EXEC silver.load_silver
========================================================================================
*/

Create Or Alter Procedure silver.load_silver As
 Begin
	Declare @start_time DateTime, @end_time DateTime, @batch_start_time DateTime, @batch_end_time DateTime
	Begin Try
			Set @batch_start_time= GetDate();
		Print '=============================================';
		Print 'Loading silver Layer';
		Print '=============================================';

		Print '---------------------------------------------';
		Print 'Loading CRM Tables';
		Print '---------------------------------------------';

			 Set @start_time= GetDate();
			 Print '>> Truncating Table: slver.crm_cust_info'
			 Truncate Table silver.crm_cust_info
			 Print '>> Inserting Data Into: silver.crm_cust_info'
			 Insert Into silver.crm_cust_info(
				cst_id,
				cst_key,
				cst_firstname,
				cst_lastname,
				cst_marital_status,
				cst_gndr,
				cst_create_date
			)
			Select 
				cst_id,
				cst_key,
				Trim(cst_firstname) as cst_firstname,
				Trim(cst_lastname) as cst_lastname,
				Case When Upper(Trim(cst_marital_status))='S' then 'Single'
					 When Upper(Trim(cst_marital_status))='M' then 'Married'--Normalise Marital status to readable format
					 Else 'n/a'
				End as cst_marital_status,
				Case When Upper(Trim(cst_gndr))='F' then 'Female'
					 When Upper(Trim(cst_gndr))='M' then 'Male'--Normalise gender status to readable format
					 Else 'n/a'
				End as cst_gndr,
				cst_create_date
			From (Select 
				*,
				Row_Number() Over(Partition by cst_id Order by cst_create_date Desc) as flag_last
			From bronze.crm_cust_info
			where cst_id is not null
			)t
			Where flag_last =1
			Set @end_time= GetDate();
				Print '>>Load Duration: ' + Cast (DatedIff(second,@start_time,@end_time) as Nvarchar) + 'seconds';
				Print '-------------------'

			Set @start_time= GetDate();
			Print '>> Truncating Table: slver.crm_prd_info'
			Truncate Table silver.crm_prd_info
			Print '>> Inserting Data Into: silver.crm_prd_info'
			Insert Into silver.crm_prd_info (
				prd_id,
				cat_id,
				prd_key,
				prd_nm,
				prd_cost,
				prd_line,
				prd_start_dt,
				prd_end_dt
			)

			Select 
				prd_id,
				Replace(Substring(prd_key,1,5),'-','_') as cat_id,	--Extract Category ID
				--We have '-' in cat_id but the integration table(erp_px_cat_g1v2) have'_'
				Substring(prd_key,7,Len(prd_key)) as prd_key,	--Extract product ID
				prd_nm,
				IsNull(prd_cost,0) as prd_cost,
				--Quick Case When (Saves Time)
				Case Upper(Trim(prd_line))
					When 'M' Then 'Mountain'
					When 'R' Then 'Road'
					When 'S' Then 'Other Sales'
					When 'T' Then 'Touring'
					Else 'n/a'
				End as prd_line,	--Map product line codes to descriptive values
				Cast(prd_start_dt as Date) as prd_start_dt,
				Cast(
					DATEADD(day, -1, LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt)
				) as Date)
				AS prd_end_dt		--Calculate end Date as 1 Day befoe the next start date
			From bronze.crm_prd_info
			Set @end_time= GetDate();
				Print '>>Load Duration: ' + Cast (DatedIff(second,@start_time,@end_time) as Nvarchar) + 'seconds';
				Print '-------------------'



			Set @start_time= GetDate();
			Print '>> Truncating Table: slver.crm_sales_details'
			Truncate Table silver.crm_sales_details
			Print '>> Inserting Data Into: silver.crm_sales_details'
			Insert Into Silver.crm_sales_details(
					sls_ord_num		,
					sls_prd_key		,			
					sls_cust_id,
					sls_order_dt	,
					sls_ship_dt		,
					sls_due_dt		,
					sls_sales		,
					sls_quantity	,
					sls_price
			)

			Select
				sls_ord_num,
				sls_prd_key,
				sls_cust_id,
				Case
					When sls_order_dt=0 Or Len(sls_order_dt)!=8 Then Null
					Else Cast(Cast(sls_order_dt as varchar) as Date)
					End sls_order_dt,
				Case
					When sls_ship_dt=0 Or Len(sls_ship_dt)!=8 Then Null
					Else Cast(Cast(sls_ship_dt as varchar) as Date)
					End sls_ship_dt,
				Case
					When sls_due_dt=0 Or Len(sls_due_dt)!=8 Then Null
					Else Cast(Cast(sls_due_dt as varchar) as Date)
					End sls_due_dt,
				Case When sls_sales Is Null Or sls_sales<=0 Or sls_sales != sls_quantity * ABS(sls_price) 
						Then sls_quantity * ABS(sls_price)
					Else sls_sales	--Recalculate sales if original value is missing or incorrect
				End as sls_sales,
				sls_quantity,
				Case When sls_price Is Null Or sls_price <=0
						Then sls_sales/NullIf(sls_quantity,0)
					Else sls_price	--Derive price if original value is invalid
				End as sls_price
			From bronze.crm_sales_details
			Set @end_time= GetDate();
				Print '>>Load Duration: ' + Cast (DatedIff(second,@start_time,@end_time) as Nvarchar) + 'seconds';
				Print '-------------------'

			Print '---------------------------------------------';
			Print 'Loading ERP Tables';
			Print '---------------------------------------------';



			Set @start_time= GetDate();
			Print '>> Truncating Table: slver.erp_cust_az12'
			Truncate Table silver.erp_cust_az12
			Print '>> Inserting Data Into: silver.erp_cust_az12'
			Insert Into silver.erp_cust_az12 (cid, bdate,gen)
			Select 
				Case When cid Like 'NAS%' then Substring(cid,4,Len(cid))
					 Else cid		--Remove 'NAS' prefix if present
				End cid,
				Case When bdate>Getdate() then Null
					Else bdate		--Set Future birthdates as Null
				End as bdate,
				Case When Upper(Trim(gen)) IN ('F','FEMALE') Then 'Female'
					 When Upper(Trim(gen)) IN ('M','MALE')  Then 'Male'
					Else 'n/a'		--Normalize Gender values and handeled Unknown Cases
				End as gen
			From bronze.erp_cust_az12
			Set @end_time= GetDate();
				Print '>>Load Duration: ' + Cast (DatedIff(second,@start_time,@end_time) as Nvarchar) + 'seconds';
				Print '-------------------'



			Set @start_time= GetDate();
			Print '>> Truncating Table: slver.erp_loc_a101'
			Truncate Table silver.erp_loc_a101
			Print '>> Inserting Data Into: silver.erp_loc_a101'
			Insert Into silver.erp_loc_a101(cid,centrty)
			Select
				replace(cid,'-','') as cid,
				Case When Trim(centrty)= 'DE' Then 'Germany'
					 When Trim(centrty) In ('US','USA') Then 'United States'
					 When Trim(centrty)='' Or centrty Is Null Then 'n/a'
					Else centrty		--Normalize and Handle Missing or Blank Country Codes
				End as centry
			From bronze.erp_loc_a101
			Set @end_time= GetDate();
				Print '>>Load Duration: ' + Cast (DatedIff(second,@start_time,@end_time) as Nvarchar) + 'seconds';
				Print '-------------------'



			Set @start_time= GetDate();
			Print '>> Truncating Table: slver.erp_px_cat_g1v2'
			Truncate Table silver.erp_px_cat_g1v2
			Print '>> Inserting Data Into: silver.erp_px_cat_g1v2'
			Insert Into silver.erp_px_cat_g1v2(
				id,
				cat,
				subcat,
				maintenance
			)
			Select 
				id,
				cat,
				subcat,
				maintenance
			From bronze.erp_px_cat_g1v2
			Set @end_time= GetDate();
				Print '>>Load Duration: ' + Cast (DatedIff(second,@start_time,@end_time) as Nvarchar) + 'seconds';
				Print '-------------------'
		End Try

		Begin Catch
		Print '================================';
		Print 'Error occured during the loading of silver Layer';
		Print 'Error_Message' + Error_Message();
		Print 'Error_Number' + Cast(Error_Number() as NVarchar);
		Print 'Error_Number' + Cast(Error_State() as NVarchar);
		Print '================================';
	End Catch
End
