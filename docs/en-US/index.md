# Home

Powershell module for API to DevOps services

## Overview

Automate tasks in Azure DevOps and Azure AD. Works on Windows Linux and MacOS.

## Installation

```powershell
Install-Module -Name InSpark.InfrastructureAsCode -Scope CurrentUser -Repository InSpark -Credential $InSparkAzureDevopsArtifacts
```

For more information on how to setup access to our repository, please checkout [our guide](https://weareinspark.github.io/BRC.PS.InfrastructureAsCode/about_InstallingModule/). The [source documentation on installation can also be found here](https://github.com/WeAreInSpark/BRC.PS.InfrastructureAsCode/blob/main/docs/en-US/about_InstallingModule.md).

## Basic Usage

### List all Azure DevOps projects

```powershell
$Params = @{
    CollectionUri = "https://dev.azure.com/contoso"
    PAT = "***"
}
Get-AzDoProject @params
```

### Create an Azure DevOps Project

```powershell
New-AzDoProject -CollectionUri "https://dev.azure.com/contoso" -PAT "***" -ProjectName "Project 1"
```

## Contributing
Contributions are welcome! Open a pull request to fix a bug, or open an issue to discuss a new feature or change.

