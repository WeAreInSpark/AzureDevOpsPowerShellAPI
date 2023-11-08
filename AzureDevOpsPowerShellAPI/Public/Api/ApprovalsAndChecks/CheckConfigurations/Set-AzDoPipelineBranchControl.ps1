function Set-AzDoPipelineBranchControl {
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

    # Project where the pipeline will be created.
    [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
    [string]
    $ProjectName,

    # PAT to authentice with the organization
    [Parameter()]
    [string]
    $PAT,

    # Name of the Build Validation policy. Default is the name of the Build Definition
    [Parameter()]
    [string]
    $PolicyName = "Branch Control",

    # Valid duration of the Build Validation policy. Default is 720 minutes
    [Parameter(Mandatory)]
    [string]
    [ValidateSet("environment", "variablegroup", "repository")]
    $ResourceType,

    # Valid duration of the Build Validation policy. Default is 720 minutes
    [Parameter(Mandatory)]
    [string[]]
    $ResourceName,

    # Valid duration of the Build Validation policy. Default is 720 minutes
    [Parameter()]
    [string]
    $AllowUnknownStatusBranches = "false",

    # Valid duration of the Build Validation policy. Default is 720 minutes
    [Parameter()]
    [string]
    $AllowedBranches = "refs/head/main",

    # Valid duration of the Build Validation policy. Default is 720 minutes
    [Parameter()]
    [string]
    [validateset("true", "false")]
    $EnsureProtectionOfBranch = "true",

    # Valid duration of the Build Validation policy. Default is 720 minutes
    [Parameter()]
    [int]
    $Timeout = 1440
  )

  begin {
    $body = New-Object -TypeName "System.Collections.ArrayList"
  }

  Process {
    $projectId = (Get-AzDoproject -CollectionUri $CollectionUri -ProjectName $ProjectName -PAT $PAT).projectId

    foreach ($name in $ResourceName) {

      switch ($ResourceType) {
        "environment" {
          $resourceId = (Get-AzDoEnvironment -CollectionUri $CollectionUri -ProjectName $ProjectName -PAT $PAT -EnvironmentName $name).id
        }
        "variablegroup" {
          $resourceId = (Get-AzDoVariableGroup -CollectionUri $CollectionUri -ProjectName $ProjectName -PAT $PAT -Name $name).id
        }
        "repository" {
          $repoId = (Get-AzDoRepo -CollectionUri $CollectionUri -ProjectName $ProjectName -PAT $PAT -Name $name).id
          $resourceId = "$($projectId).$($repoId)"
        }
        Default {}
      }

      #TODO: Check if policy already exists

      $body = @{
        type     = @{
          name = "Task Check"
          id   = "fe1de3ee-a436-41b4-bb20-f6eb4cb879a7"
        }
        settings = @{
          displayName   = $PolicyName
          definitionRef = @{
            id      = "86b05a0c-73e6-4f7d-b3cf-e38f3b39a75b"
            name    = "evaluatebranchProtection"
            version = "0.0.1"
          }
          inputs        = @{
            allowUnknownStatusBranches = $AllowUnknownStatusBranches
            allowedBranches            = $AllowedBranches
            ensureProtectionOfBranch   = $EnsureProtectionOfBranch
          }
        }
        timeout  = $Timeout
        resource = @{
          type = $ResourceType
          id   = $resourceId
        }
      }

      $params = @{
        uri     = "$CollectionUri/$projectId/_apis/pipelines/checks/configurations"
        version = "7.2-preview.1"
        Method  = "POST"
        body    = $body | ConvertTo-Json -Depth 99
      }

      if ($PSCmdlet.ShouldProcess($ProjectName, "Create envrironment named: $($PSStyle.Bold)$PolicyName$($PSStyle.Reset)")) {
        Invoke-AzDoRestMethod @params | ForEach-Object {
          [PSCustomObject]@{
            CollectionUri = $CollectionUri
            ProjectName   = $ProjectName
            Id            = $_.id
          }
        }
      } else {
        $Body | Format-List
      }
    }
  }
}
