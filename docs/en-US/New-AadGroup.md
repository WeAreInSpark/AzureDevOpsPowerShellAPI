---
external help file: InSpark.InfrastructureAsCode-help.xml
Module Name: InSpark.InfrastructureAsCode
online version:
schema: 2.0.0
---

# New-AadGroup

## SYNOPSIS
Creates an Azure AD group.

## SYNTAX

```
New-AadGroup [-GroupName] <String> [-MailNickName] <String> [-MailEnabled]
 [-Description] <ValidateNotNullOrEmptyAttribute> [-ManuallyConnectToGraph] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
Creates an Azure AD group.
It defaults to an Office 365 group with a mail address.

## EXAMPLES

### EXAMPLE 1
```
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
Provide nickname/alias for the email.

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
Enable mail on the Azure AD group

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

### PSobject containing the display name, ID and description.
## NOTES

## RELATED LINKS
