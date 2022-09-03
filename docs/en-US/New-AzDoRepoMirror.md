---
external help file: Module-help.xml
Module Name: Module
online version:
schema: 2.0.0
---

# New-AzDoRepoMirror

## SYNOPSIS
Clones all branches and tags to a new location

## SYNTAX

```
New-AzDoRepoMirror [-SourceOrganizationName] <String> [-SourceProjectName] <String> [-SourceRepoName] <String>
 [[-SourcePAT] <String>] [-DestinationOrganizationName] <String> [-DestinationProjectName] <String>
 [-DestinationRepoName] <String> [-DestinationPAT] <String> [<CommonParameters>]
```

## DESCRIPTION
Clones all branches and tags to a new location.
pull request will not be copied.

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
New-AzDoRepoMirror @params
```

This example mirrors a repo to another organization with te same project and repo name.

## PARAMETERS

### -SourceOrganizationName
Collection Uri of the organization where the source repo is located

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
Name of the project where the source repo is located

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
Name of the repo that has to be copied.

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
PAT to authentice with the source organization.
Defaults to azure pipeline token.

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
Collection Uri of the organization where the repo needs to be copied to

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
Project where the repo needs to be copied to

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
Name of the repo in the destination project.
if empty it will be the same as the source repo name.

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
PAT to authentice with the destination organization.
Defaults to azure pipeline token.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 8
Default value: $env:SYSTEM_ACCESSTOKEN
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
