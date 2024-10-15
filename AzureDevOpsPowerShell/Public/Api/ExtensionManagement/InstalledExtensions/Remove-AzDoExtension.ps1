function Remove-AzDoExtension {
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
    $ExtensionPublisherId
  )

  begin {
    Write-Verbose "Starting function: Remove-AzDoExtension"
  }

  process {
    # For extensions a different base URI is used: https://learn.microsoft.com/en-us/rest/api/azure/devops/extensionmanagement/installed-extensions/get?view=azure-devops-rest-7.1&tabs=HTTP
    $extensionCollectionUri = $CollectionUri -replace "//dev", "//extmgmt.dev"

    $params = @{
      uri     = "$extensionCollectionUri/_apis/extensionmanagement/installedextensionsbyname/$ExtensionPublisherId/$ExtensionId"
      version = "7.1-preview.1"
      method  = "DELETE"
    }

    if ($PSCmdlet.ShouldProcess($CollectionUri, "Remove $ExtensionId from organization $CollectionUri")) {
      $result = (Invoke-AzDoRestMethod @params).value
    } else {
      Write-Verbose "Calling Invoke-AzDoRestMethod with $($params| ConvertTo-Json -Depth 10)"
    }
  }
  end {
    $result
  }
}
