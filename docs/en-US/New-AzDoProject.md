---
external help file: Module-help.xml
Module Name: Module
online version:
schema: 2.0.0
---

# New-AzDoProject

## SYNOPSIS
Function to create an Azure DevOps project

## SYNTAX

```
New-AzDoProject [-CollectionUri] <String> [-PAT] <String> [-Name] <String[]> [[-Description] <String>]
 [[-SourceControlType] <String>] [[-Visibility] <String>] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
New-AzureDevOpsProject -CollectionUri $CollectionUri -PAT $PAT -ProjectName $ProjectName
```

### EXAMPLE 2
```
New-AzureDevOpsProject -CollectionUri $CollectionUri -PAT $PAT -ProjectName $ProjectName -Visibility 'public'
```

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
Accept pipeline input: False
Accept wildcard characters: False
```

### -PAT
PAT to get access to Azure DevOps.

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

### -Name
Name of the project.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: False
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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
When you are using Azure DevOps with Build service Access token, make sure the setting 'Protect access to repositories in YAML pipelin' is off.

## RELATED LINKS
