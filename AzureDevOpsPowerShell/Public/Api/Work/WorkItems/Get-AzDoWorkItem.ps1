function Get-AzDoWorkItem {
  <#
  .SYNOPSIS
  Get a work item from Azure DevOps.
  .DESCRIPTION
  Get a work item from Azure DevOps.
  .EXAMPLE
  $params = @{
    CollectionUri = 'https://dev.azure.com/organization'
    ProjectName   = 'ProjectName'
    WorkItemId     = 1
  }
  Get-AzDoWorkItem @params
  .EXAMPLE
  $params = @{
    CollectionUri = 'https://dev.azure.com/organization'
    ProjectName   = 'ProjectName'
    WorkItemId     = 1, 2, 3
  }
  Get-AzDoWorkItem @params
  .OUTPUTS
  [PSCustomObject]@{
    Id            = 1
    Title         = "Test Work Item 1"
    AreaPath      = "DevOps Automation"
    IterationPath = "DevOps Automation"
    TeamProject   = "DevOps Automation"
    WorkItemType  = "Task"
    State         = "New"
    Reason        = "New"
    AssignedTo    = "John Doe"
    CreatedDate   = "2021-01-01T00:00:00Z"
    CreatedBy     = "John Doe"
    Url           = "https://dev.azure.com/organization/ProjectName/_apis/wit/workitems/1"
  }
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

    # WorkItem Id to get
    [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
    [int[]]
    $WorkItemId
  )

  begin {
    Write-Verbose "Starting 'Get-AzDoWorkItem' function."
    $result = New-Object System.Collections.Generic.List[System.Object]
    $Uri = "$CollectionUri/$ProjectName/_apis/wit/workitems/{0}"
  }

  process {
    $params = @{
      method  = 'GET'
      version = '7.1-preview.3'
    }

    foreach ($id in $WorkItemId) {
      $id = [string]$id
      $params.uri = $Uri -f $id
      try {
        $result += Invoke-AzDoRestMethod @params
      } catch {
        Write-AzdoError -Message $_
      }
    }
  }

  end {
    Write-Verbose "Ending 'Get-AzDoWorkItem' function."
    if ($result) {
      $result | ForEach-Object {
        [PSCustomObject]@{
          Id            = $_.id
          Title         = $_.fields.'System.Title'
          AreaPath      = $_.fields.'System.AreaPath'
          IterationPath = $_.fields.'System.IterationPath'
          TeamProject   = $_.fields.'System.TeamProject'
          WorkItemType  = $_.fields.'System.WorkItemType'
          State         = $_.fields.'System.State'
          Reason        = $_.fields.'System.Reason'
          AssignedTo    = $_.fields.'System.AssignedTo'.displayName
          CreatedDate   = $_.fields.'System.CreatedDate'
          CreatedBy     = $_.fields.'System.CreatedBy'.displayName
          Url           = $_.url
        }
      }
    }
  }
}
