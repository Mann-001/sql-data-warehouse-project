/*  
========================================================================================
Stored Procedure: Load Bronze Layer(Source->Bronze)
========================================================================================
Script Purpose:
    This stored procedure loads data into 'bronze' from external CSV files.
    It performs the following actions:
    - Truncate the bronze tables before loading the data.
    - Uses the 'BULK INSERT' command to load tha data from CSV fils to bronze tables.

Parameters:
  None
  This storage procedure does not accept any parameters or return any values.

Use Examples:
    EXEC bronze.load_bronze
========================================================================================
*/

Create or Alter Procedure bronze.load_bronze as
Begin
	Declare @start_time DateTime, @end_time DateTime, @batch_start_time DateTime, @batch_end_time DateTime
	Begin Try
		Set @batch_start_time= GetDate();
		Print '=============================================';
		Print 'Loading Bronze Layer';
		Print '=============================================';

		Print '---------------------------------------------';
		Print 'Loading CRM Tables';
		Print '---------------------------------------------';

		Set @start_time= GetDate();
		Print '>>Truncating Table:bronze.crm_cust_info ';
		Truncate table bronze.crm_cust_info

		Print '>>Inserting Data Into:bronze.crm_cust_info ';
		BULK INSERT bronze.crm_cust_info
		FROM 'C:\SQL Server Management Studio 22\Project 2_Data_WareHouse\datasets\source_crm\cust_info.csv'
		With (
			FirstRow = 2,
			Fieldterminator = ',',
			TabLock
		);
		Set @end_time= GetDate();
		Print '>>Load Duration: ' + Cast (DatedIff(second,@start_time,@end_time) as Nvarchar) + 'seconds';
		Print '-------------------'

		Set @start_time= GetDate();
		Print '>>Truncating Table:bronze.crm_prd_info ';
		Truncate table bronze.crm_prd_info

		Print '>>Inserting Data Into:bronze.crm_prd_info ';
		BULK INSERT bronze.crm_prd_info
		FROM 'C:\SQL Server Management Studio 22\Project 2_Data_WareHouse\datasets\source_crm\prd_info.csv'
		With (
			FirstRow = 2,
			Fieldterminator = ',',
			TabLock
		);
		Set @end_time= GetDate();
		Print '>>Load Duration: ' + Cast (DatedIff(second,@start_time,@end_time) as Nvarchar) + 'seconds';
		Print '-------------------'

		Set @start_time= GetDate();
		Print '>>Truncating Table:bronze.crm_sales_details ';
		Truncate table bronze.crm_sales_details

		Print '>>Inserting Data Into:bronze.crm_sales_details ';
		BULK INSERT bronze.crm_sales_details
		FROM 'C:\SQL Server Management Studio 22\Project 2_Data_WareHouse\datasets\source_crm\sales_details.csv'
		With (
			FirstRow = 2,
			Fieldterminator = ',',
			TabLock
		);
		Set @end_time= GetDate();
		Print '>>Load Duration: ' + Cast (DatedIff(second,@start_time,@end_time) as Nvarchar) + 'seconds';
		Print '-------------------'

		Print '---------------------------------------------';
		Print 'Loading ERP Tables';
		Print '---------------------------------------------';

		Set @start_time= GetDate();
		Print '>>Truncating Table:bronze.erp_cust_az12 ';
		Truncate table bronze.erp_cust_az12

		Print '>>Inserting Data Into:bronze.erp_cust_az12 ';
		BULK INSERT bronze.erp_cust_az12
		FROM 'C:\SQL Server Management Studio 22\Project 2_Data_WareHouse\datasets\source_erp\cust_az12.csv'
		With (
			FirstRow = 2,
			Fieldterminator = ',',
			TabLock
		);
		Set @end_time= GetDate();
		Print '>>Load Duration: ' + Cast (DatedIff(second,@start_time,@end_time) as Nvarchar) + 'seconds';
		Print '-------------------'

		Set @start_time= GetDate();
		Print '>>Truncating Table:bronze.erp_loc_a101 ';
		Truncate table bronze.erp_loc_a101

		Print '>>Inserting Data Into:bronze.erp_loc_a101 ';
		BULK INSERT bronze.erp_loc_a101
		FROM 'C:\SQL Server Management Studio 22\Project 2_Data_WareHouse\datasets\source_erp\loc_a101.csv'
		With (
			FirstRow = 2,
			Fieldterminator = ',',
			TabLock
		);
		Set @end_time= GetDate();
		Print '>>Load Duration: ' + Cast (DatedIff(second,@start_time,@end_time) as Nvarchar) + 'seconds';
		Print '-------------------'

		Set @start_time= GetDate();
		Print '>>Truncating Table:bronze.erp_px_cat_g1v2 ';
		Truncate table bronze.erp_px_cat_g1v2

		Print '>>Inserting Data Into:bronze.erp_px_cat_g1v2 ';
		BULK INSERT bronze.erp_px_cat_g1v2
		FROM 'C:\SQL Server Management Studio 22\Project 2_Data_WareHouse\datasets\source_erp\px_cat_g1v2.csv'
		With (
			FirstRow = 2,
			Fieldterminator = ',',
			TabLock
		);
		Set @end_time= GetDate();
		Print '>>Load Duration: ' + Cast (DatedIff(second,@start_time,@end_time) as Nvarchar) + 'seconds';
		Print '-------------------';

		Set @batch_end_time=GetDate();
		Print '================================';
		Print 'Loading Bronze Layer Is Completed';
		Print 'Total Load Duration: ' + Cast (DatedIff(second,@batch_start_time,@batch_end_time) as Nvarchar) + 'seconds';
		Print '================================';

	End Try
	Begin Catch
		Print '================================';
		Print 'Error occured during the loading of Bronze Layer';
		Print 'Error_Message' + Error_Message();
		Print 'Error_Number' + Cast(Error_Number() as NVarchar);
		Print 'Error_Number' + Cast(Error_State() as NVarchar);
		Print '================================';
	End Catch
End
