<#
.SYNOPSIS
  Write an error to the pipeline
.DESCRIPTION
  This function will write an error to the pipeline
.EXAMPLE
  Write-AzDoError -Message 'This is an error'

  This example will write an error to the pipeline with the message 'This is an error'
#>



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
