function New-AzDoPullRequest {
  <#
.SYNOPSIS
    Creates a pull request in Azure DevOps.
.DESCRIPTION
    Creates a pull request in Azure DevOps.
.EXAMPLE
    $params = @{
        CollectionUri = "https://dev.azure.com/contoso"
        RepoName         = "Repo1"
        ProjectName   = "Project 1"
        Title          = "New Pull Request"
        Description    = "This is a new pull request"
        SourceRefName  = "refs/heads/feature1"
        TargetRefName  = "refs/heads/main"
    }
    New-AzDoPullRequest @params

    This example creates a new Azure DevOps Pull Request with splatting parameters
.EXAMPLE
    $params = @{
        CollectionUri = "https://dev.azure.com/contoso"
        RepoName         = "Repo1"
        ProjectName   = "Project 1"
        Title          = "New Pull Request"
        Description    = "This is a new pull request"
        SourceRefName  = "refs/heads/feature1"
        TargetRefName  = "refs/heads/main"
    }
    $params | New-AzDoPullRequest

    This example creates a new Azure DevOps Pull Request with pipeline parameters
.OUTPUTS
    [PSCustomObject]@{
        CollectionUri  = $CollectionUri
        ProjectName    = $ProjectName
        RepoName       = $RepoName
        PullRequestId  = $res.pullRequestId
        PullRequestURL = $res.url
      }
.NOTES
#>

  [CmdletBinding(SupportsShouldProcess)]
  param (
    # Collection Uri of the organization
    [Parameter(Mandatory)]
    [ValidateScript({ Validate-CollectionUri -CollectionUri $_ })]
    [string]
    $CollectionUri,

    # Id of the repository
    [Parameter(Mandatory)]
    [string]
    $RepoName,

    # Name of the project where the new repository has to be created
    [Parameter(Mandatory)]
    [string]
    $ProjectName,

    # Title of the pull request
    [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
    [string[]]
    $Title,

    # Description of the pull request
    [Parameter(ValueFromPipelineByPropertyName)]
    [string[]]
    $Description = 'Describe the changes made in this pull request',

    # Source ref name
    [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
    [string[]]
    $SourceRefName,

    # Target ref name
    [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
    [string[]]
    $TargetRefName
  )

  begin {
    Write-Verbose "Starting function: New-AzDoPullRequest"
    $CollectionUri = $CollectionUri.TrimEnd('/')
    $result = New-Object System.Collections.Generic.List[System.Object]
  }

  process {
    foreach ($pr in $Title) {
      $prTitle = $pr
      $prDescription = $Description[$Title.IndexOf($pr)]
      $prSourceRefName = $SourceRefName[$Title.IndexOf($pr)]
      $prTargetRefName = $TargetRefName[$Title.IndexOf($pr)]

      # If the ref name is not in the format refs/heads/branch, then add it
      if ($prSourceRefName -notlike "refs/*") {
        $prSourceRefName = "refs/heads/$prSourceRefName"
      }
      if ($prTargetRefName -notlike "refs/*") {
        $prTargetRefName = "refs/heads/$prTargetRefName"
      }

      $params = @{
        uri     = "$CollectionUri/$ProjectName/_apis/git/repositories/$RepoName/pullrequests"
        version = '7.2-preview.2'
        method  = 'POST'
        body    = @{
          sourceRefName = $prSourceRefName
          targetRefName = $prTargetRefName
          title         = $prTitle
          description   = $prDescription
        }
      }

      if ($PSCmdlet.ShouldProcess($CollectionUri, "Create pull request named: $($PSStyle.Bold)$prTitle$($PSStyle.Reset)")) {
        try {
          $result += Invoke-AzDoRestMethod @params
        } catch {
          if ($_ -match 'TF401179') {
            Write-Warning "Pull request between those branches already exists, trying to get it"
            $getParams = @{
              uri     = "$CollectionUri/$ProjectName/_apis/git/repositories/$RepoName/pullrequests"
              version = '7.1-preview.1'
              method  = 'GET'
            }
            $result += (Invoke-AzDoRestMethod @getParams).value | Where-Object { $_.sourceRefName -eq $prSourceRefName -and $_.targetRefName -eq $prTargetRefName }
          } else {
            Write-AzDoError -message $_
          }
        }
      } else {
        Write-Verbose "Calling Invoke-AzDoRestMethod with $($params| ConvertTo-Json -Depth 10)"
      }
    }
  }

  end {
    if ($result) {
      $result | ForEach-Object {
        [PSCustomObject]@{
          CollectionUri     = $CollectionUri
          ProjectName       = $ProjectName
          RepoName          = $RepoName
          PullRequestTitle  = $_.title
          PullRequestId     = $_.pullRequestId
          PullRequestURL    = $_.url
          PullRequestWebUrl = "$CollectionUri/$ProjectName/_git/$RepoName/pullrequest/$($_.pullRequestId)"
          PullRequestStatus = $_.status
        }
      }
    }
  }
}
