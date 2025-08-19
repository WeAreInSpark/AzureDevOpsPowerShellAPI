---
external help file: AzureDevOpsPowerShell-help.xml
Module Name: AzureDevOpsPowerShell
online version:
schema: 2.0.0
---

# Set-AzDoBranchPolicyCommentResolution

## SYNOPSIS
Creates a Comment resolution policy on a branch

## SYNTAX

```
Set-AzDoBranchPolicyCommentResolution [-CollectionUri] <String> [-ProjectName] <String> [-RepoName] <String[]>
 [[-Branch] <String>] [[-Required] <Boolean>] [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
Creates a Comment resolution policy on a branch

## EXAMPLES

### EXAMPLE 1
```
$params = @{
    CollectionUri = "https://dev.azure.com/contoso"
    RepoName = "Repo 1"
    ProjectName = "Project 1"
}
Set-AzDoBranchPolicyCommentResolution @params
```

This example creates a 'Comment resolution' policy with splatting parameters

### EXAMPLE 2
```
$env:SYSTEM_ACCESSTOKEN = '***'
'repo1', 'repo2' | Set-AzDoBranchPolicyCommentResolution -CollectionUri "https://dev.azure.com/contoso" -ProjectName "Project 1" -PAT "***"
```

This example creates a 'Comment resolution' policy on the main branch of repo1 and repo2

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

### -Required
Block pull requests until the comments are resolved

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
### id            = $res.id
### }
## NOTES

## RELATED LINKS
