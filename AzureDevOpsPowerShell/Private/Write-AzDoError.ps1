function Write-AzDoError {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [string]
    $Message
  )


  process {
    $errorRec = [System.Management.Automation.ErrorRecord]::new(
      [Exception]::new($Message),
      'ErrorID',
      [System.Management.Automation.ErrorCategory]::OperationStopped,
      'TargetObject'
    )

    $PScmdlet.ThrowTerminatingError($errorRec)
  }
}
