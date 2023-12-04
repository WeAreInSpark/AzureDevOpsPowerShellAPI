function Set-AzDoBranchPolicyBuildValidation {
  <#
.SYNOPSIS
    Creates a Build Validation policy on a branch
.DESCRIPTION
    Creates a Build Validation policy on a branch
.EXAMPLE
    $params = @{
        CollectionUri = "https://dev.azure.com/contoso"
        PAT = "***"
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

  begin {
    $result = New-Object -TypeName "System.Collections.ArrayList"
  }

  process {

    $params = @{
      uri     = "$CollectionUri/$ProjectName/_apis/policy/configurations"
      version = "7.2-preview.1"
      method  = 'POST'
    }

    $policyId = (Get-AzDoBranchPolicyType -CollectionUri $CollectionUri -ProjectName $ProjectName -PolicyType "Build").policyId

    foreach ($name in $RepoName) {
      $repoId = (Get-AzDoRepo -CollectionUri $CollectionUri -ProjectName $ProjectName -RepoName $name).RepoId

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
        $existingPolicy = Get-AzDoBranchPolicy -CollectionUri $CollectionUri -ProjectName $ProjectName -ErrorAction SilentlyContinue |
          Where-Object { ($_.type.id -eq $policyId) -and ($_.settings.scope.refName -eq "refs/heads/$branch") -and ($_.settings.scope.repositoryId -eq $repoId) -and ($_.settings.displayName -eq $name) }

        if ($null -eq $existingPolicy) {
          Write-Information "Creating 'Build' policy on $name/$branch"
          $result.add(($body | Invoke-AzDoRestMethod @params)) | Out-Null
        } else {
          Write-Error "Policy on $name/$branch already exists. It is not possible to update policies"
        }
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
