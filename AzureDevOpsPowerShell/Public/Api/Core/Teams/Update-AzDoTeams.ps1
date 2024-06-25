function Update-AzDoTeams {
  <#
      .SYNOPSIS
          This script updates a team in Azure DevOps.
      .DESCRIPTION
          This script updates a team's details in a specified project in Azure DevOps.
          When used in a pipeline, you can use the pre-defined CollectionUri, ProjectName, TeamName, and AccessToken (PAT) variables.
      .EXAMPLE
          $params = @{
              CollectionUri = 'https://dev.azure.com/weareinspark/'
              ProjectName = 'Project 1'
              TeamName = 'testteam'
              NewTeamName = 'newTestTeam'
              Description = 'Updated description for testteam'
          }
          Update-AzDoTeams @params

          This example updates the team 'testteam' in 'Project 1' with a new name and description.
      .OUTPUTS
          PSObject
      .NOTES
  #>
  [CmdletBinding(SupportsShouldProcess)]
  param (
    [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
    [ValidateScript({ Validate-CollectionUri -CollectionUri $_ })]
    [string]
    $CollectionUri,

    [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
    [string]
    $ProjectName,

    [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
    [string]
    $TeamName,

    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $NewTeamName,

    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $Description
  )

  begin {
    Write-Verbose "Starting function: Update-AzDoTeams"
  }

  process {
    # Get the team ID using the Get-AzDoProjectTeams function
    $teamParams = @{
      CollectionUri = $CollectionUri
      ProjectName   = $ProjectName
      TeamName      = $TeamName
    }

    try {
      $team = Get-AzDoProjectTeams @teamParams | Where-Object { $_.TeamName -eq $TeamName }
      if (-not $team) {
        Write-Error "Team '$TeamName' not found in project '$ProjectName'."
        return
      }

      $teamId = $team.TeamId
    } catch {
      Write-Error "Error retrieving team details: $_"
      return
    }

    $body = @{}
    if ($PSBoundParameters.ContainsKey('NewTeamName')) {
      $body.name = $NewTeamName
    }
    if ($PSBoundParameters.ContainsKey('Description')) {
      $body.description = $Description
    }

    if ($body.Count -eq 0) {
      Write-Error "No new data provided to update the team."
      return
    }

    $params = @{
      uri     = "$CollectionUri/_apis/projects/$ProjectName/teams/$teamId"
      version = "7.1-preview.3"
      method  = 'PATCH'
      body    = $body
    }

    if ($PSCmdlet.ShouldProcess($CollectionUri, "Update team: $TeamName in project: $ProjectName")) {
      try {
        $response = Invoke-AzDoRestMethod @params
        [PSCustomObject]@{
          CollectionUri = $CollectionUri
          ProjectName   = $ProjectName
          TeamName      = $response.name
          TeamId        = $response.id
          Description   = $response.description
          Url           = $response.url
          IdentityUrl   = $response.identityUrl
        }
      } catch {
        Write-Error "Error updating team: $_"
      }
    }
  }

  end {
    Write-Verbose "Ending function: Update-AzDoTeams"
  }
}
