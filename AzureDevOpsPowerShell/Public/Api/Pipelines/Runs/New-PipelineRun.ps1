function New-PipelineRun {
  [CmdletBinding(SupportsShouldProcess)]
  param (
    # Collection Uri of the organization
    [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
    [string]
    $CollectionUri,

    # Project where the pipeline is defined
    [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
    [string]
    $ProjectName,

    # Project where the pipeline will be created.
    [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
    [int]$PipelineId,

    # Project where the pipeline will be created.
    [Parameter(ValueFromPipelineByPropertyName)]
    [object]$Parameters,

    # Project where the pipeline will be created.
    [Parameter(ValueFromPipelineByPropertyName)]
    [bool]$PreviewRun,

    # Project where the pipeline will be created.
    [Parameter(ValueFromPipelineByPropertyName)]
    [array]$StagesToSkip,

    # Project where the pipeline will be created.
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]$Branch
  )

  begin {
    Write-Verbose "Starting function: New-PipelineRun"

    $body = @{}
  }

  process {
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

    if ($PSCmdlet.ShouldProcess("PiplineId: $PipelineId", "New run")) {
      try {
        $response = Invoke-AzDoRestMethod @params

        $response
      } catch {
        Write-AzDoError -message $_
      }
    } else {
      Write-Verbose "Calling Invoke-AzDoRestMethod with $($params| ConvertTo-Json -Depth 10)"
    }
  }
}
