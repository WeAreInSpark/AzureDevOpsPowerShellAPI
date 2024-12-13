---
external help file: AzureDevOpsPowerShell-help.xml
Module Name: AzureDevOpsPowerShell
online version:
schema: 2.0.0
---

# Get-AzDoProjectTeam

## SYNOPSIS
This script gets team details in a given project.

## SYNTAX

```
Get-AzDoProjectTeam [-CollectionUri] <String> [-ProjectName] <String> [[-TeamName] <String>]
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
This script gets teams in a given project.
When used in a pipeline, you can use the pre-defined CollectionUri, ProjectName, and AccessToken (PAT) variables.

## EXAMPLES

### EXAMPLE 1
```
$params = @{
    CollectionUri = 'https://dev.azure.com/contoso/'
    ProjectName = 'Project 1'
    TeamName = 'testteam'
}
Get-AzDoProjectTeam @params
```

This example gets the team 'testteam' in 'Project 1'.

### EXAMPLE 2
```
$params = @{
    CollectionUri = 'https://dev.azure.com/contoso/'
    ProjectName = 'Project 1'
}
Get-AzDoProjectTeam @params
```

This example gets all teams in 'Project 1'.

## PARAMETERS

### -CollectionUri
collection URI

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
project name of the project

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

### -TeamName
team name

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
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

### PSObject
## NOTES

## RELATED LINKS
