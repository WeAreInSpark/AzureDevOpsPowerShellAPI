function Add-AzDoPipelineBranchControl {
  <#
.SYNOPSIS
    Creates a Build Validation policy on a branch
.DESCRIPTION
    Creates a Build Validation policy on a branch
.EXAMPLE
    $params = @{
        CollectionUri = "https://dev.azure.com/contoso"
        ProjectName   = "Project 1"
        ResourceType  = "environment"
        ResourceName  = "MyEnvironment"
    }
    Add-AzDoPipelineBranchControl @params

    Default usage
.EXAMPLE
    $params = @{
        CollectionUri            = "https://dev.azure.com/contoso"
        ProjectName              = "Project 1"
        ResourceType             = "repository"
        ResourceName             = "MyRepo"
        AllowedBranches          = "refs/heads/main,refs/heads/develop"
        EnsureProtectionOfBranch = "true"
    }
    Add-AzDoPipelineBranchControl @params

    Add allowed branches and ensure branch protection
.OUTPUTS
    [PSCustomObject]@{
      CollectionUri = $CollectionUri
      ProjectName   = $ProjectName
      CheckId            = $_.id
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

    # Name of the Build Validation policy. Default is the name of the Build Definition
    [Parameter()]
    [string]
    $PolicyName = "Branch Control",

    # The type of Azure DevOps resource to be protected by a build validation policy
    [Parameter(Mandatory)]
    [string]
    [ValidateSet("environment", "variablegroup", "repository")]
    $ResourceType,

    # Name of the resource to be protected by a build validation policy
    [Parameter(Mandatory)]
    [string[]]
    $ResourceName,

    # Allow deployment from branches for which protection status could not be obtained.
    [Parameter()]
    [string]
    $AllowUnknownStatusBranches = "false",

    # Setup a comma separated list of branches from which a pipeline must be run to access this resource
    [Parameter()]
    [string]
    $AllowedBranches = "refs/head/main",

    # Validate the branches being deployed are protected.
    [Parameter()]
    [string]
    [validateset("true", "false")]
    $EnsureProtectionOfBranch = "true",

    # Valid duration of the Build Validation policy. Default is 1440 minutes
    [Parameter()]
    [int]
    $Timeout = 1440
  )
  process {
    Write-Verbose "Starting function: Add-AzDoPipelineBranchControl"

    foreach ($name in $ResourceName) {

      switch ($ResourceType) {
        "environment" {
          $resourceId = (Get-AzDoEnvironment -CollectionUri $CollectionUri -ProjectName $ProjectName -EnvironmentName $name).EnvironmentId
        }
        "variablegroup" {
          $resourceId = (Get-AzDoVariableGroup -CollectionUri $CollectionUri -ProjectName $ProjectName -VariableGroupName $name).VariableGroupId
        }
        "repository" {
          $projectId = (Get-AzDoProject -CollectionUri $CollectionUri -ProjectName $ProjectName).projectId

          $repoId = (Get-AzDoRepo -CollectionUri $CollectionUri -ProjectName $ProjectName -RepoName $name).RepoId
          $resourceId = "$($projectId).$($repoId)"
        }
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
        uri     = "$CollectionUri/$ProjectName/_apis/pipelines/checks/configurations"
        version = "7.2-preview.1"
        Method  = "POST"
        body    = $body
      }

      if ($PSCmdlet.ShouldProcess($ProjectName, "Create build-validation policy named: $($PSStyle.Bold)$PolicyName$($PSStyle.Reset)")) {
        Invoke-AzDoRestMethod @params | ForEach-Object {
          [PSCustomObject]@{
            CollectionUri = $CollectionUri
            ProjectName   = $ProjectName
            CheckId       = $_.id
          }
        }
      } else {
        Write-Verbose "Calling Invoke-AzDoRestMethod with $($params| ConvertTo-Json -Depth 10)"
      }
    }
  }
}
