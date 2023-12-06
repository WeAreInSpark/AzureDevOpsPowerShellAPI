function Clear-AzDoAuthHeader {
  <#
  .SYNOPSIS
    This script clears the header variable used for authentication.
  .DESCRIPTION
    This script clears the header variable used for authentication.
  .NOTES
    This script is used internally by the module and should not be used directly.
  .EXAMPLE
    Clear-AzDoAuthHeader

    This example clears the header variable used for authentication.
  #>

  $script:header = $null
}
