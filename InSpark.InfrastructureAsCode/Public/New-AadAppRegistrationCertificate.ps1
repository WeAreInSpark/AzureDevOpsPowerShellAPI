function New-AadAppRegistrationCertificate {
    <#
.SYNOPSIS
<<<<<<< HEAD
    Creates a X.509 certificate and uploads it to the App registration in Azure AD.
.DESCRIPTION
    Creates a X.509 certificate and uploads it as an authentication factor to the App registration in Azure AD. The certificate will also be uploaded to an Azure KeyVault.
=======
    Creates a Certificate and uploads it to the App registration.
.DESCRIPTION
    Creates a Certificate and uploads it to the App registration. The certificate will also be saves to an Azure KeyVault.
>>>>>>> 18d4dd8 (InitialVersion)
.EXAMPLE
    $newAadAppRegistrationCertificateSplat = @{
        ObjectID = "00000-00000-00000-00000"
        CertName = "cert01"
        KeyVaultName = "kv01"
        SubjectName = "contoso.com"
    }
    New-AadAppRegistrationCertificate @newAadAppRegistrationCertificateSplat

<<<<<<< HEAD
    This example will create a new certificate for the app registration, upload it to the Application Registration in Azure AD and upload it to Azure KeyVault.
.OUTPUTS
    PSObject containing the thumbprint of the certificate and 2 dates when the certificate is valid.
=======
    This example will create a new certificate for the app registration.
.OUTPUTS
    PSobject containing thumbprint of certificate and 2 dates when the certificate is valid.
>>>>>>> 18d4dd8 (InitialVersion)
.NOTES
#>
    [CmdletBinding(SupportsShouldProcess)]
    param (

        # Object Id of the App registration
        [Parameter(Mandatory)]
        [string]
        $ObjectId,

        # Name of the certificate
        [Parameter()]
        [string]
        $CertName,

<<<<<<< HEAD
        # Name of the Azure Key Vault to store the certificate
=======
        # Name of the keyvault to store the certificate
>>>>>>> 18d4dd8 (InitialVersion)
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
<<<<<<< HEAD
        $ValidityInMonths = 6,

        # Manually connect to Microsoft Graph
        [Parameter()]
        [switch]
        $ManuallyConnectToGraph
    )
    try {
        if ($ManuallyConnectToGraph) {
            Connect-MgGraphWithToken
        } else {
            Connect-MgGraphWithToken -RequestTokenViaAzurePowerShell
        }
    } catch {
        throw $_
    }

    # Replace spaces in the certificate name and subjectname
    $certNameTrimmed = ($CertName -replace " ", "")
    $subjectNameTrimmed = ($SubjectName -replace " ", "")

    # Create an Azure KeyVault Certificate Policy
    $policy = New-AzKeyVaultCertificatePolicy -SecretContentType "application/x-pkcs12" -SubjectName "CN=$subjectNameTrimmed" -IssuerName "Self" -ValidityInMonths $ValidityInMonths -ReuseKeyOnRenewal

    if ($PSCmdlet.ShouldProcess($ObjectId)) {
        Add-AzKeyVaultCertificate -VaultName $KeyVaultName -Name $certNameTrimmed -CertificatePolicy $policy | Out-Null

        # Wait until the certificate is added
        do {
            $Response = Get-AzKeyVaultCertificateOperation -VaultName $KeyVaultName -Name $certNameTrimmed
=======
        $ValidityInMonths = 6
    )
    Test-MgGraphConnection

    $CertName = ($CertName -replace " ", "")
    $SubjectName = ($SubjectName -replace " ", "")
    $Policy = New-AzKeyVaultCertificatePolicy -SecretContentType "application/x-pkcs12" -SubjectName "CN=$SubjectName" -IssuerName "Self" -ValidityInMonths $ValidityInMonths -ReuseKeyOnRenewal

    if ($PSCmdlet.ShouldProcess($ObjectId)) {
        Add-AzKeyVaultCertificate -VaultName $KeyVaultName -Name $CertName -CertificatePolicy $Policy >> $null

        do {
            $Response = Get-AzKeyVaultCertificateOperation -VaultName $KeyVaultName -Name $CertName
>>>>>>> 18d4dd8 (InitialVersion)
        } while (
            $Response.Status -ne 'completed'
        )

<<<<<<< HEAD
        $keyVaultCert = Get-AzKeyVaultCertificate -VaultName $KeyVaultName -Name $certNameTrimmed
        $Secret = Get-AzKeyVaultSecret -VaultName $KeyVaultName -Name $keyVaultCert.Name
        $secretValueText = ''

        # This part decrypts the secure string and places it in unmanaged memory (unmanaged from the dotnet perspective).
        # It then reads that unmanaged memory to a string (making it managed), and finally frees the unmanaged bit that's still remaining

        # Allocates an unmanaged binary string (BSTR) and copies the contents of a managed SecureString object into it.
        $ssPtr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($Secret.SecretValue)

        try {
            # Allocates a managed String and copies a binary string (BSTR) stored in unmanaged memory into it.
            $secretValueText = [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR($ssPtr)
        } finally {
            # Frees a BSTR pointer that was allocated using the SecureStringToBSTR(SecureString) method.
            [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($ssPtr)
        }

        $secretByte = [Convert]::FromBase64String($secretValueText)
        $cert = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2($secretByte, "", "Exportable,PersistKeySet")
=======
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
>>>>>>> 18d4dd8 (InitialVersion)

        $KeyCredential = @{
            Type                = 'AsymmetricX509Cert'
            Usage               = 'Verify'
            Key                 = $cert.RawData
            CustomKeyIdentifier = $cert.GetCertHash()
            EndDateTime         = $cert.NotAfter
<<<<<<< HEAD
            DisplayName         = $certNameTrimmed
=======
            DisplayName         = $ClientSecretName
>>>>>>> 18d4dd8 (InitialVersion)
        }

        Update-MgApplication -ApplicationId $ObjectID -KeyCredential $KeyCredential

        [PSCustomObject]@{
            Thumbprint = $Cert.Thumbprint
            NotBefore  = $Cert.NotBefore
            NotAfter   = $Cert.NotAfter
        }
    }
<<<<<<< HEAD
}
=======
}
>>>>>>> 18d4dd8 (InitialVersion)
