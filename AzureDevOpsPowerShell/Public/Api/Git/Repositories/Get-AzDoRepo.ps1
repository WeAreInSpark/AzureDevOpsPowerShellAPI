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
  [CmdletBinding(SupportsShouldProcess)]
  param (
    # Collection Uri of the organization
    [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
    [string]
    $CollectionUri,

    # Project where the Repos are contained
    [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
    [string]
    $ProjectName,

    # Name of the Repo to get information about
    [Parameter(ValueFromPipelineByPropertyName, ValueFromPipeline)]
    [string[]]
    $RepoName
  )

  begin {
    Write-Verbose "Starting function: Get-AzDoRepo"
  }

  process {

    $params = @{
      uri     = "$CollectionUri/$ProjectName/_apis/git/repositories"
      version = "7.1-preview.1"
      method  = 'GET'
    }

    if ($PSCmdlet.ShouldProcess($CollectionUri, "Get Environments from: $($PSStyle.Bold)$ProjectName$($PSStyle.Reset)")) {
      $repos = (Invoke-AzDoRestMethod @params).value

      if ($RepoName) {
        foreach ($name in $RepoName) {
          $repo = $repos | Where-Object { $_.name -eq $name }
          if (-not($repo)) {
            Write-Error "Repo $name not found"
            continue
          } else {
            $result += $repo
          }
        }
      } else {
        $result += $repos
      }

    } else {
      Write-Verbose "Calling Invoke-AzDoRestMethod with $($params| ConvertTo-Json -Depth 10)"
    }
  }

  end {
    if ($result) {
      $result | ForEach-Object {
        [PSCustomObject]@{
          CollectionURI = $CollectionUri
          ProjectName   = $ProjectName
          RepoName      = $_.name
          RepoId        = $_.id
          URL           = $_.url
          DefaultBranch = $_.defaultBranch
          WebUrl        = $_.webUrl
          RemoteUrl     = $_.remoteUrl
          SshUrl        = $_.sshUrl
          IsDisabled    = $_.IsDisabled
        }
      }
    }
  }
}
