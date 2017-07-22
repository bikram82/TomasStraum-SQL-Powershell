<#
.Synopsis
   Short description - Connects to a SQL server using SQL db credentials and creates a new domain login.

.DESCRIPTION
   Long description - First it connects to the SQL server by pointing to the correct database with IP\Servername and db
                    - It uses SQL db authentication
                    - Then it Opens the connection for 120s 
                    - Then it runs the SQL query that creates the domain user

.EXAMPLE
    Start-Job 

.EXAMPLE
    Start-Job -InstanaceNameSQL watserver -db Navision2009 -JobName test

#>
    [CmdletBinding()]
    [OutputType([int])]
param (
[string] $InstanceNameSQL='IPaddress\servername,1433',
[string] $SQLDatabase='dbname',
[string] $domainuser='username'
)


Write-host "Opening SQL connection"
$sqlConnection = new-object System.Data.SqlClient.SqlConnection 
$sqlConnection.ConnectionString = "Data Source=$InstanceNameSQL;Database=$SQLDatabase;Trusted_Connection=false;" 
$sqlConnection.connectionString="Initial Catalog=$SQLDatabase;Data Source=$InstanceNameSQL;User ID=dbusername;Password=dbpassword;"
$sqlConnection.Open() 
$sqlCommand = new-object System.Data.SqlClient.SqlCommand 
$sqlCommand.CommandTimeout = 120 
$sqlCommand.Connection = $sqlConnection 
$sqlCommand.CommandText= "create login [domain\$domainuser] from windows;"
# $sqlCommand.CommandText= "drop login [domain\$domainuser];"

Write-Host "Creating User => $domainuser..." 
$result = $sqlCommand.ExecuteNonQuery() 
$sqlConnection.Close();

Write-Host "Done." 
pause