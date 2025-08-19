---
external help file: AzureDevOpsPowerShell-help.xml
Module Name: AzureDevOpsPowerShell
online version:
schema: 2.0.0
---

# Set-AzDoBranchPolicyBuildValidation

## SYNOPSIS
Creates a Build Validation policy on a branch

## SYNTAX

```
Set-AzDoBranchPolicyBuildValidation [-CollectionUri] <String> [-ProjectName] <String> [-RepoName] <String>
 [[-Branch] <String>] [[-Required] <Boolean>] [-Id] <Int32> [[-Name] <String>] [[-FilenamePatterns] <Array>]
 [[-validDuration] <Int32>] [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Creates a Build Validation policy on a branch

## EXAMPLES

### EXAMPLE 1
```
$params = @{
    CollectionUri = "https://dev.azure.com/contoso"
    Name = "Policy 1"
    RepoName = "Repo 1"
    ProjectName = "Project 1"
    Id = 1
}
Set-AzDoBranchPolicyBuildValidation @params
```

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
Project where the branch policy build validation will be set up

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

### -RepoName
Name of the Repository containing the YAML-sourcecode

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -Branch
Branch to create the policy on

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: Main
Accept pipeline input: False
Accept wildcard characters: False
```

### -Required
Should the PR block if the pipeline fails

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: True
Accept pipeline input: False
Accept wildcard characters: False
```

### -Id
Id of the Build Definition (Pipeline)

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: True
Position: 6
Default value: 0
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Name
Name of the Build Validation policy.
Default is the name of the Build Definition

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -FilenamePatterns
Filename patterns to include in the Build Validation policy.
Default is all files

```yaml
Type: Array
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -validDuration
Valid duration of the Build Validation policy.
Default is 720 minutes

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 9
Default value: 720
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
### CollectionUri = $CollectionUri
### ProjectName   = $ProjectName
### RepoName      = $RepoName
### Id            = $result.id
### Url           = $result.url
### }
## NOTES

## RELATED LINKS
