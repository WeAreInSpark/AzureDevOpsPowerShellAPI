function New-AadGroup {
    <#
.SYNOPSIS
    Creates an Azure AD group.
.DESCRIPTION
    Creates an Azure AD group. It defaults to an Office 365 group with a mail address.
.EXAMPLE
    New-AadGroup -Name $ProjectName -MailNickname $ProjectName
.INPUTS
    New-AadGroup [-Name] <String> [-MailNickName] <String> [-MailEnabled] <String>
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

        [Parameter(Mandatory)]
        [string]
        $MailNickName,

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
    }
    else {
        $Group = New-MgGroup -DisplayName $Name -MailEnabled:$MailEnabled -MailNickname $MailNickName -SecurityEnabled:$true -Visibility 'private' -GroupTypes 'Unified' -WhatIf:$WhatIfPreference

        [PSCustomObject]@{
            DisplayName = $Group.DisplayName
            Id          = $Group.Id
            Description = $Group.Description
        }
    }
}