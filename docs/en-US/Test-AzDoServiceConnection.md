---
external help file: AzureDevOpsPowerShell-help.xml
Module Name: AzureDevOpsPowerShell
online version:
schema: 2.0.0
---

# Test-AzDoServiceConnection

## SYNOPSIS
Function to create a service connection in Azure DevOps

## SYNTAX

```
Test-AzDoServiceConnection [-ProjectName] <String> [-CollectionUri] <String> [[-PAT] <String>]
 [-ServiceConnectionName] <String> [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
Function to create a service connection in Azure DevOps

## EXAMPLES

### EXAMPLE 1
```
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
Test-AzDoServiceConnection @params
```

This example creates a new Azure DevOps service connection with a Certificate from a KeyVault in Azure.

## PARAMETERS

### -ProjectName
Name of the Project in Azure DevOps.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
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
Position: 2
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

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ServiceConnectionName
Collection Uri.
e.g.
https://dev.azure.com/contoso.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 4
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
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
