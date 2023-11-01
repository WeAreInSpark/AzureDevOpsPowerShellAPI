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

    # Name of the Pipeline
    [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
    [string]
    $PipelineName,

    # Name of the Repository containing the YAML-sourcecode
    [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
    $RepoName,

    # Path of the YAML-sourcecode in the Repository
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $Path = '/main.yaml'
  )

  Begin {
    if (-not($script:header)) {

      try {
        New-ADOAuthHeader -PAT $PAT -ErrorAction Stop
      } catch {
        $PSCmdlet.ThrowTerminatingError($_)
      }
    }
  }

  Process {
    $getAzDoRepoSplat = @{
      ProjectName = $ProjectName
      RepoName    = $RepoName
      PAT         = $PAT
    }

    $RepoId = (Get-AzDoRepo @getAzDoRepoSplat).RepoId

    $Body = @{
      name          = $PipelineName
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
      Headers     = $header
      body        = $Body | ConvertTo-Json -Depth 99
      ContentType = 'application/json'
    }

    if ($PSCmdlet.ShouldProcess($ProjectName, "Create pipeline named: $($PSStyle.Bold)$Pipeline$($PSStyle.Reset)")) {
      Invoke-RestMethod @params | ForEach-Object {
        [PSCustomObject]@{
          PipelineName   = $_.name
          PipelineFolder = $_.folder
          PipelineUrl    = $_.url
        }
      }
    } else {
      $Body | Format-List
      return
    }
  }
}
