function Add-AzDoVariableGroupVariable {
  <#
    .SYNOPSIS
        This script adds variables to variable groups in a given project.
    .DESCRIPTION
        This script adds variables to variable groups in a given project.
        When used in a pipeline, you can use the pre defined CollectionUri, ProjectName and AccessToken (PAT) variables.
    .EXAMPLE
        $splat = @{
            CollectionUri     = 'https://dev.azure.com/ChristianPiet0452/'
            ProjectName       = 'Ditproject'
            PAT = '*******************'
            VariableGroupName = @('Group1', 'Group2')
            Variables         = @{
                test = @{
                    value = 'test'
                }
                kaas = @{
                    value = 'kaas'
                }
            }
        }

        Add-AzDoVariableGroupVariable @splat

        This example creates a new Variable Group with a variable "test = test".

    .EXAMPLE
        $splat = @{
            CollectionUri     = 'https://dev.azure.com/ChristianPiet0452/'
            ProjectName       = 'Ditproject'
            VariableGroupName = @('Group1', 'Group2')
        }
        Get-AzDoVariableGroup @splat | Add-AzDoVariableGroupVariable -Variables @{ test = @{ value = 'test' } }

        This example creates a few new Variable Groups with a variable "test = test".
    .OUTPUTS
        PSObject
    .NOTES
    #>
  [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
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
    [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
    [string]
    $VariableGroupName,

    # Variable names and values
    [Parameter(Mandatory, ValueFromPipelineByPropertyName, ValueFromPipeline)]
    [hashtable]
    $Variables
  )

  begin {
    $result = @()
  }

  process {
    $groups = Get-AzDoVariableGroup -CollectionUri $CollectionUri -ProjectName $ProjectName

    # Get the variable group based on it's name and match to ID for URI
    $group = $groups | Where-Object { $_.VariableGroupName -eq $VariableGroupName }
    # $group.Variables isn't a hashtable, so it needs to be converted and back to be able
    $group.Variables = ($group.Variables | ConvertTo-Json | ConvertFrom-Json -AsHashtable)

    $trimmedvars = @{}
    foreach ($variable in $Variables.GetEnumerator()) {
      $trimmedvars += @{ $variable.Key = @{ value = $variable.Value } }
    }

    $body = @{
      variables = $trimmedvars + $group.Variables
      name      = $group.VariableGroupName
    }

    $params = @{
      uri         = "$CollectionUri/$ProjectName/_apis/distributedtask/variablegroups/$($group.VariableGroupId)?api-version=7.1-preview.1"
      Method      = 'PUT'
      Headers     = $script:header
      body        = $Body | ConvertTo-Json -Depth 99
      ContentType = 'application/json'
    }

    if ($PSCmdlet.ShouldProcess($CollectionUri, "Add Variables to Variable Group named: $($PSStyle.Bold)$name$($PSStyle.Reset)")) {
      Write-Information "Creating variables in variable group $VariableGroupName"
      $result += Invoke-AzDoRestMethod @params
    } else {
      $body | Out-String
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
