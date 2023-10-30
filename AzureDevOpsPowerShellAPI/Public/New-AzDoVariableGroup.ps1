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
    $PAT = $env:SYSTEM_ACCESSTOKEN,

    # Switch to use PAT instead of OAuth
    [Parameter()]
    [switch]
    $UsePAT = $false,

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
    foreach ($name in $VariableGroupName) {
      $trimmedvars = @{}
      foreach ($variable in $Variables.GetEnumerator()) {
        $trimmedvars += @{ $variable.Key = @{ value = $variable.Value } }
      }

      $body = @{
        description                    = $Description
        name                           = $name
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
        Headers     = $Header
        body        = $Body | ConvertTo-Json -Depth 99
        ContentType = 'application/json'
      }

      if ($PSCmdlet.ShouldProcess($ProjectName, "Create Variable Group named: $($PSStyle.Bold)$name$($PSStyle.Reset)")) {

                (Invoke-RestMethod @params) | ForEach-Object {
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
      } else {
        $body | Out-String
      }
    }
  }
}
