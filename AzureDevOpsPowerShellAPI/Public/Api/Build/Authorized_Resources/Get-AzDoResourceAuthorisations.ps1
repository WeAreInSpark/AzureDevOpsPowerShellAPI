function Get-AzDoResourceAuthorisations {
  <#
.SYNOPSIS
    Gets information about a repo in Azure DevOps.
.DESCRIPTION
    Gets information about 1 repo if the parameter $Name is filled in. Otherwise it will list all the repo's.
.EXAMPLE
    $Params = @{
        CollectionUri = "https://dev.azure.com/contoso"
        PAT = "***"
        ProjectName = "Project 1"
        Name "Repo 1"
    }
    Get-AzDoRepo -CollectionUri = "https://dev.azure.com/contoso" -PAT = "***" -ProjectName = "Project 1"

    This example will list all the repo's contained in 'Project 1'.

.OUTPUTS
    PSObject with repo(s).
.NOTES
#>
  [CmdletBinding()]
  param (
    # Collection Uri of the organization
    [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
    [string]
    $CollectionUri,

    # PAT to authenticate with the organization
    [Parameter()]
    [string]
    $PAT,

    # Name of the resource to get information about
    [Parameter()]
    [string]
    $Name,

    # Project where the Repos are contained
    [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
    [string]
    $ProjectName,

    # Type of the resource to get information about
    [Parameter(ValueFromPipelineByPropertyName)]
    [String[]]
    [ValidateSet('Service Connections', 'Variable Groups', 'Agent Pools', 'Environments', 'Repositories')]
    $Type = @('Service Connections', 'Variable Groups', 'Agent Pools', 'Environments', 'Repositories')
  )

  Begin {
    if (-not($script:header)) {
      try {
        New-ADOAuthHeader -PAT $PAT -ErrorAction Stop
      } catch {
        $PSCmdlet.ThrowTerminatingError($_)
      }
    }
    switch ($true) {
      { 'Service Connections' -in $Type } {
        $serviceConnections = Get-AzDoServiceConnection -CollectionUri $CollectionUri -ProjectName $ProjectName -ServiceConnectionName $Name -PAT $PAT
      }
      { 'Variable Groups' -in $Type } {
        $variableGroups = Get-AzDoVariableGroup -CollectionUri $CollectionUri -ProjectName $ProjectName -Name $Name -PAT $PAT
      }
      { 'Agent Pools' -in $Type } {

      }
      { 'Environments' -in $Type } {
        $environments = Get-AzDoEnvironment -CollectionUri $CollectionUri -ProjectName $ProjectName -Name $Name -PAT $PAT
      }
      { 'Repositories' -in $Type } {
        $repositories = Get-AzDoRepo -CollectionUri $CollectionUri -ProjectName $ProjectName -Name $Name -PAT $PAT
      }
      Default {}
    }

    $result = New-Object -TypeName "System.Collections.ArrayList"
  }

  Process {
    $params = @{
      Method      = 'GET'
      Headers     = $script:header
      ContentType = 'application/json'
    }

    switch ($true) {
      { -not ([string]::IsNullOrEmpty($serviceConnections.id -as [string])) } {
        $serviceConnectionPipelinePermissions = (Invoke-RestMethod @params -Uri "$CollectionUri/$ProjectName/_apis/pipelines/pipelinepermissions/endpoint/$($serviceConnections.id)?api-version=7.2-preview.1" )
        $result.Add($serviceConnectionPipelinePermissions) | Out-Null
      }
      { -not ([string]::IsNullOrEmpty($variableGroups.id -as [string])) } {
        $variableGroupPipelinePermissions = (Invoke-RestMethod @params -Uri "$CollectionUri/$ProjectName/_apis/pipelines/pipelinepermissions/variablegroup/$($variableGroups.id)?api-version=7.2-preview.1" )
        $result.Add($variableGroupPipelinePermissions) | Out-Null
      }
      { 'Agent Pools' -in $Type } {

      }
      { -not ([string]::IsNullOrEmpty($environments.id -as [string])) } {
        $environmentPipelinePermissions = (Invoke-RestMethod @params -Uri "$CollectionUri/$ProjectName/_apis/pipelines/pipelinepermissions/environment/$($environments.id)?api-version=7.2-preview.1" )
        $result.Add($environmentPipelinePermissions) | Out-Null
      }
      { -not ([string]::IsNullOrEmpty($repositories.id -as [string])) } {
        $repositoryPipelinePermissions = (Invoke-RestMethod @params -Uri "$CollectionUri/$ProjectName/_apis/pipelines/pipelinepermissions/repo/$($repositories.id)?api-version=7.2-preview.1" )
        $result.Add($repositoryPipelinePermissions) | Out-Null
      }
      Default {}
    }

  }
  End {
    if ($result) {
      $result | ForEach-Object {
        $_
      }
    }
  }
}

