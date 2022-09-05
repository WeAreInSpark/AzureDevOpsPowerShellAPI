# Installing module
In this document we will describe how to register the PowerShell repository located at InSpark.
We use Powershell Secret Management with a local stored secret vault. This implementation has 1 downside, you will need to enter your password (One that you will create is this guide) every time you start PowerShell.
## Requirements
- PAT with Packaging (Read Access) to weareinspark organization
| :warning: WARNING |
|:---------------------------|
| Contain the PAT to this permission (Packaging (Read Access)), since it's going to be exposed to the environment vars. |
|:---------------------------|...
## Set-up authentication with PAT
1. Install the required modules
```powershell
# This module handles fetching secrets
Install-Module -Name Microsoft.PowerShell.SecretManagement -Scope CurrentUser -Repository PSGallery -Force
# This module stores the secrets safely on your machine
Install-Module -Name Microsoft.PowerShell.SecretStore -Scope CurrentUser -Repository PSGallery -Force
```
2. Set the secret
```powershell
Set-Secret -Name Pat -Secret "<PERSONAL_ACCESS_TOKEN>"
```
3. Enter a password for own use.
4. Open your profile
```powershell
code $PROFILE
```
5. Save the following code in your profile
```powershell
Import-Module -Name 'Microsoft.PowerShell.SecretManagement'
Import-Module -Name 'Microsoft.PowerShell.SecretStore'
$env:VSS_NUGET_EXTERNAL_FEED_ENDPOINTS = @{
    endpointCredentials = @(
        @{
            endpoint = "https://pkgs.dev.azure.com/weareinspark/_packaging/powershell/nuget/v2"
            username = "<REPLACE ME>" # Replace with your e-mail (User Principal Name)
            password = (Get-Secret -Name Pat -AsPlainText)
        }
    )
} | ConvertTo-Json

$InSparkAzureDevopsArtifacts = New-Object System.Management.Automation.PSCredential("<REPLACE ME>", (Get-Secret -Name Pat)) # Replace with your e-mail (User Principal Name)
```
## Set-up the Powershell Repository
1. Register the Repository
```powershell
$registerPSRepositorySplat = @{
    Name = "InSpark"
    SourceLocation = "https://pkgs.dev.azure.com/weareinspark/_packaging/powershell/nuget/v2"
    PublishLocation = "https://pkgs.dev.azure.com/weareinspark/_packaging/powershell/nuget/v2"
    InstallationPolicy = 'Trusted'
    Credential = $InSparkAzureDevopsArtifacts
}
Register-PSRepository @registerPSRepositorySplat
```
## Reference
- [https://devblogs.microsoft.com/powershell-community/how-to-use-the-secret-modules/](https://devblogs.microsoft.com/powershell-community/how-to-use-the-secret-modules/)
- [https://docs.microsoft.com/en-us/azure/devops/artifacts/tutorials/private-powershell-library?view=azure-devops](https://docs.microsoft.com/en-us/azure/devops/artifacts/tutorials/private-powershell-library?view=azure-devops)
