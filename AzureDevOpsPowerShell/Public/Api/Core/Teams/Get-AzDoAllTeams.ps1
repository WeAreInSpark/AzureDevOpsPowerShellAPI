function Get-AzDoAllTeams {
  <#
  .SYNOPSIS
      This script gets all teams within an organization.
  .DESCRIPTION
      This script retrieves all teams within an organization using the Azure DevOps REST API.
  .EXAMPLE
      $params = @{
          CollectionUri = 'https://dev.azure.com/contoso/'
          ExpandIdentity = $true
          Mine = $true
      }
      Get-AzDoAllTeams @params

      This example gets all teams within 'weareinspark' where the requesting user is a member.
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

    [Parameter(ValueFromPipelineByPropertyName)]
    [bool]
    $ExpandIdentity = $false,

    [Parameter(ValueFromPipelineByPropertyName)]
    [bool]
    $Mine = $false,

    [Parameter(ValueFromPipelineByPropertyName)]
    [int]
    $Skip = 0,

    [Parameter(ValueFromPipelineByPropertyName)]
    [int]
    $Top = 0
  )

  begin {
    $result = @()
    Write-Verbose "Starting function: Get-AzDoAllTeams"

    $queryParams = @()
    if ($ExpandIdentity) {
      $queryParams += "`$expandIdentity=$ExpandIdentity"
    }
    if ($Mine) {
      $queryParams += "`$mine=$Mine"
    }
    if ($Skip -gt 0) {
      $queryParams += "`$skip=$Skip"
    }
    if ($Top -gt 0) {
      $queryParams += "`$top=$Top"
    }
    $queryParams = $queryParams -join "&"
  }

  process {
    $uri = "$CollectionUri/_apis/teams"
    $version = "7.1-preview.3"

    $params = @{
      Uri             = $uri
      Version         = $version
      QueryParameters = $queryParams
      Method          = 'GET'
    }

    # Extract organization name from the last part of the CollectionUri
    $Organization = $CollectionUri.Split('/')[-1]

    if ($PSCmdlet.ShouldProcess($CollectionUri, "Get all teams in organization: $($PSStyle.Bold)$Organization$($PSStyle.Reset)")) {
      $teams = (Invoke-AzDoRestMethod @params).value
      $result += $teams
    } else {
      Write-Verbose "Calling Invoke-AzDoRestMethod with $($params | ConvertTo-Json -Depth 10)"
    }
  }

  end {
    if ($result) {
      $result | ForEach-Object {
        [PSCustomObject]@{
          Organization = $Organization
          TeamName     = $_.name
          TeamId       = $_.id
          Description  = $_.description
          Url          = $_.url
          IdentityUrl  = $_.identityUrl
        }
      }
    }
  }
}

<#
$params = @{
  CollectionUri  = 'https://dev.azure.com/yuhnix2'
  ExpandIdentity = $true
  Mine           = $true
}

$allteamsMine = Get-AzDoAllTeams @params
$params = @{
  CollectionUri  = 'https://dev.azure.com/yuhnix2'
  ExpandIdentity = $true
  Mine           = $false
}
$allteams = Get-AzDoAllTeams @params
#>
