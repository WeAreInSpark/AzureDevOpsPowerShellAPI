function Get-AzDoProject {
  <#
.SYNOPSIS
    Gets information about projects in Azure DevOps.
.DESCRIPTION
    Gets information about all the projects in Azure DevOps.
.EXAMPLE
    $Params = @{
        CollectionUri = "https://dev.azure.com/contoso"
    }
    Get-AzDoProject @params

    This example will List all the projects contained in the collection ('https://dev.azure.com/contoso').

.EXAMPLE
    $Params = @{
        CollectionUri = "https://dev.azure.com/contoso"
        ProjectName = 'Project1'
    }
    Get-AzDoProject @params

    This example will get the details of 'Project1' contained in the collection ('https://dev.azure.com/contoso').

.EXAMPLE
    $params = @{
        collectionuri = "https://dev.azure.com/contoso"
    }
    $somedifferentobject = [PSCustomObject]@{
        ProjectName = 'Project1'
    }
    $somedifferentobject | Get-AzDoProject @params

    This example will get the details of 'Project1' contained in the collection ('https://dev.azure.com/contoso').

.EXAMPLE
    $params = @{
        collectionuri = "https://dev.azure.com/contoso"
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
  [CmdletBinding(SupportsShouldProcess)]
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

  begin {
    Write-Verbose "Starting function: Get-AzDoProject"
  }

  process {

    $params = @{
      uri     = "$CollectionUri/_apis/projects"
      version = "7.1-preview.4"
      method  = 'GET'
    }

    if ($PSCmdlet.ShouldProcess($CollectionUri, "Get Project(s)")) {
      $result = (Invoke-AzDoRestMethod @params).value | Where-Object { -not $ProjectName -or $_.Name -in $ProjectName }
    } else {
      Write-Verbose "Calling Invoke-AzDoRestMethod with $($params| ConvertTo-Json -Depth 10)"
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

