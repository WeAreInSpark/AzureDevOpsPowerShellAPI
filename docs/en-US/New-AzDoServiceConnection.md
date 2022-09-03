---
<<<<<<< HEAD
<<<<<<< HEAD
external help file: InSpark.InfrastructureAsCode-help.xml
Module Name: InSpark.InfrastructureAsCode
=======
external help file: InfrastructureAsCode-help.xml
Module Name: InfrastructureAsCode
>>>>>>> 690e7a4 (Working version)
=======
external help file: InSpark.InfrastructureAsCode-help.xml
Module Name: InSpark.InfrastructureAsCode
>>>>>>> 18d4dd8 (InitialVersion)
online version:
schema: 2.0.0
---

# New-AzDoServiceConnection

## SYNOPSIS
Function to create a service connection in Azure DevOps

## SYNTAX

### Subscription
```
<<<<<<< HEAD
<<<<<<< HEAD
New-AzDoServiceConnection -Name <String> -CollectionUri <String> [-PAT <String>] -ProjectName <String>
=======
New-AzDoServiceConnection -Name <String> -CollectionUri <String> -PAT <String> -ProjectName <String>
>>>>>>> 690e7a4 (Working version)
=======
New-AzDoServiceConnection -Name <String> -CollectionUri <String> [-PAT <String>] -ProjectName <String>
>>>>>>> 18d4dd8 (InitialVersion)
 -ProjectID <String> [-Description <String>] [-ScopeLevel <String>] -SubscriptionId <String>
 -SubscriptionName <String> -Tenantid <String> -Serviceprincipalid <String> [-AuthenticationType <String>]
 [-Serviceprincipalkey <String>] [-KeyVaultName <String>] [-CertName <String>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### ManagementGroup
```
<<<<<<< HEAD
<<<<<<< HEAD
New-AzDoServiceConnection -Name <String> -CollectionUri <String> [-PAT <String>] -ProjectName <String>
=======
New-AzDoServiceConnection -Name <String> -CollectionUri <String> -PAT <String> -ProjectName <String>
>>>>>>> 690e7a4 (Working version)
=======
New-AzDoServiceConnection -Name <String> -CollectionUri <String> [-PAT <String>] -ProjectName <String>
>>>>>>> 18d4dd8 (InitialVersion)
 -ProjectID <String> [-Description <String>] [-ScopeLevel <String>] -ManagementGroupId <String>
 -ManagementGroupName <String> -Tenantid <String> -Serviceprincipalid <String> [-AuthenticationType <String>]
 [-Serviceprincipalkey <String>] [-KeyVaultName <String>] [-CertName <String>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
Function to create a service connection in Azure DevOps
\<\<\<\<\<\<\< HEAD:InSpark.InfrastructureAsCode/Public/New-AzDoServiceConnection.ps1
=======
=======
{{ Fill in the Description }}
>>>>>>> 18d4dd8 (InitialVersion)
=======
Function to create a service connection in Azure DevOps
>>>>>>> 690e7a4 (Working version)
=======
{{ Fill in the Description }}
>>>>>>> 18d4dd8 (InitialVersion)

## EXAMPLES

### EXAMPLE 1
```
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 18d4dd8 (InitialVersion)
New-AzDoServiceConnection -CollectionUri $CollectionUri `
    -PAT $PAT `
    -ProjectName "Project 1" `
    -SubscriptionId "00000-00000-00000-00000-00000" `
    -SubscriptionName "Subscription 1" `
    -Tenantid "11111-11111-11111-11111-11111" `
    -Serviceprincipalid "1c03163f-7e4e-4fab-8b41-6f040a8361b9" `
    -ServicePrincipalCertificate $ServicePrincipalCertificate `
    -AuthenticationType 'spnCertificate' `
    -ProjectID '1f31cb4d-5a69-419f-86f0-ee3a8ed9ced2' `
    -Name 'Project 1'
<<<<<<< HEAD
```

Service connection with certificate

### EXAMPLE 2
```
New-AzDoServiceConnection -CollectionUri $CollectionUri `
    -PAT $PAT `
    -ProjectName "Project 1" `
    -SubscriptionId "00000-00000-00000-00000-00000" `
    -SubscriptionName "Subscription 1" `
    -Tenantid "11111-11111-11111-11111-11111" `
    -Serviceprincipalid "1c03163f-7e4e-4fab-8b41-6f040a8361b9" `
    -Serviceprincipalkey $Serviceprincipalkey
```

Service connection with key
=======
$params = @{
    CollectionUri               = "https://dev.azure.com/contoso"
    PAT                         = "***"
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
>>>>>>> 690e7a4 (Working version)
=======
```

Service connection with certificate

### EXAMPLE 2
```
New-AzDoServiceConnection -CollectionUri $CollectionUri `
    -PAT $PAT `
    -ProjectName "Project 1" `
    -SubscriptionId "00000-00000-00000-00000-00000" `
    -SubscriptionName "Subscription 1" `
    -Tenantid "11111-11111-11111-11111-11111" `
    -Serviceprincipalid "1c03163f-7e4e-4fab-8b41-6f040a8361b9" `
    -Serviceprincipalkey $Serviceprincipalkey
```

Service connection with key
>>>>>>> 18d4dd8 (InitialVersion)

## PARAMETERS

### -Name
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

### -PAT
PAT to get access to Azure DevOps.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

<<<<<<< HEAD
<<<<<<< HEAD
Required: False
Position: Named
Default value: $env:SYSTEM_ACCESSTOKEN
=======
Required: True
=======
Required: False
>>>>>>> 18d4dd8 (InitialVersion)
Position: Named
Default value: None
>>>>>>> 690e7a4 (Working version)
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

### -ProjectID
ID of the project.

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

### -ScopeLevel
Scope level (Subscription or ManagementGroup).

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Subscription
Accept pipeline input: False
Accept wildcard characters: False
```

### -SubscriptionId
ID of the subscriptionn.

```yaml
Type: String
Parameter Sets: Subscription
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SubscriptionName
Name of the subscription.

```yaml
Type: String
Parameter Sets: Subscription
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
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
Accept pipeline input: False
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
Accept pipeline input: False
Accept wildcard characters: False
```

### -Tenantid
ID of the tenant.

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

### -Serviceprincipalid
Client ID of the app registration.

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

### -AuthenticationType
AuthenticationType (spnKey or spnCertificate).

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: SpnKey
Accept pipeline input: False
Accept wildcard characters: False
```

### -Serviceprincipalkey
App secret of the app registation.

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

### -KeyVaultName
<<<<<<< HEAD
<<<<<<< HEAD
Certificate of the App registration in .PEM format.
=======
KeyVault name where the certificate is stored.
>>>>>>> 690e7a4 (Working version)
=======
Certificate of the App registration in .PEM format.
>>>>>>> 18d4dd8 (InitialVersion)

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

### -CertName
<<<<<<< HEAD
<<<<<<< HEAD
{{ Fill CertName Description }}
=======
Name of the certificate
>>>>>>> 690e7a4 (Working version)
=======
{{ Fill CertName Description }}
>>>>>>> 18d4dd8 (InitialVersion)

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

### -WhatIf
<<<<<<< HEAD
<<<<<<< HEAD
Shows what would happen if the cmdlet runs. The cmdlet is not run.
=======
Shows what would happen if the cmdlet runs.
The cmdlet is not run.
>>>>>>> 690e7a4 (Working version)
=======
Shows what would happen if the cmdlet runs. The cmdlet is not run.
>>>>>>> 18d4dd8 (InitialVersion)

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
When you are using Azure DevOps with Build service Access token, make sure the setting 'Protect access to repositories in YAML pipelin' is off.
<<<<<<< HEAD
\>\>\>\>\>\>\> 690e7a4 (Working version):InfrastructureAsCode/Public/New-AzDoServiceConnection.ps1
=======
>>>>>>> 690e7a4 (Working version)

## RELATED LINKS
