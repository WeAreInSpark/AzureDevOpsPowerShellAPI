function Get-AzDoPullRequest {
  <#
.SYNOPSIS
  Retrieves pull request information from Azure DevOps.

.DESCRIPTION
  This function fetches pull request details using Azure DevOps REST API.

.EXAMPLE
    $Params = @{
        CollectionUri = "https://dev.azure.com/my-org"
        ProjectName   = "MyProject"
    }
    Get-AzDoPullRequest @Params

    This example retrieves all pull requests for the specified project.

.EXAMPLE
    $Params = @{
        CollectionUri = "https://dev.azure.com/my-org"
        ProjectName   = "MyProject"
        RepositoryName = "RepositoryName"
    }
    Get-AzDoPullRequest @Params

    This example retrieves all pull requests for the specified repository in the project.

.EXAMPLE
    $Params = @{
        CollectionUri = "https://dev.azure.com/my-org"
        ProjectName   = "MyProject"
        RepositoryName = "RepositoryName"
        Query         = "searchCriteria.status=completed"
    }
    Get-AzDoPullRequest @Params

    This example retrieves all completed pull requests for the specified repository in the project.

.EXAMPLE
    $Params = @{
        CollectionUri = "https://dev.azure.com/my-org"
        ProjectName   = "MyProject"
        RepositoryName = "RepositoryName"
        PullRequestId = "6789"
    }
    Get-AzDoPullRequest @Params

    This example retrieves details of a specific pull request by its ID for the specified repository in the project.

.EXAMPLE
    $Params = @{
        CollectionUri = "https://dev.azure.com/my-org"
        ProjectName   = "MyProject"
        PullRequestId = "6789"
    }
    Get-AzDoPullRequest @Params

    This example retrieves details of a specific pull request by its ID for the specified project.

.OUTPUTS
  PSCustomObject with pull request details.

.NOTES
  Requires authentication with Azure DevOps REST API.

.LINK
  https://learn.microsoft.com/en-us/rest/api/azure/devops/git/pull-requests/get-pull-request?view=azure-devops-rest-7.2

.LINK
  https://learn.microsoft.com/en-us/rest/api/azure/devops/git/pull-requests/get-pull-request-by-id?view=azure-devops-rest-7.2

.LINK
  https://learn.microsoft.com/en-us/rest/api/azure/devops/git/pull-requests/get-pull-requests?view=azure-devops-rest-7.2

.LINK
  https://learn.microsoft.com/en-us/rest/api/azure/devops/git/pull-requests/get-pull-requests-by-project?view=azure-devops-rest-7.2
#>
  [CmdletBinding(DefaultParameterSetName = "AllProjectPullRequests", SupportsShouldProcess)]
  param (
    # The base URL of the Azure DevOps organization (e.g., https://dev.azure.com/my-org)
    [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = "RepoSpecificPullRequest")]
    [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = "ProjectSpecificPullRequest")]
    [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = "AllRepoPullRequests")]
    [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = "AllProjectPullRequests")]
    [ValidateScript({ Validate-CollectionUri -CollectionUri $_ })]
    [string]
    $CollectionUri,

    # The name of the Azure DevOps project.
    [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = "RepoSpecificPullRequest")]
    [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = "ProjectSpecificPullRequest")]
    [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = "AllRepoPullRequests")]
    [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = "AllProjectPullRequests")]
    [string]
    $ProjectName,

    # The name of the repository (optional for project-wide pull request queries).
    [Parameter(Mandatory, ValueFromPipeline, ParameterSetName = "RepoSpecificPullRequest")]
    [Parameter(Mandatory, ValueFromPipeline, ParameterSetName = "AllRepoPullRequests")]
    [string]
    $RepoName,

    # The ID of a specific pull request (optional for listing all pull requests).
    [Parameter(Mandatory, ValueFromPipeline, ParameterSetName = "RepoSpecificPullRequest")]
    [Parameter(Mandatory, ValueFromPipeline, ParameterSetName = "ProjectSpecificPullRequest")]
    [string]
    $PullRequestId,

    # A query string to filter the results (optional).
    [Parameter(ValueFromPipelineByPropertyName, ParameterSetName = "AllRepoPullRequests")]
    [string]
    $Query
  )

  begin {
    $result = @()
    Write-Verbose "Starting function: Get-AzDoPullRequest"
  }

  process {
    $uriBase = "$CollectionUri/$ProjectName/_apis/git"
    $apiVersion = "7.2-preview.2"
    $uri = ""

    switch ($PSCmdlet.ParameterSetName) {
      "RepoSpecificPullRequest" {
        $uri = "$uriBase/repositories/$RepoName/pullrequests/$PullRequestId"
      }
      "ProjectSpecificPullRequest" {
        $uri = "$uriBase/pullrequests/$PullRequestId"
      }
      "AllRepoPullRequests" {
        $uri = "$uriBase/repositories/$RepoName/pullrequests"
      }
      "AllProjectPullRequests" {
        $uri = "$uriBase/pullrequests"
      }
    }

    if ($PSCmdlet.ShouldProcess($CollectionUri, "Get Pull Request from: $ProjectName")) {
      Write-Verbose "Calling API: $uri"

      $InvokeAzDoRestMethodSplat = @{
        Uri     = $uri
        Method  = "GET"
        Version = $apiVersion
      }
      if (-not([string]::IsNullOrEmpty($Query))) {
        $InvokeAzDoRestMethodSplat.QueryParameters = $Query
      }
      $response = Invoke-AzDoRestMethod @InvokeAzDoRestMethodSplat
      if ($response.value) {
        $result += $response.value
      } else {
        $result += $response
      }
      if ($result) {
        $result | ForEach-Object {
          [PSCustomObject]@{
            CollectionUri          = $CollectionUri
            ProjectName            = $ProjectName
            RepoName               = $RepoName
            PullRequestTitle       = $_.Title
            PullRequestDescription = $_.Description
            CreatedDate            = $_.CreatedDate
            PullRequestStatus      = $_.Status
            SourceRefName          = $_.sourceRefName
            TargetRefName          = $_.targetRefName
            Reviewers              = $_.reviewers | ForEach-Object {
              [PSCustomObject]@{
                Id         = $_.id
                Name       = $_.name
                Vote       = $_.vote
                IsRequired = $_.isRequired
              }
            }
            PullRequestUrl         = $_.url
          }
        }
      }
    }
  }
}
