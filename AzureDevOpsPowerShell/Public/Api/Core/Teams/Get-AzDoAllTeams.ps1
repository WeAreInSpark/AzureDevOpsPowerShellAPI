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

      This example gets all teams within 'contoso' where the requesting user is a member.
  .OUTPUTS
      PSObject
  .NOTES
  #>
  [CmdletBinding(SupportsShouldProcess)]
  param (
    # Collection URI. e.g. https://dev.azure.com/contoso.
    [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
    [ValidateScript({ Validate-CollectionUri -CollectionUri $_ })]
    [String]
    $CollectionUri,

    # Whether or not to return detailed identity info
    [Parameter(ValueFromPipelineByPropertyName)]
    [Switch]
    $ExpandIdentity = $false,

    # Filter only teams your identity is member of
    [Parameter(ValueFromPipelineByPropertyName)]
    [Switch]
    $Mine = $false,

    # Skip number N of results
    [Parameter(ValueFromPipelineByPropertyName)]
    [Int]
    $Skip = 0,

    # Show only top N results
    [Parameter(ValueFromPipelineByPropertyName)]
    [Int]
    $Top = 0
  )
  process {
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

    $uri = "$CollectionUri/_apis/teams"
    $version = "7.1-preview.3"

    $params = @{
      Uri             = $uri
      Version         = $version
      QueryParameters = $queryParams
      Method          = 'GET'
    }

    if ($PSCmdlet.ShouldProcess($CollectionUri, "Get all teams in organization")) {
      (Invoke-AzDoRestMethod @params).value | ForEach-Object {
        [PSCustomObject]@{
          CollectionUri = $CollectionUri
          ProjectName   = $_.projectName
          TeamName      = $_.name
          TeamId        = $_.id
          Description   = $_.description
          Url           = $_.url
          IdentityUrl   = $_.identityUrl
        }
      }
    } else {
      Write-Verbose "Calling Invoke-AzDoRestMethod with $($params | ConvertTo-Json -Depth 10)"
    }
  }
}
