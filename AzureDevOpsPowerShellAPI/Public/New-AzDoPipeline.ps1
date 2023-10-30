function New-AzDoPipeline {
  <#
.SYNOPSIS
    Creates an Azure Pipeline
.DESCRIPTION
    Creates an Azure Pipeline in a given Azure Project based on a repo
.EXAMPLE
    $newAzDoPipelineSplat = @{
        CollectionUri = "https://dev.azure.com/contoso"
        PAT = "***"
        PipelineName = "Pipeline 1"
        RepoName = "Repo 1"
        ProjectName = "Project 1"
    }
    New-AzDoPipeline @newAzDoPipelineSplat

    This example creates a new Azure Pipeline using the PowerShell pipeline

.EXAMPLE
    Get-AzDoProject -CollectionUri "https://dev.azure.com/contoso" -PAT $PAT |
        Get-AzDoRepo -RepoName 'Repo 1' -PAT $PAT |
            New-AzDoPipeline -PipelineName "Pipeline 1" -PAT $PAT

    This example creates a new Azure Pipeline

.OUTPUTS
    PSobject. An object containing the name, the folder and the URI of the pipeline
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

    # PAT to authentice with the organization
    [Parameter()]
    [string]
    $PAT = $env:SYSTEM_ACCESSTOKEN,

    # Name of the Pipeline
    [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
    [string]
    $Name,

    # Name of the Repository containing the YAML-sourcecode
    [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
    $RepoName,

    # Path of the YAML-sourcecode in the Repository
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $Path = '/main.yaml'
  )
  Process {
    $RepoId = (Get-AzDoRepo -CollectionUri $CollectionUri -ProjectName $ProjectName -PAT $PAT -RepoName $RepoName).RepoId

    $Body = @{
      name          = $Name
      folder        = $null
      configuration = @{
        type       = "yaml"
        path       = $Path
        repository = @{
          id   = $RepoId
          type = "azureReposGit"
        }
      }
    }

    $params = @{
      uri         = "$CollectionUri/$ProjectName/_apis/pipelines?api-version=7.1-preview.1"
      Method      = 'POST'
      Headers     = @{Authorization = 'Basic ' + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$($PAT)")) }
      body        = $Body | ConvertTo-Json -Depth 99
      ContentType = 'application/json'
    }
    if ($PSCmdlet.ShouldProcess($CollectionUri)) {
      $result = Invoke-RestMethod @params
      [PSCustomObject]@{
        CollectionUri = $CollectionUri
        ProjectName   = $ProjectName
        RepoName      = $RepoName
        Name          = $result.name
        Id            = $result.id
      }
    } else {
      $Body | Format-List
      return
    }
  }
}

