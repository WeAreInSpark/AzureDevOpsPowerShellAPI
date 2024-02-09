# Home

Automate tasks in Azure DevOps. Works on Windows, Linux and MacOS. There are a few good open-source projects already going on this topic (Like VS-Team),
but we believe that this project in more user-friendly.

## Installation

```powershell
# PowerShell 7.3 and below
Install-Module -Name AzureDevOpsPowerShellAPI -Scope CurrentUser

# PowerShell 7.4 and up
Install-PSresource -Name AzureDevOpsPowerShellAPI -Scope CurrentUser
```

## Basic Usage

### List all Azure DevOps projects

```powershell
$Params = @{
    CollectionUri = "https://dev.azure.com/contoso"
}
Get-AzDoProject @params
```

### Create an Azure DevOps Project

```powershell
New-AzDoProject -CollectionUri "https://dev.azure.com/contoso" -ProjectName "Project 1"
```

## Contributing

Contributions are welcome! Open a pull request to fix a bug, or open an issue to discuss a new feature or change.
