function New-AzDoServiceConnection {
    <#
    .SYNOPSIS
        Function to create a service connection in Azure DevOps
    .DESCRIPTION
        Function to create a service connection in Azure DevOps
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

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
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

        # Switch to use PAT instead of OAuth
        [Parameter()]
        [switch]
        $UsePAT = $false,

        # Name of the project.
        [Parameter(Mandatory)]
        [string]
        $ProjectName,

        # Description to add to the service connection.
        [Parameter()]
        [string]
        $Description = '',

        # Scope level (Subscription or ManagementGroup).
        [Parameter(ValueFromPipelineByPropertyName)]
        [ValidateSet('Subscription', 'ManagementGroup')]
        [string]
        $ScopeLevel = 'Subscription',

        # ID of the subscriptionn.
        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = 'Subscription')]
        [string]
        $SubscriptionId,

        # Name of the subscription.
        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = 'Subscription')]
        [string]
        $SubscriptionName,

        # ID of the Management group.
        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = 'ManagementGroup')]
        [string]
        $ManagementGroupId,

        # Name of the Management group.
        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = 'ManagementGroup')]
        [string]
        $ManagementGroupName,

        # ID of the tenant.
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]
        $TenantId,

        # Client ID of the app registration.
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]
        $ServiceprincipalId,

        # AuthenticationType (spnSecret or spnCertificate).
        [Parameter(ValueFromPipelineByPropertyName)]
        [ValidateSet('spnSecret', 'spnCertificate', 'WorkloadIdentityFederation')]
        [string]
        $AuthenticationType = 'WorkloadIdentityFederation',

        # App secret of the app registation.
        [Parameter(ValueFromPipelineByPropertyName, ParameterSetName = 'ServiceprincipalSecret')]
        [string]
        $ServiceprincipalSecret,

        # KeyVault name where the certificate is stored.
        [Parameter(ValueFromPipelineByPropertyName, ParameterSetName = 'ServiceprincipalCertificate')]
        [string]
        $KeyVaultName,

        # Name of the certificate
        [Parameter(ValueFromPipelineByPropertyName, ParameterSetName = 'ServiceprincipalCertificate')]
        [string]
        $CertName,

        [Parameter(ValueFromPipelineByPropertyName)]
        [switch]
        $AsDraft
    )
    begin {
        # Validate if the user is logged into azure
        if ($KeyVaultName) {
            if (!(Get-AzContext)) {
                try {
                    Write-Error 'Please login to Azure first'
                    throw
                } catch {
                    $PSCmdlet.ThrowTerminatingError($_)
                }
            }
        }
        if ($UsePAT) {
            Write-Verbose 'The [UsePAT]-parameter was set to true, so the PAT will be used to authenticate with the organization.'
            if ($PAT -eq $env:SYSTEM_ACCESSTOKEN) {
                Write-Verbose -Message "Using the PAT from the environment variable 'SYSTEM_ACCESSTOKEN'."
            } elseif (-not [string]::IsNullOrWhitespace($PAT) -and $PSBoundParameters.ContainsKey('PAT')) {
                Write-Verbose -Message "Using a custom PAT supplied in the parameters."
            } else {
                try {
                    throw "Requested to use a PAT, but no custom PAT was supplied in the parameters or the environment variable 'SYSTEM_ACCESSTOKEN' was not set."
                } catch {
                    $PSCmdlet.ThrowTerminatingError($_)
                }
            }
        } else {
            Write-Verbose 'The [UsePAT]-parameter was set to false, so an OAuth will be used to authenticate with the organization.'
            $PAT = ($UsePAT ? $PAT : $null)
        }
        try {
            $Header = New-ADOAuthHeader -PAT $PAT -AccessToken:($UsePAT ? $false : $true) -ErrorAction Stop
        } catch {
            $PSCmdlet.ThrowTerminatingError($_)
        }

        $getAzDoProjectSplat = @{
            CollectionUri = $CollectionUri
        }

        if ($PAT) {
            $getAzDoProjectSplat += @{
                PAT    = $PAT
                UsePAT = $true
            }
        }

        $Projects = Get-AzDoProject @getAzDoProjectSplat
        $ProjectId = ($Projects | Where-Object ProjectName -EQ $ProjectName).Projectid
    }
    process {
        if (($AuthenticationType -eq 'spnSecret') -and !$ServiceprincipalSecret ) {
            Write-Error 'Parameter ServiceprincipalSecret should not be empty'
            exit
        }

        if (($AuthenticationType -eq 'spnCertificate') -and !$KeyVaultName -and !$CertName) {
            Write-Error 'Parameter KeyVaultName or CertName should not be empty'
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
        if ($AuthenticationType -eq 'WorkloadIdentityFederation' -and $AsDraft) {
            $Data += @{
                isDraft = "True"
            }
        }

        if ($AuthenticationType -eq 'spnSecret') {
            $authorization = @{
                parameters = @{
                    tenantid            = $Tenantid
                    serviceprincipalid  = $Serviceprincipalid
                    authenticationType  = $AuthenticationType
                    serviceprincipalkey = $ServiceprincipalSecret
                }
                scheme     = 'ServicePrincipal'
            }
        } elseif ($AuthenticationType -eq 'spnCertificate') {
            $CertName = ($CertName -replace ' ', '')
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
            $Cert = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2($SecretByte, '', 'Exportable,PersistKeySet')

            $Pem = New-Object System.Text.StringBuilder
            $Pem.AppendLine('-----BEGIN CERTIFICATE-----') | Out-Null
            $Pem.AppendLine([System.Convert]::ToBase64String($cert.RawData, 1)) | Out-Null
            $Pem.AppendLine('-----END CERTIFICATE-----') | Out-Null

            $Authorization = @{
                parameters = @{
                    tenantid                    = $Tenantid
                    serviceprincipalid          = $Serviceprincipalid
                    authenticationType          = $AuthenticationType
                    servicePrincipalCertificate = $Pem.ToString()
                }
                scheme     = 'ServicePrincipal'
            }
        } else {
            $authorization = @{
                parameters = @{
                    tenantid           = $Tenantid
                    serviceprincipalid = $Serviceprincipalid
                }
                scheme     = 'WorkloadIdentityFederation'
            }
        }

        $body = @{
            name                             = $Name
            type                             = 'AzureRM'
            url                              = 'https://management.azure.com/'
            description                      = $Description
            data                             = $Data
            authorization                    = $Authorization
            isShared                         = $false
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
        if (-not $AsDraft) {
            $body += @{
                isReady = $true
            }
        }

        $Params = @{
            uri         = "$CollectionUri/_apis/serviceendpoint/endpoints?api-version=7.1-preview.4"
            Method      = 'POST'
            Headers     = New-ADOAuthHeader
            body        = $Body | ConvertTo-Json -Depth 99
            ContentType = 'application/json'
        }

        if ($PSCmdlet.ShouldProcess($CollectionUri, "Create Service Connection named: $($PSStyle.Bold)$name$($PSStyle.Reset)")) {
            $Response = Invoke-RestMethod @Params

            [PSCustomObject]@{
                Name                              = $Response.name
                Type                              = $Response.Type
                SubscriptionName                  = $Response.data.subscriptionName
                SubscriptionId                    = $Response.data.subscriptionId
                workloadIdentityFederationSubject = $Response.authorization.parameters.workloadIdentityFederationSubject
                workloadIdentityFederationIssuer  = $Response.authorization.parameters.workloadIdentityFederationIssuer
            }
        } else {
            $body
        }
    }
}
