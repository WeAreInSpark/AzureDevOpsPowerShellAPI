<#
.SYNOPSIS
Retrieves properties of specified Azure DevOps projects.

.DESCRIPTION
The Get-AzDoProjectProperties function retrieves properties of specified Azure DevOps projects within a given collection URI. It supports pipeline input for project names and collection URI.

.EXAMPLE
PS> Get-AzDoProjectProperties -CollectionUri "https://dev.azure.com/organization" -ProjectName "Project1"

.EXAMPLE
PS> "Project1", "Project2" | Get-AzDoProjectProperties -CollectionUri "https://dev.azure.com/organization"

.NOTES
This function requires the Validate-CollectionUri and Invoke-AzDoRestMethod helper functions to be defined in the scope.
#>
function Get-AzDoProjectProperties {

  [CmdletBinding(SupportsShouldProcess)]
  param (
    # Collection Uri of the organization
    [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
    [ValidateScript({ Validate-CollectionUri -CollectionUri $_ })]
    [string]
    $CollectionUri,

    # Project where the Repos are contained
    [Parameter(ValueFromPipelineByPropertyName, ValueFromPipeline)]
    [string]
    $ProjectName
  )

  begin {
    Write-Verbose "Starting function: Get-AzDoProjectProperties"
  }

  process {
    # somehow it will not work on project name, but will work like this:
    $ProjectId = (Get-AzDoProject -CollectionUri $CollectionUri -ProjectName $ProjectName).ProjectID
    $params = @{
      uri     = "$CollectionUri/_apis/projects/$ProjectId/Properties"
      version = "7.2-preview.1"
      method  = 'GET'
    }

    if ($PSCmdlet.ShouldProcess($CollectionUri, "Get project $ProjectName properties")) {
      $result = Invoke-AzDoRestMethod @params
    } else {
      Write-Verbose "Calling Invoke-AzDoRestMethod with $($params| ConvertTo-Json -Depth 10)"
    }

    if ($result) {
      $HashTable = @{
        CollectionURI = $CollectionUri
        ProjectName   = $ProjectName
      }
      foreach ($property in $result.value) {
        $HashTable[$property.Name] = $property.Value
      }
      [PSCustomObject]$HashTable
    }
  }
}
