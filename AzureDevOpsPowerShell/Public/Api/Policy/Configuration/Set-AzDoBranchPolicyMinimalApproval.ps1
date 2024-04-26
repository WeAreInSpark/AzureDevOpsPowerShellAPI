function Set-AzDoBranchPolicyMinimalApproval {
  <#
.SYNOPSIS
    Creates a Minimal approval policy on a branch
.DESCRIPTION
    Creates a Minimal approval policy on a branch
.EXAMPLE
    $params = @{
        CollectionUri = "https://dev.azure.com/contoso"
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
  [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
  param (
    # Collection Uri of the organization
    [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
    [ValidateScript({ Validate-CollectionUri -CollectionUri $_ })]
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
    $result = @()
    Write-Verbose "Starting function: Set-AzDoBranchPolicyMinimalApproval"
  }

  process {

    $params = @{
      uri     = "$CollectionUri/$ProjectName/_apis/policy/configurations"
      version = "7.2-preview.1"
      method  = 'POST'
    }

    $getAzDoBranchPolicyTypeSplat = @{
      CollectionUri = $CollectionUri
      ProjectName   = $ProjectName
      PolicyType    = "Minimum number of reviewers"
    }

    $policyId = (Get-AzDoBranchPolicyType @getAzDoBranchPolicyTypeSplat).policyId

    foreach ($name in $RepoName) {
      $getAzDoRepoSplat = @{
        CollectionUri = $CollectionUri
        ProjectName   = $ProjectName
        RepoName      = $name
      }

      $repoId = (Get-AzDoRepo @getAzDoRepoSplat).RepoId

      $body = @{
        isEnabled  = $true
        isBlocking = $true
        type       = @{
          id = $policyId
        }
        settings   = @{
          minimumApproverCount        = $minimumApproverCount
          creatorVoteCounts           = $creatorVoteCounts
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

      if ($PSCmdlet.ShouldProcess($ProjectName, "Create Minimal approval policy on: $($PSStyle.Bold)$name$($PSStyle.Reset)")) {
        $getAzDoBranchPolicySplat = @{
          CollectionUri = $CollectionUri
          ProjectName   = $ProjectName
          ErrorAction   = 'SilentlyContinue'
        }

        $existingPolicy = Get-AzDoBranchPolicy @getAzDoBranchPolicySplat |
          Where-Object { ($_.type.id -eq $policyId) -and ($_.settings.scope.refName -eq "refs/heads/$branch") -and ($_.settings.scope.repositoryId -eq $repoId) }

        if ($null -eq $existingPolicy) {
          $result += ($body | Invoke-AzDoRestMethod @params)
        } else {
          Write-Warning "Policy on $name/$branch already exists. It is not possible to update policies"
        }
      } else {
        Write-Verbose "Calling Invoke-AzDoRestMethod with $($params| ConvertTo-Json -Depth 10)"
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
          url           = $_.url
        }
      }
    }
  }
}
