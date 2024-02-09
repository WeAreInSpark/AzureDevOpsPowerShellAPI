# Authentication

## Users

When you use the module locally you only have to log in to your Azure tenant with 'Azure PowerShell'.
The module will then fetch a Access token with `Get-AzAccessToken`.

```powershell
Connect-AzAccount

Get-AzDoProject -CollectionUri = "https://dev.azure.com/contoso"
```

## Azure resources

When using the module in for example an Automation Account or an Azure Function you can use the Managed Identity to
give access to the azure DevOps resources. The module can again use the access token to access the resources.

```powershell
Connect-AzAccount -Identity

Get-AzDoProject -CollectionUri = "https://dev.azure.com/contoso"
```

## Azure DevOps

When you use Azure DevOps you can use of the Azure DevOps token to authenticate to Azure. Do not forget to disable the protection setting. You can find the docmentation [here](https://learn.microsoft.com/en-us/azure/devops/pipelines/process/access-tokens?view=azure-devops&tabs=yaml#protect-access-to-repositories-in-yaml-pipelines)

```yaml
steps:
  - powershell: |
      Set-AzdoPat -Pat "$env:SYSTEM_ACCESSTOKEN"

      Get-AzDoProject -CollectionUri = "https://dev.azure.com/contoso"
    env:
      SYSTEM_ACCESSTOKEN: $(System.AccessToken)
```
