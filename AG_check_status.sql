/*
Check the current status of all Availability Groups and databases on the current host.
*/
SELECT AG.name AS AvailabilityGroupName,
       dbcs.database_name AS DatabaseName,
       CASE
           WHEN dbrs.synchronization_state = 0 THEN
               'Not synchronizing'
           WHEN dbrs.synchronization_state = 1 THEN
               'Synchronizing'
           WHEN dbrs.synchronization_state = 2 THEN
               'Synchronized'
           WHEN dbrs.synchronization_state = 3 THEN
               'Reverting'
           WHEN dbrs.synchronization_state = 4 THEN
               'Initializing'
           ELSE
               'Unknown'
       END AS AGState,
       AR.failover_mode_desc,
       AR.availability_mode_desc,
       ISNULL(dbrs.is_suspended, 0) AS IsSuspended
FROM master.sys.availability_groups AS AG
    LEFT OUTER JOIN master.sys.dm_hadr_availability_group_states AS agstates
        ON AG.group_id = agstates.group_id
    INNER JOIN master.sys.availability_replicas AS AR
        ON AG.group_id = AR.group_id
    INNER JOIN master.sys.dm_hadr_availability_replica_states AS arstates
        ON AR.replica_id = arstates.replica_id
           AND arstates.is_local = 1
    INNER JOIN master.sys.dm_hadr_database_replica_cluster_states AS dbcs
        ON arstates.replica_id = dbcs.replica_id
    LEFT OUTER JOIN master.sys.dm_hadr_database_replica_states AS dbrs
        ON dbcs.replica_id = dbrs.replica_id
           AND dbcs.group_database_id = dbrs.group_database_id
WHERE dbcs.is_database_joined = 1
ORDER BY AG.name ASC,
         dbcs.database_name;