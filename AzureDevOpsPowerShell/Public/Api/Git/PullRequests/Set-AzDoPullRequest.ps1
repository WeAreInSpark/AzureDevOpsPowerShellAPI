function Set-AzDoPullRequest {
  <#
.SYNOPSIS
  Updates pull request details in Azure DevOps.

.DESCRIPTION
  This function updates pull request details using Azure DevOps REST API.

.EXAMPLE
    $Params = @{
        CollectionUri = "https://dev.azure.com/my-org"
        ProjectName   = "MyProject"
        RepositoryName = "Repo"
        PullRequestId = "123"
        Title         = "Updated PR Title"
        Description   = "New description"
    }
    Set-AzDoPullRequest @Params

    This example updates only the title and description of a pull request.

.EXAMPLE
    $completionOptions = @{
        deleteSourceBranch = $true
        mergeCommitMessage = "Auto-merging PR"
    }
    $Params = @{
        CollectionUri      = "https://dev.azure.com/my-org"
        ProjectName        = "MyProject"
        RepositoryName     = "Repo"
        PullRequestId      = "123"
        AutoCompleteSetBy  = "user-id-123"
        CompletionOptions  = $completionOptions
    }
    Set-AzDoPullRequest @Params

    This example sets auto-complete for a pull request with completion options.

.EXAMPLE
    $Params = @{
        CollectionUri  = "https://dev.azure.com/my-org"
        ProjectName    = "MyProject"
        RepositoryName = "Repo"
        PullRequestId  = "123"
        MergeOptions   = "squash"
        Status         = "completed"
    }
    Set-AzDoPullRequest @Params

    This example changes the merge strategy to squash and completes the pull request.

.EXAMPLE
    $Params = @{
        CollectionUri  = "https://dev.azure.com/my-org"
        ProjectName    = "MyProject"
        RepositoryName = "Repo"
        PullRequestId  = "123"
        TargetRefName  = "develop"
    }
    Set-AzDoPullRequest @Params

    This example retargets a pull request to a different branch.

.EXAMPLE
    $completionOptions = @{
        transitionWorkItems = $true
        deleteSourceBranch  = $true
    }
    $Params = @{
        CollectionUri      = "https://dev.azure.com/my-org"
        ProjectName        = "MyProject"
        RepositoryName     = "Repo"
        PullRequestId      = "123"
        AutoCompleteSetBy  = "user-id-123"
        CompletionOptions  = $completionOptions
    }
    Set-AzDoPullRequest @Params

    This example sets auto-complete for a pull request with a transition work item option.

.OUTPUTS
  PSCustomObject with pull request details.

.NOTES
  Requires authentication with Azure DevOps REST API.
#>
  [CmdletBinding(SupportsShouldProcess)]
  param (
    # The base URL of the Azure DevOps organization (e.g., https://dev.azure.com/my-org).
    [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
    [ValidateScript({ Validate-CollectionUri -CollectionUri $_ })]
    [string]
    $CollectionUri,

    # The name of the Azure DevOps project.
    [Parameter(Mandatory, ValueFromPipelineByPropertyName, ValueFromPipeline)]
    [string]
    $ProjectName,

    # The name of the repository (optional for project-wide pull request queries).
    [Parameter(Mandatory, ValueFromPipelineByPropertyName, ValueFromPipeline)]
    [string]
    $RepositoryName,

    # The ID of a specific pull request (optional for listing all pull requests).
    [Parameter(Mandatory, ValueFromPipelineByPropertyName, ValueFromPipeline)]
    [string]
    $PullRequestId,

    # The new status of the pull request. Allowed values: active, abandoned, completed.
    [Parameter(ValueFromPipelineByPropertyName, ValueFromPipeline)]
    [ValidateSet('active', 'abandoned', 'completed', 'all')]
    [string]
    $Status,

    # The new title for the pull request (max 256 characters).
    [Parameter(ValueFromPipelineByPropertyName, ValueFromPipeline)]
    [ValidateLength(0, 256)]
    [string]
    $Title,

    # The new description for the pull request (max 4000 characters).
    [Parameter(ValueFromPipelineByPropertyName, ValueFromPipeline)]
    [ValidateLength(0, 4000)]
    [string]
    $Description,

    # Specifies how the PR should be completed. Example: @{ deleteSourceBranch = $true; mergeCommitMessage = "Merged PR" }
    [Parameter(ValueFromPipelineByPropertyName, ValueFromPipeline)]
    [ValidateSet('setAutoComplete', 'setAutoCompleteSetBy')]
    [string]
    $CompletionOptions,

    # Specifies how the PR should be merged. Allowed values: noMerge, squash, rebase, rebaseMerge.
    [Parameter(ValueFromPipelineByPropertyName, ValueFromPipeline)]
    [ValidateSet('noMerge', 'squash', 'rebase', 'rebaseMerge')]
    [string]
    $MergeOptions,

    # The Azure DevOps user ID who sets the PR to auto-complete.
    [Parameter(ValueFromPipelineByPropertyName, ValueFromPipeline)]
    [string]
    $AutoCompleteSetBy,

    # The new target branch for the pull request. Example: "main" (automatically prefixed with "refs/heads/").
    # Retargeting a pull request means changing the destination branch where the pull request will be merged.
    [Parameter(ValueFromPipelineByPropertyName, ValueFromPipeline)]
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
