---
external help file: Module-help.xml
Module Name: Module
online version:
schema: 2.0.0
---

# New-AadAppRegistrationSecret

## SYNOPSIS
Creates a secret for the App registration

## SYNTAX

```
New-AadAppRegistrationSecret -ObjectID <String> -ClientSecretName <String> -EndDate <String> [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Creates a secret for the App registration.
The secret will get uploaded to an Azure KeyVault.

## EXAMPLES

### EXAMPLE 1
```
$newAadAppRegistrationSecretSplat = @{
    ObjectID = "00000-00000-00000-00000-00000"
    ClientSecretName = "Secret 1"
    EndDate = "2022-01-01"
}
New-AadAppRegistrationSecret @newAadAppRegistrationSecretSplat
```

This example will create a new secret for the app registration.

## PARAMETERS

### -ObjectID
Application (client) ID of the app registration

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

### -ClientSecretName
Display name of the secret

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

### -EndDate
Duration of the secret until this date

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

## OUTPUTS

### The Appsecret
## NOTES

## RELATED LINKS
