function New-AzDoTeam {
  <#
.SYNOPSIS
Create a new team in a project.

.DESCRIPTION
Create a new team in a project.

.EXAMPLE
$Params = @{
  CollectionUri = "https://dev.azure.com/contoso"
  ProjectName   = "Project 1"
  TeamName      = "Team 1"
}
New-AzDoTeam @Params

This example will create a new team named 'Team 1' in 'Project 1'.

.EXAMPLE
$Params = @{
  CollectionUri = "https://dev.azure.com/contoso"
  ProjectName   = "Project 1"
  TeamName      = "Team 1", "Team 2"
  Description   = "Team 1 description", "Team 2 description"
}
New-AzDoTeam @Params

This example will create two new teams named 'Team 1' and 'Team 2' in 'Project 1' with the descriptions 'Team 1 description' and 'Team 2 description' respectively.

.NOTES
Additional information about the function.
  #>
  [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
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

    # Name of the team to create
    [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
    [string[]]
    $TeamName,

    # Description of the team to create
    [Parameter(ValueFromPipelineByPropertyName)]
    [string[]]
    $Description
  )

  process {
    Write-Verbose "Starting 'New-AzDoTeam' function."
    $CollectionUri = $CollectionUri.TrimEnd('/')

    $Project = (Get-AzDoProject -CollectionUri $CollectionUri -ProjectName $ProjectName)
    Write-Verbose "ProjectId: $($Project.ProjectId)"

    $params = @{
      uri     = "$CollectionUri/_apis/projects/$($Project.ProjectId)/teams"
      method  = 'POST'
      version = '7.1-preview.3'
      body    = @{}
    }

    foreach ($name in $TeamName) {
      if ($Description) {
        $params.body = @{
          name        = $name
          description = $Description[$TeamName.IndexOf($name)]
        }
      } else {
        $params.body = @{
          name        = $name
          description = "Team created by Azure DevOps PowerShell module."
        }
      }

      if ($PSCmdlet.ShouldProcess($CollectionUri, "Create team named: $($PSStyle.Bold)$name$($PSStyle.Reset) in Project $($PSStyle.Bold)$ProjectName$($PSStyle.Reset)")) {
        try {
          Invoke-AzDoRestMethod @params | ForEach-Object {
            [PSCustomObject]@{
              TeamId      = $_.id
              TeamName    = $_.name
              ProjectName = $_.projectName
              Description = $_.description
              IdentityUrl = $_.identityUrl
              WebUrl      = $_.url
            }
          }
        } catch {
          Write-Error "Error creating team $name in $ProjectName Error: $_"
          continue
        }
      } else {
        Write-Verbose "Calling Invoke-AzDoRestMethod with $($params| ConvertTo-Json -Depth 10)"
      }
    }
    Write-Verbose "Finished executing 'New-AzDoTeam' function."
  }
}
