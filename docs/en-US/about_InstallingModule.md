# Installing module
In this document we will describe how to register the PowerShell repository located at InSpark.
We use Powershell Secret Management with a local stored secret vault. This implementation has 1 downside, you will need to enter your password (One that you will create is this guide) every time you start PowerShell.
## Requirements
- PAT with Packaging (Read Access) to weareinspark organization
| :warning: WARNING                                                                                                       |
| :---------------------------------------------------------------------------------------------------------------------- |
| Contain the permission of the PAT to (Packaging (Read Access)), since it's going to be exposed to the environment vars. |
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
# This prepares authentication with the nuget packagefeed
$env:VSS_NUGET_EXTERNAL_FEED_ENDPOINTS = @{
    endpointCredentials = @(
        @{
            endpoint = "https://pkgs.dev.azure.com/weareinspark/_packaging/powershell/nuget/v2"
            username = "<REPLACE ME>" # Replace with your e-mail (User Principal Name)
            password = (Get-Secret -Name Pat -AsPlainText)
        }
    )
} | ConvertTo-Json
# This creates a persistant PSCredential so you can easily install modules from the repository
$InSparkAzureDevopsArtifacts = New-Object System.Management.Automation.PSCredential("<REPLACE ME>", (Get-Secret -Name Pat)) # Replace with your e-mail (User Principal Name)
```
## Install Azure Artifact Credential Provider
1. Follow the steps to install the [Azure Artifact Credential Provider](https://github.com/microsoft/artifacts-credprovider#setup)
## Set-up the Powershell Repository
1. Restart PowerShell session
2. Register the Repository
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
3. Validate that the setup succeeded
```powershell
Find-Module -Repository InSpark
```
4. Install the module ()
```powershell
Install-Module -Name InSpark.InfrastructureAsCode -Scope CurrentUser -Repository InSpark -Credential $InSparkAzureDevopsArtifacts
```
## Troubleshooting
### Query Url ... is invalid
**Issue**
In some cases PowerShell returns errors during `Find-Module` or `Install-Module`.
PowerShell will return errors like:
```powershell
Find-Module -Repository InSpark
WARNING: Query Url https://pkgs.dev.azure.com/weareinspark/_packaging/PowerShell/nuget/v2 is invalid.
```
PowerShell sometimes registers a NuGet Provider as a PackageSource when registering a PSRepository instead of just the PowerShellGet entry.
You can check this by performing:
```powershell
Get-PackageSource
Name                             ProviderName     IsTrusted  Location
----                             ------------     ---------  --------
PSGallery                        PowerShellGet    True       https://www.powershellgallery.com/api/v2
InSpark                          PowerShellGet    True       https://pkgs.dev.azure.com/weareinspark/_packaging/powershell/nuget/v2
InSpark                          NuGet            True       https://pkgs.dev.azure.com/weareinspark/_packaging/powershell/nuget/v2
```
**Fix**
You can remove the NuGet PackageSource with:
```powershell
Unregister-PackageSource -Name InSpark -ProviderName NuGet
```
Make sure to validate that functionality is restored:
```powershell
Find-Module -Repository InSpark
```
## Reference
- [https://devblogs.microsoft.com/powershell-community/how-to-use-the-secret-modules/](https://devblogs.microsoft.com/powershell-community/how-to-use-the-secret-modules/)
- [https://docs.microsoft.com/en-us/azure/devops/artifacts/tutorials/private-powershell-library?view=azure-devops](https://docs.microsoft.com/en-us/azure/devops/artifacts/tutorials/private-powershell-library?view=azure-devops)
