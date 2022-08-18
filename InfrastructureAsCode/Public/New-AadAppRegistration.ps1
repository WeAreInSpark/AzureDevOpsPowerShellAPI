function New-AadAppRegistration {
    <#
.SYNOPSIS
    Creates an App registration in Azure AD.
.DESCRIPTION
    Creates an App regestration in Azure AD when no App registration with the same name exists.
.EXAMPLE
    New-AadAppRegistration -Name "App 1"

    This Example will create a new App registration with the name 'App 1'
.OUTPUTS
    PSobject with the object ID and application ID of the App registration
.NOTES
#>
    [CmdletBinding(SupportsShouldProcess, DefaultParameterSetName = 'ByDate')]
    param (
        # Name of the App registration
        [Parameter(Mandatory)]
        [string]
        $Name
    )

    Test-MgGraphConnection

    $ExistingApplication = Get-MgApplication | Where-Object { $_.DisplayName -eq $Name }
    if ($ExistingApplication) {
        Write-Error 'This Application already exists!'
        exit
    }
    else {
        if ($PSCmdlet.ShouldProcess()) {
            $Application = New-MgApplication -DisplayName $Name

            ###Create an AAD service principal
            New-MgServicePrincipal -AppId $Application.AppId > $null

            [PSCustomObject]@{
                AppId = $Application.AppId
                Id    = $Application.Id
            }
        }
        else {
            New-MgApplication -DisplayName $Name -WhatIf
            New-MgServicePrincipal -AppId $Application.AppId -WhatIf
        }
    }
}