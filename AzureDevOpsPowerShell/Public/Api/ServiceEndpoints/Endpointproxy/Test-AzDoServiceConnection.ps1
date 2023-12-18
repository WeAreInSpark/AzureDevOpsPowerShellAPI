function Test-AzDoServiceConnection {
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
        Test-AzDoServiceConnection @params

        This example creates a new Azure DevOps service connection with a Certificate from a KeyVault in Azure.
    #>

  [CmdletBinding(SupportsShouldProcess)]
  param (
    # Name of the Project in Azure DevOps.
    [Parameter(Mandatory)]
    [string]
    $ProjectName,

    # Collection Uri. e.g. https://dev.azure.com/contoso.
    [Parameter(Mandatory)]
    [string]
    $CollectionUri,

    # PAT to get access to Azure DevOps.
    [Parameter()]
    [string]
    $PAT,

    # Collection Uri. e.g. https://dev.azure.com/contoso.
    [Parameter(Mandatory, ValueFromPipelineByPropertyName, ValueFromPipeline)]
    [string]
    $ServiceConnectionName
  )

  begin {
    Write-Verbose "Starting function: Test-AzDoServiceConnection"
    $getAzDoProjectSplat = @{
      CollectionUri = $CollectionUri
    }
    $ProjectId = (Get-AzDoProject @getAzDoProjectSplat | Where-Object ProjectName -EQ $ProjectName).Projectid

    $getAzDoServiceConnectionSplat = @{
      CollectionUri = $CollectionUri
      ProjectName   = $ProjectName
    }

    $Connections = Get-AzDoServiceConnection @getAzDoServiceConnectionSplat
  }

  process {
    $connectioninfo = $connections | Where-Object ServiceConnectionName -EQ $ServiceConnectionName

    $body = @{
      dataSourceDetails = @{
        dataSourceName = 'TestConnection'
        parameters     = $null
      }
    }

    $params = @{
      uri         = "$CollectionUri/$ProjectId/_apis/serviceendpoint/endpointproxy?endpointId=$($connectioninfo.ServiceConnectionId)&api-version=7.2-preview.1"
      Method      = 'POST'
      body        = $Body | ConvertTo-Json -Depth 99
      ContentType = 'application/json'
    }

    if ($PSCmdlet.ShouldProcess($ProjectName, "Test service connection on: $($PSStyle.Bold)$ProjectName$($PSStyle.Reset)")) {
      $response = Invoke-RestMethod @Params
      if ($response.statusCode -eq 'badRequest') {
        Write-Error "Connection $($connectioninfo.ServiceConnectionName) is not working: error $($response.errorMessage)"
      } else {
        [PSCustomObject]@{
          Result = "Connection [$($connectioninfo.ServiceConnectionName)] is working as expected"
        }
        Write-Verbose ($response.result | ConvertFrom-Json -Depth 10 | ConvertTo-Json -Depth 10 -Compress)
      }
    }
  }
}

