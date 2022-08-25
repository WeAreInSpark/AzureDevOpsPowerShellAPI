function New-AadAppRegistrationSecret {
    <#
.SYNOPSIS
    Creates a secret and set it to the App registration in Azure AD.
.DESCRIPTION
    Creates a secret and uploads it as an authentication factor to the App registration in Azure AD. The secret will also be uploaded to an Azure KeyVault.
.EXAMPLE
    $newAadAppRegistrationSecretSplat = @{
        ObjectID = "00000-00000-00000-00000-00000"
        ClientSecretName = "Secret 1"
        EndDate = "2022-01-01"
    }
    New-AadAppRegistrationSecret @newAadAppRegistrationSecretSplat

    This example will create a new secret for the app registration, upload it to the Azure KeyVault and add it to the Application Registration in Azure AD.
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

        # Enddate of validity of the secret
        [Parameter(Mandatory)]
        [string]
        $EndDate
    )

    Test-MgGraphConnection

    $PasswordCredential = @{
        endDateTime = $EndDate
        displayName = $ClientSecretName
    }
    if ($PSCmdlet.ShouldProcess()) {
        Add-MgApplicationPassword -ApplicationId $ObjectID -PasswordCredential $PasswordCredential | Select-Object SecretText | ConvertTo-SecureString -String $_ -AsPlainText
    } else {
        Add-MgApplicationPassword -ApplicationId $ObjectID -PasswordCredential $PasswordCredential -WhatIf
    }
}
