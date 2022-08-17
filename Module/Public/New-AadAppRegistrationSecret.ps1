function New-AadAppRegistrationSecret {
    <#
.SYNOPSIS
    Creates a secret for the App registration
.DESCRIPTION
    Creates a secret for the App registration. The secret will get uploaded to an Azure KeyVault.
.EXAMPLE
    $newAadAppRegistrationSecretSplat = @{
        ObjectID = "00000-00000-00000-00000-00000"
        ClientSecretName = "Secret 1"
        EndDate = "2022-01-01"
    }
    New-AadAppRegistrationSecret @newAadAppRegistrationSecretSplat

    This example will create a new secret for the app registration.
.OUTPUTS
    The Appsecret
.NOTES
#>
    [CmdletBinding(SupportsShouldProcess)]
    param (

        # Application (client) ID of the app registration
        [Parameter(Mandatory)]
        [string]
        $ObjectID,

        # Display name of the secret
        [Parameter(Mandatory)]
        [string]
        $ClientSecretName,

        # Duration of the secret until this date
        [Parameter(Mandatory, ParameterSetName = 'ByDate')]
        [string]
        $EndDate
    )

    Test-MgGraphConnection

    $PasswordCredential = @{
        endDateTime = $EndDate
        displayName = $ClientSecretName
    }
    if ($PSCmdlet.ShouldProcess()) {
        Add-MgApplicationPassword -ApplicationId $ObjectID -PasswordCredential $PasswordCredential | Select-Object SecretText | ConvertTo-SecureString -String $_
    }
    else {
        Add-MgApplicationPassword -ApplicationId $ObjectID -PasswordCredential $PasswordCredential -WhatIf
    }
}