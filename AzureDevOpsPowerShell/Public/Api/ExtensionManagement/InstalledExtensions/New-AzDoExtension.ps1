function New-AzDoExtension {
  <#
.SYNOPSIS
Installs an Azure DevOps extension in the specified organization.

.DESCRIPTION
The New-AzDoExtension cmdlet installs an Azure DevOps extension in the specified organization.
It uses the Azure DevOps REST API to perform the installation.

.PARAMETER CollectionUri
The URI of the Azure DevOps organization.

.PARAMETER ExtensionId
The ID of the extension to install.

.PARAMETER ExtensionPublisherId
The publisher ID of the extension to install.

.PARAMETER ExtensionVersion
The version of the extension to install. If not specified, the latest version will be installed.

.EXAMPLE
PS> New-AzDoExtension -CollectionUri "https://dev.azure.com/yourorganization" -ExtensionId "extensionId" -ExtensionPublisherId "publisherId"

This command installs the specified extension in the given Azure DevOps organization.

.EXAMPLE
PS> New-AzDoExtension -CollectionUri "https://dev.azure.com/yourorganization" -ExtensionId "extensionId" -ExtensionPublisherId "publisherId" -ExtensionVersion "1.0.0"

This command installs version 1.0.0 of the specified extension in the given Azure DevOps organization.

.NOTES
This cmdlet requires the Azure DevOps REST API and appropriate permissions to install extensions.

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
