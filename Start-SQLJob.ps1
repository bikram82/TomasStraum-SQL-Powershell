<#
.Synopsis
   Short description

.DESCRIPTION
   Long description

.EXAMPLE
    Start-Job 

.EXAMPLE
    Start-Job -InstanaceNameSQL watserver -db Navision2009 -JobName test

#>
    [CmdletBinding()]
    [OutputType([int])]
param (
[string] $InstanceNameSQL='server name',
[string] $SQLDatabase='database name',
[string] $JobName='[Name of your SQL job]'
)


Write-host "Opening SQL connection"
$sqlConnection = new-object System.Data.SqlClient.SqlConnection 
$sqlConnection.ConnectionString = "server=$InstanceNameSQL; integrated security=TRUE;database=$SQLDatabase" 
$sqlConnection.Open() 
$sqlCommand = new-object System.Data.SqlClient.SqlCommand 
$sqlCommand.CommandTimeout = 120 
$sqlCommand.Connection = $sqlConnection 
$sqlCommand.CommandText= "execute msdb.dbo.sp_start_job @JobName='Test'"

Write-Host "Executing Job => $jobname..." 
$result = $sqlCommand.ExecuteNonQuery() 
$sqlConnection.Close()

Write-Host "Done." 
pause