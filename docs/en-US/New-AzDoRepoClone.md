---
external help file: InfrastructureAsCode-help.xml
Module Name: InfrastructureAsCode
online version:
schema: 2.0.0
---

# New-AzDoRepoClone

## SYNOPSIS
Clones the main branch to a new location

## SYNTAX

```
New-AzDoRepoClone [-SourceOrganizationName] <String> [-SourceProjectName] <String> [-SourceRepoName] <String>
 [[-SourcePAT] <String>] [-DestinationOrganizationName] <String> [-DestinationProjectName] <String>
 [-DestinationRepoName] <String> [-DestinationPAT] <String> [-Mirror] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Clones the main branch to a new location

## EXAMPLES

### EXAMPLE 1
```
$params = @{
    SourceOrganizationName      = "contoso"
    SourceProjectName           = "project1"
    SourcePAT                   = "***"
    SourceRepoName              = "repo1"
    DestinationOrganizationName = "New Contoso"
    DestinationProjectName      = "Project1"
    DestinationPAT              = "***"
    DestinationRepoName         = "repo1"
}
New-AzDoRepoClone @params
```

This example Clones the main branch to another organization with the same project and repo name.

## PARAMETERS

### -SourceOrganizationName
Collection Uri of the organization

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

### -SourceProjectName
Project where the variable group has to be created

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

### -SourceRepoName
Project where the variable group has to be created

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SourcePAT
PAT to authentice with the organization

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: $env:SYSTEM_ACCESSTOKEN
Accept pipeline input: False
Accept wildcard characters: False
```

### -DestinationOrganizationName
Collection Uri of the organization

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DestinationProjectName
Project where the variable group has to be created

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DestinationRepoName
Project where the variable group has to be created

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 7
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DestinationPAT
PAT to authentice with the organization

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 8
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Mirror
Switch to enable mirroring the repo

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: False
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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### PSobject
## NOTES

## RELATED LINKS
