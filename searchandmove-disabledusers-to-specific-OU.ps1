#
# ------------Script to find all disabled users and moved them to a specific OU---------------
# 
# 
# 
#
#
#

Import-Module ActiveDirectory

$srchall = Search-ADAccount –AccountDisabled –UsersOnly –SearchBase "OU=Users,OU=My Business,DC=contoso,DC=contoso,DC=com”

[int] $i = 0
    foreach ($one in $srchall)
{
    $i++
     
    if ($one.DistinguishedName -match "Disabled") 
        {        
        Write-Output "$i user IN in disabled users: $($one.givenname)"
        }
    else
        {
        Write-Output "$i user NOT in disabled users: $one.givenname `nMoving AD User account to disabled"
        Write-Output "$($one.distinguishedname)"
    [string]$userDN = $one.distinguishedname
        Write-Output "DN is: $userDN"
        move-adobject $userDN -TargetPath "OU=Disabled Users,OU=Users,OU=My Business,DC=contoso,DC=contoso,DC=com”
    }
}