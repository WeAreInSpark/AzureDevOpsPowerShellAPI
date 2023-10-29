function Set-AzDoBranchPolicyCommentResolution {
  <#
.SYNOPSIS
    Creates a Comment resolution policy on a branch
.DESCRIPTION
    Creates a Comment resolution policy on a branch
.EXAMPLE
    $params = @{
        CollectionUri = "https://dev.azure.com/contoso"
        PAT = "***"
        RepoName = "Repo 1"
        ProjectName = "Project 1"
    }
    Set-AzDoBranchPolicyCommentResolution @params

    This example creates a 'Comment resolution' policy with splatting parameters

.EXAMPLE
    $env:SYSTEM_ACCESSTOKEN = '***'
    'repo1', 'repo2' | Set-AzDoBranchPolicyCommentResolution -CollectionUri "https://dev.azure.com/contoso" -ProjectName "Project 1" -PAT "***"

    This example creates a 'Comment resolution' policy on the main branch of repo1 and repo2

.OUTPUTS
    [PSCustomObject]@{
      CollectionUri = $CollectionUri
      ProjectName   = $ProjectName
      RepoName      = $RepoName
      id            = $res.id
    }
.NOTES
#>
  [CmdletBinding(SupportsShouldProcess)]
  param (
    # Collection Uri of the organization
    [Parameter(Mandatory, ValueFromPipelineByPropertyName, ValueFromPipeline)]
    [string]
    $CollectionUri,

    # Project where the pipeline will be created.
    [Parameter(Mandatory, ValueFromPipelineByPropertyName, ValueFromPipeline)]
    [string]
    $ProjectName,

    # PAT to authentice with the organization
    [Parameter()]
    [string]
    $PAT = $env:SYSTEM_ACCESSTOKEN,

    # Name of the Repository containing the YAML-sourcecode
    [Parameter(Mandatory, ValueFromPipelineByPropertyName, ValueFromPipeline)]
    [string]
    $RepoName,

    # Branch to create the policy on
    [Parameter()]
    [string]
    $Branch = "main",

    # Block pull requests until the comments are resolved
    [Parameter()]
    [bool]
    $Required = $true
  )

  Process {
    Write-Debug "CollectionUri: $CollectionUri"
    Write-Debug "ProjectName: $ProjectName"
    Write-Debug "RepoName: $RepoName"
    Write-Debug "branch: $branch"
    Write-Debug "Required: $Required"

    try {
      $policyId = Get-BranchPolicyType -CollectionUri $CollectionUri -ProjectName $ProjectName -PAT $PAT -PolicyType "Comment requirements"
    } catch {
      throw $_.Exception.Message
    }

    try {
      $repoId = (Get-AzDoRepo -CollectionUri $CollectionUri -ProjectName $ProjectName -PAT $PAT -RepoName $RepoName).RepoId
    } catch {
      throw $_.Exception.Message
    }

    $body = @{
      isEnabled  = $true
      isBlocking = $Required
      type       = @{
        id = $policyId
      }
      settings   = @{
        scope = @(
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
        Write-Information "Creating 'Comment requirements' policy on $RepoName/$branch"
        $res = Invoke-RestMethod @params
        [PSCustomObject]@{
          CollectionUri = $CollectionUri
          ProjectName   = $ProjectName
          RepoName      = $RepoName
          id            = $res.id
        }
      } catch {
        Write-Warning "Policy on $RepoName/$branch already exists. It is not possible to update policies"
      }
    } else {
      $Body | Format-List
    }

  }
}
