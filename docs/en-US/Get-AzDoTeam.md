---
external help file: AzureDevOpsPowerShell-help.xml
Module Name: AzureDevOpsPowerShell
online version:
schema: 2.0.0
---

# Get-AzDoTeam

## SYNOPSIS
Gets information about teams in Azure DevOps.

## SYNTAX

```
Get-AzDoTeam [-CollectionUri] <String> [-ProjectName] <String> [[-TeamName] <String[]>] [[-TeamId] <String>]
[-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Gets information about one team if the parameter $TeamName or $TeamId is filled in.
Otherwise, it will list all the teams in the specified project.

## EXAMPLES

### EXAMPLE 1
```
$Params = @{
    CollectionUri = "https://dev.azure.com/contoso"
    ProjectName = "Project1"
}
Get-AzDoTeam @Params
```
This command retrieves all teams in the specified project.

### EXAMPLE 2
```
$Params = @{
    CollectionUri = "https://dev.azure.com/contoso"
    ProjectName = "Project1"
    TeamName = "Team1"
}
Get-AzDoTeam @Params
```
This command retrieves the team named "Team1" in the specified project.

### EXAMPLE 3
```
$Params = @{
    CollectionUri = "https://dev.azure.com/contoso"
    ProjectName = "Project1"
    TeamId = "12345678-1234-1234-1234-1234567890ab"
}
Get-AzDoTeam @Params
```
This command retrieves the team with the specified ID in the specified project.

## PARAMETERS

### -CollectionUri
The URI of the Azure DevOps organization.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ProjectName
The name of the project where the teams are located.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -TeamName
The name of the team to fetch. If not specified, all teams in the project will be retrieved.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -TeamId
The ID of the team to fetch. If specified, only the team with this ID will be retrieved.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ProgressAction
Determines how the cmdlet responds to progress updates.

```yaml
Type: ActionPreference
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs. The cmdlet is not run.

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

### <CommonParameters>
This cmdlet supports the common parameters: `-Debug`, `-ErrorAction`, `-ErrorVariable`, `-InformationAction`, `-InformationVariable`, `-OutVariable`, `-OutBuffer`, `-PipelineVariable`, `-Verbose`, `-WarningAction`, and `-WarningVariable`. For more information, see [about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String

## OUTPUTS

### System.Object
