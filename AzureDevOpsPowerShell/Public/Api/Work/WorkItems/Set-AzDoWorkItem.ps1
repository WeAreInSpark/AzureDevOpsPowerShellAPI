function Set-AzDoWorkItem {
  <#
  .SYNOPSIS
  Set a work item in Azure DevOps.
  .DESCRIPTION
  Set a work item in Azure DevOps.
  .EXAMPLE
  $params = @{
    CollectionUri = 'https://dev.azure.com/organization'
    ProjectName   = 'ProjectName'
    WorkItem      = @{
      WorkItemId    = 1
      Title         = "Test Work Item 2"
      Description   = "This is a test work item."
      AreaPath      = "DevOps Automation"
      IterationPath = "DevOps Automation"
      TeamProject   = "DevOps Automation"
      ParentId      = 3
    }
  }
  Set-AzDoWorkItem @params
  .OUTPUTS
  [PSCustomObject]@{
    Id   = 1
    Name = "Test Work Item 2"
    Url  = "https://dev.azure.com/organization/ProjectName/_apis/wit/workitems/1"
  }
  #>
  [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
  param (
    # Collection Uri of the organization
    [Parameter(Mandatory)]
    [ValidateScript({ Validate-CollectionUri -CollectionUri $_ })]
    [string]
    $CollectionUri,

    # Name of the project where the team is located
    [Parameter(Mandatory)]
    [string]
    $ProjectName,

    # Work item object (could be a hashtable or a custom object)
    # template: @{
    #   WorkItemId    = 1 (required)
    #   Title         = "Test Work Item 2" (optional)
    #   Description   = "This is a test work item." (optional)
    #   AreaPath      = "DevOps Automation" (optional)
    #   IterationPath = "DevOps Automation" (optional)
    #   TeamProject   = "DevOps Automation" (optional)
    #   ParentId      = 3 (optional)
    # }
    [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
    [object[]]
    $WorkItem
  )

  begin {
    Write-Verbose "Starting 'Set-AzDoWorkItem' function."
    $result = New-Object System.Collections.Generic.List[System.Object]
  }

  process {
    $WorkItem | ForEach-Object {
      $body = @(
        @{
          op    = 'test'
          path  = '/id'
          value = $_.WorkItemId
        }
      )

      if ($_.Title) {
        $body += @{
          op    = 'add'
          path  = '/fields/System.Title'
          value = $_.Title
        }
      }

      if ($_.Description) {
        $body += @{
          op    = 'add'
          path  = '/fields/System.Description'
          value = $_.Description
        }
      }

      if ($_.AreaPath) {
        $body += @{
          op    = 'add'
          path  = '/fields/System.AreaPath'
          value = $_.AreaPath
        }
      }

      if ($_.IterationPath) {
        $body += @{
          op    = 'add'
          path  = '/fields/System.IterationPath'
          value = $_.IterationPath
        }
      }

      if ($_.TeamProject) {
        $body += @{
          op    = 'add'
          path  = '/fields/System.TeamProject'
          value = $_.TeamProject
        }
      }

      if ($_.ParentId) {
        $body += @{
          op    = 'add'
          path  = '/relations/-'
          value = @{
            rel = 'System.LinkTypes.Hierarchy-Reverse'
            url = "$CollectionUri/$ProjectName/_apis/wit/workitems/$($_.ParentId)"
          }
        }
      }

      $params = @{
        uri         = "$CollectionUri/$ProjectName/_apis/wit/workitems/$($_.WorkItemId)"
        method      = 'PATCH'
        version     = '7.1-preview.3'
        body        = $body
        contentType = 'application/json-patch+json'
      }

      if ($PSCmdlet.ShouldProcess($CollectionUri, "Setting work item: $($PSStyle.Bold)$($_.WorkItemId)$($PSStyle.Reset)")) {
        try {
          $result += Invoke-AzDoRestMethod @params
        } catch {
          Write-AzDoError -message $_.Exception.Message
        }
      }
    }
  }

  end {
    if ($result) {
      $result | ForEach-Object {
        [PSCustomObject]@{
          Id   = $_.id
          Name = $_.fields.'System.Title'
          Url  = $_.url
        }
      }
    }
  }
}
