---
<<<<<<< HEAD
external help file: InSpark.InfrastructureAsCode-help.xml
Module Name: InSpark.InfrastructureAsCode
=======
external help file: InfrastructureAsCode-help.xml
Module Name: InfrastructureAsCode
>>>>>>> 690e7a4 (Working version)
online version:
schema: 2.0.0
---

# New-AzDoRepoClone

## SYNOPSIS
<<<<<<< HEAD
This script creates a variable group with at least 1 variable in a given project.
=======
Clones the main branch to a new location
>>>>>>> 690e7a4 (Working version)

## SYNTAX

```
New-AzDoRepoClone [-SourceOrganizationName] <String> [-SourceProjectName] <String> [-SourceRepoName] <String>
 [[-SourcePAT] <String>] [-DestinationOrganizationName] <String> [-DestinationProjectName] <String>
<<<<<<< HEAD
 [-DestinationRepoName] <String> [-DestinationPAT] <String> [-Mirror] [-NewRepo] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
This script creates a variable group with at least 1 variable in a given project.
When used in a pipeline, you can use the pre defined CollectionUri,
ProjectName and AccessToken (PAT) variables.
=======
 [-DestinationRepoName] <String> [-DestinationPAT] <String> [-Mirror] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Clones the main branch to a new location
>>>>>>> 690e7a4 (Working version)

## EXAMPLES

### EXAMPLE 1
```
<<<<<<< HEAD
To create a variable group 'test' with one variable:
New-AzDoVariableGroup -collectionuri 'https://dev.azure.com/weareinspark/' -PAT '*******************' -ProjectName 'BusinessReadyCloud'
-Name 'test' -Variables @{ test = @{ value = 'test' } } -Description 'This is a test'
```

=======
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

>>>>>>> 690e7a4 (Working version)
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
<<<<<<< HEAD
PAT to authenticate with the organization
=======
PAT to authentice with the organization
>>>>>>> 690e7a4 (Working version)

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
<<<<<<< HEAD
PAT to authenticate with the organization
=======
PAT to authentice with the organization
>>>>>>> 690e7a4 (Working version)

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

<<<<<<< HEAD
Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -NewRepo
<<<<<<< HEAD
Switch to create a new repo
=======
Creates a new repo if $true
>>>>>>> 18d4dd8 (InitialVersion)

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
=======
Required: True
>>>>>>> 690e7a4 (Working version)
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
<<<<<<< HEAD
Shows what would happen if the cmdlet runs.
The cmdlet is not run.
=======
Shows what would happen if the cmdlet runs. The cmdlet is not run.
>>>>>>> 690e7a4 (Working version)

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

<<<<<<< HEAD
### New-AzDoVariableGroup [-CollectionUri] <string> [-PAT] <string> [-ProjectName] <string> [-Name] <string> [-Variables] <hashtable> [[-Description] <string>]
### [<CommonParameters>]
## OUTPUTS

### New variable group with at least 1 variable in a given project.
=======
## OUTPUTS

### PSobject
>>>>>>> 690e7a4 (Working version)
## NOTES

## RELATED LINKS
