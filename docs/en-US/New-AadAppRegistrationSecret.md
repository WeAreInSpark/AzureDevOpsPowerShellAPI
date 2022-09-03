---
external help file: InSpark.InfrastructureAsCode-help.xml
Module Name: InSpark.InfrastructureAsCode
online version:
schema: 2.0.0
---

# New-AadAppRegistrationSecret

## SYNOPSIS
Creates a secret and set it to the App registration in Azure AD.

## SYNTAX

```
New-AadAppRegistrationSecret [-ObjectID] <String> [-ClientSecretName] <String> [-EndDate] <String>
 [-ManuallyConnectToGraph] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Creates a secret and uploads it as an authentication factor to the App registration in Azure AD.
The secret will also be uploaded to an Azure KeyVault.

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

This example will create a new secret for the app registration, upload it to the Azure KeyVault and add it to the Application Registration in Azure AD.

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
Enddate of validity of the secret

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### The Appsecret
## NOTES

## RELATED LINKS
