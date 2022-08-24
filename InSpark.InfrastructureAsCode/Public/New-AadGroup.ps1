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
    [CmdletBinding(SupportsShouldProcess, DefaultParameterSetName = 'ByDate')]
    param (
        # Name of the app registration
        [Parameter(Mandatory)]
        [string]
        $Name,

        # Provide nickname for the email. this cannot have spaces in it.
        [Parameter(Mandatory)]
        [string]
        $MailNickName,

        # Enable mail on the Azure AD group
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
}