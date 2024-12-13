function Remove-AzDoTeam {
  <#
  .SYNOPSIS
  Remove a team from Azure DevOps.
  .DESCRIPTION
  Remove a team from Azure DevOps.
  .EXAMPLE
  $params = @{
    CollectionUri = 'https://dev.azure.com/organization'
    ProjectName   = 'ProjectName'
    TeamName      = 'TeamName'
  }
  Remove-AzDoTeam @params
  .EXAMPLE
  $params = @{
    CollectionUri = 'https://dev.azure.com/organization'
    ProjectName   = 'ProjectName'
    TeamId        = 'TeamId'
  }
  Remove-AzDoTeam @params
  #>
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

    # Name(s) of the team(s) to delete
    [Parameter(ValueFromPipelineByPropertyName)]
    [string[]]
    $TeamName,

    # Id(s) of the team(s) to delete
    [Parameter(ValueFromPipelineByPropertyName)]
    [string[]]
    $TeamId
  )
  process {
    Write-Verbose "Starting function: Remove-AzDoTeam"

    if ($TeamName) {
      $TeamId = foreach ($Name in $TeamName) {
        Get-AzDoTeam -CollectionUri $CollectionUri -ProjectName $ProjectName -TeamName $Name | Select-Object -ExpandProperty Id
      }
    }

    foreach ($Id in $TeamId) {
      $params = @{
        uri     = "$CollectionUri/_apis/projects/$ProjectName/teams/$Id"
        method  = 'DELETE'
        version = '7.1-preview.3'
      }

      if ($PSCmdlet.ShouldProcess("Delete team '$Id' in project '$ProjectName'")) {
        try {
          Invoke-AzDoRestMethod @params
        } catch {
          Write-Error "Error Deleting team $id in $projectname Error: $_"
          continue
        }
      } else {
        Write-Verbose "To be deleted teams in project '$ProjectName'."
      }
    }
    Write-Verbose "Ending function: Remove-AzDoTeam"
  }
}
