---
external help file: AzureDevOpsPowerShell-help.xml
Module Name: AzureDevOpsPowerShell
online version:
schema: 2.0.0
---

# New-AzDoPipeline

## SYNOPSIS
Creates an Azure Pipeline

## SYNTAX

```
New-AzDoPipeline [-CollectionUri] <String> [-ProjectName] <String> [-PipelineName] <String>
 [-RepoName] <Object> [[-Path] <String>] [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
Creates an Azure Pipeline in a given Azure Project based on a repo

## EXAMPLES

### EXAMPLE 1
```
$newAzDoPipelineSplat = @{
    CollectionUri = "https://dev.azure.com/contoso"
    PipelineName = "Pipeline 1"
    RepoName = "Repo 1"
    ProjectName = "Project 1"
}
New-AzDoPipeline @newAzDoPipelineSplat
```

This example creates a new Azure Pipeline using the PowerShell pipeline

### EXAMPLE 2
```
Get-AzDoProject -CollectionUri "https://dev.azure.com/contoso" -PAT $PAT |
    Get-AzDoRepo -RepoName 'Repo 1' -PAT $PAT |
        New-AzDoPipeline -PipelineName "Pipeline 1" -PAT $PAT
```

This example creates a new Azure Pipeline

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
Project where the pipeline will be created.

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

### -PipelineName
Name of the Pipeline

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

### -RepoName
Name of the Repository containing the YAML-sourcecode

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 4
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Path
Path of the YAML-sourcecode in the Repository

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: /main.yaml
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

### PSobject. An object containing the name, the folder and the URI of the pipeline
## NOTES

## RELATED LINKS
