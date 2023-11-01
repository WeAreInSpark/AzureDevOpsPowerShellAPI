function Get-AzDoRepo {
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

    # PAT to authenticate with the organization
    [Parameter()]
    [string]
    $PAT,

    # Name of the Repo to get information about
    [Parameter()]
    [string]
    $Name,

    # Project where the Repos are contained
    [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
    [string]
    $ProjectName
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
      uri         = "$CollectionUri/$ProjectName/_apis/git/repositories?api-version=7.1-preview.1"
      Method      = 'GET'
      Headers     = $script:header
      ContentType = 'application/json'
    }

    if ($Name) {
      $result = (Invoke-RestMethod @params).value | Where-Object { $_.name -eq $Name }
    } else {
      $result = (Invoke-RestMethod @params).value
    }

    $result | ForEach-Object {
      [PSCustomObject]@{
        Name          = $_.name
        Id            = $_.id
        URL           = $_.url
        ProjectName   = $ProjectName
        DefaultBranch = $_.defaultBranch
        WebUrl        = $_.webUrl
        HttpsUrl      = $_.remoteUrl
        SshUrl        = $_.sshUrl
        CollectionURI = $CollectionUri
        IsDisabled    = $_.IsDisabled
      }
    }
  }
}
