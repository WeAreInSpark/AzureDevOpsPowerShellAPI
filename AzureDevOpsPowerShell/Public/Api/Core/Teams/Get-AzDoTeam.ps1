function Get-AzDoTeam {
  <#
.SYNOPSIS
    Gets information about a team in Azure DevOps.
.DESCRIPTION
    Gets information about 1 team if the parameter $TeamName is filled in. Otherwise it will list all the teams's.
.EXAMPLE
    $Params = @{
        CollectionUri = "https://dev.azure.com/contoso"
    }
    Get-AzDoTeam -CollectionUri = "https://dev.azure.com/contoso"

    This example will list all the teams in the organization.
.EXAMPLE
    $Params = @{
        CollectionUri = "https://dev.azure.com/contoso"
        ProjectName = "Project 1"
    }
    Get-AzDoTeam -CollectionUri = "https://dev.azure.com/contoso" -ProjectName = "Project 1"

    This example will list all the teams contained in 'Project 1'.
.EXAMPLE
    $Params = @{
        CollectionUri = "https://dev.azure.com/contoso"
        TeamName "Team 1"
    }
    Get-AzDoTeam -CollectionUri = "https://dev.azure.com/contoso" -TeamName "Team 1"

    This example will fetch information about the team with the name 'Team 1'.
.EXAMPLE
    $Params = @{
        CollectionUri = "https://dev.azure.com/contoso"
        TeamId "564e8204-a90b-4432-883b-d4363c6125ca"
    }
    Get-AzDoTeam -CollectionUri = "https://dev.azure.com/contoso" -TeamId "564e8204-a90b-4432-883b-d4363c6125ca"

    This example will fetch information about the team with the ID '564e8204-a90b-4432-883b-d4363c6125ca'.
.OUTPUTS
    PSObject with team(s).

#>
  [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Low')]
  param (
    # Collection Uri of the organization
    [Parameter(Mandatory)]
    [ValidateScript({ Validate-CollectionUri -CollectionUri $_ })]
    [string]
    $CollectionUri,

    # Name of the project where the team is located
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $ProjectName,

    # Name of the team to fetch
    [Parameter(ValueFromPipelineByPropertyName)]
    [string[]]
    $TeamName,

    # Id of the team to fetch
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $TeamId
  )
  process {
    Write-Verbose "Starting function: Get-AzDoTeam"

    $params = @{
      uri     = "$CollectionUri/_apis/teams"
      version = "7.1-preview.3"
      method  = 'GET'
    }

    if ($PSCmdlet.ShouldProcess($CollectionUri, "Get Teams from: $($PSStyle.Bold)$ProjectName$($PSStyle.Reset)")) {
      try {
        $teams = (Invoke-AzDoRestMethod @params).value
      } catch {
        $PSCmdlet.ThrowTerminatingError((Write-AzDoError -message "Failed to get team '$TeamName' from project '$ProjectName' in collection '$CollectionUri' Error: $_" ))
      }

      # Filter the teams if the parameters are filled in
      if ($TeamName) {
        $teams = $teams | Where-Object { $_.name -eq $TeamName }
      }
      if ($ProjectName) {
        $teams = $teams | Where-Object { $_.projectName -eq $ProjectName }
      }
      if ($TeamId) {
        $teams = $teams | Where-Object { $_.id -eq $TeamId }
      }
      if ($teams) {
        $teams | ForEach-Object {
          [PSCustomObject]@{
            CollectionURI = $CollectionUri
            ProjectName   = $ProjectName
            TeamName      = $_.name
            TeamId        = $_.id
          }
        }
      } else {
        Write-Host "No teams found"
      }
    } else {
      Write-Verbose "Calling Invoke-AzDoRestMethod with $($params| ConvertTo-Json -Depth 10)"
    }
  }
}
