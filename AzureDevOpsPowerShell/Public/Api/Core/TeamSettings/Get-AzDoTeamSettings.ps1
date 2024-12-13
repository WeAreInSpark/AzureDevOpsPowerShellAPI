function Get-AzDoTeamSettings {
  <#
.SYNOPSIS
    Get the settings of a Team in Azure DevOps.
.DESCRIPTION
    Get the settings of a Team or multiple in Azure DevOps.
.EXAMPLE
    $Params = @{
      CollectionUri  = "https://dev.azure.com/cantoso"
      ProjectName    = "Playground"
      TeamName       = "Team1"
    }

    Get-AzDoTeamSettings @Params

    This example will get the settings of the team 'Team1' in the project 'Playground'.
.OUTPUTS
    PSObject with the settings of the team(s).
#>

  [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Low')]
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

    # Name of the team to get the settings from
    [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
    [string[]]
    $TeamName
  )
  process {
    Write-Verbose "Starting function: Get-AzDoTeamSettings"
    $CollectionUri = $CollectionUri.TrimEnd('/')

    foreach ($Name in $TeamName) {
      $params = @{
        uri     = "$CollectionUri/$ProjectName/$Name/_apis/work/teamSettings"
        method  = 'GET'
        version = '7.1-preview.1'
      }

      if ($PSCmdlet.ShouldProcess("Get team settings for team '$Name' in project '$ProjectName'")) {
        try {
          Invoke-AzDoRestMethod @params | ForEach-Object {
            [PSCustomObject]@{
              CollectionUri         = $CollectionUri
              ProjectName           = $ProjectName
              TeamName              = $Name
              TeamId                = ($_.url -split '/')[-4]
              BacklogIteration      = $_.backlogIteration
              BacklogVisibilities   = $_.backlogVisibilities
              DefualtIteration      = $_.defaultIteration
              DefaultIterationMacro = $_.defaultIterationMacro
              WorkingDays           = $_.workingDays
              BugsBehavior          = $_.bugsBehavior
              Url                   = $_.url
            }
          }
        } catch {
          $PSCmdlet.ThrowTerminatingError((Write-AzdoError -Message "Failed to get settings for team '$name' in $projectName Error: $_"))
        }
      } else {
        Write-Verbose "Skipping team settings for team '$Name' in project '$ProjectName'."
      }
    }
  }
}
