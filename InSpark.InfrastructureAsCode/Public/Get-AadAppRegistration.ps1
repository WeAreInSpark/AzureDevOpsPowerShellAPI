function Get-AadAppRegistration {
    <#
    .SYNOPSIS
        Retrieves an App registration from Azure AD.
    .DESCRIPTION
        Retrieves an App regestration from Azure AD.
    .EXAMPLE
        Get-AadAppRegistration -Name "App 1"

        This Example will retrieve the App registration with the name 'App 1'
    .OUTPUTS
        PSobject with the object ID and application ID of the App registration.
    .NOTES
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param (
        # Name of the App registration
        [Parameter(Mandatory)]
        [string]
        $Name,

        # Manually connect to Microsoft Graph
        [Parameter()]
        [switch]
        $ManuallyConnectToGraph
    )

    try {
        if ($ManuallyConnectToGraph) {
            Connect-MgGraphWithToken
        } else {
            Connect-MgGraphWithToken -RequestTokenViaAzurePowerShell
        }
    } catch {
        throw $_
    }

    $ExistingApplication = Get-MgApplication | Where-Object { $_.DisplayName -eq $Name }
    if ($ExistingApplication) {
        [PSCustomObject]@{
            AppId = $ExistingApplication.AppId
            Id    = $ExistingApplication.Id
        }
    } else {
        Write-Error 'App registration doesn`t exist'
    }
}
