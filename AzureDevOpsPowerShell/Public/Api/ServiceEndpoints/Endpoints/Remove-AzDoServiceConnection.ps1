function Remove-AzDoServiceConnection {
  <#
.SYNOPSIS
    Removes the service connection in an Azure DevOps project.
.DESCRIPTION
    Removes the service connection in an Azure DevOps project.
.EXAMPLE
    $Params = @{
      CollectionUri = "https://dev.azure.com/contoso"
      ProjectName = "Project 1"
      ServiceConnectionName = 'ServiceConnection1', 'ServiceConnection2'
    }
    Get-AzDoServiceConnection @getAzDoServiceConnectionSplat

    This example will remove the service connections in the array

.OUPUTS
    System.Management.Automation.PSCustomObject
#>
  [CmdletBinding(SupportsShouldProcess)]
  param (
    [Parameter(Mandatory)]
    [string]$CollectionUri,

    [Parameter(Mandatory)]
    [string]$ProjectName,

    [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
    [string[]]$ServiceConnectionName
  )

  begin {
    Write-Verbose "Removing service connection(s) '$($ServiceConnectionName -join ', ')'"
    $ProjectId = Get-AzDoProjectId -CollectionUri $CollectionUri -ProjectName $ProjectName
    if ($null -eq $ProjectId) {
      Write-AzDoError -Message "Project '$ProjectName' not found in collection '$CollectionUri'"
      exit 1
    }
  }

  process {
    foreach ($ServiceConnection in $ServiceConnectionName) {
      $ServiceConnectionId = Get-AzDoServiceConnection -CollectionUri $CollectionUri -ProjectName $ProjectName -ServiceConnectionName $ServiceConnection | Select-Object -ExpandProperty Id
      if ($ServiceConnectionId) {
        $params = @{
          uri     = "$CollectionUri/_apis/serviceendpoint/endpoints/$ServiceConnectionId?projectIds=$ProjectId"
          version = '7.1-preview.4'
          method  = 'DELETE'
        }
        if ($PSCmdlet.ShouldProcess("Service Connection '$ServiceConnection' in project '$ProjectName'")) {
          try {
            Invoke-AzDoRestMethod @params
          } catch {
            Write-AzDoError -Message $_
          }
        }
      }
    }
  }

  end {
    Write-Verbose "Service connection(s) '$($ServiceConnectionName -join ', ') removed"
  }
}
