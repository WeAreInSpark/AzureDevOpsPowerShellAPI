---
external help file: AzureDevOpsPowerShell-help.xml
Module Name: AzureDevOpsPowerShell
online version:
schema: 2.0.0
---

# Get-PipelineRun

## SYNOPSIS
Retrieves pipeline run information from Azure DevOps for a specified pipeline within a project.

## SYNTAX

```
Get-PipelineRun [-CollectionUri] <String> [-ProjectName] <String> [-PipelineId] <Int32> [[-RunId] <Int32[]>]
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The \`Get-PipelineRun\` function fetches details about one or more pipeline runs from an Azure DevOps project.
It requires the collection URI, project name, and pipeline ID.
Optionally, specific run IDs can be provided
to filter the results.
The function uses the \`Invoke-AzDoRestMethod\` cmdlet to make the REST API call to
Azure DevOps and returns the run details.

## EXAMPLES

### EXAMPLE 1
```
Get-PipelineRun -CollectionUri "https://dev.azure.com/YourOrg" -ProjectName "YourProject" -PipelineId 123
```

Retrieves all runs for the specified pipeline in the given project.

### EXAMPLE 2
```
Get-PipelineRun -CollectionUri "https://dev.azure.com/YourOrg" -ProjectName "YourProject" -PipelineId 123 -RunId 456
```

Retrieves the details of the specified run (with ID 456) for the given pipeline.

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
The name of the project containing the pipeline

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

### -PipelineId
The ID of the pipeline to retrieve the run for

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: 0
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -RunId
The ID of the run to retrieve.
If not provided, all runs for the pipeline are returned.

```yaml
Type: Int32[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
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

### Returns an array of pipeline run objects. If specific run IDs are provided, only the matching runs are returned.
## NOTES

## RELATED LINKS
