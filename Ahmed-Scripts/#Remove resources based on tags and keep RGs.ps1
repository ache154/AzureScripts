[CmdletBinding()]
param (
    [Parameter()]
    [string]
    $SubscriptionID

    [Parameter()]
    [string]
    $Tagname

    [Parameter()]
    [string]
    $Tagvalue
)

#Login to your azure account
Connect-AzAccount

#Set current subscription you want to work with
Set-AzContext -SubscriptionId  $SubscriptionID

#Filter resources based on tags and store in a variable
$global:taggedResources = get-azresource -tagname "Delete"  -tagvalue "Yes"

#Number of resources earmarked for removal:
write-host Number of resources earmarked for removal: $global:taggedResources.count

$global:loopcount=1

for ($i=1;$i -le $global:taggedResources.count; $i++) 
{
    $global:taggedResources = get-azresource -tagname "delete"   -tagvalue "yes" 

    $global:taggedResources | ForEach-Object -Parallel {Remove-AzResource -ResourceId $_.resourceID.ToString() -Verbose -Force } -Verbose -ThrottleLimit 7 

    write-host This is loop number: $global:loopcount

    write-host Number of resources left: $global:taggedResources.count

    $global:loopcount++
}

write-host all resources have been removed. Resources left: $global:taggedResources.count

#Confirm that all tagged resources have been removed. The below object will return empty.
get-azresource -tagname "delete"   -tagvalue "yes" 

#You can also check the number of resources, but this value may return a value even though the resources are removed. This is due to hidden resources run by azure platform.
$global:taggedResources.count


