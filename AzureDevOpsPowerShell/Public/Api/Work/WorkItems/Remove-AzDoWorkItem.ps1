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

    .EXAMPLE
    $params = @{
      CollectionUri = 'https://dev.azure.com/organization'
      ProjectName   = 'ProjectName'
      WorkItemId     = 1, 2, 3
    }
    Remove-AzDoWorkItem @params
  #>
  [CmdletBinding(SupportsShouldProcess)]
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

    # WorkItem Id to remove
    [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
    [int[]]
    $WorkItemId
  )

  begin {
    Write-Verbose "Starting 'Remove-AzDoWorkItem' function."
    $Uri = "$CollectionUri/$ProjectName/_apis/wit/workitems/{0}"
  }

  process {
    $params = @{
      method  = 'DELETE'
      version = '7.1-preview.3'
    }

    foreach ($id in $WorkItemId) {
      $id = [string]$id
      $params.uri = $Uri -f $id
      try {
        Invoke-AzDoRestMethod @params
        Write-Host "Work item $id deleted successfully."
      } catch {
        Write-AzdoError -Message $_
      }
    }
  }

  end {
    Write-Verbose "Ending 'Remove-AzDoWorkItem' function."
  }
}
