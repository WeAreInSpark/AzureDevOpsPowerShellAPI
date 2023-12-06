---
external help file: AzureDevOpsPowerShell-help.xml
Module Name: AzureDevOpsPowerShell
online version:
schema: 2.0.0
---

# Add-AzDoPipelineBranchControl

## SYNOPSIS
Creates a Build Validation policy on a branch

## SYNTAX

```
Add-AzDoPipelineBranchControl [-CollectionUri] <String> [-ProjectName] <String> [[-PolicyName] <String>]
 [-ResourceType] <String> [-ResourceName] <String[]> [[-AllowUnknownStatusBranches] <String>]
 [[-AllowedBranches] <String>] [[-EnsureProtectionOfBranch] <String>] [[-Timeout] <Int32>]
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Creates a Build Validation policy on a branch

## EXAMPLES

### EXAMPLE 1
```
$params = @{
    CollectionUri = "https://dev.azure.com/contoso"
    PAT = "***"
    Name = "Policy 1"
    RepoName = "Repo 1"
    ProjectName = "Project 1"
    Id = 1
}
```

Set-AzDoBranchPolicyBuildValidation @params

This example creates a policy with splatting parameters

### EXAMPLE 2
```
$env:SYSTEM_ACCESSTOKEN = '***'
New-AzDoPipeline -CollectionUri "https://dev.azure.com/contoso" -ProjectName "Project 1" -Name "Pipeline 1" -RepoName "Repo 1" -Path "main.yml"
| Set-AzDoBranchPolicyBuildValidation
```

This example creates a new Azure Pipeline and sets this pipeline as Build Validation policy on the main branch

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
Accept wildcard characters: False
```

### -PolicyName
Name of the Build Validation policy.
Default is the name of the Build Definition

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: Branch Control
Accept pipeline input: False
Accept wildcard characters: False
```

### -ResourceType
The type of Azure DevOps resource to be protected by a build validation policy

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

### -ResourceName
Name of the resource to be protected by a build validation policy

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AllowUnknownStatusBranches
Valid duration of the Build Validation policy.
Default is 720 minutes

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -AllowedBranches
Setup an allow list of branches from which a pipeline must be run to access this resource

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: Refs/head/main
Accept pipeline input: False
Accept wildcard characters: False
```

### -EnsureProtectionOfBranch
Setup a requirement of branch protection policies for the branch from which a pipeline will be run to access this resource

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: True
Accept pipeline input: False
Accept wildcard characters: False
```

### -Timeout
Valid duration of the Build Validation policy.
Default is 720 minutes

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 9
Default value: 1440
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

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

### -ProgressAction
{{ Fill ProgressAction Description }}

```yaml
Type: ActionPreference
Parameter Sets: (All)
Aliases: proga

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

### [PSCustomObject]@{
###   CollectionUri = $CollectionUri
###   ProjectName   = $ProjectName
###   Id            = $_.id
### }
## NOTES

## RELATED LINKS
