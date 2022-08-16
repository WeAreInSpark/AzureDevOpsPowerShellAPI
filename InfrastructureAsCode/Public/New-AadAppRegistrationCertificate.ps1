function New-AadAppRegistrationCertificate {
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


        # Application (client) ID of the app registration
        [Parameter(Mandatory)]
        [string]
        $ObjectID,

        # Name of the certificate
        [Parameter()]
        [string]
        $CertName,

        # Name of the keyvault to store the certificate
        [Parameter()]
        [string]
        $KeyVaultName,

        [Parameter()]
        [string]
        $SubjectName,

        [Parameter()]
        [string]
        $ExpiresAfterMonths = 6
    )
    Test-MgGraphConnection
    $CertName = ($CertName -replace " ", "")
    $SubjectName = ($SubjectName -replace " ", "")

    $Policy = New-AzKeyVaultCertificatePolicy -SecretContentType "application/x-pkcs12" -SubjectName "CN=$SubjectName" -IssuerName "Self" -ValidityInMonths $ValidityInMonths -ReuseKeyOnRenewal
    Add-AzKeyVaultCertificate -VaultName $KeyVaultName -Name $CertName -CertificatePolicy $Policy >> $null

    do {
        $Response = Get-AzKeyVaultCertificateOperation -VaultName $KeyVaultName -Name $CertName
    } while (
        $Response.Status -ne 'completed'
    )

    $KeyVaultCert = Get-AzKeyVaultCertificate -VaultName $KeyVaultName -Name $CertName
    $Secret = Get-AzKeyVaultSecret -VaultName $KeyVaultName -Name $KeyVaultCert.Name
    $SecretValueText = ''
    $SsPtr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($Secret.SecretValue)

    try {
        $SecretValueText = [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR($SsPtr)
    }
    finally {
        [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($ssPtr)
    }

    $SecretByte = [Convert]::FromBase64String($secretValueText)
    $Cert = new-object System.Security.Cryptography.X509Certificates.X509Certificate2($SecretByte, "", "Exportable,PersistKeySet")

    $KeyCredential = @{
        Type                = 'AsymmetricX509Cert'
        Usage               = 'Verify'
        Key                 = $cert.RawData
        CustomKeyIdentifier = $cert.GetCertHash()
        EndDateTime         = $cert.NotAfter
        DisplayName         = $ClientSecretName
    }

    Update-MgApplication -ApplicationId $ObjectID -KeyCredential $KeyCredential

    [PSCustomObject]@{
        Thumbprint = $Cert.Thumbprint
        NotBefore  = $Cert.NotBefore
        NotAfter   = $Cert.NotAfter
    }
}