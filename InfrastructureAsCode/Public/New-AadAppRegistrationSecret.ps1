function New-AadAppRegistrationSecret {
    <#
.SYNOPSIS
    This script creates a new certificate or secret for an existing app registration.
.DESCRIPTION
    This script creates a new certificate or secret for an existing app registration.
.EXAMPLE
    To create a secret that lasts 1 year for an existing app registration, input the Application (client) ID of the app registration, a name for $ClientSecretName and set
    $ClientSecretDuration to 1.
.INPUTS
    New-AppRegistrationSecret -ClientSecretName <String> [-Append <Boolean>] -ClientId <String> -ClientSecretDuration <Int32> [-CreateCert <Boolean>] [-CertName <String>]
    [-KeyVaultName <String>] [<CommonParameters>]

    New-AppRegistrationSecret -ClientSecretName <String> [-Append <Boolean>] -ClientId <String> -EndDate <String> [-CreateCert <Boolean>] [-CertName <String>] [-KeyVaultName
    <String>] [<CommonParameters>]
.OUTPUTS
    New credentials in an app registration, and a variable with the secret.
.NOTES
#>
    [CmdletBinding()]
    param (
        # Display name of the secret
        [Parameter(Mandatory)]
        [string]
        $ClientSecretName,

        # Application (client) ID of the app registration
        [Parameter(Mandatory)]
        [string]
        $ObjectID,

        # Duration of the secret until this date
        [Parameter(Mandatory, ParameterSetName = 'ByDate')]
        [string]
        $EndDate
    )

    $PasswordCredential = @{
        endDateTime = $EndDate
        displayName = $ClientSecretName
    }

    $clientSecret = (Add-MgApplicationPassword -ApplicationId $ObjectID -PasswordCredential $PasswordCredential).SecretText

    ConvertTo-SecureString -String $ClientSecret -AsPlainText
}