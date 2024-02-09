<h1 align="center">
  <a href="https://inspark.nl">
    <img alt="InSpark" src="docs/en-US/assets/inspark-logo-semi.svg" height="150">
  </a>
  <br>AzureDevOpsPowerShellAPI<br>
</h1>

<p align="center">
  PowerShell module to automate tasks in Azure DevOps.
  <br />
  <a href="https://weareinspark.github.io/AzureDevOpsPowerShellAPI/"><strong>Explore the docs »</strong></a>
</p>

<p align="center">
  <a href="https://github.com/WeAreInSpark/AzureDevOpsPowerShellAPI/issues">
    <img alt="GitHub Workflow Status" src="https://img.shields.io/github/issues/WeAreInSpark/AzureDevOpsPowerShellAPI?style=flat-square">
  </a>
  <a href="https://www.powershellgallery.com/packages/AzureDevOpsPowerShell">
    <img alt="PowerShell Gallery" src="https://img.shields.io/powershellgallery/dt/AzureDevOpsPowerShell?label=PowerShell%20Gallery&logo=PowerShell%20Gallery%20Downloads&style=flat-square">
  </a>
  <a href="https://www.powershellgallery.com/packages/AzureDevOpsPowerShell">
    <img alt="PowerShell Gallery Version" src="https://img.shields.io/powershellgallery/v/AzureDevOpsPowerShell?label=released%20version&style=flat-square">
  </a>
</p>

<p align="center">
  <a href="https://github.com/WeAreInSpark/AzureDevOpsPowerShellAPI/blob/main/LICENSE">
    <img alt="GitHub" src="https://img.shields.io/github/license/WeAreInSpark/AzureDevOpsPowerShellAPI?style=flat-square">
  </a>
</p>

## Overview

Automate tasks in Azure DevOps and Azure AD. Works on Windows Linux and MacOS.

## Installation

```powershell

Install-Module -Name AzureDevOpsPowerShellAPI -Scope CurrentUser -Repository InSpark -Credential $InSparkAzureDevopsArtifacts

```

For more information on how to setup access to our repository, please checkout [our guide](https://weareinspark.github.io/AzureDevOpsPowerShellAPI/about_InstallingModule/). The [source documentation on installation can also be found here](https://github.com/WeAreInSpark/AzureDevOpsPowerShellAPI/blob/main/docs/en-US/about_InstallingModule.md).

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
