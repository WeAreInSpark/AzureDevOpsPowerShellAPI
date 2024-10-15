function New-AzDoExtension {
  [CmdletBinding(SupportsShouldProcess)]
  param (
    # Collection Uri of the organization
    [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
    [ValidateScript({ Validate-CollectionUri -CollectionUri $_ })]
    [string]
    $CollectionUri,

    # Name(s) of the extension(s) to look for
    [Parameter(Mandatory, ValueFromPipelineByPropertyName, ValueFromPipeline)]
    [string]
    $ExtensionId,

    # Id(s) of the extension(s) to look for
    [Parameter(Mandatory, ValueFromPipelineByPropertyName, ValueFromPipeline)]
    [string]
    $ExtensionPublisherId,

    # Version of the extension to install
    [Parameter(ValueFromPipelineByPropertyName, ValueFromPipeline)]
    [string]
    $ExtensionVersion
  )

  begin {
    Write-Verbose "Starting function: New-AzDoExtensions"
  }

  process {
    # For extensions a different base URI is used: https://learn.microsoft.com/en-us/rest/api/azure/devops/extensionmanagement/installed-extensions/get?view=azure-devops-rest-7.1&tabs=HTTP
    $extensionCollectionUri = $CollectionUri -replace "//dev", "//extmgmt.dev"

    if ($ExtensionVersion) {
      $uri = "$extensionCollectionUri/_apis/extensionmanagement/installedextensionsbyname/$ExtensionPublisherId/$ExtensionId/$ExtensionVersion"
    } else {
      $uri = "$extensionCollectionUri/_apis/extensionmanagement/installedextensionsbyname/$ExtensionPublisherId/$ExtensionId"
    }

    $params = @{
      uri     = $uri
      version = "7.1-preview.1"
      method  = "POST"
    }

    if ($PSCmdlet.ShouldProcess($CollectionUri, "Install Extension $ExtensionName in $CollectionUri")) {
      $result = (Invoke-AzDoRestMethod @params).value
    } else {
      Write-Verbose "Calling Invoke-AzDoRestMethod with $($params| ConvertTo-Json -Depth 10)"
    }
  }
  end {
    $result
  }
}
