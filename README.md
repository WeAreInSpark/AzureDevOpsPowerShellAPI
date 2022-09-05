<h1 align="center">
  <a href="https://inspark.nl">
    <img alt="InSpark" src="https://insparkteamplayer.inspark.nl/assets/partner/inspark-logo.png" height="150">
  </a>
  <br>InfrastructureAsCode<br>
</h1>

 <p align="center">
    PowerShell module to automate DevOps services
    <br />
    <a href="https://weareinspark.github.io/BRC.PS.InfrastructureAsCode/"><strong>Explore the docs »</strong></a>
  </p>
<p align="center">
  <a href="https://dev.azure.com/weareinspark/Expertteam%20Deployment%20and%20Automation/_artifacts/feed/PowerShell/NuGet/InSpark.InfrastructureAsCode">
   <img alt="Azure Artifact" src="https://feeds.dev.azure.com/weareinspark/_apis/public/Packaging/Feeds/PowerShell/Packages/200425db-4a18-4620-9e56-e793d845934c/Badge">
  </a>
</p>

<p align="center">
  <a href="CODE_OF_CONDUCT.md">Code of conduct</a> |
  <a href=".github/CONTRIBUTING.md">Contributing</a> |
  <a href="LICENSE">License</a> |
  <a href="https://github.com/WeAreInSpark/BRC.PS.InfrastructureAsCode/releases">Releases</a> |

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

