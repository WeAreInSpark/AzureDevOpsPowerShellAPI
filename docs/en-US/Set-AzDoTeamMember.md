---
<<<<<<< HEAD
<<<<<<< HEAD
external help file: InSpark.InfrastructureAsCode-help.xml
Module Name: InSpark.InfrastructureAsCode
=======
external help file: InfrastructureAsCode-help.xml
Module Name: InfrastructureAsCode
>>>>>>> 690e7a4 (Working version)
=======
external help file: InSpark.InfrastructureAsCode-help.xml
Module Name: InSpark.InfrastructureAsCode
>>>>>>> 18d4dd8 (InitialVersion)
online version:
schema: 2.0.0
---

# Set-AzDoTeamMember

## SYNOPSIS
<<<<<<< HEAD
<<<<<<< HEAD
This script creates a variable group with at least 1 variable in a given project.
=======
Adds a Azure Group to a default team in an Azure DevOps project.
>>>>>>> 690e7a4 (Working version)
=======
This script creates a variable group with at least 1 variable in a given project.
>>>>>>> 18d4dd8 (InitialVersion)

## SYNTAX

```
<<<<<<< HEAD
<<<<<<< HEAD
Set-AzDoTeamMember [-OrganizationName] <String> [[-PAT] <String>] [-ProjectName] <String> [-ObjectId] <String>
=======
Set-AzDoTeamMember [-OrganizationName] <String> [-PAT] <String> [-ProjectName] <String> [-ObjectId] <String>
>>>>>>> 690e7a4 (Working version)
=======
Set-AzDoTeamMember [-OrganizationName] <String> [[-PAT] <String>] [-ProjectName] <String> [-ObjectId] <String>
>>>>>>> 18d4dd8 (InitialVersion)
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
<<<<<<< HEAD
<<<<<<< HEAD
This script creates a variable group with at least 1 variable in a given project.
When used in a pipeline, you can use the pre defined CollectionUri,
ProjectName and AccessToken (PAT) variables.
=======
Adds a Azure Group to a default team in an Azure DevOps project.
>>>>>>> 690e7a4 (Working version)
=======
This script creates a variable group with at least 1 variable in a given project.
When used in a pipeline, you can use the pre defined CollectionUri,
ProjectName and AccessToken (PAT) variables.
>>>>>>> 18d4dd8 (InitialVersion)

## EXAMPLES

### EXAMPLE 1
```
<<<<<<< HEAD
<<<<<<< HEAD
To create a variable group 'test' with one variable:
=======
>>>>>>> 690e7a4 (Working version)
=======
To create a variable group 'test' with one variable:
>>>>>>> 18d4dd8 (InitialVersion)
New-AzDoVariableGroup -collectionuri 'https://dev.azure.com/weareinspark/' -PAT '*******************' -ProjectName 'BusinessReadyCloud'
-Name 'test' -Variables @{ test = @{ value = 'test' } } -Description 'This is a test'
```

<<<<<<< HEAD
<<<<<<< HEAD
=======
To create a variable group 'test' with one variable

>>>>>>> 690e7a4 (Working version)
=======
>>>>>>> 18d4dd8 (InitialVersion)
## PARAMETERS

### -OrganizationName
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

### -PAT
PAT to authentice with the organization

```yaml
Type: String
Parameter Sets: (All)
Aliases:

<<<<<<< HEAD
<<<<<<< HEAD
Required: False
Position: 2
Default value: $env:SYSTEM_ACCESSTOKEN
=======
Required: True
=======
Required: False
>>>>>>> 18d4dd8 (InitialVersion)
Position: 2
Default value: None
>>>>>>> 690e7a4 (Working version)
Accept pipeline input: False
Accept wildcard characters: False
```

### -ProjectName
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

### -ObjectId
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

### -WhatIf
<<<<<<< HEAD
<<<<<<< HEAD
Shows what would happen if the cmdlet runs. The cmdlet is not run.
=======
Shows what would happen if the cmdlet runs.
The cmdlet is not run.
>>>>>>> 690e7a4 (Working version)
=======
Shows what would happen if the cmdlet runs. The cmdlet is not run.
>>>>>>> 18d4dd8 (InitialVersion)

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

### New-AzDoVariableGroup [-CollectionUri] <string> [-PAT] <string> [-ProjectName] <string> [-Name] <string> [-Variables] <hashtable> [[-Description] <string>]
### [<CommonParameters>]
## OUTPUTS

### New variable group with at least 1 variable in a given project.
## NOTES

## RELATED LINKS
