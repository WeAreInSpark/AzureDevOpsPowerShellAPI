function Test-MgGraphConnection {
    <#
.SYNOPSIS
    This script creates a new app registration with a certificate or secret.
.DESCRIPTION
    This script creates a new app registration with a certificate or secret.
.EXAMPLE
    To create an app registration with a secret that lasts 1 year, choose a name for $AppRegName, a name for $ClientSecretName and set $ClientSecretDuration to 1.
.INPUTS
    New-AppRegistration -AppRegName <String> -ClientSecretName <String> -EndDate <String> [-Append <Boolean>] [-CreateCert <Boolean>] [-CertName <String>] [-KeyVaultName <String>]
    [<CommonParameters>]

    New-AppRegistration -AppRegName <String> -ClientSecretName <String> -ClientSecretDuration <Int32> [-Append <Boolean>] [-CreateCert <Boolean>] [-CertName <String>] [-KeyVaultName
    <String>] [<CommonParameters>]
.OUTPUTS
    New app registration with credentials, and variables with the ID and secret.
.NOTES
#>

    try {
        $Token = (Get-AzAccessToken -ResourceTypeName MSGraph).Token
        Connect-MgGraph -AccessToken $Token > $null
    }
    catch {
        $_
    }

}