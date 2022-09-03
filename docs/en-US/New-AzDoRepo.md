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

# New-AzDoRepo

## SYNOPSIS
<<<<<<< HEAD
<<<<<<< HEAD
This script creates a variable group with at least 1 variable in a given project.
=======
Creates a repo in Azure DevOps.
>>>>>>> 690e7a4 (Working version)
=======
This script creates a variable group with at least 1 variable in a given project.
>>>>>>> 18d4dd8 (InitialVersion)

## SYNTAX

```
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
New-AzDoRepo [-CollectionUri] <String> [[-PAT] <String>] [-RepoName] <String> [-ProjectName] <String> [-WhatIf]
=======
New-AzDoRepo [-CollectionUri] <String> [[-PAT] <String>] [-Name] <String> [-ProjectName] <String> [-WhatIf]
>>>>>>> 18d4dd8 (InitialVersion)
=======
New-AzDoRepo [-CollectionUri] <String> [-PAT] <String> [-Name] <String> [-ProjectId] <String> [-WhatIf]
>>>>>>> 690e7a4 (Working version)
=======
New-AzDoRepo [-CollectionUri] <String> [[-PAT] <String>] [-Name] <String> [-ProjectName] <String> [-WhatIf]
>>>>>>> 18d4dd8 (InitialVersion)
 [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
<<<<<<< HEAD
<<<<<<< HEAD
This script creates a variable group with at least 1 variable in a given project.
When used in a pipeline, you can use the pre defined CollectionUri,
ProjectName and AccessToken (PAT) variables.
=======
Creates a repo in Azure DevOps.
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
<<<<<<< HEAD
=======
>>>>>>> 690e7a4 (Working version)
$params = @{
    CollectionUri = "https://dev.azure.com/contoso"
    PAT           = "***"
    Name          = "Repo 1"
<<<<<<< HEAD
    ProjectName   = "RandomProject"
}
New-AzDoRepo @params
=======
To create a variable group 'test' with one variable:
New-AzDoVariableGroup -collectionuri 'https://dev.azure.com/weareinspark/' -PAT '*******************' -ProjectName 'BusinessReadyCloud'
-Name 'test' -Variables @{ test = @{ value = 'test' } } -Description 'This is a test'
>>>>>>> 18d4dd8 (InitialVersion)
```

=======
    ProjectId     = "00000-00000-00000-00000-00000"
}
New-AzDoRepo @params
```

This example creates a new Azure DevOps repo

>>>>>>> 690e7a4 (Working version)
=======
To create a variable group 'test' with one variable:
New-AzDoVariableGroup -collectionuri 'https://dev.azure.com/weareinspark/' -PAT '*******************' -ProjectName 'BusinessReadyCloud'
-Name 'test' -Variables @{ test = @{ value = 'test' } } -Description 'This is a test'
```

>>>>>>> 18d4dd8 (InitialVersion)
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
<<<<<<< HEAD
Accept pipeline input: True (ByPropertyName)
=======
Accept pipeline input: False
>>>>>>> 690e7a4 (Working version)
Accept wildcard characters: False
```

### -PAT
<<<<<<< HEAD
PAT to authenticate with the organization
=======
PAT to authentice with the organization
>>>>>>> 690e7a4 (Working version)

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

<<<<<<< HEAD
### -RepoName
Name of the new repository
=======
### -Name
Project where the variable group has to be created
>>>>>>> 690e7a4 (Working version)

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
<<<<<<< HEAD
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -ProjectName
Name of the project where the new repository has to be created
=======
Accept pipeline input: False
Accept wildcard characters: False
```

<<<<<<< HEAD
### -ProjectId
Project where the variable group has to be created
>>>>>>> 690e7a4 (Working version)
=======
### -ProjectName
Name of the project where the new repository has to be created
>>>>>>> 18d4dd8 (InitialVersion)

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

<<<<<<< HEAD
<<<<<<< HEAD
### New-AzDoVariableGroup [-CollectionUri] <string> [-PAT] <string> [-ProjectName] <string> [-Name] <string> [-Variables] <hashtable> [[-Description] <string>]
### [<CommonParameters>]
## OUTPUTS

### New variable group with at least 1 variable in a given project.
=======
## OUTPUTS

### PSObject
### Containg the repo information
>>>>>>> 690e7a4 (Working version)
=======
### New-AzDoVariableGroup [-CollectionUri] <string> [-PAT] <string> [-ProjectName] <string> [-Name] <string> [-Variables] <hashtable> [[-Description] <string>]
### [<CommonParameters>]
## OUTPUTS

### New variable group with at least 1 variable in a given project.
>>>>>>> 18d4dd8 (InitialVersion)
## NOTES

## RELATED LINKS
