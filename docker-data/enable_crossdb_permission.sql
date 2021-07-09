EXECUTE sp_configure 'show advanced', 1;
RECONFIGURE;
EXECUTE sp_configure 'cross db ownership chaining', 1;
RECONFIGURE;