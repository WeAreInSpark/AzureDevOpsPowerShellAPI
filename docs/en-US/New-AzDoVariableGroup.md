---
external help file: AzureDevOpsPowerShell-help.xml
Module Name: AzureDevOpsPowerShell
online version:
schema: 2.0.0
---

# New-AzDoVariableGroup

## SYNOPSIS
This script creates a variable group with at least 1 variable in a given project.

## SYNTAX

```
New-AzDoVariableGroup [-CollectionUri] <String> [-ProjectName] <String> [-VariableGroupName] <String[]>
 [-Variables] <Hashtable> [[-Description] <String>] [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
This script creates a variable group with at least 1 variable in a given project.
When used in a pipeline, you can use the pre defined CollectionUri, ProjectName and AccessToken (PAT) variables.

## EXAMPLES

### EXAMPLE 1
```
$params = @{
    Collectionuri = 'https://dev.azure.com/weareinspark/'
    PAT = '*******************'
    ProjectName = 'Project 1'
    VariableGroupName = 'VariableGroup1'
    Variables = @{ test = @{ value = 'test' } }
    Description = 'This is a test'
}
New-AzDoVariableGroup @params
```

This example creates a new Variable Group with a variable "test = test".

### EXAMPLE 2
```
$params = @{
    Collectionuri = 'https://dev.azure.com/ChristianPiet0452/'
    ProjectName = 'Ditproject'
    Variables = @{ test = @{ value = 'test' } }
    Description = 'This is a test'
    PAT = $PAT
}
@(
    'dev-group'
    'acc-group'
    'prd-group'
) | New-AzDoVariableGroup @params
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
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -VariableGroupName
Name of the variable group

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -Variables
Variable names and values

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: True
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Description
Description of the variable group

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
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

### PSobject
## NOTES

## RELATED LINKS
