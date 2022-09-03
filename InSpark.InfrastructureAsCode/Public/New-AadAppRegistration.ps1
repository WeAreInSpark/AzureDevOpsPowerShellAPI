function New-AadAppRegistration {
    <#
<<<<<<< HEAD
    .SYNOPSIS
        Creates an App registration in Azure AD.
    .DESCRIPTION
        Creates an App regestration in Azure AD, if no App registration with the same name exists.
    .EXAMPLE
        New-AadAppRegistration -Name "App 1"

        This Example will create a new App registration with the name 'App 1'
    .OUTPUTS
        PSobject with the object ID and application ID of the App registration.
    .NOTES
    #>
    [CmdletBinding(SupportsShouldProcess)]
=======
.SYNOPSIS
    Creates an App registration in Azure AD.
.DESCRIPTION
    Creates an App regestration in Azure AD when no App registration with the same name exists.
.EXAMPLE
    New-AadAppRegistration -Name "App 1"

    This Example will create a new App registration with the name 'App 1'
.OUTPUTS
    PSobject with the object ID and application ID of the App registration.
.NOTES
#>
    [CmdletBinding(SupportsShouldProcess, DefaultParameterSetName = 'ByDate')]
>>>>>>> 18d4dd8 (InitialVersion)
    param (
        # Name of the App registration
        [Parameter(Mandatory)]
        [string]
<<<<<<< HEAD
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
=======
        $Name
    )

    Test-MgGraphConnection
>>>>>>> 18d4dd8 (InitialVersion)

    $ExistingApplication = Get-MgApplication | Where-Object { $_.DisplayName -eq $Name }
    if ($ExistingApplication) {
        Write-Error 'This Application already exists!'
<<<<<<< HEAD
        return
    } else {
        if ($PSCmdlet.ShouldProcess()) {
            $Application = New-MgApplication -DisplayName $Name

            # Create an AAD service principal
            New-MgServicePrincipal -AppId $Application.AppId | Out-Null
=======
        exit
    }
    else {
        if ($PSCmdlet.ShouldProcess()) {
            $Application = New-MgApplication -DisplayName $Name

            ###Create an AAD service principal
            New-MgServicePrincipal -AppId $Application.AppId > $null
>>>>>>> 18d4dd8 (InitialVersion)

            [PSCustomObject]@{
                AppId = $Application.AppId
                Id    = $Application.Id
            }
<<<<<<< HEAD
        } else {
=======
        }
        else {
>>>>>>> 18d4dd8 (InitialVersion)
            New-MgApplication -DisplayName $Name -WhatIf
            New-MgServicePrincipal -AppId $Application.AppId -WhatIf
        }
    }
<<<<<<< HEAD
}
=======
}
>>>>>>> 18d4dd8 (InitialVersion)
