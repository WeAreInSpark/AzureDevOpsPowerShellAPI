function Get-AzDoTeamMembersExtended {
  <#
  .SYNOPSIS
      This script gets team members with extended properties in a given project and team.
  .DESCRIPTION
      This script gets team members with extended properties in a given project and team.
      When used in a pipeline, you can use the pre-defined CollectionUri, ProjectName, and AccessToken (PAT) variables.
  .EXAMPLE
      $params = @{
          CollectionUri = 'https://dev.azure.com/weareinspark/'
          ProjectName = 'Project 1'
          TeamName = 'testteam'
      }
      Get-AzDoTeamMembersExtended @params

      This example gets the team members with extended properties in 'testteam' within 'Project 1'.
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
    $TeamName
  )

  begin {
    $result = @()
    Write-Verbose "Starting function: Get-AzDoTeamMembersExtended"
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
      Write-Verbose "Retrieved Team ID: $teamId"
    } catch {
      Write-Error "Error retrieving team details: $_"
      return
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
          $result += $members
        }
      } catch {
        Write-Error "Error retrieving team members: $_"
        return
      }
    } else {
      Write-Verbose "Calling Invoke-AzDoRestMethod with $($params | ConvertTo-Json -Depth 10)"
    }
  }

  end {
    if ($result) {
      $result | ForEach-Object {
        [PSCustomObject]@{
          TeamName    = $TeamName
          ProjectName = $ProjectName
          MemberId    = $_.identity.id
          DisplayName = $_.identity.displayName
          UniqueName  = $_.identity.uniqueName
          Email       = $_.identity.mailAddress
          IsTeamAdmin = $_.isTeamAdmin
        }
      }
    }
  }
}

<#
# Example usage
$params = @{
    CollectionUri = 'https://dev.azure.com/yuhnix2'
    ProjectName   = 'Test'
    TeamName      = 'test Team'
}
Get-AzDoTeamMembersExtended @params
#>
