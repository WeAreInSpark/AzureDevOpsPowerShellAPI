function Remove-AzDoExtension {
  <#
  .SYNOPSIS
  Removes an Azure DevOps extension from an organization.

  .DESCRIPTION
  The `Remove-AzDoExtension` cmdlet removes an Azure DevOps extension from a specified organization.
  It uses the Azure DevOps REST API to perform the deletion.

  .PARAMETER CollectionUri
  Specifies the URI of the Azure DevOps organization. This parameter is mandatory and accepts a string.

  .PARAMETER ExtensionId
  Specifies the ID of the extension to be removed. This parameter is mandatory and accepts a string.

  .PARAMETER ExtensionPublisherId
  Specifies the publisher ID of the extension to be removed. This parameter is mandatory and accepts a string.

  .EXAMPLE
  PS> Remove-AzDoExtension -CollectionUri "https://dev.azure.com/yourorganization" -ExtensionId "yourExtensionId" -ExtensionPublisherId "yourPublisherId"

  This command removes the specified extension from the specified Azure DevOps organization.

  .NOTES
  For more information on the Azure DevOps REST API, see:
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
