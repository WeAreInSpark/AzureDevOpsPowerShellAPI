function New-AadGroup {
    <#
.SYNOPSIS
    Creates an Azure AD group.
.DESCRIPTION
    Creates an Azure AD group. It defaults to an Office 365 group with a mail address.
.EXAMPLE
<<<<<<< HEAD
<<<<<<< HEAD
    New-AadGroup -GroupName "AD group 1" -MailNickname "AdGroup1"

    This example will create a new Azure AD group with a specific mail address.

.EXAMPLE
    [pscustomobject]@{
        GroupName    = 'Group1'
        MailNickname = 'group1'
        Description  = 'This is the best group'
    },
    [pscustomobject]@{
        GroupName    = 'Group2'
        MailNickname = 'group2'
        Description  = 'This is also the best group'
    } | New-AadGroup

    This example will create new Azure AD groups with a specific mail addresses.
=======
    New-AadGroup -Name "AD group 1" -MailNickname "AdGroup1"

    This example will create a new Azure AD group with a specific mail address.
>>>>>>> 18d4dd8 (InitialVersion)
=======
    New-AadGroup -Name "AD group 1" -MailNickname "AdGroup1"

    This example will create a new Azure AD group with a specific mail address.
>>>>>>> 18d4dd8 (InitialVersion)
.OUTPUTS
    PSobject containing the display name, ID and description.
.NOTES
#>
<<<<<<< HEAD
<<<<<<< HEAD
    [CmdletBinding(SupportsShouldProcess)]
    param (
        # Name of the Azure AD Group
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]
        $GroupName,

        # Provide nickname/alias for the email.
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
=======
=======
>>>>>>> 18d4dd8 (InitialVersion)
    [CmdletBinding(SupportsShouldProcess, DefaultParameterSetName = 'ByDate')]
    param (
        # Name of the app registration
        [Parameter(Mandatory)]
        [string]
        $Name,

        # Provide nickname for the email. this cannot have spaces in it.
        [Parameter(Mandatory)]
<<<<<<< HEAD
>>>>>>> 18d4dd8 (InitialVersion)
=======
>>>>>>> 18d4dd8 (InitialVersion)
        [string]
        $MailNickName,

        # Enable mail on the Azure AD group
<<<<<<< HEAD
<<<<<<< HEAD
        [Parameter()]
        [switch]
        $MailEnabled = $true,

        # Provide a description for the group.
        [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty]
        [string]
        $Description,

        # Manually connect to Microsoft Graph
        [Parameter()]
        [switch]
        $ManuallyConnectToGraph
    )
    begin {
        try {
            if ($ManuallyConnectToGraph) {
                Connect-MgGraphWithToken
            } else {
                Connect-MgGraphWithToken -RequestTokenViaAzurePowerShell
            }
        } catch {
            throw $_
        }
    }
    process {
        $MailNickName = ($MailNickName -replace " ", "")
        $ExistingGroup = Get-MgGroup -All | Where-Object { $_.DisplayName -eq $GroupName }

        if ($ExistingGroup) {
            Write-Error 'This Group already exists!'
            return $ExistingGroup

        } else {
            if ($PSCmdlet.ShouldProcess($GroupName)) {
                $newMgGroupSplat = @{
                    DisplayName     = $GroupName
                    MailEnabled     = $MailEnabled
                    MailNickname    = $MailNickName
                    SecurityEnabled = $true
                    Description     = $Description
                    Visibility      = 'private'
                    GroupTypes      = 'Unified'
                    WhatIf          = $WhatIfPreference
                }

                New-MgGroup @newMgGroupSplat | ForEach-Object {
                    [PSCustomObject]@{
                        DisplayName = $_.DisplayName
                        GroupId     = $_.Id
                        Description = $Description
                    }
                }
            }
        }
    }
}
=======
=======
>>>>>>> 18d4dd8 (InitialVersion)
        [Parameter(Mandatory = $false)]
        [bool]
        $MailEnabled = $true
    )
    Test-MgGraphConnection
    $MailNickName = ($MailNickName -replace " ", "")
    $ExistingGroup = Get-MgGroup | Where-Object { $_.DisplayName -eq $Name }

    if ($ExistingGroup) {
        Write-Error 'This Group already exists!'
        exit
    } else {
        if ($PSCmdlet.ShouldProcess($Name)) {
            $Group = New-MgGroup -DisplayName $Name -MailEnabled:$MailEnabled -MailNickname $MailNickName -SecurityEnabled:$true -Visibility 'private' -GroupTypes 'Unified' -WhatIf:$WhatIfPreference

            [PSCustomObject]@{
                DisplayName = $Group.DisplayName
                Id          = $Group.Id
                Description = $Group.Description
            }
        }
    }
<<<<<<< HEAD
}
>>>>>>> 18d4dd8 (InitialVersion)
=======
}
>>>>>>> 18d4dd8 (InitialVersion)
