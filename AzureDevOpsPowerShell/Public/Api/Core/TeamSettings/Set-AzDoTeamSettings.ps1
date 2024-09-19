function Set-AzDoTeamSettings {
  <#
.SYNOPSIS
    Set the settings of a Team in Azure DevOps.
.DESCRIPTION
    Set the settings of a Team or multiple in Azure DevOps.
.EXAMPLE
    $Params = @{
      CollectionUri  = "https://dev.azure.com/cantoso"
      ProjectName    = "Playground"
      TeamName           = "Team1"
      BacklogIteration = "323b04b6-2fb8-4093-94f4-fbe3bd36a19f"
      DefaultIteration = "8c2457e8-8936-4cdc-b3aa-17b20f56c76c"
      BugsBehavior = "off"
      WorkingDays = @("monday", "tuesday", "wednesday", "thursday", "friday")
      Iterations = @(
        "8c2457e8-8936-4cdc-b3aa-17b20f56c76c",
        "323b04b6-2fb8-4093-94f4-fbe3bd36a19f"
      )
      AreaPath = "ProjectName"
      IncludeAreaChildren = $true
    }

    Set-AzDoTeamSettings @Params

    This example will set the settings of the team 'Team1' in the project 'Playground'.
#>
  [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Low')]
  param(
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
    [string]
    $TeamName,

    # Backlog iteration id
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $BacklogIteration,

    # Bugs behavior
    [Parameter(ValueFromPipelineByPropertyName)]
    [ValidateSet('off', 'asRequirements', 'asTasks')]
    [string]
    $BugsBehavior,

    # Working days
    [Parameter(ValueFromPipelineByPropertyName)]
    [ValidateSet('monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday')]
    [string[]]
    $WorkingDays,

    # Iteration paths
    [Parameter(ValueFromPipelineByPropertyName)]
    [string[]]
    $Iterations,

    # Area path
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $AreaPath,

    # Include area children
    [Parameter(ValueFromPipelineByPropertyName)]
    [bool]
    $IncludeAreaChildren = $true
  )

  begin {
    Write-Verbose "Starting function: Set-AzDoTeamSettings"
  }

  process {
    $Team = Get-AzDoTeam -CollectionUri $CollectionUri -ProjectName $ProjectName -TeamName $TeamName -ErrorAction SilentlyContinue
    if ($Team) {
      # Set the team settings
      $Settings = @{}
      if ($BacklogIteration) {
        $Settings.backlogIteration = $BacklogIteration
      }
      if ($BugsBehavior) {
        $Settings.bugsBehavior = $BugsBehavior
      }
      if ($WorkingDays) {
        $Settings.workingDays = $WorkingDays
      }
      $SettingsParams = @{
        uri     = "$CollectionUri/$ProjectName/$TeamName/_apis/work/teamSettings"
        method  = 'PATCH'
        version = '7.1-preview.1'
        body    = $Settings
      }
      try {
        Write-Verbose "Setting team settings for team '$TeamName' in project '$ProjectName'."
        $SettingsResult = Invoke-AzDoRestMethod @SettingsParams
      } catch {
        Write-AzdoError -Message $_
      }

      # Set the area path
      if ($AreaPath) {
        $AreaParams = @{
          uri     = "$CollectionUri/$ProjectName/$TeamName/_apis/work/teamsettings/teamfieldvalues"
          method  = 'PATCH'
          version = '7.1-preview.1'
          body    = @{
            defaultValue = "$ProjectName\\$AreaPath"
            values       = @(
              @{
                includeChildren = $IncludeAreaChildren
                value           = "$ProjectName\\$AreaPath"
              }
            )
          }
        }
        try {
          Write-Verbose "Setting area path for team '$TeamName' in project '$ProjectName'."
          $AreaResult = Invoke-AzDoRestMethod @AreaParams
        } catch {
          Write-AzdoError -Message $_
        }
      }

      # Set the iteration paths
      $IterationResult = @()
      foreach ($Iteration in $Iterations) {
        $IterationParams = @{
          uri     = "$CollectionUri/$ProjectName/$TeamName/_apis/work/teamsettings/iterations"
          method  = 'POST'
          version = '7.1-preview.1'
          body    = @{ id = $Iteration }
        }
        try {
          Write-Verbose "Setting iteration paths for team '$TeamName' in project '$ProjectName'."
          $IterationResult += Invoke-AzDoRestMethod @IterationParams
        } catch {
          Write-AzdoError -Message $_
        }
      }

      $result += [PSCustomObject]@{
        CollectionUri       = $CollectionUri
        ProjectName         = $ProjectName
        TeamName            = $TeamName
        BacklogIteration    = $SettingsResult.backlogIteration
        BugsBehavior        = $SettingsResult.bugsBehavior
        WorkingDays         = $SettingsResult.workingDays
        AreaPath            = $AreaResult.defaultValue
        IncludeAreaChildren = $AreaResult.values.includeChildren
        Iterations          = $IterationResult
      }
    } else {
      Write-Host "Team '$TeamName' not found in project '$ProjectName', skipping."
    }
  }

  end {
    if ($result) {
      $result
    }
    Write-Verbose "Ending function: Set-AzDoTeamSettings"
  }
}
