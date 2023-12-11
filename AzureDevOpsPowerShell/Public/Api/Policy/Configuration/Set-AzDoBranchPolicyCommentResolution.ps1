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
  [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
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

    # Block pull requests until the comments are resolved
    [Parameter()]
    [bool]
    $Required = $true
  )

  begin {
    Write-Verbose "Starting function: Set-AzDoBranchPolicyBuildValidation"
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
      PolicyType    = "Comment requirements"
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

      if ($PSCmdlet.ShouldProcess($ProjectName, "Create Branch policy named: $($PSStyle.Bold)$name$($PSStyle.Reset)")) {
        $result += ($body | Invoke-AzDoRestMethod @params)
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
