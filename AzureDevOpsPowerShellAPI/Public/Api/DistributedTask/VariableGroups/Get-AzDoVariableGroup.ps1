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
    $PAT,

    # Project where the variable group has to be created
    [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
    [string]
    $ProjectName,

    # Name of the variable group
    [Parameter(ValueFromPipelineByPropertyName, ValueFromPipeline)]
    [string]
    $Name
  )

  Begin {
    if (-not($script:header)) {

      try {
        New-ADOAuthHeader -PAT $PAT -ErrorAction Stop
      } catch {
        $PSCmdlet.ThrowTerminatingError($_)
      }
    }

    $ProjectId = (Get-AzDoProject -CollectionUri $CollectionUri -PAT $PAT | Where-Object ProjectName -EQ $ProjectName).Projectid

  }

  Process {
    $params = @{
      uri         = "$CollectionUri/$ProjectId/_apis/distributedtask/variablegroups?api-version=7.1-preview.2"
      Method      = 'GET'
      Headers     = $script:header
      body        = $Body | ConvertTo-Json -Depth 99
      ContentType = 'application/json'
    }

    if ($PSCmdlet.ShouldProcess($CollectionUri)) {

      $result = (Invoke-RestMethod @params).value | ForEach-Object {
        [PSCustomObject]@{
          Name          = $_.name
          Id            = $_.id
          Variables     = $_.variables
          CreatedOn     = $_.createdOn
          IsShared      = $_.isShared
          ProjectName   = $ProjectName
          CollectionURI = $CollectionUri
        }
      }

      if ($Name) {
        $result | Where-Object { $Name -eq $_.Name }
      } else {
        $result
      }
    } else {
      $body | Out-String
    }
  }
}
