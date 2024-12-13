function Write-AzDoError {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [string]
    $Message
  )


  process {
    [System.Management.Automation.ErrorRecord]::new(
      [Exception]::new($Message),
      'ErrorID',
      [System.Management.Automation.ErrorCategory]::OperationStopped,
      'TargetObject'
    )
  }
}
