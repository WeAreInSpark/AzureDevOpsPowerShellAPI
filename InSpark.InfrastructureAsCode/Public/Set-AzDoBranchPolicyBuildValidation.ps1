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
    PSobject. An object containing the name, the folder and the URI of the pipeline
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

    [Parameter()]
    [bool]
    $Required = $true,

    # Id of the Build Definition (Pipeline)
    [Parameter(Mandatory, ValueFromPipelineByPropertyName, ValueFromPipeline)]
    [int]
    $Id,

    # Name of the Build Validation policy. Default is the name of the Build Definition
    [Parameter(ValueFromPipelineByPropertyName, ValueFromPipeline)]
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

  Process {
    Write-Debug "CollectionUri: $CollectionUri"
    Write-Debug "ProjectName: $ProjectName"
    Write-Debug "RepoName: $RepoName"
    Write-Debug "branch: $branch"
    Write-Debug "Required: $Required"
    Write-Debug "BuildDefinitionId: $Id"
    Write-Debug "Name: $Name"

    try {
      $policyId = Get-BranchPolicyType -CollectionUri $CollectionUri -ProjectName $ProjectName -PAT $PAT -PolicyType "Build"
      Write-Debug "PolicyId: $policyId"
    } catch {
      throw $_.Exception.Message
    }

    try {
      $repoId = (Get-AzDoRepo -CollectionUri $CollectionUri -ProjectName $ProjectName -PAT $PAT -RepoName $RepoName).RepoId
      Write-Debug "RepoId: $repoId"
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

    $params = @{
      uri         = "$CollectionUri/$ProjectName/_apis/policy/configurations?api-version=7.2-preview.1"
      Method      = 'POST'
      Headers     = @{Authorization = 'Basic ' + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$($PAT)")) }
      body        = $Body | ConvertTo-Json -Depth 99
      ContentType = 'application/json'
    }

    if ($PSCmdlet.ShouldProcess($CollectionUri)) {
      $existingPolicy = Get-BranchPolicy -CollectionUri $CollectionUri -ProjectName $ProjectName -PAT $PAT -ErrorAction SilentlyContinue |
        Where-Object { ($_.type.id -eq $policyId) -and ($_.settings.scope.refName -eq "refs/heads/$branch") -and ($_.settings.scope.repositoryId -eq $repoId) -and ($_.settings.displayName -eq $name) }

      if ($null -eq $existingPolicy) {
        try {
          Write-Information "Creating 'Build' policy on $RepoName/$branch"
          $result = Invoke-RestMethod @params | Select-Object createdDate, settings, id, url
          [PSCustomObject]@{
            CollectionUri = $CollectionUri
            ProjectName   = $ProjectName
            RepoName      = $RepoName
            Id            = $result.id
            Url           = $result.url
          }
        } catch {
          $body | Format-List
          throw $_.Exception
        }
      } else {
        Write-Error "Policy on $RepoName/$branch already exists. It is not possible to update policies"
      }
    } else {
      $Body | Format-List
    }

  }
}
