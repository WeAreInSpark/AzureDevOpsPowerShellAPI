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

# New-AzDoRepoFork

## SYNOPSIS
This script creates a fork of a repo in a project to a given project.

## SYNTAX

```
New-AzDoRepoFork [-CollectionUri] <String> [[-PAT] <String>] [-ProjectId] <String> [-ForkName] <String>
 [-SourceProjectId] <String> [-SourceRepo] <String> [[-CopyBranch] <Boolean>] [[-ToBeForkedBranch] <String>]
<<<<<<< HEAD
 [-WhatIf] [-Confirm] [<CommonParameters>]
=======
 [<CommonParameters>]
>>>>>>> 690e7a4 (Working version)
```

## DESCRIPTION
This script creates a fork of a repo in a project to a given project.
The fork can be based on a specific branch or fork the entire repo (with all branches).

When used in a pipeline, you can use the pre defined CollectionUri, TeamProject and AccessToken (PAT) variables.

## EXAMPLES

### EXAMPLE 1
```
This example forks a repo from one project to another and forks a single branch ('main'), the forked repo is called 'ForkedRepo'.
$newAzDoRepoForkSplat = @{
<<<<<<< HEAD
    CollectionUri    = 'https://dev.azure.com/contoso'
=======
    CollectionUri    = 'https://dev.azure.com/ChristianPiet0452'
>>>>>>> 690e7a4 (Working version)
    ProjectId        = "15bca695-6260-498a-8b4c-38e53097906c"
    SourceProjectId  = "15bca695-6260-498a-8b4c-38e53097906c"
    SourceRepo       = 'b050b2de-2d6c-4357-8a03-3c14c1ccb3f5'
    CopyBranch       = $true
    ForkName         = 'ForkedRepo'
    ToBeForkedBranch = 'main'
}
```

New-AzDoRepoFork @newAzDoRepoForkSplat

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
PAT to authenticate with the organization

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
<<<<<<< HEAD
Default value: $env:SYSTEM_ACCESSTOKEN
=======
Default value: (Read-Host -MaskInput -Prompt 'Azure DevOps PAT: ')
>>>>>>> 690e7a4 (Working version)
Accept pipeline input: False
Accept wildcard characters: False
```

### -ProjectId
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

### -ForkName
Name of the forked repo

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

### -SourceProjectId
Azure DevOps Project-ID where the repo has to be forked from

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

### -SourceRepo
Azure DevOps Repository-ID which should be forked

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

### -CopyBranch
If set to $true, a single branch specified in the ToBeForkedBranch-variable will be forked.
If false will clone the repo with all branches

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -ToBeForkedBranch
Project where the variable group has to be created

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: Main
Accept pipeline input: False
Accept wildcard characters: False
```

<<<<<<< HEAD
### -WhatIf
<<<<<<< HEAD
Shows what would happen if the cmdlet runs.
The cmdlet is not run.
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

=======
>>>>>>> 690e7a4 (Working version)
### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### New-AzDoRepoFork [-CollectionUri] <String> [[-PAT] <String>] [-ProjectId] <String> [-ForkName] <String> [-SourceProjectId] <String> [-SourceRepo] <String> [[-CopyBranch] <Boolean>] [[-ToBeForkedBranch] <String>] [<CommonParameters>]
## OUTPUTS

### PSCustomObject
## NOTES

## RELATED LINKS
