function Set-AzDoBranchPolicyMergeStrategy {
  <#
.SYNOPSIS
    Creates a Merge strategy policy on a branch
.DESCRIPTION
    Creates a Merge strategy policy on a branch
.EXAMPLE
    $params = @{
        CollectionUri = "https://dev.azure.com/contoso"
        PAT = "***"
        RepoName = "Repo 1"
        ProjectName = "Project 1"
    }
    Set-AzDoBranchPolicyMergeStrategy @params

    This example creates a 'Require a merge strategy' policy with splatting parameters

.EXAMPLE
    'repo1', 'repo2' |
    Set-AzDoBranchPolicyMergeStrategy -CollectionUri "https://dev.azure.com/contoso" -ProjectName "Project 1" -PAT "***"

    This example creates a 'Require a merge strategy' policy on the main branch of repo1 and repo2

.OUTPUTS
    [PSCustomObject]@{
      CollectionUri      = $CollectionUri
      ProjectName        = $ProjectName
      RepoName           = $RepoName
      id                 = $res.id
      allowSquash        = $res.settings.allowSquash
      allowNoFastForward = $res.settings.allowNoFastForward
      allowRebase        = $res.settings.allowRebase
      allowRebaseMerge   = $res.settings.allowRebaseMerge
    }
.NOTES
#>
  [CmdletBinding(SupportsShouldProcess)]
  param (
    # Collection Uri of the organization
    [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
    [string]
    $CollectionUri,

    # Project where the pipeline will be created.
    [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
    [string]
    $ProjectName,

    # Name of the Repository containing the YAML-sourcecode
    [Parameter(Mandatory, ValueFromPipelineByPropertyName, ValueFromPipeline)]
    [string[]]
    $RepoName,

    # Branch to create the policy on
    [Parameter()]
    [string]
    $Branch = "main",

    # Allow squash merge
    [Parameter()]
    [bool]
    $AllowSquash = $true,

    # Allow no fast forward merge
    [Parameter()]
    [bool]
    $AllowNoFastForward = $false,

    # Allow rebase merge
    [Parameter()]
    [bool]
    $AllowRebase = $false,

    # Allow rebase merge message
    [Parameter()]
    [bool]
    $AllowRebaseMerge = $false
  )

  begin {
    $result = New-Object -TypeName "System.Collections.ArrayList"
  }

  Process {

    $params = @{
      uri     = "$CollectionUri/$ProjectName/_apis/policy/configurations"
      version = "7.2-preview.1"
      Method  = 'POST'
    }

    $policyId = (Get-AzDoBranchPolicyType -CollectionUri $CollectionUri -ProjectName $ProjectName -PolicyType "Require a merge strategy").policyId

    foreach ($name in $RepoName) {
      $repoId = (Get-AzDoRepo -CollectionUri $CollectionUri -ProjectName $ProjectName -RepoName $name).RepoId

      $body = @{
        isEnabled  = $true
        isBlocking = $false
        type       = @{
          id = $policyId
        }
        settings   = @{
          allowSquash        = $AllowSquash
          allowNoFastForward = $AllowNoFastForward
          allowRebase        = $AllowRebase
          allowRebaseMerge   = $AllowRebaseMerge
          scope              = @(
            @{
              repositoryId = $repoId
              refName      = "refs/heads/$branch"
              matchKind    = "exact"
            }
          )
        }
      }

      if ($PSCmdlet.ShouldProcess($ProjectName, "Create Branch policy named: $($PSStyle.Bold)$name$($PSStyle.Reset)")) {
        Write-Information "Creating 'Require a merge strategy' policy on $name/$branch"
        $result.add(($body | Invoke-AzDoRestMethod @params)) | Out-Null
      } else {
        $Body | Format-List
      }
    }
  }

  end {
    if ($result) {
      $result | ForEach-Object {
        [PSCustomObject]@{
          CollectionUri = $CollectionUri
          ProjectName   = $ProjectName
          RepoName      = $RepoName
          PolicyId      = $_.id
          Url           = $_.url
        }
      }
    }
  }
}
