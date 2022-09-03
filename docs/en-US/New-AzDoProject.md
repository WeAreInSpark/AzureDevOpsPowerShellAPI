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

# New-AzDoProject

## SYNOPSIS
Function to create an Azure DevOps project

## SYNTAX

```
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
New-AzDoProject [-CollectionUri] <String> [[-PAT] <String>] [-ProjectName] <String[]> [[-Description] <String>]
=======
New-AzDoProject [-CollectionUri] <String> [[-PAT] <String>] [-Name] <String[]> [[-Description] <String>]
>>>>>>> 18d4dd8 (InitialVersion)
=======
New-AzDoProject [-CollectionUri] <String> [-PAT] <String> [-Name] <String[]> [[-Description] <String>]
>>>>>>> 690e7a4 (Working version)
=======
New-AzDoProject [-CollectionUri] <String> [[-PAT] <String>] [-Name] <String[]> [[-Description] <String>]
>>>>>>> 18d4dd8 (InitialVersion)
 [[-SourceControlType] <String>] [[-Visibility] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
<<<<<<< HEAD
<<<<<<< HEAD
{{ Fill in the Description }}
=======
Function to create an Azure DevOps project
>>>>>>> 690e7a4 (Working version)
=======
{{ Fill in the Description }}
>>>>>>> 18d4dd8 (InitialVersion)

## EXAMPLES

### EXAMPLE 1
```
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
New-AzDoProject -CollectionUri "https://dev.azure.com/contoso" -PAT "***" -ProjectName "Project 1"
=======
New-AzureDevOpsProject -CollectionUri $CollectionUri -PAT $PAT -ProjectName $ProjectName
>>>>>>> 18d4dd8 (InitialVersion)
```

### EXAMPLE 2
```
<<<<<<< HEAD
New-AzDoProject -CollectionUri "https://dev.azure.com/contoso" -PAT "***" -ProjectName "Project 1" -Visibility 'public'
=======
New-AzureDevOpsProject -CollectionUri "https://dev.azure.com/contoso" -PAT "***" -ProjectName "Project 1"
=======
New-AzureDevOpsProject -CollectionUri $CollectionUri -PAT $PAT -ProjectName $ProjectName
>>>>>>> 18d4dd8 (InitialVersion)
```

### EXAMPLE 2
```
<<<<<<< HEAD
New-AzureDevOpsProject -CollectionUri "https://dev.azure.com/contoso" -PAT "***" -ProjectName "Project 1" -Visibility 'public'
>>>>>>> 690e7a4 (Working version)
```

This example creates a new public Azure DevOps project

<<<<<<< HEAD
### EXAMPLE 3
```
@("MyProject1","Myproject2") | New-AzDoProject -CollectionUri "https://dev.azure.com/contoso" -PAT "***"
```

This example creates two new Azure DevOps projects using the pipeline.

### EXAMPLE 4
```
[pscustomobject]@{
    ProjectName     = 'Project 1'
    Visibility      = 'public'
    Description     = 'This is the best project'
},
[pscustomobject]@{
    ProjectName     = 'Project 1'
    Description     = 'This is the best project'
} | New-AzDoProject -PAT $PAT -CollectionUri $CollectionUri
```

This example creates two new Azure DevOps projects using the pipeline.

=======
New-AzureDevOpsProject -CollectionUri $CollectionUri -PAT $PAT -ProjectName $ProjectName -Visibility 'public'
```

>>>>>>> 18d4dd8 (InitialVersion)
=======
>>>>>>> 690e7a4 (Working version)
=======
New-AzureDevOpsProject -CollectionUri $CollectionUri -PAT $PAT -ProjectName $ProjectName -Visibility 'public'
```

>>>>>>> 18d4dd8 (InitialVersion)
## PARAMETERS

### -CollectionUri
Collection URI.
e.g.
<<<<<<< HEAD
<<<<<<< HEAD
https://dev.azure.com/contoso. 
=======
https://dev.azure.com/contoso.
>>>>>>> 690e7a4 (Working version)
=======
https://dev.azure.com/contoso. 
>>>>>>> 18d4dd8 (InitialVersion)
Azure Pipelines has a predefined variable for this.

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
PAT to get access to Azure DevOps.

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
### -ProjectName
=======
### -Name
>>>>>>> 690e7a4 (Working version)
Name of the project.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
<<<<<<< HEAD
Accept pipeline input: True (ByPropertyName, ByValue)
=======
Accept pipeline input: False
>>>>>>> 690e7a4 (Working version)
Accept wildcard characters: False
```

### -Description
Description of the project

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SourceControlType
Type of source control.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: GIT
Accept pipeline input: False
Accept wildcard characters: False
```

### -Visibility
Visibility of the project (private or public).

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: Private
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

## OUTPUTS

## NOTES
<<<<<<< HEAD
=======
When you are using Azure DevOps with Build service Access token, make sure the setting 'Protect access to repositories in YAML pipelin' is off.
>>>>>>> 690e7a4 (Working version)

## RELATED LINKS
