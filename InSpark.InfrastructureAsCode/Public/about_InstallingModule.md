# Installing module
In this document we will describe how to Register the powershell repository located at inspark.
We make use of Powershell secret management which has 1 downside. You will need to enter your password (One that you will create is this guide) every time you start powershell.

## Requirements

- Module Microsoft.PowerShell.SecretManagement
- Module Microsoft.PowerShell.SecretStore
- PAT with packaging read access

## Set-up the Powershell Repository
1. Set your PAT as secret string
```powershell
$patToken = "<PERSONAL_ACCESS_TOKEN>" | ConvertTo-SecureString -AsPlainText -Force
```

2. Set-up a credential variable
```powershell
$credsAzureDevopsServices = New-Object System.Management.Automation.PSCredential("<USER_NAME>", $patToken)
```

3. Register the Repository
```powershell
Register-PSRepository -Name "InSpark" -SourceLocation "https://pkgs.dev.azure.com/weareinspark/_packaging/PowerShell/nuget/v2" -PublishLocation "https://pkgs.dev.azure.com/weareinspark/_packaging/PowerShell/nuget/v2" -InstallationPolicy Trusted -Credential $credsAzureDevopsServices
```

## Set-up authentication with PAT
1. Install the modules
```powershell
Install-module -Name Microsoft.PowerShell.SecretManagement -force
Install-module -Name Microsoft.PowerShell.SecretStore -force
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
$Pat = Get-Secret Pat -AsPlainText
$env:VSS_NUGET_EXTERNAL_FEED_ENDPOINTS = @{
    endpointCredentials = @( 
        @{
            endpoint = "https://pkgs.dev.azure.com/weareinspark/_packaging/dylantest/nuget/v2"
            username = "<USER_NAME>"
            password = $Pat
        }
    )
} | ConvertTo-Json
```

## Reference
- [https://devblogs.microsoft.com/powershell-community/how-to-use-the-secret-modules/](https://devblogs.microsoft.com/powershell-community/how-to-use-the-secret-modules/)
- [https://docs.microsoft.com/en-us/azure/devops/artifacts/tutorials/private-powershell-library?view=azure-devops](https://docs.microsoft.com/en-us/azure/devops/artifacts/tutorials/private-powershell-library?view=azure-devops)
