function Set-AzDoPullRequest {
  <#
.SYNOPSIS
  Retrieves pull request information from Azure DevOps.

.DESCRIPTION
  This function fetches pull request details using Azure DevOps REST API.

.PARAMETER CollectionUri
  The base URL of the Azure DevOps organization (e.g., https://dev.azure.com/my-org).

.PARAMETER ProjectName
  The name of the Azure DevOps project.

.PARAMETER RepositoryName
  The name of the repository (optional for project-wide pull request queries).

.PARAMETER PullRequestId
  The ID of a specific pull request (optional for listing all pull requests).

.PARAMETER Status
  The new status of the pull request. Allowed values: active, abandoned, completed.

.PARAMETER Title
  The new title for the pull request (max 256 characters).

.PARAMETER Description
  The new description for the pull request (max 4000 characters).

.PARAMETER CompletionOptions
  Specifies how the PR should be completed. Example: @{ deleteSourceBranch = $true; mergeCommitMessage = "Merged PR" }

.PARAMETER MergeOptions
  Specifies how the PR should be merged. Allowed values: noMerge, squash, rebase, rebaseMerge.

.PARAMETER AutoCompleteSetBy
  The Azure DevOps user ID who sets the PR to auto-complete.

.PARAMETER TargetRefName
  The new target branch for the pull request. Example: "main" (automatically prefixed with "refs/heads/").
  Retargeting a pull request means changing the destination branch where the pull request will be merged.

.EXAMPLE
  # Update only the title and description of a pull request
  Set-AzDoPullRequest -CollectionUri "https://dev.azure.com/my-org" -ProjectName "MyProject" -RepositoryName "Repo" -PullRequestId "123" -Title "Updated PR Title" -Description "New description"

.EXAMPLE
  # Set auto-complete with completion options
  $completionOptions = @{
    deleteSourceBranch = $true
    mergeCommitMessage = "Auto-merging PR"
  }
  Set-AzDoPullRequest -CollectionUri "https://dev.azure.com/my-org" -ProjectName "MyProject" -RepositoryName "Repo" -PullRequestId "123" -AutoCompleteSetBy "user-id-123" -CompletionOptions $completionOptions

.EXAMPLE
  # Change the merge strategy to squash and complete the PR
  Set-AzDoPullRequest -CollectionUri "https://dev.azure.com/my-org" -ProjectName "MyProject" -RepositoryName "Repo" -PullRequestId "123" -MergeOptions "squash" -Status "completed"

.EXAMPLE
  # Retarget a pull request to a different branch
  Set-AzDoPullRequest -CollectionUri "https://dev.azure.com/my-org" -ProjectName "MyProject" -RepositoryName "Repo" -PullRequestId "123" -TargetRefName "develop"

.EXAMPLE
  # Set auto-complete for a pull request with a transition work item option
  $completionOptions = @{
    transitionWorkItems = $true
    deleteSourceBranch = $true
  }
  Set-AzDoPullRequest -CollectionUri "https://dev.azure.com/my-org" -ProjectName "MyProject" -RepositoryName "Repo" -PullRequestId "123" -AutoCompleteSetBy "user-id-123" -CompletionOptions $completionOptions


.OUTPUTS
  PSCustomObject with pull request details.

.NOTES
  Requires authentication with Azure DevOps REST API.

  I have currently added the 'extra parameters' to the function,  that are registered in the first paragraph on this page:
  https://learn.microsoft.com/en-us/rest/api/azure/devops/git/pull-requests/update?view=azure-devops-rest-7.2&tabs=HTTP#request-body

  With the text currently being:
  These are the properties that can be updated with the API:
    Status
    Title
    Description (up to 4000 characters)
    CompletionOptions
    MergeOptions
    AutoCompleteSetBy.Id
    TargetRefName (when the PR retargeting feature is enabled) Attempting to update other properties outside of this list will either cause the server to throw an InvalidArgumentValueException, or to silently ignore the update.

.LINK
  https://learn.microsoft.com/en-us/rest/api/azure/devops/git/pull-requests/update?view=azure-devops-rest-7.2&tabs=HTTP#request-body
#>
  [CmdletBinding(SupportsShouldProcess)]
  param (
    [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
    [ValidateScript({ Validate-CollectionUri -CollectionUri $_ })]
    [string]
    $CollectionUri,

    [Parameter(Mandatory, ValueFromPipelineByPropertyName, ValueFromPipeline)]
    [string]
    $ProjectName,

    [Parameter(Mandatory, ValueFromPipelineByPropertyName, ValueFromPipeline)]
    [string]
    $RepositoryName,

    [Parameter(Mandatory, ValueFromPipelineByPropertyName, ValueFromPipeline)]
    [string]
    $PullRequestId,

    [Parameter( ValueFromPipelineByPropertyName, ValueFromPipeline)]
    [ValidateSet('active', 'abandoned', 'completed', 'all')]
    [string]
    $Status,

    [Parameter( ValueFromPipelineByPropertyName, ValueFromPipeline)]
    [ValidateLength(0, 256)]
    [string]
    $Title,

    [Parameter( ValueFromPipelineByPropertyName, ValueFromPipeline)]
    [ValidateLength(0, 4000)]
    [string]
    $Description,

    [Parameter( ValueFromPipelineByPropertyName, ValueFromPipeline)]
    [ValidateSet('setAutoComplete', 'setAutoCompleteSetBy')]
    [string]
    $CompletionOptions,

    [Parameter( ValueFromPipelineByPropertyName, ValueFromPipeline)]
    [ValidateSet('noMerge', 'squash', 'rebase', 'rebaseMerge')]
    [string]
    $MergeOptions,

    [Parameter( ValueFromPipelineByPropertyName, ValueFromPipeline)]
    [string]
    $AutoCompleteSetBy,

    [Parameter( ValueFromPipelineByPropertyName, ValueFromPipeline)]
    [string]
    $TargetRefName
  )

  begin {
    $result = @()
    Write-Verbose "Starting function: Set-AzDoPullRequest"
  }

  process {
    $uriBase = "$CollectionUri/$ProjectName/_apis/git"
    $apiVersion = "7.2-preview.2"

    $body = @{}

    if ($Status) { $body["status"] = $Status }
    if ($Title) { $body["title"] = $Title }
    if ($Description) { $body["description"] = $Description }
    if ($MergeOptions) { $body["mergeOptions"] = $MergeOptions }
    if ($TargetRefName) { $body["targetRefName"] = "refs/heads/$TargetRefName" }

    if ($CompletionOptions -and $CompletionOptions.Count -gt 0) {
      $body["completionOptions"] = $CompletionOptions
    }

    if ($AutoCompleteSetBy) {
      $body["autoCompleteSetBy"] = @{ id = $AutoCompleteSetBy }
    }

    if ($PSCmdlet.ShouldProcess($CollectionUri, "Get Pull Request from: $ProjectName")) {
      Write-Verbose "Calling API: $uri"

      $InvokeAzDoRestMethodSplat = @{
        Uri     = "$uriBase/repositories/$RepositoryName/pullrequests/$PullRequestId"
        Method  = "PATCH"
        Version = $apiVersion
        Body    = $Body
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
            CollectionUri = $CollectionUri
            ProjectName   = $ProjectName
            RepoName      = $RepoName
            PullRequest   = $PSItem
          }
        }
      }
    }
  }
}
