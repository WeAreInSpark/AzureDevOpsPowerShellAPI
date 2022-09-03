---
external help file: InSpark.InfrastructureAsCode-help.xml
Module Name: InSpark.InfrastructureAsCode
online version:
schema: 2.0.0
---

# New-AadAppRegistrationSecret

## SYNOPSIS
This script creates a new certificate or secret for an existing app registration.

## SYNTAX

```
New-AadAppRegistrationSecret [-ObjectID] <String> [-ClientSecretName] <String> [-EndDate] <String>
 [-ManuallyConnectToGraph] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
This script creates a new certificate or secret for an existing app registration.

## EXAMPLES

### EXAMPLE 1
```
To create a secret that lasts 1 year for an existing app registration, input the Application (client) ID of the app registration, a name for $ClientSecretName and set
$ClientSecretDuration to 1.
```

## PARAMETERS

### -ObjectID
Application (client) ID of the app registration

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

### -ClientSecretName
Display name of the secret

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

### -EndDate
Duration of the secret until this date

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ManuallyConnectToGraph
Manually connect to Microsoft Graph

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs. The cmdlet is not run.

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

### New-AppRegistrationSecret -ClientSecretName <String> [-Append <Boolean>] -ClientId <String> -ClientSecretDuration <Int32> [-CreateCert <Boolean>] [-CertName <String>]
### [-KeyVaultName <String>] [<CommonParameters>]
### New-AppRegistrationSecret -ClientSecretName <String> [-Append <Boolean>] -ClientId <String> -EndDate <String> [-CreateCert <Boolean>] [-CertName <String>] [-KeyVaultName
### <String>] [<CommonParameters>]
## OUTPUTS

### New credentials in an app registration, and a variable with the secret.
## NOTES

## RELATED LINKS
