function New-AzDoEnvironment {
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
    [string]
    $CollectionUri,

    # Project where the pipeline will be created.
    [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
    [string]
    $ProjectName,

    # Name of the Build Validation policy. Default is the name of the Build Definition
    [Parameter(ValueFromPipelineByPropertyName, ValueFromPipeline)]
    [string[]]
    $EnvironmentName,

    # Valid duration of the Build Validation policy. Default is 720 minutes
    [Parameter()]
    [string]
    $Description
  )

  Begin {
    $result = @()
    Write-Verbose "Starting function: New-AzDoEnvironment"
  }

  Process {

    $params = @{
      uri     = "$CollectionUri/$ProjectName/_apis/pipelines/environments"
      version = "7.2-preview.1"
      method  = "POST"
    }

    foreach ($name in $EnvironmentName) {
      $body = @{
        name        = $name
        description = $Description
      }

      if ($PSCmdlet.ShouldProcess($ProjectName, "Create environment named: $($PSStyle.Bold)$name$($PSStyle.Reset)")) {
        try {
          $result += ($body | Invoke-AzDoRestMethod @params)
        } catch {
          if ($_ -match 'exists in current project') {
            Write-Warning "Environment $name already exists, trying to get it"
            $params.Method = 'GET'
            $result += (Invoke-AzDoRestMethod @params).value | Where-Object { $_.name -eq $name }
          } else {
            Write-AzDoError -message $_
          }
        }
      } else {
        Write-Verbose "Calling Invoke-AzDoRestMethod with $($params| ConvertTo-Json -Depth 10)"
      }
    }
  }

  End {
    if ($result) {
      $result | ForEach-Object {
        [PSCustomObject]@{
          CollectionUri   = $CollectionUri
          ProjectName     = $ProjectName
          EnvironmentName = $_.name
          Id              = $_.id
        }
      }
    }
  }
}
