---
external help file: Module-help.xml
Module Name: Module
online version:
schema: 2.0.0
---

# New-AadGroup

## SYNOPSIS
This script creates a new app registration with a certificate or secret.

## SYNTAX

```
New-AadGroup [-Name] <String> [-MailNickName] <String> [[-MailEnabled] <Boolean>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
This script creates a new app registration with a certificate or secret.

## EXAMPLES

### EXAMPLE 1
```
To create an app registration with a secret that lasts 1 year, choose a name for $AppRegName, a name for $ClientSecretName and set $ClientSecretDuration to 1.
```

## PARAMETERS

### -Name
Name of the app registration

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

### -MailNickName
{{ Fill MailNickName Description }}

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

### -MailEnabled
{{ Fill MailEnabled Description }}

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: True
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

### New-AppRegistration -AppRegName <String> -ClientSecretName <String> -EndDate <String> [-Append <Boolean>] [-CreateCert <Boolean>] [-CertName <String>] [-KeyVaultName <String>]
### [<CommonParameters>]
### New-AppRegistration -AppRegName <String> -ClientSecretName <String> -ClientSecretDuration <Int32> [-Append <Boolean>] [-CreateCert <Boolean>] [-CertName <String>] [-KeyVaultName
### <String>] [<CommonParameters>]
## OUTPUTS

### New app registration with credentials, and variables with the ID and secret.
## NOTES

## RELATED LINKS
