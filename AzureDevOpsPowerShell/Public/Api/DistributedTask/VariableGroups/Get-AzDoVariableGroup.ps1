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

    # Project where the variable group has to be created
    [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
    [string]
    $ProjectName,

    # Name of the variable group
    [Parameter(ValueFromPipelineByPropertyName, ValueFromPipeline)]
    [string[]]
    $VariableGroupName
  )

  begin {
    $result = New-Object -TypeName "System.Collections.ArrayList"
  }

  process {
    $params = @{
      uri     = "$CollectionUri/$ProjectName/_apis/distributedtask/variablegroups"
      version = "7.1-preview.2"
      method  = 'GET'
    }

    if ($PSCmdlet.ShouldProcess($CollectionUri, "Get Variable groups from: $($PSStyle.Bold)$ProjectName$($PSStyle.Reset)")) {
      $variableGroups = (Invoke-AzDoRestMethod @params).value

      if ($VariableGroupName) {
        foreach ($name in $VariableGroupName) {
          $variableGroup = $variableGroups | Where-Object { $_.name -eq $name }
          if (-not($variableGroup)) {
            Write-Error "Variable group $name not found"
          } else {
            $result.add($variableGroup ) | Out-Null
          }
        }
      } else {
        $result.add($variableGroups) | Out-Null
      }

    } else {
      $body | Out-String
    }
  }

  end {
    if ($result) {
      $result | ForEach-Object {
        [PSCustomObject]@{
          CollectionURI = $CollectionUri
          ProjectName   = $ProjectName
          Name          = $_.name
          Id            = $_.id
          Variables     = $_.variables
          CreatedOn     = $_.createdOn
          IsShared      = $_.isShared
        }
      }
    }
  }
}
