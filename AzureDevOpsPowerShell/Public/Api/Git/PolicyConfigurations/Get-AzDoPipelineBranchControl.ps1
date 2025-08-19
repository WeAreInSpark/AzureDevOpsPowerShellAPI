function Get-AzDoPipelineBranchControl {
  <#
.SYNOPSIS
Retrieves branch policy configurations of specified Azure DevOps projects.

.DESCRIPTION
The Get-AzDoPipelineBranchControl function retrieves branch policy configurations of specified Azure DevOps projects within a given collection URI.
It supports pipeline input for project names and collection URI.

.EXAMPLE
$Params = @{
    CollectionUri = "https://dev.azure.com/organization"
    ProjectName   = "Project1"
}
Get-AzDoPipelineBranchControl @Params

This example retrieves branch policy configurations for the project named "Project1" in the specified Azure DevOps organization.

.EXAMPLE
$Params = @{
    CollectionUri = "https://dev.azure.com/organization"
}
"Project1", "Project2" | Get-AzDoPipelineBranchControl @Params

This example retrieves branch policy configurations for multiple projects ("Project1" and "Project2") in the specified Azure DevOps organization.

.EXAMPLE
$Params = @{
    CollectionUri  = "https://dev.azure.com/organization"
    ProjectName    = "Project1"
    RepositoryId   = "12345"
    RefName        = "refs/heads/main"
    PolicyType     = "Build"
}
Get-AzDoPipelineBranchControl @Params

This example retrieves branch policy configurations for the "main" branch in the repository with ID "12345" in the project "Project1" in the specified Azure DevOps organization, filtered by the "Build" policy type.

.NOTES
This function requires the Validate-CollectionUri and Invoke-AzDoRestMethod helper functions to be defined in the scope.

.LINK
https://learn.microsoft.com/en-us/rest/api/azure/devops/git/policy-configurations/list?view=azure-devops-rest-5.0#policyconfiguration
#>
  [CmdletBinding(SupportsShouldProcess)]
  param (
    # Collection URI of the organization
    [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
    [ValidateScript({ Validate-CollectionUri -CollectionUri $_ })]
    [string]
    $CollectionUri,

    # Project where the policies are defined
    [Parameter(ValueFromPipelineByPropertyName, ValueFromPipeline)]
    [string]
    $ProjectName,

    # Repository ID (optional)
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $RepositoryId,

    # Ref name (branch) to filter policies (optional)
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $RefName,

    # Policy type to filter results (optional)
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $PolicyType
  )

  begin {
    Write-Verbose "Starting function: Get-AzDoPipelineBranchControl"
  }

  process {
    # somehow it will not work on project name, but will work like this:
    $ProjectId = (Get-AzDoProject -CollectionUri $CollectionUri -ProjectName $ProjectName).ProjectID

    $queryParams = @()
    if ($RepositoryId) {
      $queryParams += "repositoryId=$RepositoryId"
    }
    if ($RefName) {
      $queryParams += "refName=$RefName"
    }
    if ($PolicyType) {
      $queryParams += "policyType=$PolicyType"
    }
    $queryString = $queryParams -join "&"

    $params = @{
      Uri     = "$CollectionUri/$ProjectId/_apis/git/policy/configurations"
      Version = "7.1"
      Method  = 'GET'
    }
    if (-not([string]::IsNullOrEmpty(($queryString)))) {
      $params.QueryParameters = $queryString
    }
    if ($PSCmdlet.ShouldProcess($CollectionUri, "Get branch policies for project $ProjectName")) {
      $result = (Invoke-AzDoRestMethod @params).value
    } else {
      Write-Verbose "Calling Invoke-AzDoRestMethod with $($params | ConvertTo-Json -Depth 10)"
    }
    if ($result) {

      $result | ForEach-Object {
        [PSCustomObject]@{
          CollectionUri = $CollectionUri
          ProjectName   = $ProjectName
          IsEnabled     = $_.isEnabled
          IsBlocking    = $_.isBlocking
          Settings      = $_.settings
          PolicyId      = $_.id
          PolicyUrl     = $_.url
          PolicyType    = $_.PolicyTypeRef
          CreatedBy     = $_.createdBy
          CreatedDate   = $_.createdDate
        }
      }
    }
  }
}
