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

# New-AzDoPipeline

## SYNOPSIS
<<<<<<< HEAD
This script creates a variable group with at least 1 variable in a given project.
=======
Creates an Azure Pipeline
>>>>>>> 690e7a4 (Working version)

## SYNTAX

```
<<<<<<< HEAD
<<<<<<< HEAD
New-AzDoPipeline [-CollectionUri] <String> [-ProjectName] <String> [[-PAT] <String>] [-PipelineName] <String[]>
 [-RepoName] <Object> [[-Path] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Creates an Azure Pipeline in a given Azure Project based on a repo
=======
New-AzDoPipeline [-CollectionUri] <String> [[-PAT] <String>] [-Name] <String[]> [-RepoName] <Object>
=======
New-AzDoPipeline [-CollectionUri] <String> [-PAT] <String> [-Name] <String[]> [-RepoName] <Object>
>>>>>>> 690e7a4 (Working version)
 [-ProjectName] <String> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
<<<<<<< HEAD
This script creates a variable group with at least 1 variable in a given project.
When used in a pipeline, you can use the pre defined CollectionUri,
ProjectName and AccessToken (PAT) variables.
>>>>>>> 18d4dd8 (InitialVersion)
=======
Creates an Azure Pipeline
>>>>>>> 690e7a4 (Working version)

## EXAMPLES

### EXAMPLE 1
```
<<<<<<< HEAD
<<<<<<< HEAD
$newAzDoPipelineSplat = @{
    CollectionUri = "https://dev.azure.com/contoso"
    PAT = "***"
    PipelineName = "Pipeline 1"
=======
$newAzDoPipelineSplat = @{
    CollectionUri = "https://dev.azure.com/contoso"
    PAT = "***"
    Name = "Pipeline 1"
>>>>>>> 690e7a4 (Working version)
    RepoName = "Repo 1"
    ProjectName = "Project 1"
}
New-AzDoPipeline @newAzDoPipelineSplat
```

<<<<<<< HEAD
This example creates a new Azure Pipeline using the PowerShell pipeline

### EXAMPLE 2
```
Get-AzDoProject -CollectionUri "https://dev.azure.com/contoso" -PAT $PAT | 
    Get-AzDoRepo -RepoName 'Repo 1' -PAT $PAT |
        New-AzDoPipeline -PipelineName "Pipeline 1" -PAT $PAT
```

This example creates a new Azure Pipeline

=======
To create a variable group 'test' with one variable:
New-AzDoVariableGroup -collectionuri 'https://dev.azure.com/weareinspark/' -PAT '*******************' -ProjectName 'BusinessReadyCloud'
-Name 'test' -Variables @{ test = @{ value = 'test' } } -Description 'This is a test'
```

>>>>>>> 18d4dd8 (InitialVersion)
=======
This example creates a new Azure Pipeline

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
Accept wildcard characters: False
```

### -ProjectName
Project where the pipeline will be created.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
=======
Accept pipeline input: False
>>>>>>> 690e7a4 (Working version)
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
<<<<<<< HEAD
Position: 3
Default value: $env:SYSTEM_ACCESSTOKEN
=======
Position: 2
Default value: None
>>>>>>> 18d4dd8 (InitialVersion)
=======
Required: True
Position: 2
Default value: None
>>>>>>> 690e7a4 (Working version)
Accept pipeline input: False
Accept wildcard characters: False
```

<<<<<<< HEAD
### -PipelineName
Name of the Pipeline
=======
### -Name
Project where the variable group has to be created
>>>>>>> 690e7a4 (Working version)

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
<<<<<<< HEAD
Position: 4
Default value: None
Accept pipeline input: True (ByPropertyName)
=======
Position: 3
Default value: None
Accept pipeline input: False
>>>>>>> 690e7a4 (Working version)
Accept wildcard characters: False
```

### -RepoName
<<<<<<< HEAD
Name of the Repository containing the YAML-sourcecode
=======
Project where the variable group has to be created
>>>>>>> 690e7a4 (Working version)

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
<<<<<<< HEAD
Position: 5
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Path
Path of the YAML-sourcecode in the Repository
=======
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ProjectName
Project where the variable group has to be created
>>>>>>> 690e7a4 (Working version)

```yaml
Type: String
Parameter Sets: (All)
Aliases:

<<<<<<< HEAD
Required: False
Position: 6
Default value: /main.yaml
Accept pipeline input: True (ByPropertyName)
=======
Required: True
Position: 5
Default value: None
Accept pipeline input: False
>>>>>>> 690e7a4 (Working version)
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

<<<<<<< HEAD
### PSobject. An object containing the name, the folder and the URI of the pipeline
=======
### New variable group with at least 1 variable in a given project.
>>>>>>> 18d4dd8 (InitialVersion)
=======
## OUTPUTS

### PSobject containing Project information
>>>>>>> 690e7a4 (Working version)
## NOTES

## RELATED LINKS
