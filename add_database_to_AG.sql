/*
SQL CMD script for adding Availability Group to SQL Server
Developed by Jack Worthen
Date: 5/12/2025

Script must be run in SQL CMD Mode (Query>>SQL CMD Mode)
*/

/*Define Variables*/
:ON ERROR EXIT
:SETVAR Primary ""
:SETVAR Secondary "" 
:SETVAR DbName ""
:SETVAR BkupDir "" 
:SETVAR DataDir	""
:SETVAR LogDir	""
:SETVAR LogBkupJob ""

SET NOCOUNT ON;

:CONNECT  $(Primary)
/*Disable Log Backup Job on Primary*/ 
	EXEC msdb.dbo.sp_update_job @job_name='$(LogBkupJob)',@enabled = 0 
GO	
/*Backup Database on Primary*/
	BACKUP DATABASE [$(DbName)] to disk = '$(BkupDir)\$(DbName)\$(Primary)_post_refresh_reSETAG.bak' WITH COPY_ONLY;	
	GO
	BACKUP LOG  [$(DbName)] to disk = '$(BkupDir)\$(DbName)\$(Primary)_post_refresh_reSETAG.trn';
GO 

/*Connect to Secondary*/
:CONNECT $(Secondary)
/*Check If Database Exists on Secondary and Drop it */	
	IF EXISTS (SELECT 1 FROM SYS.DATABASES WHERE NAME = '$(DbName)')
	BEGIN 
	   BEGIN TRY 
		   EXEC msdb.dbo.sp_delete_database_backuphistory @database_name ='$(DbName)'   

		   DROP DATABASE $(DbName);	   
	   END TRY
	   BEGIN CATCH 
			DECLARE @ErrorMessage NVARCHAR(4000), @ErrorSeverity INT, @ErrorState INT;  		
			SELECT @ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE();  
			RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);  
	   END CATCH 
	END 

/*Restore Prviouly Taken Backups to Secondary */
	RESTORE DATABASE [$(DbName)] FROM DISK = '$(BkupDir)\$(DbName)\$(Primary)_post_refresh_reSETAG.bak' 
     with NORECOVERY, STATS=4
	,MOVE '$(DbName)' TO '$(DataDir)\$(DbName).MDF'
	,MOVE '$(DbName)_log' TO '$(LogDir)\$(DbName)_log.LDF'
	GO
	RESTORE LOG [$(DbName)] FROM DISK = '$(BkupDir)\$(DbName)\$(Primary)_post_refresh_reSETAG.trn' with NORECOVERY
GO 

:CONNECT $(Primary)	
ALTER AVAILABILITY GROUP [$(Primary)] ADD DATABASE [$(DbName)]; 
GO

/*Enable Log Backup Job on Primary*/
:CONNECT  $(Primary)
	EXEC msdb.dbo.sp_update_job @job_name='$(LogBkupJob)',@enabled = 1
GO

