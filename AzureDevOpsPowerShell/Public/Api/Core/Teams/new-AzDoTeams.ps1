function New-AzDoTeams {
  <#
  .SYNOPSIS
      Function to create an Azure DevOps team.
  .DESCRIPTION
      Function to create an Azure DevOps team within a specified project.
  .EXAMPLE
      $newAzDoTeamSplat = @{
          CollectionUri = "https://dev.azure.com/contoso"
          ProjectName = ProjectName
          TeamName = "NewTeamName"
          Description = "This is the new team"
      }
      New-AzDoTeam @newAzDoTeamSplat

      This example creates a new team named "NewTeamName" in the specified project ProjectName within the collectionUri "https://dev.azure.com/contoso".

  .OUTPUTS
      Outputs the response from the Azure DevOps REST API, which includes details of the newly created team.

  .NOTES
      This function requires the user to be authenticated with Azure using Connect-AzAccount.
      Ensure that the tenant ID is correctly specified in the script.
  #>
  [CmdletBinding(SupportsShouldProcess)]
  param (
    # Collection URI. e.g. https://dev.azure.com/contoso.
    [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
    [string]$CollectionUri,

    # Name of the project.
    [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
    [string]$ProjectName,

    # Name of the team.
    [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
    [string]$TeamName,

    # Description of the team.
    [Parameter()]
    [string]$Description = "Team for $TeamName"
  )

  begin {
    Write-Verbose "Starting function: New-AzDoTeam"
  }

  process {
    # Get the project ID

    try {
      $projectid = (Get-AzDoProject -CollectionUri $CollectionUri -ProjectName $ProjectName).Projectid
      #$projectId = $project
    } catch {
      Write-Error "Failed to get project ID for project '$ProjectName'. Error: $_"
      return
    }

    $params = @{
      Uri     = "$CollectionUri/_apis/projects/$projectId/teams"
      Version = "7.2-preview.3"
      Method  = 'POST'
    }

    $body = @{
      name        = $TeamName
      description = $Description
      visibility  = $true

    }

    if ($PSCmdlet.ShouldProcess($CollectionUri, "Create team named: $($PSStyle.Bold)$TeamName$($PSStyle.Reset) in project: $($PSStyle.Bold)$Project$($PSStyle.Reset)")) {
      try {
        $response = $body | Invoke-AzDoRestMethod @params
        if ($response -is [System.Management.Automation.PSObject]) {
          #Write-Output "Team '$TeamName' created successfully in project '$Project'."
          $output = [PSCustomObject]@{
            CollectionUri = $CollectionUri
            ProjectName   = $ProjectName
            projectId     = $projectId
            Name          = $TeamName
            Description   = $Description
            TeamId        = $response.id
            Url           = $response.url
            IdentityUrl   = $response.IdentityUrl
            Identity      = $response.Identity
          }
          return $output
        } else {
          Write-AzDoError -Message "Unexpected response format: $($response | Out-String)"
        }
      } catch {
        Write-AzDoError -Message "Failed to create team '$TeamName'. Error: $_"
      }
    } else {
      Write-Verbose "Calling Invoke-AzDoRestMethod with $($params | ConvertTo-Json -Depth 10)"
    }
  }

  end {
    Write-Verbose "Ending function: New-AzDoTeam"
  }
}
