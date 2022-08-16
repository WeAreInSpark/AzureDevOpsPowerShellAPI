function New-AadAppRegistrationCertificate {
    <#
.SYNOPSIS
    Creates a Certificate and uploads it to the App registration.
.DESCRIPTION
    Creates a Certificate and uploads it to the App registration. The certificate will also be saves to an Azure KeyVault.
.EXAMPLE
    $newAadAppRegistrationCertificateSplat = @{
        ObjectID = "00000-00000-00000-00000"
        CertName = "cert01"
        KeyVaultName = "kv01"
        SubjectName = "contoso.com"
    }
    New-AadAppRegistrationCertificate @newAadAppRegistrationCertificateSplat
.OUTPUTS
    PSobject containing thumbprint of certificate and 2 dates when the certificate is valid.
.NOTES
#>
    [CmdletBinding()]
    param (

        # Object Id of the App registration
        [Parameter(Mandatory)]
        [string]
        $ObjectId,

        # Name of the certificate
        [Parameter()]
        [string]
        $CertName,

        # Name of the keyvault to store the certificate
        [Parameter()]
        [string]
        $KeyVaultName,

        # CN for the certificate
        [Parameter()]
        [string]
        $SubjectName,

        # Amount of months the certificate must be valid
        [Parameter()]
        [int]
        $ValidityInMonths = 6
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