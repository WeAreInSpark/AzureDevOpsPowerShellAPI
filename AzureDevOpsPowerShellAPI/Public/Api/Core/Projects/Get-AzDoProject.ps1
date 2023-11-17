function Get-AzDoProject {
  <#
.SYNOPSIS
    Gets information about projects in Azure DevOps.
.DESCRIPTION
    Gets information about all the projects in Azure DevOps.
.EXAMPLE
    $Params = @{
        CollectionUri = "https://dev.azure.com/contoso"
        PAT = "***"
    }
    Get-AzDoProject @params

    This example will List all the projects contained in the collection ('https://dev.azure.com/contoso').

.EXAMPLE
    $Params = @{
        CollectionUri = "https://dev.azure.com/contoso"
        PAT = "***"
        ProjectName = 'Project1'
    }
    Get-AzDoProject @params

    This example will get the details of 'Project1' contained in the collection ('https://dev.azure.com/contoso').

.EXAMPLE
    $params = @{
        collectionuri = "https://dev.azure.com/contoso"
        PAT = "***"
    }
    $somedifferentobject = [PSCustomObject]@{
        ProjectName = 'Project1'
    }
    $somedifferentobject | Get-AzDoProject @params

    This example will get the details of 'Project1' contained in the collection ('https://dev.azure.com/contoso').

.EXAMPLE
    $params = @{
        collectionuri = "https://dev.azure.com/contoso"
        PAT = "***"
    }
    @(
        'Project1',
        'Project2'
    ) | Get-AzDoProject @params

    This example will get the details of 'Project1' contained in the collection ('https://dev.azure.com/contoso').
.OUTPUTS
    PSObject with repo(s).
.NOTES
#>
  [CmdletBinding()]
  param (
    # Collection Uri of the organization
    [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
    [string]
    $CollectionUri,

    # Project where the Repos are contained
    [Parameter(ValueFromPipelineByPropertyName, ValueFromPipeline)]
    [string[]]
    $ProjectName
  )

  Process {

    $params = @{
      uri     = "$CollectionUri/_apis/projects"
      version = "7.1-preview.4"
      method  = 'GET'
    }

    if ($PSCmdlet.ShouldProcess($CollectionUri, "Get Environments from: $($PSStyle.Bold)$ProjectName$($PSStyle.Reset)")) {
      $projects = (Invoke-AzDoRestMethod @params).value

      if ($ProjectName) {
        foreach ($name in $ProjectName) {
          $project = $projects | Where-Object { $_.name -eq $name }
          if (-not($project)) {
            Write-Warning "Project $name not found"
          } else {
            $result += $project
          }
        }
      } else {
        $result += $projects
      }

    } else {
      $body | Format-List
    }
  }

  end {
    if ($result) {
      $result | ForEach-Object {
        [PSCustomObject]@{
          CollectionURI     = $CollectionUri
          ProjectName       = $_.name
          ProjectID         = $_.id
          ProjectURL        = $_.url
          ProjectVisibility = $_.visibility
          State             = $_.state
        }
      }
    }
  }
}
