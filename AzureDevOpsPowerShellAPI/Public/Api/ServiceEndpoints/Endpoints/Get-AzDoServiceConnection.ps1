function Get-AzDoServiceConnection {
  <#
.SYNOPSIS
    Gets information about a repo in Azure DevOps.
.DESCRIPTION
    Gets information about 1 repo if the parameter $Name is filled in. Otherwise it will list all the repo's.
.EXAMPLE
    $Params = @{
        CollectionUri = "https://dev.azure.com/contoso"
        PAT = "***"
        ProjectName = "Project 1"
        Name "Repo 1"
    }
    Get-AzDoRepo -CollectionUri = "https://dev.azure.com/contoso" -PAT = "***" -ProjectName = "Project 1"

    This example will list all the repo's contained in 'Project 1'.
.EXAMPLE
    $Params = @{
        CollectionUri = "https://dev.azure.com/contoso"
        PAT = "***"
        ProjectName = "Project 1"
        Name "Repo 1"
    }
    Get-AzDoRepo -CollectionUri = "https://dev.azure.com/contoso" -PAT = "***" -ProjectName = "Project 1" -Name "Repo 1"

    This example will fetch information about the repo with the name 'Repo 1'.
.EXAMPLE
    $Params = @{
        CollectionUri = "https://dev.azure.com/contoso"
        PAT = "***"
        Name "Repo 1"
    }
    get-AzDoProject -pat $pat -CollectionUri $collectionuri | Get-AzDoRepo -PAT $PAT

    This example will fetch information about the repo with the name 'Repo 1'.
.OUTPUTS
    PSObject with repo(s).
.NOTES
#>
  [CmdletBinding()]
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
    $result = New-Object -TypeName "System.Collections.ArrayList"
  }

  Process {
    $params = @{
      uri     = "$CollectionUri/$ProjectName/_apis/serviceendpoint/endpoints"
      version = "7.2-preview.4"
      method  = 'GET'
    }
    if ($PSCmdlet.ShouldProcess($CollectionUri, "Get Environments from: $($PSStyle.Bold)$ProjectName$($PSStyle.Reset)")) {
      $serviceConnections = (Invoke-AzDoRestMethod @params).value

      if ($ServiceConnectionName) {
        foreach ($name in $ServiceConnectionName) {
          $conn = $serviceConnections | Where-Object { $_.name -eq $name }
          if (-not($conn)) {
            Write-Error "Environment $name not found"
            continue
          } else {
            $result.add($conn ) | Out-Null
          }
        }
      } else {
        $result.add($serviceConnections) | Out-Null
      }

    } else {
      $body | Format-List
    }
  }

  end {
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
          ServiceConnectionCreatedOn                        = $_.createdOn
          ServiceConnectionModifiedBy                       = $_.modifiedBy.displayName
          ServiceConnectionModifiedOn                       = $_.modifiedOn
          ServiceConnectionAuthorization                    = $_.authorization.parameters
          ServiceConnectionData                             = $_.data
          ServiceConnectionIsShared                         = $_.isShared
          ServiceConnectionOwner                            = $_.owner
          ServiceConnectionReadersGroup                     = $_.readersGroup
          ServiceConnectionServiceEndpointProjectReferences = $_.serviceEndpointProjectReferences
          ServiceConnectionServiceEndpointType              = $_.serviceEndpointType
          ServiceConnectionVersion                          = $_.version
        }
      }
    }
  }
}

