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

# New-AzDoRepo

## SYNOPSIS
<<<<<<< HEAD
This script creates a variable group with at least 1 variable in a given project.
=======
Creates a repo in Azure DevOps.
>>>>>>> 690e7a4 (Working version)

## SYNTAX

```
<<<<<<< HEAD
<<<<<<< HEAD
New-AzDoRepo [-CollectionUri] <String> [[-PAT] <String>] [-RepoName] <String> [-ProjectName] <String> [-WhatIf]
=======
New-AzDoRepo [-CollectionUri] <String> [[-PAT] <String>] [-Name] <String> [-ProjectName] <String> [-WhatIf]
>>>>>>> 18d4dd8 (InitialVersion)
=======
New-AzDoRepo [-CollectionUri] <String> [-PAT] <String> [-Name] <String> [-ProjectId] <String> [-WhatIf]
>>>>>>> 690e7a4 (Working version)
 [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
<<<<<<< HEAD
This script creates a variable group with at least 1 variable in a given project.
When used in a pipeline, you can use the pre defined CollectionUri,
ProjectName and AccessToken (PAT) variables.
=======
Creates a repo in Azure DevOps.
>>>>>>> 690e7a4 (Working version)

## EXAMPLES

### EXAMPLE 1
```
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

### -ProjectId
Project where the variable group has to be created
>>>>>>> 690e7a4 (Working version)

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
## NOTES

## RELATED LINKS
