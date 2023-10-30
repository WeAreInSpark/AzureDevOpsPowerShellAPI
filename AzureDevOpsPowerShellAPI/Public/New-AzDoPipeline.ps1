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
    $PAT = $env:SYSTEM_ACCESSTOKEN,

    # Switch to use PAT instead of OAuth
    [Parameter()]
    [switch]
    $UsePAT = $false,

    # Name of the Pipeline
    [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
    [string]
    [string[]]
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
    if ($UsePAT) {
      Write-Verbose 'The [UsePAT]-parameter was set to true, so the PAT will be used to authenticate with the organization.'
      if ($PAT -eq $env:SYSTEM_ACCESSTOKEN) {
        Write-Verbose -Message "Using the PAT from the environment variable 'SYSTEM_ACCESSTOKEN'."
      } elseif (-not [string]::IsNullOrWhitespace($PAT) -and $PSBoundParameters.ContainsKey('PAT')) {
        Write-Verbose -Message "Using a custom PAT supplied in the parameters."
      } else {
        try {
          throw "Requested to use a PAT, but no custom PAT was supplied in the parameters or the environment variable 'SYSTEM_ACCESSTOKEN' was not set."
        } catch {
          $PSCmdlet.ThrowTerminatingError($_)
        }
      }
    } else {
      Write-Verbose 'The [UsePAT]-parameter was set to false, so an OAuth will be used to authenticate with the organization.'
      $PAT = ($UsePAT ? $PAT : $null)
    }
    try {
      $Header = New-ADOAuthHeader -PAT $PAT -AccessToken:($UsePAT ? $false : $true) -ErrorAction Stop
    } catch {
      $PSCmdlet.ThrowTerminatingError($_)
    }
  }
  Process {
    $getAzDoRepoSplat = @{
      ProjectName = $ProjectName
      RepoName    = $RepoName
    }
  
    if ($PAT) {
      $getAzDoRepoSplat += @{
      }        PAT = $PAT
    }
  }

  $RepoId = (Get-AzDoRepo @getAzDoRepoSplat).RepoId

  foreach ($Pipeline in $PipelineName) {
    $Body = @{
      name          = $Pipeline
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
}
}
