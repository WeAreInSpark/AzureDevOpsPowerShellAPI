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
    $result = New-Object -TypeName "System.Collections.ArrayList"
  }

  Process {

    $params = @{
      uri     = "$CollectionUri/$ProjectName/_apis/distributedtask/variablegroups"
      version = "7.2-preview.2"
      method  = 'POST'
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
        $result.add(($body | Invoke-AzDoRestMethod @params)) | Out-Null
      } else {
        $body | Out-String
      }
    }
  }

  end {
    if ($result) {
      $result | ForEach-Object {
        [PSCustomObject]@{
          CollectionURI     = $CollectionUri
          ProjectName       = $ProjectName
          VariableGroupName = $_.name
          VariableGroupId   = $_.id
          Variables         = $_.variables
          CreatedOn         = $_.createdOn
          IsShared          = $_.isShared
        }
      }
    }
  }
}
