function Get-AzDoEnvironment {
  <#
.SYNOPSIS
    Creates a Build Validation policy on a branch
.DESCRIPTION
    Creates a Build Validation policy on a branch

.EXAMPLE
    $Params = @{
        CollectionUri = "https://dev.azure.com/contoso"
        ProjectName   = "Project 1"
    }
    Get-AzDoEnvironment @Params

    This example retrieves all environments in the specified project ("Project 1") in Azure DevOps.

.EXAMPLE
    $Params = @{
        CollectionUri   = "https://dev.azure.com/contoso"
        ProjectName     = "Project 1"
        EnvironmentName = "Environment 1"
    }
    Get-AzDoEnvironment @Params

    This example retrieves details of the environment named "Environment 1" in the specified project ("Project 1") in Azure DevOps.

.EXAMPLE
    $Params = @{
        CollectionUri   = "https://dev.azure.com/contoso"
        ProjectName     = "Project 1"
        EnvironmentName = @("Environment 1", "Environment 2")
    }
    Get-AzDoEnvironment @Params

    This example retrieves details of multiple environments ("Environment 1" and "Environment 2") in the specified project ("Project 1") in Azure DevOps.

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
    [ValidateScript({ Validate-CollectionUri -CollectionUri $_ })]
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
