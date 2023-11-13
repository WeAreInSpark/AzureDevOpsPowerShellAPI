function New-AzDoVariableGroup {
  <#
    .SYNOPSIS
        This script creates a variable group with at least 1 variable in a given project.
    .DESCRIPTION
        This script creates a variable group with at least 1 variable in a given project.
        When used in a pipeline, you can use the pre defined CollectionUri, ProjectName and AccessToken (PAT) variables.
    .EXAMPLE
        $params = @{
            Collectionuri = 'https://dev.azure.com/weareinspark/'
            PAT = '*******************'
            ProjectName = 'Project 1'
            VariableGroupName = 'VariableGroup1'
            Variables = @{ test = @{ value = 'test' } }
            Description = 'This is a test'
        }
        New-AzDoVariableGroup @params

        This example creates a new Variable Group with a variable "test = test".

    .EXAMPLE
        $params = @{
            Collectionuri = 'https://dev.azure.com/ChristianPiet0452/'
            ProjectName = 'Ditproject'
            Variables = @{ test = @{ value = 'test' } }
            Description = 'This is a test'
            PAT = $PAT
        }
        @(
            'dev-group'
            'acc-group'
            'prd-group'
        ) | New-AzDoVariableGroup @params

        This example creates a few new Variable Groups with a variable "test = test".
    .OUTPUTS
        PSobject
    .NOTES
    #>
  [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
  param (
    # Collection Uri of the organization
    [Parameter(Mandatory)]
    [string]
    $CollectionUri,

    # PAT to authentice with the organization
    [Parameter()]
    [string]
    $PAT,

    # Project where the variable group has to be created
    [Parameter(Mandatory)]
    [string]
    $ProjectName,

    # Name of the variable group
    [Parameter(Mandatory, ValueFromPipelineByPropertyName, ValueFromPipeline)]
    [string[]]
    $VariableGroupName,

    # Variable names and values
    [Parameter(Mandatory)]
    [hashtable]
    $Variables,

    # Description of the variable group
    [Parameter()]
    [string]
    $Description
  )

  Begin {
    $body = New-Object -TypeName "System.Collections.ArrayList"
  }

  Process {

    $params = @{
      uri     = "$CollectionUri/$ProjectName/_apis/distributedtask/variablegroups"
      version = "7.2-preview.2"
      method  = 'POST'
      pat     = $PAT
    }

    $trimmedvars = @{}
    foreach ($variable in $Variables.GetEnumerator()) {
      $trimmedvars += @{ $variable.Key = @{ value = $variable.Value } }
    }

    foreach ($name in $VariableGroupName) {
      $body = @{
        description                    = $Description
        name                           = $name
        variables                      = $trimmedvars
        variableGroupProjectReferences = @(
          @{
            name             = $name
            description      = $Description
            projectReference = @{
              name = $ProjectName
            }
          }
        )
      }

      if ($PSCmdlet.ShouldProcess($ProjectName, "Create Variable Group named: $($PSStyle.Bold)$name$($PSStyle.Reset)")) {

        $result = $body | Invoke-AzDoRestMethod @params

        [PSCustomObject]@{
          VariableGroupName = $result.name
          VariableGroupId   = $result.id
          Variables         = $result.variables
          CreatedOn         = $result.createdOn
          IsShared          = $result.isShared
          ProjectName       = $ProjectName
          CollectionURI     = $CollectionUri
        }

      } else {
        $body | Out-String
      }
    }
  }
}
