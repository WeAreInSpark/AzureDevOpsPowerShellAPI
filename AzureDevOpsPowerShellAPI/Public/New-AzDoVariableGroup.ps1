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
    $trimmedvars = @{}
    foreach ($variable in $Variables.GetEnumerator()) {
      $trimmedvars += @{ $variable.Key = @{ value = $variable.Value } }
    }

    $body = @{
      description                    = $Description
      name                           = $VariableGroupName
      variables                      = $trimmedvars
      variableGroupProjectReferences = @(
        @{
          name             = $ProjectName
          description      = $Description
          projectReference = @{
            id = $ProjectId
          }
        }
      )
    }

    $params = @{
      uri         = "$CollectionUri/$ProjectId/_apis/distributedtask/variablegroups?api-version=7.2-preview.2"
      Method      = 'POST'
      Headers     = $script:header
      body        = $Body | ConvertTo-Json -Depth 99
      ContentType = 'application/json'
    }

    if ($PSCmdlet.ShouldProcess($ProjectName, "Create Variable Group named: $($PSStyle.Bold)$name$($PSStyle.Reset)")) {

      $result = (Invoke-RestMethod @params)
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
