<#
.SYNOPSIS
Retrieves branch policy configurations of specified Azure DevOps projects.

.DESCRIPTION
The Get-AzDoPipelineBranchControl function retrieves branch policy configurations of specified Azure DevOps projects within a given collection URI.
It supports pipeline input for project names and collection URI.

.EXAMPLE
PS> Get-AzDoPipelineBranchControl -CollectionUri "https://dev.azure.com/organization" -ProjectName "Project1"

.EXAMPLE
PS> "Project1", "Project2" | Get-AzDoPipelineBranchControl -CollectionUri "https://dev.azure.com/organization"

.NOTES
This function requires the Validate-CollectionUri and Invoke-AzDoRestMethod helper functions to be defined in the scope.
#>
function Get-AzDoPipelineBranchControl {

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
      Version = "5.0-preview.1"
      Method  = 'GET'
    }
    if (-not([string]::IsNullOrEmpty(($queryString)))) {
      $params.QueryParameters = $queryString
    }
    if ($PSCmdlet.ShouldProcess($CollectionUri, "Get branch policies for project $ProjectName")) {
      $response = Invoke-AzDoRestMethod @params
    } else {
      Write-Verbose "Calling Invoke-AzDoRestMethod with $($params | ConvertTo-Json -Depth 10)"
    }
    if ($response) {
      $List = [System.Collections.Generic.List[Object]]::new()
      foreach ($property in $response.Value) {
        $Property | Add-Member -MemberType NoteProperty -Name "ProjectName" -Value $ProjectName
        $Property | Add-Member -MemberType NoteProperty -Name "CollectionURI" -Value $CollectionUri
        if ($RepositoryId) {
          $Property | Add-Member -MemberType NoteProperty -Name "RepositoryId" -Value $RepositoryId
        }
        if ($RefName) {
          $Property | Add-Member -MemberType NoteProperty -Name "RefName" -Value $RefName
        }
        if ($PolicyType) {
          $Property | Add-Member -MemberType NoteProperty -Name "PolicyType" -Value $PolicyType
        }
        $List.Add($Property)
      }
      $List
    }
  }
}
