function Set-AzDoPAT {
  <#
  .SYNOPSIS
    This script sets the header variable with a PAT.
  .DESCRIPTION
    This script sets the header variable with a PAT.
  .NOTES
    This function can be used to use a PAT for authentication instead of an Azure PowerShell access token.
  .EXAMPLE
    Set-AzDoPAT -Pat '***'

    This example sets the header variable used for authentication with a PAT.
  #>
  [CmdletBinding(SupportsShouldProcess)]
  param (
    # PAT used for authentication
    [Parameter(Mandatory, ValueFromPipelineByPropertyName, ValueFromPipeline)]
    [string]
    $Pat
  )

  process {
    if ($PSCmdlet.ShouldProcess()) {
      New-AzDoAuthHeader -Pat $Pat
    } else {
      Write-Verbose "Calling New-AzDoAuthHeader with pat"
    }
  }
}
