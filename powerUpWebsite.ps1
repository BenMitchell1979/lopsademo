## powerOnWebsite ##
$connectionName = "AzureRunAsConnection"
try
{
    # Get the connection "AzureRunAsConnection "
    $servicePrincipalConnection=Get-AutomationConnection -Name $connectionName         

    "Logging in to Azure..."
    Add-AzureRmAccount `
        -ServicePrincipal `
        -TenantId $servicePrincipalConnection.TenantId `
        -ApplicationId $servicePrincipalConnection.ApplicationId `
        -CertificateThumbprint $servicePrincipalConnection.CertificateThumbprint 
}
catch {
    if (!$servicePrincipalConnection)
    {
        $ErrorMessage = "Connection $connectionName not found."
        throw $ErrorMessage
    } else{
        Write-Error -Message $_.Exception
        throw $_.Exception
    }
}

# Get VM Names and power up 2 of them
$VMS = Get-AzureRmVM -ResourceGroup azure-automation-demo |? name -like "win-iis-demo*"

foreach ($vm in $vms) {
    IF ($vm.name -ne 'win-iis-demo-a') {
        $vm | Start-AzureRmVm
    }
}