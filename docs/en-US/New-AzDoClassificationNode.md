---
external help file: AzureDevOpsPowerShell-help.xml
Module Name: AzureDevOpsPowerShell
online version:
schema: 2.0.0
---

# New-AzDoClassificationNode

## SYNOPSIS
Creates a Classification Node in Azure DevOps.

## SYNTAX

```
New-AzDoClassificationNode [-CollectionUri] <String> [-ProjectName] <String> [-StructureGroup] <String>
 [[-Path] <String>] [-Name] <String> [[-startDate] <String>] [[-finishDate] <String>]
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Creates a Classification Node in Azure DevOps.
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

New-AzDoClassificationNode @Params

This example creates a Classification Node of the type 'areas' within the Project.

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

New-AzDoClassificationNode @Params

This example creates a Classification Node of the type 'areas' within the specified path.

### EXAMPLE 3
```
$Params = @{
  CollectionUri  = "https://dev.azure.com/cantoso"
  ProjectName    = "Playground"
  StructureGroup = "iterations"
  Name           = "Iteration1"
}
```

New-AzDoClassificationNode @Params

This example creates a Classification Node of the type 'iterations' within the Project.

### EXAMPLE 4
```
$Params = @{
  CollectionUri  = "https://dev.azure.com/cantoso"
  ProjectName    = "Playground"
  StructureGroup = "iterations"
  Name           = "Iteration1"
  Path           = "Path1"
  startDate      = "10//701001 00:00:00
  finishDate     = "10//701008 00:00:00
}
```

New-AzDoClassificationNode @Params

This example creates a Classification Node of the type 'iterations' within the specified path, it is also possible to use a start and finish date of the iteration by adding the optional parameters 'startDate' and 'finishDate'.

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

### -startDate
Start date of the iteration (optional)

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -finishDate
Finish date of the iteration (optional)

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
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

### [PSCustomObject]@{
### CollectionUri = $CollectionUri
### ProjectName   = $ProjectName
### Id            = $_.id
### Identifier    = $_.identifier
### Name          = $_.name
### StructureType = $_.structureType
### HasChildren   = $_.hasChildren
### Path          = $_.path
### Links         = $_._links
### Url           = $_.url
### }
## NOTES

## RELATED LINKS
