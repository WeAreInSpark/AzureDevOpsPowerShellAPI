function New-AzDoPipeline {
  <#
.SYNOPSIS
  Creates an Azure Pipeline
.DESCRIPTION
  Creates an Azure Pipeline in a given Azure Project based on a repo
.EXAMPLE
  $newAzDoPipelineSplat = @{
      CollectionUri = "https://dev.azure.com/contoso"
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
    [ValidateScript({ Validate-CollectionUri -CollectionUri $_ })]
    [string]
    $CollectionUri,

    # Project where the pipeline will be created.
    [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
    [string]
    $ProjectName,

    # Name of the Pipeline
    [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
    [string]
    $PipelineName,

    # Name of the Repository containing the YAML-sourcecode
    [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
    $RepoName,

    # Folder to put Azure Devops Pipeline in
    [Parameter(ValueFromPipelineByPropertyName)]
    $PipelineFolderPath = $null,

    # Path of the YAML-sourcecode in the Repository
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $Path = '/main.yaml'
  )

  begin {
    Write-Verbose "Starting function: New-AzDoPipeline"
  }

  process {
    $getAzDoRepoSplat = @{
      CollectionUri = $CollectionUri
      ProjectName   = $ProjectName
      RepoName      = $RepoName
    }

    Write-Debug "Calling Get-AzDoRepo with $($getAzDoRepoSplat| ConvertTo-Json -Depth 10)"
    $RepoId = (Get-AzDoRepo @getAzDoRepoSplat -ErrorAction Stop).RepoId

    $body = @{
      name          = $PipelineName
      folder        = $PipelineFolderPath
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
      uri     = "$CollectionUri/$ProjectName/_apis/pipelines"
      version = "7.1-preview.1"
      Method  = 'POST'
    }

    if ($PSCmdlet.ShouldProcess($ProjectName, "Create pipeline named: $($PSStyle.Bold)$PipelineName$($PSStyle.Reset)")) {
      try {
        $body | Invoke-AzDoRestMethod @params | ForEach-Object {
          [PSCustomObject]@{
            CollectionUri  = $CollectionUri
            ProjectName    = $ProjectName
            RepoName       = $RepoName
            PipelineName   = $_.name
            PipelineFolder = $_.folder
            PipelineUrl    = $_.url
            PipelineId     = $_.id
          }
        }
      } catch {
        if ($_ -match 'already exists for project') {
          Write-Warning "Pipeline $name already exists, trying to get it"
          $params.Method = 'GET'
          (Invoke-AzDoRestMethod @params).value | Where-Object { $_.name -eq $PipelineName } | ForEach-Object {
            [PSCustomObject]@{
              CollectionUri  = $CollectionUri
              ProjectName    = $ProjectName
              RepoName       = $RepoName
              PipelineName   = $_.name
              PipelineFolder = $_.folder
              PipelineUrl    = $_.url
              PipelineId     = $_.id
            }
          }
        } else {
          Write-AzDoError -message $_
        }
      }

    } else {
      Write-Verbose "Calling Invoke-AzDoRestMethod with $($params| ConvertTo-Json -Depth 10)"
    }
  }
}
