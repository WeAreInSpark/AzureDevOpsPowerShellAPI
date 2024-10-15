function Get-AzDoExtension {
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
