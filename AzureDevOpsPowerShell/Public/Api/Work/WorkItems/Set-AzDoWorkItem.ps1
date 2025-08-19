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

  .NOTES
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
    [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
    [ValidateScript({ Validate-CollectionUri -CollectionUri $_ })]
    [string]
    $CollectionUri,

    # Name of the project where the team is located
    [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
    [string]
    $ProjectName,

    # Work item to update
    [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
    [object[]]
    $WorkItem
  )
  process {
    Write-Verbose "Starting 'Set-AzDoWorkItem' function."

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
          Invoke-AzDoRestMethod @params | ForEach-Object {
            [PSCustomObject]@{
              CollectionUri = $CollectionUri
              ProjectName   = $ProjectName
              Id            = $_.id
              Name          = $_.fields.'System.Title'
              Url           = $_.url
              WorkItem      = [PSCustomObject]@{
                WorkItemId    = $_.id
                Title         = $_.fields.'System.Title'
                AreaPath      = $_.fields.'System.AreaPath'
                IterationPath = $_.fields.'System.IterationPath'
                TeamProject   = $_.fields.'System.TeamProject'
              }

            }
          }
        } catch {
          Write-Error "Error setting work item $($_.WorkItemId) in project '$projectname' Error: $_"
          # return in a foreach-object loop will act as a continue
          return
        }
      }
    }
  }
}
