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
    PSobject. An object containing the name, the folder and the URI of the pipeline
.NOTES
#>
  [CmdletBinding(SupportsShouldProcess)]
  param (
    # Collection Uri of the organization
    [Parameter(Mandatory)]
    [string]
    $CollectionUri,

    # Project where the pipeline will be created.
    [Parameter(Mandatory)]
    [string]
    $ProjectName,

    # PAT to authentice with the organization
    [Parameter()]
    [string]
    $PAT = $env:SYSTEM_ACCESSTOKEN,

    # Name of the Repository containing the YAML-sourcecode
    [Parameter(Mandatory, ValueFromPipelineByPropertyName, ValueFromPipeline)]
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

  Begin {
    try {
      $policyId = Get-BranchPolicyType -CollectionUri $CollectionUri -ProjectName $ProjectName -PAT $PAT -PolicyType "Require a merge strategy"
    } catch {
      throw $_.Exception.Message
    }
  }

  Process {
    try {
      $repoId = (Get-AzDoRepo -CollectionUri $CollectionUri -ProjectName $ProjectName -PAT $PAT -RepoName $RepoName).RepoId
    } catch {
      throw $_.Exception.Message
    }

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

    $params = @{
      uri         = "$CollectionUri/$ProjectName/_apis/policy/configurations?api-version=7.2-preview.1"
      Method      = 'POST'
      Headers     = @{Authorization = 'Basic ' + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$($PAT)")) }
      body        = $Body | ConvertTo-Json -Depth 99
      ContentType = 'application/json'
    }

    if ($PSCmdlet.ShouldProcess($CollectionUri)) {
      try {
        Write-Information "Creating 'Require a merge strategy' policy on $RepoName/$branch"
        Invoke-RestMethod @params | Select-Object createdDate, settings, id, url
      } catch {
        Write-Warning "Policy on $RepoName/$branch already exists. It is not possible to update policies"
      }
    } else {
      $Body | Format-List
    }

  }
}
