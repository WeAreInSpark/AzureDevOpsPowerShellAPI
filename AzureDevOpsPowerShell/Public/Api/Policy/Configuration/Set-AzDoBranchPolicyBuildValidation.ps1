function Set-AzDoBranchPolicyBuildValidation {
  <#
.SYNOPSIS
    Creates a Build Validation policy on a branch
.DESCRIPTION
    Creates a Build Validation policy on a branch
.EXAMPLE
    $params = @{
        CollectionUri = "https://dev.azure.com/contoso"
        Name = "Policy 1"
        RepoName = "Repo 1"
        ProjectName = "Project 1"
        Id = 1
    }
    Set-AzDoBranchPolicyBuildValidation @params

    This example creates a policy with splatting parameters

.EXAMPLE
    $env:SYSTEM_ACCESSTOKEN = '***'
    New-AzDoPipeline -CollectionUri "https://dev.azure.com/contoso" -ProjectName "Project 1" -Name "Pipeline 1" -RepoName "Repo 1" -Path "main.yml"
    | Set-AzDoBranchPolicyBuildValidation

    This example creates a new Azure Pipeline and sets this pipeline as Build Validation policy on the main branch

.OUTPUTS
    [PSCustomObject]@{
      CollectionUri = $CollectionUri
      ProjectName   = $ProjectName
      RepoName      = $RepoName
      Id            = $result.id
      Url           = $result.url
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

    # Project where the branch policy build validation will be set up
    [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
    [string]
    $ProjectName,

    # Name of the Repository containing the YAML-sourcecode
    [Parameter(Mandatory, ValueFromPipelineByPropertyName, ValueFromPipeline)]
    [string]
    $RepoName,

    # Branch to create the policy on
    [Parameter()]
    [string]
    $Branch = "main",

    # Should the PR block if the pipeline fails
    [Parameter()]
    [bool]
    $Required = $true,

    # Id of the Build Definition (Pipeline)
    [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
    [int]
    $Id,

    # Name of the Build Validation policy. Default is the name of the Build Definition
    [Parameter(ValueFromPipelineByPropertyName)]
    [AllowNull()]
    [string]
    $Name,

    # Filename patterns to include in the Build Validation policy. Default is all files
    [Parameter()]
    [AllowNull()]
    [array]
    $FilenamePatterns,

    # Valid duration of the Build Validation policy. Default is 720 minutes
    [Parameter()]
    [int]
    $validDuration = 720
  )
  process {
    Write-Verbose "Starting function: Set-AzDoBranchPolicyBuildValidation"

    $params = @{
      uri     = "$CollectionUri/$ProjectName/_apis/policy/configurations"
      version = "7.2-preview.1"
      method  = 'POST'
    }

    $getAzDoBranchPolicyTypeSplat = @{
      CollectionUri = $CollectionUri
      ProjectName   = $ProjectName
      PolicyType    = "Build"
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
          buildDefinitionId       = $Id
          displayName             = $Name
          filenamePatterns        = $FilenamePatterns
          queueOnSourceUpdateOnly = $true
          manualQueueOnly         = $false
          validDuration           = $validDuration
          scope                   = @(
            @{
              repositoryId = $repoId
              refName      = "refs/heads/$branch"
              matchKind    = "exact"
            }
          )
        }
      }

      if ($PSCmdlet.ShouldProcess($ProjectName, "Create Branch policy named: $($PSStyle.Bold)$name$($PSStyle.Reset)")) {
        $getAzDoBranchPolicySplat = @{
          CollectionUri = $CollectionUri
          ProjectName   = $ProjectName
          ErrorAction   = 'SilentlyContinue'
        }

        $existingPolicy = Get-AzDoBranchPolicy @getAzDoBranchPolicySplat |
        Where-Object { ($_.type.id -eq $policyId) -and ($_.settings.scope.refName -eq "refs/heads/$branch") -and ($_.settings.scope.repositoryId -eq $repoId) -and ($_.settings.displayName -eq $name) }

        if ($null -eq $existingPolicy) {
          try {
          ($body | Invoke-AzDoRestMethod @params) | ForEach-Object {
              [PSCustomObject]@{
                CollectionUri = $CollectionUri
                ProjectName   = $ProjectName
                RepoName      = $RepoName
                PolicyId      = $_.id
                Url           = $_.url
              }
            }
          } catch {
            Write-Error "Failed to create policy on $name/$branch in repo '$name' in project '$projectName' Error: $_"
          }
        } else {
          Write-Warning "Policy on $name/$branch already exists. It is not possible to update policies"
        }
      } else {
        Write-Verbose "Calling Invoke-AzDoRestMethod with $($params| ConvertTo-Json -Depth 10)"
      }
    }
  }
}
