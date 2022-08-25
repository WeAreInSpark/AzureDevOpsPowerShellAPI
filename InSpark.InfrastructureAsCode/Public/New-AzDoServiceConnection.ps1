function New-AzDoServiceConnection {
    <#
    .SYNOPSIS
        Function to create a service connection in Azure DevOps
    .DESCRIPTION
        Function to create a service connection in Azure DevOps
    .NOTES
        When you are using Azure DevOps with Build service Access token, make sure the setting 'Protect access to repositories in YAML pipelin' is off.
    .EXAMPLE
        $params = @{
            CollectionUri               = "https://dev.azure.com/contoso"
            PAT                         = "***"
            ProjectName                 = "Project 1"
            SubscriptionId              = "00000-00000-00000-00000-00000"
            SubscriptionName            = "Subscription 1"
            Tenantid                    = "11111-11111-11111-11111-11111"
            Serviceprincipalid          = "1c03163f-7e4e-4fab-8b41-6f040a8361b9"
            KeyVaultName                = "kv01"
            CertName                    = "Cert01"
            AuthenticationType          = "spnCertificate"
            ProjectID                   = "1f31cb4d-5a69-419f-86f0-ee3a8ed9ced2"
            Name                        = "Project 1"
        }
        New-AzDoServiceConnection @params

        This example creates a new Azure DevOps service connection with a Certificate from a KeyVault in Azure.
    #>

    [CmdletBinding(SupportsShouldProcess)]
    param (
        # Name of the service connection.
        [Parameter(Mandatory)]
        [string]
        $Name,

        # Collection Uri. e.g. https://dev.azure.com/contoso.
        [Parameter(Mandatory)]
        [string]
        $CollectionUri,

        # PAT to get access to Azure DevOps.
        [Parameter()]
        [string]
        $PAT = $env:SYSTEM_ACCESSTOKEN,

        # Name of the project.
        [Parameter(Mandatory)]
        [string]
        $ProjectName,

        # ID of the project.
        [Parameter(Mandatory)]
        [string]
        $ProjectID,

        # Description to add to the service connection.
        [Parameter(Mandatory = $false)]
        [string]
        $Description = '',

        # Scope level (Subscription or ManagementGroup).
        [Parameter(Mandatory = $false)]
        [ValidateSet('Subscription', 'ManagementGroup')]
        [string]
        $ScopeLevel = 'Subscription',

        # ID of the subscriptionn.
        [Parameter(Mandatory, ParameterSetName = 'Subscription')]
        [string]
        $SubscriptionId,

        # Name of the subscription.
        [Parameter(Mandatory, ParameterSetName = 'Subscription')]
        [string]
        $SubscriptionName,

        # ID of the Management group.
        [Parameter(Mandatory, ParameterSetName = 'ManagementGroup')]
        [string]
        $ManagementGroupId,

        # Name of the Management group.
        [Parameter(Mandatory, ParameterSetName = 'ManagementGroup')]
        [string]
        $ManagementGroupName,

        # ID of the tenant.
        [Parameter(Mandatory)]
        [string]
        $Tenantid,

        # Client ID of the app registration.
        [Parameter(Mandatory)]
        [string]
        $Serviceprincipalid,

        # AuthenticationType (spnKey or spnCertificate).
        [Parameter(Mandatory = $false)]
        [ValidateSet('spnKey', 'spnCertificate')]
        [string]
        $AuthenticationType = 'spnKey',

        # App secret of the app registation.
        [Parameter(Mandatory = $false)]
        [string]
        $Serviceprincipalkey,

        # KeyVault name where the certificate is stored.
        [Parameter(Mandatory = $false)]
        [string]
        $KeyVaultName,

        # Name of the certificate
        [Parameter(Mandatory = $false)]
        [string]
        $CertName
    )

    if (($AuthenticationType -eq 'spnKey') -and !$Serviceprincipalkey ) {
        Write-Error "Parameter Serviceprincipalkey should not be empty"
        exit
    }

    if (($AuthenticationType -eq 'spnCertificate') -and !$KeyVaultName -and !$CertName) {
        Write-Error "Parameter KeyVaultName or CertName should not be empty"
        exit
    }

    if ($scopeLevel -eq 'Subscription') {
        $Data = @{
            subscriptionId   = $SubscriptionId
            subscriptionName = $SubscriptionName
            environment      = 'AzureCloud'
            scopeLevel       = $scopeLevel
            creationMode     = 'Manual'
        }
    } else {
        $Data = @{
            managementGroupId   = $ManagementGroupId
            managementGroupName = $ManagementGroupName
            environment         = 'AzureCloud'
            scopeLevel          = $scopeLevel
            creationMode        = 'Manual'
        }
    }

    if ($AuthenticationType -eq 'spnKey') {
        $authorization = @{
            parameters = @{
                tenantid            = $Tenantid
                serviceprincipalid  = $Serviceprincipalid
                authenticationType  = $AuthenticationType
                serviceprincipalkey = $Serviceprincipalkey
            }
            scheme     = 'ServicePrincipal'
        }
    } else {
        $CertName = ($CertName -replace " ", "")
        $KeyVaultCert = Get-AzKeyVaultCertificate -VaultName $KeyVaultName -Name $CertName
        $Secret = Get-AzKeyVaultSecret -VaultName $KeyVaultName -Name $KeyVaultCert.Name
        $SecretValueText = ''
        $SsPtr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($Secret.SecretValue)

        try {
            $secretValueText = [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR($SsPtr)
        } finally {
            [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($SsPtr)
        }

        $SecretByte = [Convert]::FromBase64String($secretValueText)
        $Cert = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2($SecretByte, "", "Exportable,PersistKeySet")

        $Pem = New-Object System.Text.StringBuilder
        $Pem.AppendLine("-----BEGIN CERTIFICATE-----") > $null
        $Pem.AppendLine([System.Convert]::ToBase64String($cert.RawData, 1)) > $null
        $Pem.AppendLine("-----END CERTIFICATE-----") > $null

        $Authorization = @{
            parameters = @{
                tenantid                    = $Tenantid
                serviceprincipalid          = $Serviceprincipalid
                authenticationType          = $AuthenticationType
                servicePrincipalCertificate = $Pem.ToString()
            }
            scheme     = 'ServicePrincipal'
        }
    }

    $Body = @{
        name                             = $Name
        type                             = 'AzureRM'
        url                              = 'https://management.azure.com/'
        description                      = $Description
        data                             = $Data
        authorization                    = $Authorization
        isShared                         = $false
        isReady                          = $true
        serviceEndpointProjectReferences = @(
            @{
                projectReference = @{
                    id   = $ProjectID
                    name = $ProjectName
                }
                name             = $Name
            }
        )
    }

    $Params = @{
        uri         = "$CollectionUri/_apis/serviceendpoint/endpoints?api-version=7.1-preview.4"
        Method      = 'POST'
        Headers     = @{Authorization = 'Basic ' + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$($PAT)")) }
        body        = $Body | ConvertTo-Json -Depth 99
        ContentType = 'application/json'
    }

    if ($PSCmdlet.ShouldProcess($CollectionUri)) {
        $Response = Invoke-RestMethod @Params

        [PSCustomObject]@{
            Name             = $Response.name
            Type             = $Response.Type
            SubscriptionName = $Response.data.subscriptionName
            SubscriptionId   = $Response.data.subscriptionId
        }
    } else {
        Write-Output $Body | Format-List
        return
    }
}