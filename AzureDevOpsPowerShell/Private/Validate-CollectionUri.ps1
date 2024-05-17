function Validate-CollectionUri {
  [CmdletBinding()]
  param (
    # Parameter help description
    [Parameter(Mandatory)]
    [string]
    $CollectionUri
  )

  if ($CollectionUri -notmatch '^https:\/\/dev\.azure\.com\/\w+') {
    Write-AzdoError "CollectionUri must be a valid Azure DevOps collection URI starting with 'https://dev.azure.com/'"
  } else {
    $true
  }
}
