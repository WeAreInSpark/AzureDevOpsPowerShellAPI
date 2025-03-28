function Remove-AzDoEnvironment {
  <#
    .SYNOPSIS
    Remove Environment from Azure DevOps.

    .DESCRIPTION
    This function removes an environment from Azure DevOps.

    .EXAMPLE
    Remove-AzDoEnvironment -CollectionUri "https://dev.azure.com/contoso" -ProjectName "Project 1" -EnvironmentName "Environment 1"

    This example removes the environment named "Environment 1" from the specified project in Azure DevOps.

    .EXAMPLE
    Remove-AzDoEnvironment -CollectionUri "https://dev.azure.com/contoso" -ProjectName "Project 1" -EnvironmentName "Environment 1", "Environment 2"

    This example removes multiple environments ("Environment 1" and "Environment 2") from the specified project in Azure DevOps.

    .EXAMPLE
    Remove-AzDoEnvironment -CollectionUri "https://dev.azure.com/contoso" -ProjectName "Project 1" -EnvironmentName 1

    This example removes the environment with the ID 1 from the specified project in Azure DevOps.

    .EXAMPLE
    Remove-AzDoEnvironment -CollectionUri "https://dev.azure.com/contoso" -ProjectName "Project 1" -EnvironmentName 1, 2

    This example removes multiple environments with IDs 1 and 2 from the specified project in Azure DevOps.

    .EXAMPLE
    Remove-AzDoEnvironment -CollectionUri "https://dev.azure.com/contoso" -ProjectName "Project 1" -EnvironmentName "Environment 1", 2

    This example removes a mix of environments by name ("Environment 1") and ID (2) from the specified project in Azure DevOps.

    .LINK
    https://learn.microsoft.com/en-us/rest/api/azure/devops/environments/environments/delete?view=azure-devops-rest-7.2
    #>
  [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
  [OutputType([System.Collections.ArrayList])]
  param (
    # Collection URI. e.g. https://dev.azure.com/contoso.
    # Azure Pipelines has a predefined variable for this.
    [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
    [ValidateScript({ Validate-CollectionUri -CollectionUri $_ })]
    [string]
    $CollectionUri,

    # Name of the project.
    [Parameter(Mandatory, ValueFromPipelineByPropertyName, ValueFromPipeline)]
    [string]
    $ProjectName,

    # Id or name of the environment.
    # this is a string because a name can be used as well and will do a Get-AzDoEnvironment to get the ID.
    [Parameter(Mandatory, ValueFromPipelineByPropertyName, ValueFromPipeline)]
    [string[]]
    $EnvironmentName
  )

  begin {
    $result = @()
    Write-Verbose "Starting function: Remove-AzDoEnvironment"
  }

  Process {

    foreach ($Environment in $EnvironmentName) {
      if ($Environment -ne [int]) {
        $EnvironmentId = (Get-AzDoEnvironment -CollectionUri $CollectionUri -ProjectName $ProjectName -EnvironmentName $Environment).EnvironmentId

      } else {
        $EnvironmentId = $Environment
      }

      $params = @{
        uri     = "$CollectionUri/$ProjectName/_apis/pipelines/environments/$EnvironmentId"
        version = "7.2-preview.1"
        method  = 'DELETE'
      }

      if ($PSCmdlet.ShouldProcess($CollectionUri, "Remove environment id: $($PSStyle.Bold)$EnvironmentId$($PSStyle.Reset)")) {
        $result += Invoke-AzDoRestMethod @params
      } else {
        Write-Verbose "Calling Invoke-AzDoRestMethod with $($params| ConvertTo-Json -Depth 10)"
      }
    }
    if ($result) {
      $result | ForEach-Object {
        [PSCustomObject]@{
          CollectionUri = $CollectionUri
          ProjectName   = $ProjectName
          Response      = $_
        }
      }
    }
  }
}
