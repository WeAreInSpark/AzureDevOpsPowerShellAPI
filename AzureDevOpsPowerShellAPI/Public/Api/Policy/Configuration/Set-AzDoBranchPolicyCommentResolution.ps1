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
    $result = New-Object -TypeName "System.Collections.ArrayList"
  }

  process {

    $params = @{
      uri     = "$CollectionUri/$ProjectName/_apis/policy/configurations"
      version = "7.2-preview.1"
      method  = 'POST'
    }

    $policyId = (Get-AzDoBranchPolicyType -CollectionUri $CollectionUri -ProjectName $ProjectName -PolicyType "Comment requirements").policyId

    foreach ($name in $RepoName) {
      $repoId = (Get-AzDoRepo -CollectionUri $CollectionUri -ProjectName $ProjectName -RepoName $name).RepoId

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
        Write-Information "Creating 'Comment requirements' policy on $RepoName/$branch"
        $result.add(($body | Invoke-AzDoRestMethod @params))
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
