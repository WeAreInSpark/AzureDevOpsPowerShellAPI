function New-AadGroup {
    <#
.SYNOPSIS
    Creates an Azure AD group.
.DESCRIPTION
    Creates an Azure AD group. It defaults to an Office 365 group with a mail address.
.EXAMPLE
    New-AadGroup -Name "AD group 1" -MailNickname "AdGroup1"

    This example will create a new Azure AD group with a specific mail address.
.OUTPUTS
    PSobject containing the display name, ID and description.
.NOTES
#>
    [CmdletBinding(SupportsShouldProcess)]
    param (
        # Name of the Azure AD Group
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]
        $GroupName,

        # Provide nickname/alias for the email.
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]
        $MailNickName,

        # Enable mail on the Azure AD group
        [Parameter()]
        [switch]
        $MailEnabled = $true,

        # Provide a description for the group.
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]
        $Description
    )
    begin {
        try {
            Connect-MgGraphWithToken -RequestTokenViaAzurePowerShell
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
