---
external help file: AzureDevOpsPowerShell-help.xml
Module Name: AzureDevOpsPowerShell
online version:
schema: 2.0.0
---

# Remove-AzDoClassificationNode

## SYNOPSIS
Delete a Classification Node in Azure DevOps.

## SYNTAX

```
Remove-AzDoClassificationNode [-CollectionUri] <String> [-ProjectName] <String> [-StructureGroup] <String>
 [[-Path] <String>] [-Name] <String> [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
Delete a Classification Node in Azure DevOps.
This could be an area or an iteration.

## EXAMPLES

### EXAMPLE 1
```
$Params = @{
  CollectionUri  = "https://dev.azure.com/cantoso"
  ProjectName    = "Playground"
  StructureGroup = "areas"
  Name           = "Area1"
}
```

Remove-AzDoClassificationNode @Params

This example removes a Classification Node of the type 'areas' within the Project.

### EXAMPLE 2
```
$Params = @{
  CollectionUri  = "https://dev.azure.com/cantoso"
  ProjectName    = "Playground"
  StructureGroup = "areas"
  Name           = "Area1"
  Path           = "Path1"
}
```

Remove-AzDoClassificationNode @Params

This example removes a Classification Node of the type 'areas' within the specified path.

### EXAMPLE 3
```
$Params = @{
  CollectionUri  = "https://dev.azure.com/cantoso"
  ProjectName    = "Playground"
  StructureGroup = "iterations"
  Name           = "Iteration1"
}
```

Remove-AzDoClassificationNode @Params

This example removes a Classification Node of the type 'iterations' within the specified path.

### EXAMPLE 4
```
$Params = @{
  CollectionUri  = "https://dev.azure.com/cantoso"
  ProjectName    = "Playground"
  StructureGroup = "iterations"
  Name           = "Iteration1"
  Path           = "Path1"
}
```

Remove-AzDoClassificationNode @Params

This example removes a Classification Node of the type 'iterations' within the specified path.

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
Name of the project where the new repository has to be created

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

### -StructureGroup
Name of the project where the new repository has to be created

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

### -Path
Path of the classification node (optional)

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Name
Name of the classification node

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 5
Default value: None
Accept pipeline input: True (ByPropertyName)
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

## NOTES

## RELATED LINKS
