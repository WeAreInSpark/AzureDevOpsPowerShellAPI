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
            VariableGroupName = 'Group1'
            Variables         = @{
                test = 'test'
                kaas = 'kaas'
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
        Get-AzDoVariableGroup @splat | Add-AzDoVariableGroupVariable -Variables @{ test = 'test' }

        This example creates a few new Variable Groups with a variable "test = test".
    .OUTPUTS
        PSObject
    .NOTES
    #>
  [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
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
    [Alias('Name')]
    [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
    [string]
    $VariableGroupName,

    # Variable names and values
    [Parameter(Mandatory, ValueFromPipelineByPropertyName, ValueFromPipeline)]
    [hashtable]
    $Variables,

    # Overwrite existing values
    [Parameter()]
    [Switch]
    $Force
  )
  process {
    Write-Verbose "Starting function: Add-AzDoVariableGroupVariable"

    Write-Information "Starting function: Add-AzDoVariableGroupVariable"
    $groups = Get-AzDoVariableGroup -CollectionUri $CollectionUri -ProjectName $ProjectName

    # Get the variable group based on it's name and match to ID for URI
    $group = $groups | Where-Object { $_.VariableGroupName -eq $VariableGroupName }

    $body = @{
      variables = @{}
      name      = $group.VariableGroupName
    }

    # This adds the existing variables to the payload of the PUT-request
    foreach ($existingVariable in $Group.Variables.GetEnumerator()) {
      $body.variables[$existingVariable.key] = @{value = $existingVariable.Value }
      if ([string]::IsNullOrWhiteSpace($body.variables[$existingVariable.key])) {
        $body.variables[$existingVariable.key] = @{ value = "" }
      }
    }

    # This adds the new variables to the payload of the PUT-request
    foreach ($variable in $Variables.GetEnumerator()) {
      # This will overwrite without throwing. User supplied wins.
      if ($Force) {
        $body.variables[$variable.Key] = @{ value = $variable.Value }
        if ([string]::IsNullOrWhiteSpace($body.variables[$variable.Key].value)) {
          $body.variables[$variable.Key] = @{ value = "" }
        }
        Write-Verbose "Overwriting variable '$($variable.Key)' in variable group '$VariableGroupName' in project '$ProjectName' in collectionURI '$CollectionUri'"
        continue
      }
      try {
        $body.variables.Add($variable.Key, @{ value = $variable.Value } )
      } catch {
        Write-Error "Trying to add a variable that already exists. Use -Force to overwrite."
        $PSCmdlet.ThrowTerminatingError((Write-AzDoError "Error adding variable '$($variable.Key)' to variable group '$VariableGroupName' in project '$ProjectName' in collectionURI '$CollectionUri' Error: $_"))
      }
    }

    $params = @{
      uri         = "$CollectionUri/$ProjectName/_apis/distributedtask/variablegroups/$($group.VariableGroupId)"
      Method      = 'PUT'
      body        = $Body
      ContentType = 'application/json'
      Version     = '7.1-preview.1'
    }

    if ($PSCmdlet.ShouldProcess($CollectionUri, "Add Variables to Variable Group named: $($PSStyle.Bold)$name$($PSStyle.Reset)")) {
      try {
        Invoke-AzDoRestMethod @params | ForEach-Object {
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
      } catch {
        $PSCmdlet.ThrowTerminatingError((Write-AzDoError "Error adding variables to variable group '$VariableGroupName' in project '$ProjectName' in collectionURI '$CollectionUri' Error: $_"))
      }
    } else {
      Write-Verbose "Calling Invoke-AzDoRestMethod with $($params| ConvertTo-Json -Depth 10)"
    }
  }
}
