function Get-AzDoTeamMembers {
  <#
  .SYNOPSIS
      This script gets team members with extended properties in a given project and team.
  .DESCRIPTION
      This script gets team members with extended properties in a given project and team.
      When used in a pipeline, you can use the pre-defined CollectionUri, ProjectName, and AccessToken (PAT) variables.
  .EXAMPLE
      $params = @{
          CollectionUri = 'https://dev.azure.com/contos0'
          ProjectName = 'Project 1'
          TeamName = 'testteam'
      }
      Get-AzDoTeamMembers @params

      This example gets the team members with extended properties in 'testteam' within 'Project 1'.
  .OUTPUTS
      PSObject
  .NOTES
  #>
  [CmdletBinding(SupportsShouldProcess)]
  param (
    #  Collection Uri of the organization
    [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
    [ValidateScript({ Validate-CollectionUri -CollectionUri $_ })]
    [string]
    $CollectionUri,

    # the projectName
    [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
    [string]
    $ProjectName,

    # Team name of the team
    [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
    [string]
    $TeamName
  )

  process {
    Write-Verbose "Starting function: Get-AzDoTeamMembers"

    # Get the team ID using the Get-AzDoProjectTeams function
    $teamParams = @{
      CollectionUri = $CollectionUri
      ProjectName   = $ProjectName
      TeamName      = $TeamName
    }

    try {
      $team = Get-AzDoProjectTeams @teamParams | Where-Object { $_.TeamName -eq $TeamName }
      if (-not $team) {
        Write-AzDoError "Team '$TeamName' not found in project '$ProjectName'."
      }

      $teamId = $team.TeamId
      Write-Verbose "Retrieved Team ID: $teamId"
    } catch {
      Write-AzDoError "Error retrieving team details: $_"
    }

    $params = @{
      uri     = "$CollectionUri/_apis/projects/$ProjectName/teams/$teamId/members"
      version = "7.1-preview.2"
      method  = 'GET'
    }

    Write-Verbose "Request URI: $($params.uri)"

    if ($PSCmdlet.ShouldProcess($CollectionUri, "Get team members with extended properties from: $($PSStyle.Bold)$TeamName$($PSStyle.Reset) in project: $($PSStyle.Bold)$ProjectName$($PSStyle.Reset)")) {
      try {
        $members = (Invoke-AzDoRestMethod @params).value
        if (-not $members) {
          Write-Verbose "No members found for team '$TeamName'."
        } else {
          $members | ForEach-Object {
            [PSCustomObject]@{
              TeamName    = $TeamName
              ProjectName = $ProjectName
              MemberId    = $_.identity.id
              DisplayName = $_.identity.displayName
              UniqueName  = $_.identity.uniqueName
              IsTeamAdmin = $_.isTeamAdmin
            }
          }
        }
      } catch {
        Write-AzDoError "Error retrieving team members: $_"
      }
    } else {
      Write-Verbose "Calling Invoke-AzDoRestMethod with $($params | ConvertTo-Json -Depth 10)"
    }
  }
}
