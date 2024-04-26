function Set-AzDoBranchPolicyMergeStrategy {
  <#
.SYNOPSIS
    Creates a Merge strategy policy on a branch
.DESCRIPTION
    Creates a Merge strategy policy on a branch
.EXAMPLE
    $params = @{
        CollectionUri = "https://dev.azure.com/contoso"
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
  [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
  param (
    # Collection Uri of the organization
    [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
    [ValidateScript({ Validate-CollectionUri -CollectionUri $_ })]
    [string]
    $CollectionUri,

    # Project where the branch policy merge strategy will be setup
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
    Write-Verbose "Starting function: Set-AzDoBranchPolicyMergeStrategy"
  }

  process {

    $params = @{
      uri     = "$CollectionUri/$ProjectName/_apis/policy/configurations"
      version = "7.2-preview.1"
      Method  = 'POST'
    }

    $getAzDoBranchPolicyTypeSplat = @{
      CollectionUri = $CollectionUri
      ProjectName   = $ProjectName
      PolicyType    = "Require a merge strategy"
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

      if ($PSCmdlet.ShouldProcess($ProjectName, "Create Merge strategy policy on: $($PSStyle.Bold)$name$($PSStyle.Reset)")) {
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
          Url           = $_.url
        }
      }
    }
  }
}
