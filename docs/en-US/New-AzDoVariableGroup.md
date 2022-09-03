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

# New-AzDoVariableGroup

## SYNOPSIS
This script creates a variable group with at least 1 variable in a given project.

## SYNTAX

```
<<<<<<< HEAD
<<<<<<< HEAD
New-AzDoVariableGroup [-CollectionUri] <String> [[-PAT] <String>] [-ProjectName] <String>
 [-VariableGroupName] <String[]> [-Variables] <Hashtable> [[-Description] <String>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
=======
New-AzDoVariableGroup [-CollectionUri] <String> [[-PAT] <String>] [-ProjectName] <String> [-Name] <String[]>
 [-Variables] <Hashtable> [[-Description] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
>>>>>>> 18d4dd8 (InitialVersion)
=======
New-AzDoVariableGroup [-CollectionUri] <String> [-PAT] <String> [-ProjectName] <String> [-Name] <String[]>
 [-Variables] <Hashtable> [[-Description] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
>>>>>>> 690e7a4 (Working version)
```

## DESCRIPTION
This script creates a variable group with at least 1 variable in a given project.
<<<<<<< HEAD
When used in a pipeline, you can use the pre defined CollectionUri, ProjectName and AccessToken (PAT) variables.
=======
When used in a pipeline, you can use the pre defined CollectionUri,
ProjectName and AccessToken (PAT) variables.
>>>>>>> 690e7a4 (Working version)

## EXAMPLES

### EXAMPLE 1
```
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 690e7a4 (Working version)
$params = @{
    Collectionuri = 'https://dev.azure.com/weareinspark/'
    PAT = '*******************'
    ProjectName = 'Project 1'
<<<<<<< HEAD
    VariableGroupName = 'VariableGroup1'
=======
    Name = 'VariableGroup1'
>>>>>>> 690e7a4 (Working version)
    Variables = @{ test = @{ value = 'test' } }
    Description = 'This is a test'
}
New-AzDoVariableGroup @params
```

This example creates a new Variable Group with a variable "test = test".

<<<<<<< HEAD
### EXAMPLE 2
```
$params = @{
    Collectionuri = 'https://dev.azure.com/ChristianPiet0452/'
    ProjectName = 'Ditproject'
    Variables = @{ test = @{ value = 'test' } }
    Description = 'This is a test'
    PAT = $PAT
}
@(
    'dev-group'
    'acc-group'
    'prd-group'
) | New-AzDoVariableGroup @params
```

This example creates a few new Variable Groups with a variable "test = test".

=======
To create a variable group 'test' with one variable:
New-AzDoVariableGroup -collectionuri 'https://dev.azure.com/weareinspark/' -PAT '*******************' -ProjectName 'BusinessReadyCloud'
-Name 'test' -Variables @{ test = @{ value = 'test' } } -Description 'This is a test'
```

>>>>>>> 18d4dd8 (InitialVersion)
=======
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

<<<<<<< HEAD
### -VariableGroupName
=======
### -Name
>>>>>>> 690e7a4 (Working version)
Name of the variable group

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 4
Default value: None
<<<<<<< HEAD
Accept pipeline input: True (ByPropertyName, ByValue)
=======
Accept pipeline input: False
>>>>>>> 690e7a4 (Working version)
Accept wildcard characters: False
```

### -Variables
Variable names and values

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: True
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Description
Description of the variable group

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
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

### PSobject
>>>>>>> 690e7a4 (Working version)
## NOTES

## RELATED LINKS
