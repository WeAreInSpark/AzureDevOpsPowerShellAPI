function New-AzDoPipelineRun {
  <#
.SYNOPSIS
  Initiates a new run of an Azure DevOps pipeline.

.DESCRIPTION
  The New-AzDoPipelineRun function starts a new run for a specified Azure DevOps pipeline.
  It supports various parameters to customize the pipeline run, including the collection URI, project name, pipeline ID, branch, parameters, preview run flag, and stages to skip.
  This function leverages the Azure DevOps REST API to trigger the pipeline run.

.EXAMPLE
  $newPipelineRunSplat = @{
    CollectionUri = "https://dev.azure.com/organization"
    ProjectName = "SampleProject"
    PipelineId = 123
    StagesToSkip = @("Stage1", "Stage2")
  }

  New-AzDoPipelineRun @newPipelineRunSplat
  This command initiates a new run of the pipeline with ID 123 in the "SampleProject" project.

.EXAMPLE
  $newPipelineRunSplat = @{
      CollectionUri = "https://dev.azure.com/organization"
      ProjectName = "SampleProject"
      PipelineId = 123
      Branch = "dev"
      Parameters = @{param1 = "value1"; param2 = "value2"}
  }

  New-AzDoPipelineRun @newPipelineRunSplat
  This command initiates a new run of the pipeline with ID 123 in the "SampleProject" project, targeting the "dev" branch.

.OUTPUTS
  System.Management.Automation.PSCustomObject

  Returns the response from the Azure DevOps REST API, which includes details of the pipeline run.
#>
  [CmdletBinding(SupportsShouldProcess)]
  param (
    # Collection Uri of the organization
    [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
    [ValidateScript({ Validate-CollectionUri -CollectionUri $_ })]
    [string]
    $CollectionUri,

    # Project where the pipeline is defined
    [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
    [string]
    $ProjectName,

    # Pipeline ID of the pipeline to start the run for
    [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
    [int]$PipelineId,

    # Parameters to pass to the pipeline
    [Parameter(ValueFromPipelineByPropertyName)]
    [object]$Parameters,

    # If the run should be a preview run
    [Parameter(ValueFromPipelineByPropertyName)]
    [switch]$PreviewRun,

    # Stages to skip in the pipeline run
    [Parameter(ValueFromPipelineByPropertyName)]
    [array]$StagesToSkip,

    # Branch to run the pipeline for
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]$Branch
  )
  process {
    $body = @{}

    if ($PreviewRun) {
      $body.Add("previewRun", $PreviewRun)
    }

    if ($Branch) {
      $resources = @{
        repositories = @{
          self = @{
            refName = $Branch
          }
        }
      }

      $body.Add("resources", $resources)
    }

    if ($StagesToSkip) {
      $body.Add("stagesToSkip", $StagesToSkip)
    }

    if ($Parameters) {
      $body.Add("templateParameters", $Parameters)
    } else {
      $body.Add("templateParameters", @{})
    }

    $params = @{
      Uri     = "$CollectionUri/$ProjectName/_apis/pipelines/$PipelineId/runs"
      Version = "7.0"
      Method  = 'POST'
      Body    = $body
    }

    if ($PSCmdlet.ShouldProcess("PipelineId: $PipelineId", "Trigger a new run on pipeline")) {
      try {
        $output = Invoke-AzDoRestMethod @params
        [PSCustomObject]@{
          PipelineId    = $output.pipeline.id
          RunId         = $output.id
          RunName       = $output.name
          CreatedAt     = $output.createdDate
          ProjectName   = $ProjectName
          CollectionUri = $CollectionUri
          URL           = $output.url
          Resources     = $output.resources
        }
      } catch {
        Write-AzDoError -Message $_
      }
    } else {
      Write-Verbose "Calling Invoke-AzDoRestMethod with $($params| ConvertTo-Json -Depth 10)"
    }
  }
}
