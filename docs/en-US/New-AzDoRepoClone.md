---
external help file: Module-help.xml
Module Name: Module
online version:
schema: 2.0.0
---

# New-AzDoRepoClone

## SYNOPSIS
This script creates a variable group with at least 1 variable in a given project.

## SYNTAX

```
New-AzDoRepoClone [-SourceOrganizationName] <String> [[-SourcePAT] <String>] [-SourceRepoName] <String>
 [-SourceProjectName] <String> [-DestinationOrganizationName] <String> [-DestinationPAT] <String>
 [-DestinationRepoName] <String> [-DestinationProjectName] <String> [<CommonParameters>]
```

## DESCRIPTION
This script creates a variable group with at least 1 variable in a given project.
When used in a pipeline, you can use the pre defined CollectionUri,
ProjectName and AccessToken (PAT) variables.

## EXAMPLES

### EXAMPLE 1
```
New-AzDoVariableGroup -collectionuri 'https://dev.azure.com/weareinspark/' -PAT '*******************' -ProjectName 'BusinessReadyCloud'
-Name 'test' -Variables @{ test = @{ value = 'test' } } -Description 'This is a test'
```

To create a variable group 'test' with one variable

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

### -SourcePAT
PAT to authentice with the organization

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: $env:SYSTEM_ACCESSTOKEN
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

### -SourceProjectName
Project where the variable group has to be created

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 4
Default value: None
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

### -DestinationPAT
PAT to authentice with the organization

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

### -DestinationProjectName
Project where the variable group has to be created

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### New-AzDoVariableGroup [-CollectionUri] <string> [-PAT] <string> [-ProjectName] <string> [-Name] <string> [-Variables] <hashtable> [[-Description] <string>]
### [<CommonParameters>]
## OUTPUTS

### New variable group with at least 1 variable in a given project.
## NOTES

## RELATED LINKS
