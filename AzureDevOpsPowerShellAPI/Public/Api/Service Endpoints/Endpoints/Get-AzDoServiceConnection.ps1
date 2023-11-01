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

    # Project where the Repos are contained
    [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
    [string]
    $ProjectName,

    # PAT to authenticate with the organization
    [Parameter()]
    [string]
    $PAT,

    # Name of the Repo to get information about
    [Parameter(ValueFromPipelineByPropertyName, ValueFromPipeline)]
    [string[]]
    $ServiceConnectionName
  )
  Begin {
    if (-not($script:header)) {

      try {
        New-ADOAuthHeader -PAT $PAT -ErrorAction Stop
      } catch {
        $PSCmdlet.ThrowTerminatingError($_)
      }
    }
  }
  Process {
    $params = @{
      uri         = "$CollectionUri/$ProjectName/_apis/serviceendpoint/endpoints?api-version=7.2-preview.4"
      Method      = 'GET'
      Headers     = $script:header
      ContentType = 'application/json'
    }

    if ($ServiceConnectionName) {
      foreach ($name in $ServiceConnectionName) {

        $params.uri = "$CollectionUri/$ProjectName/_apis/serviceendpoint/endpoints?endpointNames=$($name)?api-version=7.2-preview.4"
            (Invoke-RestMethod @params) | ForEach-Object {
          [PSCustomObject]@{
            ServiceConnectionName            = $_.name
            ServiceConnectionId              = $_.id
            ServiceConnectionType            = $_.type
            ServiceConnectionDescription     = $_.description
            ServiceConnectionScheme          = $_.authorization.scheme
            IsShared                         = $_.isShared
            IsReady                          = $_.isReady
            ServiceEndpointProjectReferences = $_.serviceEndpointProjectReferences
          }
        }
      }
    } else {
                (Invoke-RestMethod @params).value | ForEach-Object {
        [PSCustomObject]@{
          ServiceConnectionName            = $_.name
          ServiceConnectionId              = $_.id
          ServiceConnectionType            = $_.type
          ServiceConnectionDescription     = $_.description
          ServiceConnectionScheme          = $_.authorization.scheme
          IsShared                         = $_.isShared
          IsReady                          = $_.isReady
          ServiceEndpointProjectReferences = $_.serviceEndpointProjectReferences
        }
      }
    }
  }
}

