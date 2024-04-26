---
external help file: AzureDevOpsPowerShell-help.xml
Module Name: AzureDevOpsPowerShell
online version:
schema: 2.0.0
---

# Set-AzDoBranchPolicyMergeStrategy

## SYNOPSIS
Creates a Merge strategy policy on a branch

## SYNTAX

```
Set-AzDoBranchPolicyMergeStrategy [-CollectionUri] <String> [-ProjectName] <String> [-RepoName] <String[]>
 [[-Branch] <String>] [[-AllowSquash] <Boolean>] [[-AllowNoFastForward] <Boolean>] [[-AllowRebase] <Boolean>]
 [[-AllowRebaseMerge] <Boolean>] [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Creates a Merge strategy policy on a branch

## EXAMPLES

### EXAMPLE 1
```
$params = @{
    CollectionUri = "https://dev.azure.com/contoso"
    RepoName = "Repo 1"
    ProjectName = "Project 1"
}
Set-AzDoBranchPolicyMergeStrategy @params
```

This example creates a 'Require a merge strategy' policy with splatting parameters

### EXAMPLE 2
```
'repo1', 'repo2' |
Set-AzDoBranchPolicyMergeStrategy -CollectionUri "https://dev.azure.com/contoso" -ProjectName "Project 1" -PAT "***"
```

This example creates a 'Require a merge strategy' policy on the main branch of repo1 and repo2

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
Project where the branch policy merge strategy will be setup

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
Type: String[]
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

### -AllowSquash
Allow squash merge

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

### -AllowNoFastForward
Allow no fast forward merge

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -AllowRebase
Allow rebase merge

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

### -AllowRebaseMerge
Allow rebase merge message

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: False
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
###   CollectionUri      = $CollectionUri
###   ProjectName        = $ProjectName
###   RepoName           = $RepoName
###   id                 = $res.id
###   allowSquash        = $res.settings.allowSquash
###   allowNoFastForward = $res.settings.allowNoFastForward
###   allowRebase        = $res.settings.allowRebase
###   allowRebaseMerge   = $res.settings.allowRebaseMerge
### }
## NOTES

## RELATED LINKS
