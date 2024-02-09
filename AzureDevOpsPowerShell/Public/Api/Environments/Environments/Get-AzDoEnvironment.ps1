function Get-AzDoEnvironment {
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

    # Name of the Build Validation policy. Default is the name of the Build Definition
    [Parameter(ValueFromPipelineByPropertyName, ValueFromPipeline)]
    [string[]]
    $EnvironmentName
  )

  begin {
    $result = @()
    Write-Verbose "Starting function: Get-AzDoEnvironment"
  }

  process {

    $params = @{
      uri     = "$CollectionUri/$ProjectName/_apis/pipelines/environments"
      version = "7.2-preview.1"
      Method  = "GET"
    }

    if ($PSCmdlet.ShouldProcess($CollectionUri, "Get Environments from: $($PSStyle.Bold)$ProjectName$($PSStyle.Reset)")) {
      $result += (Invoke-AzDoRestMethod @params).value | Where-Object { -not $EnvironmentName -or $_.Name -in $EnvironmentName }
    } else {
      Write-Verbose "Calling Invoke-AzDoRestMethod with $($params| ConvertTo-Json -Depth 10)"
    }
  }

  end {
    if ($result) {
      $result | ForEach-Object {
        [PSCustomObject]@{
          CollectionUri   = $CollectionUri
          ProjectName     = $ProjectName
          EnvironmentId   = $_.id
          EnvironmentName = $_.name
        }
      }
    }
  }
}
