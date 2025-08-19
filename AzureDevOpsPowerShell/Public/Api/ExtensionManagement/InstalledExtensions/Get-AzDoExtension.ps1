
function Get-AzDoExtension {
  <#
.SYNOPSIS
Retrieves installed Azure DevOps extensions for a given organization.

.DESCRIPTION
The Get-AzDoExtension function retrieves installed extensions from an Azure DevOps organization.
It supports filtering by extension name and extension ID. The function uses the Azure DevOps REST API
to fetch the extensions and returns detailed information about each extension.

.PARAMETER CollectionUri
The URI of the Azure DevOps organization collection. This parameter is mandatory and accepts a string.

.PARAMETER ExtensionName
The name(s) of the extension(s) to look for. This parameter accepts an array of strings and is optional.

.PARAMETER ExtensionId
The ID(s) of the extension(s) to look for. This parameter accepts an array of strings and is optional.

.EXAMPLE
PS> Get-AzDoExtension -CollectionUri "https://dev.azure.com/organization" -ExtensionName "extension1"

Retrieves the extension named "extension1" from the specified Azure DevOps organization.

.EXAMPLE
PS> Get-AzDoExtension -CollectionUri "https://dev.azure.com/organization" -ExtensionId "extension-id-123"

Retrieves the extension with the ID "extension-id-123" from the specified Azure DevOps organization.

.NOTES
This function uses the Azure DevOps REST API to fetch the installed extensions.
Ensure you have the necessary permissions to access the API.

.LINK
https://learn.microsoft.com/en-us/rest/api/azure/devops/extensionmanagement/installed-extensions/get?view=azure-devops-rest-7.1&tabs=HTTP
#>
  [CmdletBinding(SupportsShouldProcess)]
  param (
    # Collection Uri of the organization
    [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
    [ValidateScript({ Validate-CollectionUri -CollectionUri $_ })]
    [string]
    $CollectionUri,

    # Name(s) of the extension(s) to look for
    [Parameter(ValueFromPipelineByPropertyName, ValueFromPipeline)]
    [string[]]
    $ExtensionName,

    # Id(s) of the extension(s) to look for
    [Parameter(ValueFromPipelineByPropertyName, ValueFromPipeline)]
    [string[]]
    $ExtensionId
  )

  begin {
    Write-Verbose "Starting function: Get-AzDoExtension"
  }

  process {
    # For extensions a different base URI is used: https://learn.microsoft.com/en-us/rest/api/azure/devops/extensionmanagement/installed-extensions/get?view=azure-devops-rest-7.1&tabs=HTTP
    $extensionCollectionUri = $CollectionUri -replace "//dev", "//extmgmt.dev"

    $params = @{
      uri     = "$extensionCollectionUri/_apis/extensionmanagement/installedextensions"
      version = "7.1-preview.1"
      method  = "GET"
    }

    if ($PSCmdlet.ShouldProcess($CollectionUri, "Get Extension(s) in $CollectionUri")) {
      $result = (Invoke-AzDoRestMethod @params).value | Where-Object { -not $ExtensionName -and -not $ExtensionId -or $_.extensionName -in $ExtensionName -or $_.extensionId -in $ExtensionId }
    } else {
      Write-Verbose "Calling Invoke-AzDoRestMethod with $($params| ConvertTo-Json -Depth 10)"
    }
  }
  end {
    if ($result) {
      $result | ForEach-Object {
        [PSCustomObject]@{
          CollectionURI            = $CollectionUri
          ExtensionCollectionURI   = $extensionCollectionUri
          ExtensionId              = $_.extensionId
          ExtensionName            = $_.extensionName
          ExtensionPublisherId     = $_.PublisherId
          ExtensionPublisherName   = $_.PublisherName
          ExtensionVersion         = $_.version
          ExtensionBaseUri         = $_.baseUri
          ExtensionFallbackBaseUri = $_.fallbackBaseUri
        }
      }
    }
  }
}
