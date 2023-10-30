function Get-AzDoProject {
  <#
.SYNOPSIS
    Gets information about projects in Azure DevOps.
.DESCRIPTION
    Gets information about all the projects in Azure DevOps.
.EXAMPLE
    $Params = @{
        CollectionUri = "https://dev.azure.com/contoso"
        PAT = "***"
    }
    Get-AzDoProject @params

    This example will List all the projects contained in the collection ('https://dev.azure.com/contoso').

.EXAMPLE
    $Params = @{
        CollectionUri = "https://dev.azure.com/contoso"
        PAT = "***"
        ProjectName = 'Project1'
    }
    Get-AzDoProject @params

    This example will get the details of 'Project1' contained in the collection ('https://dev.azure.com/contoso').

.EXAMPLE
    $params = @{
        collectionuri = "https://dev.azure.com/contoso"
        PAT = "***"
    }
    $somedifferentobject = [PSCustomObject]@{
        ProjectName = 'Project1'
    }
    $somedifferentobject | Get-AzDoProject @params

    This example will get the details of 'Project1' contained in the collection ('https://dev.azure.com/contoso').

.EXAMPLE
    $params = @{
        collectionuri = "https://dev.azure.com/contoso"
        PAT = "***"
    }
    @(
        'Project1',
        'Project2'
    ) | Get-AzDoProject @params

    This example will get the details of 'Project1' contained in the collection ('https://dev.azure.com/contoso').
.OUTPUTS
    PSObject with repo(s).
.NOTES
#>
  [CmdletBinding()]
  param (
    # Collection Uri of the organization
    [Parameter()]
    [string]
    $CollectionUri,

    # PAT to authenticate with the organization
    [Parameter()]
    [string]
    $PAT = $env:SYSTEM_ACCESSTOKEN,

    # Switch to use PAT instead of OAuth
    [Parameter()]
    [switch]
    $UsePAT = $false,

    # Project where the Repos are contained
    [Parameter(ValueFromPipelineByPropertyName, ValueFromPipeline)]
    [string]
    $ProjectName
  )
  Begin {
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
    $Header = New-ADOAuthHeader -PAT $PAT -AccessToken:($UsePAT ? $false : $true)
  }
  Process {
    if ($ProjectName) {
      $uri = "$CollectionUri/_apis/projects/$($ProjectName)?api-version=7.1-preview.4"
    } else {
      $uri = "$CollectionUri/_apis/projects?api-version=7.1-preview.4"
    }

    $params = @{
      uri         = $uri
      Method      = 'GET'
      Headers     = $header
      ContentType = 'application/json'
    }

    if ($ProjectName) {
            (Invoke-RestMethod @params) | ForEach-Object {
        [PSCustomObject]@{
          ProjectName       = $_.name
          ProjectID         = $_.id
          ProjectURL        = $_.url
          CollectionURI     = $CollectionUri
          ProjectVisibility = $_.visibility
          State             = $_.state
        }
      }
    } else {
            (Invoke-RestMethod @params).value | ForEach-Object {
        [PSCustomObject]@{
          ProjectName       = $_.name
          ProjectID         = $_.id
          ProjectURL        = $_.url
          CollectionURI     = $CollectionUri
          ProjectVisibility = $_.visibility
          State             = $_.state
        }
      }
    }
  }
}
