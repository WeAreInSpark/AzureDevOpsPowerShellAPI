---
external help file: AzureDevOpsPowerShellAPI-help.xml
Module Name: AzureDevOpsPowerShellAPI
online version:
schema: 2.0.0
---

# Set-AzDoBranchPolicyMinimalApproval

## SYNOPSIS
Creates a Minimal approval policy on a branch

## SYNTAX

```
Set-AzDoBranchPolicyMinimalApproval [-CollectionUri] <String> [-ProjectName] <String> [[-PAT] <String>]
 [-RepoName] <String> [[-branch] <String>] [[-minimumApproverCount] <Int32>] [[-creatorVoteCounts] <Boolean>]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Creates a Minimal approval policy on a branch

## EXAMPLES

### EXAMPLE 1
```
$params = @{
    CollectionUri = "https://dev.azure.com/contoso"
    PAT = "***"
    RepoName = "Repo 1"
    ProjectName = "Project 1"
}
Set-AzDoBranchPolicyMinimalApproval @params
```

This example creates a new Azure Pipeline using the PowerShell pipeline

### EXAMPLE 2
```
'repo1', 'repo2' |
Set-AzDoBranchPolicyMinimalApproval -CollectionUri $CollectionUri -ProjectName $ProjectName -PAT "***"
```

This example creates a 'Minimum number of reviewers' policy on the main branch of repo1 and repo2

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
Accept pipeline input: True (ByPropertyName, ByValue)
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
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -PAT
PAT to authentice with the organization

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RepoName
Name of the Repository containing the YAML-sourcecode

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 4
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -branch
Branch to create the policy on

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: Main
Accept pipeline input: False
Accept wildcard characters: False
```

### -minimumApproverCount
Block pull requests until the comments are resolved

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: 2
Accept pipeline input: False
Accept wildcard characters: False
```

### -creatorVoteCounts
Block self approval

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: True
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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### [PSCustomObject]@{
### CollectionUri               = $CollectionUri
### ProjectName                 = $ProjectName
### RepoName                    = $RepoName
### id                          = $res.id
### minimumApproverCount        = $res.settings.minimumApproverCount
### creatorVoteCounts           = $res.settings.creatorVoteCounts
### allowDownvotes              = $res.settings.allowDownvotes
### resetOnSourcePush           = $res.settings.resetOnSourcePush
### requireVoteOnLastIteration  = $res.settings.requireVoteOnLastIteration
### resetRejectionsOnSourcePush = $res.settings.resetRejectionsOnSourcePush
### blockLastPusherVote         = $res.settings.blockLastPusherVote
### requireVoteOnEachIteration  = $res.settings.requireVoteOnEachIteration
### }
## NOTES

## RELATED LINKS
