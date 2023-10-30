function Remove-AzDoProject {
  <#
    .SYNOPSIS
        Function to create an Azure DevOps project
    .DESCRIPTION
        Function to create an Azure DevOps project
    .EXAMPLE
        New-AzDoProject -CollectionUri "https://dev.azure.com/contoso" -PAT "***" -ProjectName "Project 1"

        This example creates a new private Azure DevOps project
    .EXAMPLE
        New-AzDoProject -CollectionUri "https://dev.azure.com/contoso" -PAT "***" -ProjectName "Project 1" -Visibility 'public'

        This example creates a new public Azure DevOps project
    .EXAMPLE
        @("MyProject1","Myproject2") | New-AzDoProject -CollectionUri "https://dev.azure.com/contoso" -PAT "***"

        This example creates two new Azure DevOps projects using the pipeline.

    .EXAMPLE
        [pscustomobject]@{
            ProjectName     = 'Project 1'
            Visibility      = 'public'
            Description     = 'This is the best project'
        },
        [pscustomobject]@{
            ProjectName     = 'Project 1'
            Description     = 'This is the best project'
        } | New-AzDoProject -PAT $PAT -CollectionUri $CollectionUri

        This example creates two new Azure DevOps projects using the pipeline.
    #>
  [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
  param (
    # Collection URI. e.g. https://dev.azure.com/contoso.
    # Azure Pipelines has a predefined variable for this.
    [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
    [string]
    $CollectionUri,

    # PAT to get access to Azure DevOps.
    [Parameter()]
    [string]
    $PAT = $env:SYSTEM_ACCESSTOKEN,

    # Switch to use PAT instead of OAuth
    [Parameter()]
    [switch]
    $UsePAT = $false,

    # Name of the project.
    [Parameter(Mandatory, ValueFromPipelineByPropertyName, ValueFromPipeline)]
    [string[]]
    $ProjectName
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

    $getAzDoProjectSplat = @{
      CollectionUri = $CollectionUri
    }
    if ($PAT) {
      $getAzDoProjectSplat += @{
        PAT    = $PAT
        UsePAT = $true
      }
    }

    $projects = Get-AzDoProject @getAzDoProjectSplat
  }
  Process {
    foreach ($name in $ProjectName) {
      $project = $projects | Where-Object -Property ProjectName -EQ -Value $name

      $params = @{
        uri         = "$CollectionUri/_apis/projects/$($project.ProjectID)?api-version=6.0"
        Method      = 'DELETE'
        Headers     = $Header
        ContentType = 'application/json'
        ErrorAction = 'Stop'
      }
      if ($PSCmdlet.ShouldProcess($project.ProjectName, "Remove Azure DevOps Project")) {
        Write-Verbose "Trying to remove the project"
        try {
                    (Invoke-RestMethod @params | Out-Null)
        } catch {
          $message = $_
          Write-Error "Failed to create the project [$name]"
          Write-Error $message.ErrorDetails.Message
          continue
        }
      }
    }
  }
}
