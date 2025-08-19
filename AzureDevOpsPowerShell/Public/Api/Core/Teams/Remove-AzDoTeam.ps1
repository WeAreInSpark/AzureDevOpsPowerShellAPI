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
    [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
    [ValidateScript({ Validate-CollectionUri -CollectionUri $_ })]
    [string]
    $CollectionUri,

    # Name of the project where the team is located
    [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
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
      Get-AzDoTeam -CollectionUri $CollectionUri -ProjectName $ProjectName -TeamName $TeamName
    } elseif ($TeamId) {
      Get-AzDoTeam -CollectionUri $CollectionUri -ProjectName $ProjectName -TeamId $TeamId
    } else {
      Write-Warning "No team name(s) or team id provided."
      return
    }

    foreach ($Team in $Teams) {
      $params = @{
        uri     = "$CollectionUri/_apis/projects/$ProjectName/teams/$($Team.TeamId)"
        method  = 'DELETE'
        version = '7.1-preview.3'
      }

      if ($PSCmdlet.ShouldProcess($CollectionUri, "Delete team '$($team.TeamName)' in project '$ProjectName'")) {
        try {
          Invoke-AzDoRestMethod @params | ForEach-Object {
            [PSCustomObject]@{
              CollectionURI = $CollectionUri
              ProjectName   = $ProjectName
              TeamName      = $team.TeamName
              Removed       = $true
            }
          }
        } catch {
          Write-Error "Error Deleting team '$($team.TeamName)' in project '$projectname' Error: $_"
          [PSCustomObject]@{
            CollectionURI = $CollectionUri
            ProjectName   = $ProjectName
            TeamName      = $team.TeamName
            Removed       = $false
          }
          continue
        }
      } else {
        Write-Verbose "To be deleted team '$($team.TeamName)' in project '$ProjectName'."
      }
    }
    Write-Verbose "Ending function: Remove-AzDoTeam"
  }
}
