function Get-PipelineRun {
  <#
.SYNOPSIS
  Retrieves pipeline run information from Azure DevOps for a specified pipeline within a project.
.DESCRIPTION
  The `Get-PipelineRun` function fetches details about one or more pipeline runs from an Azure DevOps project.
  It requires the collection URI, project name, and pipeline ID. Optionally, specific run IDs can be provided
  to filter the results. The function uses the `Invoke-AzDoRestMethod` cmdlet to make the REST API call to
  Azure DevOps and returns the run details.
.EXAMPLE
  Get-PipelineRun -CollectionUri "https://dev.azure.com/YourOrg" -ProjectName "YourProject" -PipelineId 123

  Retrieves all runs for the specified pipeline in the given project.
.EXAMPLE
  Get-PipelineRun -CollectionUri "https://dev.azure.com/YourOrg" -ProjectName "YourProject" -PipelineId 123 -RunId 456

  Retrieves the details of the specified run (with ID 456) for the given pipeline.
.OUTPUTS
  Returns an array of pipeline run objects. If specific run IDs are provided, only the matching runs are returned.
.NOTES
#>
  [CmdletBinding(SupportsShouldProcess)]
  param (
    # Collection Uri of the organization
    [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
    [ValidateScript({ Validate-CollectionUri -CollectionUri $_ })]
    [string]
    $CollectionUri,

    # The name of the project containing the pipeline
    [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
    [string]
    $ProjectName,

    # The ID of the pipeline to retrieve the run for
    [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
    [int]$PipelineId,

    # The ID of the run to retrieve. If not provided, all runs for the pipeline are returned.
    [Parameter(ValueFromPipelineByPropertyName)]
    [int[]]$RunId
  )

  process {
    $params = @{
      Uri     = "$CollectionUri/$ProjectName/_apis/pipelines/$PipelineId/runs"
      Version = "6.0"
      Method  = 'GET'
    }

    if ($PSCmdlet.ShouldProcess("Pipeline Id: $PipelineId", "Get run")) {
      $response = Invoke-AzDoRestMethod @params
      $runs = $response.value

      if (-not $RunId) {
        return $runs
      }

      $runs | Where-Object { $_.id -in $RunId }
    } else {
      Write-Verbose "Calling Invoke-AzDoRestMethod with $($params| ConvertTo-Json -Depth 10)"
    }
  }
}

