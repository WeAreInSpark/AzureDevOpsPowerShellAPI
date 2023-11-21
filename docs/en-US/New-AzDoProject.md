---
external help file: AzureDevOpsPowerShellAPI-help.xml
Module Name: AzureDevOpsPowerShellAPI
online version:
schema: 2.0.0
---

# New-AzDoProject

## SYNOPSIS
Function to create an Azure DevOps project

## SYNTAX

```
New-AzDoProject [-CollectionUri] <String> [[-PAT] <String>] [-ProjectName] <String[]> [[-Description] <String>]
 [[-SourceControlType] <String>] [[-Visibility] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Function to create an Azure DevOps project

## EXAMPLES

### EXAMPLE 1
```
New-AzDoProject -CollectionUri "https://dev.azure.com/contoso" -PAT "***" -ProjectName "Project 1"
```

This example creates a new private Azure DevOps project

### EXAMPLE 2
```
New-AzDoProject -CollectionUri "https://dev.azure.com/contoso" -PAT "***" -ProjectName "Project 1" -Visibility 'public'
```

This example creates a new public Azure DevOps project

### EXAMPLE 3
```
@("MyProject1","Myproject2") | New-AzDoProject -CollectionUri "https://dev.azure.com/contoso" -PAT "***"
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

### -PAT
PAT to get access to Azure DevOps.

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
Name of the project.
Length
- Must not be a system reserved name.
- Must not be one of the hidden segments used for IIS request filtering like App_Browsers, App_code, App_Data, App_GlobalResources, App_LocalResources, App_Themes, App_WebResources, bin, or web.config.
- Must not contain any Unicode control characters or surrogate characters.
- Must not contain the following printable characters: \ / : * ?
" \< \> | ; # $ * { } , + = \[ \].
- Must not start with an underscore _.
- Must not start or end with a period ..

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

### -Description
Description of the project

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SourceControlType
Type of source control.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: GIT
Accept pipeline input: False
Accept wildcard characters: False
```

### -Visibility
Visibility of the project (private or public).

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: Private
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

## NOTES

## RELATED LINKS
