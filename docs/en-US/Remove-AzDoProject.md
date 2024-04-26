---
external help file: AzureDevOpsPowerShell-help.xml
Module Name: AzureDevOpsPowerShell
online version:
schema: 2.0.0
---

# Remove-AzDoProject

## SYNOPSIS
Function to create an Azure DevOps project

## SYNTAX

```
Remove-AzDoProject [-CollectionUri] <String> [-ProjectName] <String[]> [-ProgressAction <ActionPreference>]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Function to create an Azure DevOps project

## EXAMPLES

### EXAMPLE 1
```
New-AzDoProject -CollectionUri "https://dev.azure.com/contoso" -ProjectName "Project 1"
```

This example creates a new private Azure DevOps project

### EXAMPLE 2
```
New-AzDoProject -CollectionUri "https://dev.azure.com/contoso" -ProjectName "Project 1" -Visibility 'public'
```

This example creates a new public Azure DevOps project

### EXAMPLE 3
```
@("MyProject1","Myproject2") | New-AzDoProject -CollectionUri "https://dev.azure.com/contoso"
```

This example creates two new Azure DevOps projects using the pipeline.

### EXAMPLE 4
```
[pscustomobject]@{
    ProjectName     = 'Project 1'
    Visibility      = 'public'
    Description     = 'This is the best project'
},
[pscustomobject]@{
    ProjectName     = 'Project 1'
    Description     = 'This is the best project'
} | New-AzDoProject -PAT $PAT -CollectionUri $CollectionUri
```

This example creates two new Azure DevOps projects using the pipeline.

## PARAMETERS

### -CollectionUri
Collection URI.
e.g.
https://dev.azure.com/contoso.
Azure Pipelines has a predefined variable for this.

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
Name of the project.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
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

### System.Collections.ArrayList
## NOTES

## RELATED LINKS
