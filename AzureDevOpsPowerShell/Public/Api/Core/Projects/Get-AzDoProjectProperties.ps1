function Get-AzDoProjectProperties {
  <#
.SYNOPSIS
Retrieves properties of specified Azure DevOps projects.

.DESCRIPTION
The Get-AzDoProjectProperties function retrieves properties of specified Azure DevOps projects within a given collection URI. It supports pipeline input for project names and collection URI.

.EXAMPLE
$Params = @{
    CollectionUri = "https://dev.azure.com/organization"
    ProjectName   = "Project1"
}
Get-AzDoProjectProperties @Params

This example retrieves properties of the project named "Project1" in the specified Azure DevOps organization.

.EXAMPLE
$Params = @{
    CollectionUri = "https://dev.azure.com/organization"
}
"Project1", "Project2" | Get-AzDoProjectProperties @Params

This example retrieves properties of multiple projects ("Project1" and "Project2") in the specified Azure DevOps organization.

.NOTES
This function requires the Validate-CollectionUri and Invoke-AzDoRestMethod helper functions to be defined in the scope.

.LINK
https://learn.microsoft.com/en-us/rest/api/azure/devops/core/projects/get-project-properties?view=azure-devops-rest-7.1&tabs=HTTP
#>
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
      $result = (Invoke-AzDoRestMethod @params).value
    } else {
      Write-Verbose "Calling Invoke-AzDoRestMethod with $($params| ConvertTo-Json -Depth 10)"
    }

    if ($result) {
      [PSCustomObject]@{
        CollectionURI = $CollectionUri
        ProjectName   = $ProjectName
        Properties    = $result
      }
    }
  }
}
