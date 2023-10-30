function Get-AzDoVariableGroup {
  <#
    .SYNOPSIS
        This script gets a variable group details in a given project.
    .DESCRIPTION
        This script gets a variable groups a given project.
        When used in a pipeline, you can use the pre defined CollectionUri, ProjectName and AccessToken (PAT) variables.
    .EXAMPLE
        $params = @{
            Collectionuri = 'https://dev.azure.com/weareinspark/'
            PAT = '*******************'
            ProjectName = 'Project 1'
            VariableGroupName = 'VariableGroup1','VariableGroup2'
        }
        Get-AzDoVariableGroup @params

        This example gets Variable Groups 'VariableGroup1' and 'VariableGroup2' .
    .EXAMPLE
        $params = @{
            Collectionuri = 'https://dev.azure.com/weareinspark/'
            PAT = '*******************'
            ProjectName = 'Project 1'
        }
        Get-AzDoVariableGroup @params

        This example gets all variable groups the user has access to within a project.
    .OUTPUTS
        PSObject
    .NOTES
    #>
  [CmdletBinding(SupportsShouldProcess)]
  param (
    # Collection Uri of the organization
    [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
    [string]
    $CollectionUri,

    # PAT to authentice with the organization
    [Parameter()]
    [string]
    $PAT = $env:SYSTEM_ACCESSTOKEN,

    # Project where the variable group has to be created
    [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
    [string]
    $ProjectName,

    # Name of the variable group
    [Parameter(ValueFromPipelineByPropertyName, ValueFromPipeline)]
    [string[]]
    $VariableGroupName
  )
  Begin {
    if ($UsePAT) {
      Write-Verbose 'The [UsePAT]-parameter was set to true, so the PAT will be used to authenticate with the organization.'
      if ($PAT -eq $env:SYSTEM_ACCESSTOKEN) {
        Write-Verbose -Message "Using the PAT from the environment variable 'SYSTEM_ACCESSTOKEN'."
      } elseif (-not [string]::IsNullOrWhitespace($PAT) -and $PSBoundParameters.ContainsKey('PAT')) {
        Write-Verbose -Message "Using a custom PAT supplied in the parameters."
      } else {
        try {
          throw "Requested to use a PAT, but no custom PAT was supplied in the parameters or the environment variable 'SYSTEM_ACCESSTOKEN' was not set."
        } catch {
          $PSCmdlet.ThrowTerminatingError($_)
        }
      }
    } else {
      Write-Verbose 'The [UsePAT]-parameter was set to false, so an OAuth will be used to authenticate with the organization.'
      $PAT = ($UsePAT ? $PAT : $null)
    }
    try {
      $Header = New-ADOAuthHeader -PAT $PAT -AccessToken:($UsePAT ? $false : $true) -ErrorAction Stop
    } catch {
      $PSCmdlet.ThrowTerminatingError($_)
    }

    $getAzDoProjectSplat = @{
      CollectionUri = $CollectionUri
    }

    if ($PAT) {
      $getAzDoProjectSplat += @{
        PAT    = $PAT
        UsePAT = $true
      }
    }

    $Projects = Get-AzDoProject @getAzDoProjectSplat
    $ProjectId = ($Projects | Where-Object ProjectName -EQ $ProjectName).Projectid
  }
  Process {
    $params = @{
      uri         = "$CollectionUri/$ProjectId/_apis/distributedtask/variablegroups?api-version=7.1-preview.2"
      Method      = 'GET'
      Headers     = $header
      body        = $Body | ConvertTo-Json -Depth 99
      ContentType = 'application/json'
    }

    if ($PSCmdlet.ShouldProcess($CollectionUri)) {

      $result = (Invoke-RestMethod @params).value | ForEach-Object {
        [PSCustomObject]@{
          VariableGroupName = $_.name
          VariableGroupId   = $_.id
          Variables         = $_.variables
          CreatedOn         = $_.createdOn
          IsShared          = $_.isShared
          ProjectName       = $ProjectName
          CollectionURI     = $CollectionUri
        }
      }
      if ($VariableGroupName) {
        $result | Where-Object { $VariableGroupName -eq $_.VariableGroupName }
      } else {
        $result
      }
    } else {
      $body | Out-String
    }
  }
}
