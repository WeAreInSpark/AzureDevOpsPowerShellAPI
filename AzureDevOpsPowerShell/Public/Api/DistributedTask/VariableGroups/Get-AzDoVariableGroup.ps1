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
    [ValidateScript({ Validate-CollectionUri -CollectionUri $_ })]
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
  process {
    Write-Verbose "Starting function: Get-AzDoVariableGroup"

    $params = @{
      uri     = "$CollectionUri/$ProjectName/_apis/distributedtask/variablegroups"
      version = "7.1-preview.2"
      method  = 'GET'
    }

    if ($PSCmdlet.ShouldProcess($CollectionUri, "Get Variable groups from: $($PSStyle.Bold)$ProjectName$($PSStyle.Reset)")) {
      try {
        $variableGroups = (Invoke-AzDoRestMethod @params).value
      } catch {
        $PSCmdlet.ThrowTerminatingError((Write-AzDoError -Message "Failed to get variable groups from $ProjectName in $CollectionUri Error: $_" ))
      }
      $variableGroups | Where-Object { -not $VariableGroupName -or $_.Name -in $VariableGroupName } | ForEach-Object {
        $variablesObject = $_.variables | ConvertTo-Json -Depth 10 | ConvertFrom-Json -AsHashtable -Depth 10

        $variablesOutput = @{}
        foreach ($item in $variablesObject.GetEnumerator()) {
          $variablesOutput[$item.Key] = $item.value.value
        }

        [PSCustomObject]@{
          CollectionURI     = $CollectionUri
          ProjectName       = $ProjectName
          VariableGroupName = $_.name
          VariableGroupId   = $_.id
          Variables         = $variablesOutput
          CreatedOn         = $_.createdOn
          IsShared          = $_.isShared
        }
      }
    } else {
      Write-Verbose "Calling Invoke-AzDoRestMethod with $($params| ConvertTo-Json -Depth 10)"
    }
  }
}
