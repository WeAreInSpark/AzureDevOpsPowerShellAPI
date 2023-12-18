# Home

Powershell module for API to DevOps services

## Overview

Automate tasks in Azure DevOps. Works on Windows Linux and MacOS.

## Installation

```powershell
Install-PSResource -Name AzureDevOpsPowerShell
```

## Basic Usage

The project does not support a PAT for now. We know this makes it not easy to use within Azure DevOps pipelines, but for now we focus on delivering a MVP first.

### List all Azure DevOps projects

```powershell
Connect-AzAccount

Get-AzDoProject -CollectionUri "https://dev.azure.com/contoso"
```

### Create an Azure DevOps Project

```powershell
Connect-AzAccount

New-AzDoProject -CollectionUri "https://dev.azure.com/contoso" -ProjectName "testproject1"
```

## Contributing

Contributions are welcome! Open a pull request to fix a bug, or open an issue to discuss a new feature or change.
