function Get-AzDoServiceConnection {
  <#
.SYNOPSIS
    Gets information about service connection in an Azure DevOps project.
.DESCRIPTION
    Gets information about specific service connection if the parameter $ServiceConnectionName is filled in. Otherwise it will list all the service connections.
.EXAMPLE
    $getAzDoServiceConnectionSplat = @{
      CollectionUri = "https://dev.azure.com/contoso"
      ProjectName = "Project 1"
    }
    Get-AzDoServiceConnection @getAzDoServiceConnectionSplat

    This example will list all the service connections contained in 'Project 1'.
.EXAMPLE
    $getAzDoServiceConnectionSplat = @{
      CollectionUri = "https://dev.azure.com/contoso"
      ProjectName = "Project 1"
      ServiceConnectionName = 'ServiceConnection1', 'ServiceConnection2'
    }
    Get-AzDoServiceConnection @getAzDoServiceConnectionSplat

    This example will fetch information about the service connections 'ServiceConnection1', 'ServiceConnection2' in the project 'Project 1'.
.EXAMPLE
    $getAzDoServiceConnectionSplat = @{
      CollectionUri = "https://dev.azure.com/contoso"
      ProjectName = "Project 1"
    }
   'ServiceConnection1', 'ServiceConnection2' | Get-AzDoServiceConnection @getAzDoServiceConnectionSplat

    This example will fetch information about the service connections 'ServiceConnection1', 'ServiceConnection2' in the project 'Project 1'.

.EXAMPLE
    [PSCustomObject]@{
      CollectionUri = "https://dev.azure.com/contoso"
      ProjectName = "Project 1"
      ServiceConnectionName = "Service Connection 1", "Service Connection 2"
    } | Get-AzDoServiceConnection

    This example will fetch information about the service connections 'ServiceConnection1', 'ServiceConnection2' in the project 'Project 1'.

.EXAMPLE
    [PSCustomObject]@{
      CollectionUri = "https://dev.azure.com/contoso"
      ProjectName = "Project 1"
      ServiceConnectionName = "Service Connection 1", "Service Connection 2"
    } | Get-AzDoServiceConnection

    This example will fetch information about the service connections 'ServiceConnection1', 'ServiceConnection2' in the project 'Project 1'.

.EXAMPLE
  @(
    [PSCustomObject]@{
    CollectionUri = "https://dev.azure.com/contoso"
    ProjectName = "Project 1"
    ServiceConnectionName = "Service Connection 1"
  },
    [PSCustomObject]@{
      CollectionUri = "https://dev.azure.com/contoso"
      ProjectName = "Project 1"
      ServiceConnectionName = "Service Connection 2"
  }
  ) | Get-AzDoServiceConnection

  This example will fetch information about the service connections 'ServiceConnection1', 'ServiceConnection2' in the project 'Project 1'.

.OUTPUTS
    PSCustomObject(s) with serviceconnections(s).
.NOTES
#>
  [CmdletBinding(SupportsShouldProcess)]
  param (
    # Collection Uri of the organization
    [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
    [string]
    $CollectionUri,

    # Project where the Service Connection is used
    [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
    [string]
    $ProjectName,

    # Name of the Service Connection to get information about
    [Parameter(ValueFromPipelineByPropertyName, ValueFromPipeline)]
    [string[]]
    $ServiceConnectionName
  )

  begin {
    $result = @()
    Write-Verbose "Starting function: Get-AzDoServiceConnection"
  }

  process {
    $result = @()
    $params = @{
      uri     = "$CollectionUri/$ProjectName/_apis/serviceendpoint/endpoints"
      version = "7.2-preview.4"
      method  = 'GET'
    }
    if ($PSCmdlet.ShouldProcess($CollectionUri, "Get Service Connections from: $($PSStyle.Bold)$ProjectName$($PSStyle.Reset)")) {
      $result += (Invoke-AzDoRestMethod @params).value | Where-Object { -not $ServiceConnectionName -or $_.Name -in $ServiceConnectionName }

      if ($result) {
        $result | ForEach-Object {
          [PSCustomObject]@{
            CollectionUri                                     = $CollectionUri
            ProjectName                                       = $ProjectName
            ServiceConnectionName                             = $_.name
            ServiceConnectionId                               = $_.id
            ServiceConnectionType                             = $_.type
            ServiceConnectionUrl                              = $_.url
            ServiceConnectionDescription                      = $_.description
            ServiceConnectionCreatedBy                        = $_.createdBy.displayName
            ServiceConnectionAuthorization                    = $_.authorization
            ServiceConnectionData                             = $_.data
            ServiceConnectionIsShared                         = $_.isShared
            ServiceConnectionOwner                            = $_.owner
            ServiceConnectionServiceEndpointProjectReferences = $_.serviceEndpointProjectReferences
          }
        }
      }
    } else {
      Write-Verbose "Calling Invoke-AzDoRestMethod with $($params| ConvertTo-Json -Depth 10)"
    }
  }
}

