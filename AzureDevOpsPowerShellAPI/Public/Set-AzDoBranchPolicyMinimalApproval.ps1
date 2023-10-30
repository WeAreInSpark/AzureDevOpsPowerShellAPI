function Set-AzDoBranchPolicyMinimalApproval {
  <#
.SYNOPSIS
    Creates a Minimal approval policy on a branch
.DESCRIPTION
    Creates a Minimal approval policy on a branch
.EXAMPLE
    $params = @{
        CollectionUri = "https://dev.azure.com/contoso"
        PAT = "***"
        RepoName = "Repo 1"
        ProjectName = "Project 1"
    }
    Set-AzDoBranchPolicyMinimalApproval @params

    This example creates a new Azure Pipeline using the PowerShell pipeline

.EXAMPLE
    'repo1', 'repo2' |
    Set-AzDoBranchPolicyMinimalApproval -CollectionUri $CollectionUri -ProjectName $ProjectName -PAT "***"

    This example creates a 'Minimum number of reviewers' policy on the main branch of repo1 and repo2

.OUTPUTS
    [PSCustomObject]@{
      CollectionUri               = $CollectionUri
      ProjectName                 = $ProjectName
      RepoName                    = $RepoName
      id                          = $res.id
      minimumApproverCount        = $res.settings.minimumApproverCount
      creatorVoteCounts           = $res.settings.creatorVoteCounts
      allowDownvotes              = $res.settings.allowDownvotes
      resetOnSourcePush           = $res.settings.resetOnSourcePush
      requireVoteOnLastIteration  = $res.settings.requireVoteOnLastIteration
      resetRejectionsOnSourcePush = $res.settings.resetRejectionsOnSourcePush
      blockLastPusherVote         = $res.settings.blockLastPusherVote
      requireVoteOnEachIteration  = $res.settings.requireVoteOnEachIteration
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
    $PAT,

    # Name of the Repository containing the YAML-sourcecode
    [Parameter(Mandatory, ValueFromPipelineByPropertyName, ValueFromPipeline)]
    [string]
    $RepoName,

    # Branch to create the policy on
    [Parameter()]
    [string]
    $branch = "main",

    # Block pull requests until the comments are resolved
    [Parameter()]
    [int]
    $minimumApproverCount = 2,

    # Block self approval
    [Parameter()]
    [bool]
    $creatorVoteCounts = $true
  )

  begin {
    if (-not($script:header)) {

      try {
        New-ADOAuthHeader -PAT $PAT -ErrorAction Stop
      } catch {
        $PSCmdlet.ThrowTerminatingError($_)
      }
    }
  }

  Process {

    Write-Debug "CollectionUri: $CollectionUri"
    Write-Debug "ProjectName: $ProjectName"
    Write-Debug "RepoName: $RepoName"
    Write-Debug "branch: $branch"

    try {
      $policyId = Get-BranchPolicyType -CollectionUri $CollectionUri -ProjectName $ProjectName -PAT $PAT -PolicyType "Minimum number of reviewers"
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
      isBlocking = $true
      type       = @{
        id = $policyId
      }
      settings   = @{
        minimumApproverCount        = $minimumApproverCount
        creatorVoteCounts           = $true
        allowDownvotes              = $false
        resetOnSourcePush           = $false
        requireVoteOnLastIteration  = $false
        resetRejectionsOnSourcePush = $false
        blockLastPusherVote         = $false
        requireVoteOnEachIteration  = $false
        scope                       = @(
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
      Headers     = $script:header
      body        = $Body | ConvertTo-Json -Depth 99
      ContentType = 'application/json'
    }

    if ($PSCmdlet.ShouldProcess($CollectionUri)) {
      try {
        Write-Information "Creating 'Minimum number of reviewers' policy on $RepoName/$branch"
        $res = Invoke-RestMethod @params
        [PSCustomObject]@{
          CollectionUri               = $CollectionUri
          ProjectName                 = $ProjectName
          RepoName                    = $RepoName
          id                          = $res.id
          minimumApproverCount        = $res.settings.minimumApproverCount
          creatorVoteCounts           = $res.settings.creatorVoteCounts
          allowDownvotes              = $res.settings.allowDownvotes
          resetOnSourcePush           = $res.settings.resetOnSourcePush
          requireVoteOnLastIteration  = $res.settings.requireVoteOnLastIteration
          resetRejectionsOnSourcePush = $res.settings.resetRejectionsOnSourcePush
          blockLastPusherVote         = $res.settings.blockLastPusherVote
          requireVoteOnEachIteration  = $res.settings.requireVoteOnEachIteration
        }
      } catch {
        Write-Warning "Policy on $RepoName/$branch already exists. It is not possible to update policies"
      }
    } else {
      $Body | Format-List
    }

  }
}
