/*SQLCMD script for monitoring the status of backup and restore of database going
into a SQL Server Availability Group
*/

--Set variables for primary and secondary
:SETVAR Primary ""
:SETVAR Secondary ""

:CONNECT  $(Primary)
SELECT session_id as SPID, command, a.text AS Query, start_time, percent_complete, dateadd(second,estimated_completion_time/1000, getdate()) as estimated_completion_time 
FROM sys.dm_exec_requests r CROSS APPLY sys.dm_exec_sql_text(r.sql_handle) a 
WHERE r.command in ('BACKUP DATABASE','BACKUP LOG','RESTORE DATABASE', 'RESTORE LOG') 
GO

:CONNECT  $(Secondary)
SELECT session_id as SPID, command, a.text AS Query, start_time, percent_complete, dateadd(second,estimated_completion_time/1000, getdate()) as estimated_completion_time 
FROM sys.dm_exec_requests r CROSS APPLY sys.dm_exec_sql_text(r.sql_handle) a 
WHERE r.command in ('BACKUP DATABASE','BACKUP LOG','RESTORE DATABASE', 'RESTORE LOG') 
GO