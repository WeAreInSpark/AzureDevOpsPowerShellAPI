function Remove-AzDoWorkItem {
  <#
    .SYNOPSIS
    Remove a work item from Azure DevOps.

    .DESCRIPTION
    Remove a work item from Azure DevOps.

    .EXAMPLE
    $params = @{
      CollectionUri = 'https://dev.azure.com/organization'
      ProjectName   = 'ProjectName'
      WorkItemId     = 1
    }
    Remove-AzDoWorkItem @params

    This example removes a work item from Azure DevOps.
    .EXAMPLE
    $params = @{
      CollectionUri = 'https://dev.azure.com/organization'
      ProjectName   = 'ProjectName'
      WorkItemId     = 1, 2, 3
    }
    Remove-AzDoWorkItem @params

    This cmdlet removes work items from Azure DevOps.
  #>
  [CmdletBinding(SupportsShouldProcess)]
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

    # WorkItem Id to remove
    [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
    [int[]]
    $WorkItemId
  )
  process {
    Write-Verbose "Starting 'Remove-AzDoWorkItem' function."
    $Uri = "$CollectionUri/$ProjectName/_apis/wit/workitems/{0}"

    $params = @{
      method  = 'DELETE'
      version = '7.2-preview.3'
    }

    foreach ($id in $WorkItemId) {
      $id = [string]$id
      $params.uri = $Uri -f $id
      try {
        Invoke-AzDoRestMethod @params | ForEach-Object {
          [PSCustomObject]@{
            CollectionUri = $CollectionUri
            ProjectName   = $ProjectName
            WorkItemId    = $id
            DeletedItem   = $true
            DeletedDate   = $_.deletedDate
            DeletedBy     = $_.deletedBy
          }
        }
        Write-Verbose "Work item $id deleted successfully from project $projectName."
      } catch {
        Write-Error "Error deleting work item $id in project '$projectname' Error: $_"
        continue
      }
    }
    Write-Verbose "Ending 'Remove-AzDoWorkItem' function."
  }
}
