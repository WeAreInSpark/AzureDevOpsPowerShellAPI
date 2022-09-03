function New-AadAppRegistration {
    <#
<<<<<<< HEAD
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
=======
>>>>>>> 18d4dd8 (InitialVersion)
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
<<<<<<< HEAD
>>>>>>> 18d4dd8 (InitialVersion)
=======
>>>>>>> 18d4dd8 (InitialVersion)
    param (
        # Name of the App registration
        [Parameter(Mandatory)]
        [string]
<<<<<<< HEAD
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
=======
>>>>>>> 18d4dd8 (InitialVersion)
        $Name
    )

    Test-MgGraphConnection
<<<<<<< HEAD
>>>>>>> 18d4dd8 (InitialVersion)
=======
>>>>>>> 18d4dd8 (InitialVersion)

    $ExistingApplication = Get-MgApplication | Where-Object { $_.DisplayName -eq $Name }
    if ($ExistingApplication) {
        Write-Error 'This Application already exists!'
<<<<<<< HEAD
<<<<<<< HEAD
        return
    } else {
        if ($PSCmdlet.ShouldProcess()) {
            $Application = New-MgApplication -DisplayName $Name

            # Create an AAD service principal
            New-MgServicePrincipal -AppId $Application.AppId | Out-Null
=======
=======
>>>>>>> 18d4dd8 (InitialVersion)
        exit
    }
    else {
        if ($PSCmdlet.ShouldProcess()) {
            $Application = New-MgApplication -DisplayName $Name

            ###Create an AAD service principal
            New-MgServicePrincipal -AppId $Application.AppId > $null
<<<<<<< HEAD
>>>>>>> 18d4dd8 (InitialVersion)
=======
>>>>>>> 18d4dd8 (InitialVersion)

            [PSCustomObject]@{
                AppId = $Application.AppId
                Id    = $Application.Id
            }
<<<<<<< HEAD
<<<<<<< HEAD
        } else {
=======
        }
        else {
>>>>>>> 18d4dd8 (InitialVersion)
=======
        }
        else {
>>>>>>> 18d4dd8 (InitialVersion)
            New-MgApplication -DisplayName $Name -WhatIf
            New-MgServicePrincipal -AppId $Application.AppId -WhatIf
        }
    }
<<<<<<< HEAD
<<<<<<< HEAD
}
=======
}
>>>>>>> 18d4dd8 (InitialVersion)
=======
}
>>>>>>> 18d4dd8 (InitialVersion)
