---
external help file: Module-help.xml
Module Name: Module
online version:
schema: 2.0.0
---

# New-AadAppRegistration

## SYNOPSIS
Creates an App registration in Azure AD.

## SYNTAX

```
New-AadAppRegistration [-Name] <String> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Creates an App regestration in Azure AD when no App registration with the same name exists.

## EXAMPLES

### EXAMPLE 1
```
New-AadAppRegistration -Name $ProjectName
```

## PARAMETERS

### -Name
Name of the App registration

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

### PSobject with the object ID and application ID of the App registration
## NOTES

## RELATED LINKS
