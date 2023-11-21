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

  .EXAMPLE
    $params = @{
      CollectionUri         = "https://dev.azure.com/contoso"
      ProjectName           = "Project 1"
      ServiceConnectionName = "ServiceConnection1"
      Description           = 'Service connection for Azure Resource Manager'
      SubscriptionId        = "00000-00000-00000-00000-00000"
      SubscriptionName      = "Subscription 1"
      TenantId              = 'aee976c7-a678-4b4b-884a-cc6cfccad0f9'
      Serviceprincipalid    = "1c03163f-7e4e-4fab-8b41-6f040a8361b9"
      AuthenticationType    = 'WorkloadIdentityFederation'
      AsDraft               = $true
      Force                 = $true
    }
    New-AzDoServiceConnection @params

    This example creates a new Azure DevOps service connection with WorkloadIdentityFederation as authentication type.
  #>

  [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
  param (
    # Collection Uri. e.g. https://dev.azure.com/contoso.
    [Parameter(Mandatory)]
    [string]
    $CollectionUri,

    # Name of the project.
    [Parameter(Mandatory)]
    [string]
    $ProjectName,

    # Name of the service connection.
    [Parameter(Mandatory)]
    [string]
    $ServiceConnectionName,

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

    # Create the service connection as draft (useful when creating a WorkloadIdentityFederation based service connection).
    [Parameter(ValueFromPipelineByPropertyName)]
    [switch]
    $AsDraft,

    # Parameter help description
    [Parameter(ValueFromPipelineByPropertyName)]
    [Switch]
    $Force
  )


  process {
    if ($Force -and -not $Confirm) {
      $ConfirmPreference = 'None'
    }

    $Projects = Get-AzDoProject -CollectionUri $CollectionUri -ProjectName $ProjectName
    $ProjectId = ($Projects | Where-Object ProjectName -EQ $ProjectName).Projectid

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
      name                             = $ServiceConnectionName
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
          name             = $ServiceConnectionName
        }
      )
    }

    if (-not $AsDraft) {
      $body += @{
        isReady = $true
      }
    }

    $Params = @{
      uri     = "$CollectionUri/_apis/serviceendpoint/endpoints"
      version = "7.2-preview.4"
      Method  = 'POST'
      body    = $Body
    }

    if ($PSCmdlet.ShouldProcess($CollectionUri, "Create Service Connection named: $($PSStyle.Bold)$serviceconnectionname$($PSStyle.Reset)")) {
      Invoke-AzDoRestMethod @params | ForEach-Object {
        [PSCustomObject]@{
          Name                              = $_.name
          Type                              = $_.Type
          SubscriptionName                  = $_.data.subscriptionName
          SubscriptionId                    = $_.data.subscriptionId
          workloadIdentityFederationSubject = $_.authorization.parameters.workloadIdentityFederationSubject
          workloadIdentityFederationIssuer  = $_.authorization.parameters.workloadIdentityFederationIssuer
        }
      }
    } else {
      Write-Information "This request will call $($Params.uri) with the following body:"
      $body | ConvertTo-Json -Depth 99
    }
  }
}
