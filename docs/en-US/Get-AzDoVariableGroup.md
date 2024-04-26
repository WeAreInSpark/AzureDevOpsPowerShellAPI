---
external help file: AzureDevOpsPowerShell-help.xml
Module Name: AzureDevOpsPowerShell
online version:
schema: 2.0.0
---

# Get-AzDoVariableGroup

## SYNOPSIS
This script gets a variable group details in a given project.

## SYNTAX

```
Get-AzDoVariableGroup [-CollectionUri] <String> [-ProjectName] <String> [[-VariableGroupName] <String[]>]
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
This script gets a variable groups a given project.
When used in a pipeline, you can use the pre defined CollectionUri, ProjectName and AccessToken (PAT) variables.

## EXAMPLES

### EXAMPLE 1
```
$params = @{
    Collectionuri = 'https://dev.azure.com/weareinspark/'
    ProjectName = 'Project 1'
    VariableGroupName = 'VariableGroup1','VariableGroup2'
}
Get-AzDoVariableGroup @params
```

This example gets Variable Groups 'VariableGroup1' and 'VariableGroup2' .

### EXAMPLE 2
```
$params = @{
    Collectionuri = 'https://dev.azure.com/weareinspark/'
    PAT = '*******************'
    ProjectName = 'Project 1'
}
Get-AzDoVariableGroup @params
```

This example gets all variable groups the user has access to within a project.

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

### -ProjectName
Project where the variable group has to be created

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

### -VariableGroupName
Name of the variable group

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
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

### PSObject
## NOTES

## RELATED LINKS
