---
external help file: AzureDevOpsPowerShell-help.xml
Module Name: AzureDevOpsPowerShell
online version:
schema: 2.0.0
---

# New-AzDoServiceConnection

## SYNOPSIS
Function to create a service connection in Azure DevOps

## SYNTAX

### WorkloadIdentityFederation
```
New-AzDoServiceConnection -CollectionUri <String> -ProjectName <String> -ServiceConnectionName <String>
 [-Description <String>] [-Force] [-AsDraft] [-ScopeLevel <String>] [-AuthenticationType <String>]
 [-SubscriptionId <String>] [-SubscriptionName <String>] [-TenantId <String>] [-ServiceprincipalId <String>]
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### ServiceprincipalCertificate
```
New-AzDoServiceConnection -CollectionUri <String> -ProjectName <String> -ServiceConnectionName <String>
 [-Description <String>] [-Force] -ScopeLevel <String> [-AuthenticationType <String>] -TenantId <String>
 -ServiceprincipalId <String> [-KeyVaultName <String>] [-CertName <String>]
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### ServiceprincipalSecret
```
New-AzDoServiceConnection -CollectionUri <String> -ProjectName <String> -ServiceConnectionName <String>
 [-Description <String>] [-Force] -ScopeLevel <String> [-AuthenticationType <String>] -TenantId <String>
 -ServiceprincipalId <String> [-ServiceprincipalSecret <String>] [-ProgressAction <ActionPreference>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

### Subscription
```
New-AzDoServiceConnection -CollectionUri <String> -ProjectName <String> -ServiceConnectionName <String>
 [-Description <String>] [-Force] [-AuthenticationType <String>] -SubscriptionId <String>
 -SubscriptionName <String> [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### ManagementGroup
```
New-AzDoServiceConnection -CollectionUri <String> -ProjectName <String> -ServiceConnectionName <String>
 [-Description <String>] [-Force] [-AuthenticationType <String>] -ManagementGroupId <String>
 -ManagementGroupName <String> [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Function to create a service connection in Azure DevOps

## EXAMPLES

### EXAMPLE 1
```
$params = @{
    CollectionUri               = "https://dev.azure.com/contoso"
    ProjectName                 = "Project 1"
    SubscriptionId              = "00000-00000-00000-00000-00000"
    SubscriptionName            = "Subscription 1"
    Tenantid                    = "11111-11111-11111-11111-11111"
    Serviceprincipalid          = "1c03163f-7e4e-4fab-8b41-6f040a8361b9"
    KeyVaultName                = "kv01"
    CertName                    = "Cert01"
    AuthenticationType          = "spnCertificate"
    ProjectID                   = "1f31cb4d-5a69-419f-86f0-ee3a8ed9ced2"
    Name                        = "Project 1"
}
New-AzDoServiceConnection @params
```

This example creates a new Azure DevOps service connection with a Certificate from a KeyVault in Azure.

### EXAMPLE 2
```
$params = @{
  CollectionUri         = "https://dev.azure.com/contoso"
  ProjectName           = "Project 1"
  ServiceConnectionName = "ServiceConnection1"
  Description           = 'Service connection for Azure Resource Manager'
  SubscriptionId        = "00000-00000-00000-00000-00000"
  SubscriptionName      = "Subscription 1"
  TenantId              = 'aee976c7-a678-4b4b-884a-cc6cfccad0f9'
  Serviceprincipalid    = "1c03163f-7e4e-4fab-8b41-6f040a8361b9"
  AuthenticationType    = 'WorkloadIdentityFederation'
  AsDraft               = $true
  Force                 = $true
}
New-AzDoServiceConnection @params
```

This example creates a new Azure DevOps service connection with WorkloadIdentityFederation as authentication type.

## PARAMETERS

### -CollectionUri
Collection Uri.
e.g.
https://dev.azure.com/contoso.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ProjectName
Name of the project.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ServiceConnectionName
Name of the service connection.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Description
Description to add to the service connection.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Force
Parameter help description

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -AsDraft
Create the service connection as draft (useful when creating a WorkloadIdentityFederation based service connection).

```yaml
Type: SwitchParameter
Parameter Sets: WorkloadIdentityFederation
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ScopeLevel
Scope level (Subscription or ManagementGroup).

```yaml
Type: String
Parameter Sets: WorkloadIdentityFederation
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

```yaml
Type: String
Parameter Sets: ServiceprincipalCertificate, ServiceprincipalSecret
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -AuthenticationType
AuthenticationType (spnSecret or spnCertificate).

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: WorkloadIdentityFederation
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -SubscriptionId
ID of the subscriptionn.

```yaml
Type: String
Parameter Sets: WorkloadIdentityFederation
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

```yaml
Type: String
Parameter Sets: Subscription
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -SubscriptionName
Name of the subscription.

```yaml
Type: String
Parameter Sets: WorkloadIdentityFederation
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

```yaml
Type: String
Parameter Sets: Subscription
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ManagementGroupId
ID of the Management group.

```yaml
Type: String
Parameter Sets: ManagementGroup
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ManagementGroupName
Name of the Management group.

```yaml
Type: String
Parameter Sets: ManagementGroup
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -TenantId
ID of the tenant.

```yaml
Type: String
Parameter Sets: WorkloadIdentityFederation
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

```yaml
Type: String
Parameter Sets: ServiceprincipalCertificate, ServiceprincipalSecret
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ServiceprincipalId
Client ID of the app registration.

```yaml
Type: String
Parameter Sets: WorkloadIdentityFederation
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

```yaml
Type: String
Parameter Sets: ServiceprincipalCertificate, ServiceprincipalSecret
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ServiceprincipalSecret
App secret of the app registation.

```yaml
Type: String
Parameter Sets: ServiceprincipalSecret
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -KeyVaultName
KeyVault name where the certificate is stored.

```yaml
Type: String
Parameter Sets: ServiceprincipalCertificate
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -CertName
Name of the certificate

```yaml
Type: String
Parameter Sets: ServiceprincipalCertificate
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ProgressAction
{{ Fill ProgressAction Description }}

```yaml
Type: ActionPreference
Parameter Sets: (All)
Aliases: proga

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
