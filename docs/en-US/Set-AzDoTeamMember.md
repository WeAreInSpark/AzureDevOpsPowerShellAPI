---
external help file: Module-help.xml
Module Name: Module
online version:
schema: 2.0.0
---

# Set-AzDoTeamMember

## SYNOPSIS
This script creates a variable group with at least 1 variable in a given project.

## SYNTAX

```
Set-AzDoTeamMember [-OrganizationName] <String> [-PAT] <String> [-ProjectName] <String> [-ObjectId] <String>
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
This script creates a variable group with at least 1 variable in a given project.
When used in a pipeline, you can use the pre defined CollectionUri,
ProjectName and AccessToken (PAT) variables.

## EXAMPLES

### EXAMPLE 1
```
New-AzDoVariableGroup -collectionuri 'https://dev.azure.com/weareinspark/' -PAT '*******************' -ProjectName 'BusinessReadyCloud'
-Name 'test' -Variables @{ test = @{ value = 'test' } } -Description 'This is a test'
```

To create a variable group 'test' with one variable

## PARAMETERS

### -OrganizationName
Collection Uri of the organization

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

### -PAT
PAT to authentice with the organization

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

### -ProjectName
Project where the variable group has to be created

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

### -ObjectId
Project where the variable group has to be created

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 4
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

### New-AzDoVariableGroup [-CollectionUri] <string> [-PAT] <string> [-ProjectName] <string> [-Name] <string> [-Variables] <hashtable> [[-Description] <string>]
### [<CommonParameters>]
## OUTPUTS

### New variable group with at least 1 variable in a given project.
## NOTES

## RELATED LINKS
