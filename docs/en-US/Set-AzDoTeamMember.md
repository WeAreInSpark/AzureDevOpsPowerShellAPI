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

# Set-AzDoTeamMember

## SYNOPSIS
<<<<<<< HEAD
This script creates a variable group with at least 1 variable in a given project.
=======
Adds a Azure Group to a default team in an Azure DevOps project.
>>>>>>> 690e7a4 (Working version)

## SYNTAX

```
<<<<<<< HEAD
Set-AzDoTeamMember [-OrganizationName] <String> [[-PAT] <String>] [-ProjectName] <String> [-ObjectId] <String>
=======
Set-AzDoTeamMember [-OrganizationName] <String> [-PAT] <String> [-ProjectName] <String> [-ObjectId] <String>
>>>>>>> 690e7a4 (Working version)
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
<<<<<<< HEAD
This script creates a variable group with at least 1 variable in a given project.
When used in a pipeline, you can use the pre defined CollectionUri,
ProjectName and AccessToken (PAT) variables.
=======
Adds a Azure Group to a default team in an Azure DevOps project.
>>>>>>> 690e7a4 (Working version)

## EXAMPLES

### EXAMPLE 1
```
<<<<<<< HEAD
To create a variable group 'test' with one variable:
=======
>>>>>>> 690e7a4 (Working version)
New-AzDoVariableGroup -collectionuri 'https://dev.azure.com/weareinspark/' -PAT '*******************' -ProjectName 'BusinessReadyCloud'
-Name 'test' -Variables @{ test = @{ value = 'test' } } -Description 'This is a test'
```

<<<<<<< HEAD
=======
To create a variable group 'test' with one variable

>>>>>>> 690e7a4 (Working version)
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
Required: False
Position: 2
Default value: $env:SYSTEM_ACCESSTOKEN
=======
Required: True
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
Shows what would happen if the cmdlet runs. The cmdlet is not run.
=======
Shows what would happen if the cmdlet runs.
The cmdlet is not run.
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

### New-AzDoVariableGroup [-CollectionUri] <string> [-PAT] <string> [-ProjectName] <string> [-Name] <string> [-Variables] <hashtable> [[-Description] <string>]
### [<CommonParameters>]
## OUTPUTS

### New variable group with at least 1 variable in a given project.
## NOTES

## RELATED LINKS
