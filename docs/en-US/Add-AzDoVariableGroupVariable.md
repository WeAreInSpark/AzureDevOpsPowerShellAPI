---
external help file: AzureDevOpsPowerShellAPI-help.xml
Module Name: AzureDevOpsPowerShellAPI
online version:
schema: 2.0.0
---

# Add-AzDoVariableGroupVariable

## SYNOPSIS
This script adds variables to variable groups in a given project.

## SYNTAX

```
Add-AzDoVariableGroupVariable [-CollectionUri] <String> [[-PAT] <String>] [-ProjectName] <String>
 [-VariableGroupName] <String> [-Variables] <Hashtable> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
This script adds variables to variable groups in a given project.
When used in a pipeline, you can use the pre defined CollectionUri, ProjectName and AccessToken (PAT) variables.

## EXAMPLES

### EXAMPLE 1
```
$splat = @{
    CollectionUri     = 'https://dev.azure.com/ChristianPiet0452/'
    ProjectName       = 'Ditproject'
    PAT = '*******************'
    VariableGroupName = @('Group1', 'Group2')
    Variables         = @{
        test = @{
            value = 'test'
        }
        kaas = @{
            value = 'kaas'
        }
    }
}
```

Add-AzDoVariableGroupVariable @splat

This example creates a new Variable Group with a variable "test = test".

### EXAMPLE 2
```
$splat = @{
    CollectionUri     = 'https://dev.azure.com/ChristianPiet0452/'
    ProjectName       = 'Ditproject'
    VariableGroupName = @('Group1', 'Group2')
}
Get-AzDoVariableGroup @splat | Add-AzDoVariableGroupVariable -Variables @{ test = @{ value = 'test' } }
```

This example creates a few new Variable Groups with a variable "test = test".

## PARAMETERS

### -CollectionUri
Collection Uri of the organization

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

### -PAT
PAT to authenticate with the organization

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
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
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -VariableGroupName
Name of the variable group

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 4
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Variables
Variable names and values

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: True
Position: 5
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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### PSObject
## NOTES

## RELATED LINKS
