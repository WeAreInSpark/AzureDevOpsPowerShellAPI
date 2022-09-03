---
external help file: InSpark.InfrastructureAsCode-help.xml
Module Name: InSpark.InfrastructureAsCode
online version:
schema: 2.0.0
---

# New-AadGroup

## SYNOPSIS
This script creates a new app registration with a certificate or secret.

## SYNTAX

```
New-AadGroup [-GroupName] <String> [-MailNickName] <String> [-MailEnabled]
 [-Description] <ValidateNotNullOrEmptyAttribute> [-ManuallyConnectToGraph] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
This script creates a new app registration with a certificate or secret.

## EXAMPLES

### EXAMPLE 1
```
<<<<<<< HEAD
New-AadGroup -GroupName "AD group 1" -MailNickname "AdGroup1"
```

This example will create a new Azure AD group with a specific mail address.

### EXAMPLE 2
```
[pscustomobject]@{
    GroupName    = 'Group1'
    MailNickname = 'group1'
    Description  = 'This is the best group'
},
[pscustomobject]@{
    GroupName    = 'Group2'
    MailNickname = 'group2'
    Description  = 'This is also the best group'
} | New-AadGroup
```

This example will create new Azure AD groups with a specific mail addresses.

=======
To create an app registration with a secret that lasts 1 year, choose a name for $AppRegName, a name for $ClientSecretName and set $ClientSecretDuration to 1.
```

>>>>>>> 18d4dd8 (InitialVersion)
## PARAMETERS

### -GroupName
Name of the Azure AD Group

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -MailNickName
<<<<<<< HEAD
Provide nickname/alias for the email.
=======
{{ Fill MailNickName Description }}
>>>>>>> 18d4dd8 (InitialVersion)

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -MailEnabled
{{ Fill MailEnabled Description }}

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: True
Accept pipeline input: False
Accept wildcard characters: False
```

### -Description
Provide a description for the group.

```yaml
Type: ValidateNotNullOrEmptyAttribute
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: True (ByPropertyName)
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

### New-AppRegistration -AppRegName <String> -ClientSecretName <String> -EndDate <String> [-Append <Boolean>] [-CreateCert <Boolean>] [-CertName <String>] [-KeyVaultName <String>]
### [<CommonParameters>]
### New-AppRegistration -AppRegName <String> -ClientSecretName <String> -ClientSecretDuration <Int32> [-Append <Boolean>] [-CreateCert <Boolean>] [-CertName <String>] [-KeyVaultName
### <String>] [<CommonParameters>]
## OUTPUTS

### New app registration with credentials, and variables with the ID and secret.
## NOTES

## RELATED LINKS
