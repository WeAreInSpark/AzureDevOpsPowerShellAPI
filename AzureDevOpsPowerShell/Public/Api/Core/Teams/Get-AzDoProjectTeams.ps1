function Get-AzDoProjectTeams {
  <#
      .SYNOPSIS
          This script gets team details in a given project.
      .DESCRIPTION
          This script gets teams in a given project.
          When used in a pipeline, you can use the pre-defined CollectionUri, ProjectName, and AccessToken (PAT) variables.
      .EXAMPLE
          $params = @{
              CollectionUri = 'https://dev.azure.com/weareinspark/'
              ProjectName = 'Project 1'
              TeamName = 'testteam'
          }
          Get-AzDoTeams @params

          This example gets the team 'testteam' in 'Project 1'.
      .EXAMPLE
          $params = @{
              CollectionUri = 'https://dev.azure.com/weareinspark/'
              ProjectName = 'Project 1'
          }
          Get-AzDoTeams @params

          This example gets all teams in 'Project 1'.
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

    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $TeamName
  )

  begin {
    $result = @()
    Write-Verbose "Starting function: Get-AzDoProjectTeams"
  }

  process {
    $params = @{
      uri     = "$CollectionUri/_apis/projects/$ProjectName/teams"
      version = "7.1-preview.3"
      method  = 'GET'
    }

    if ($PSCmdlet.ShouldProcess($CollectionUri, "Get teams from: $($PSStyle.Bold)$ProjectName$($PSStyle.Reset)")) {
      $teams = (Invoke-AzDoRestMethod @params).value
      if ($TeamName) {
        $result += $teams | Where-Object { $_.name -eq $TeamName }
      } else {
        $result += $teams
      }
    } else {
      Write-Verbose "Calling Invoke-AzDoRestMethod with $($params | ConvertTo-Json -Depth 10)"
    }
  }

  end {
    if ($result) {
      $result | ForEach-Object {
        [PSCustomObject]@{
          CollectionURI = $CollectionUri
          ProjectName   = $ProjectName
          TeamName      = $_.name
          TeamId        = $_.id
          Description   = $_.description
          Url           = $_.url
          IdentityUrl   = $_.identityUrl
        }
      }
    }
  }
}
