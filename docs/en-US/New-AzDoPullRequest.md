---
external help file: AzureDevOpsPowerShell-help.xml
Module Name: AzureDevOpsPowerShell
online version:
schema: 2.0.0
---

# New-AzDoPullRequest

## SYNOPSIS
Creates a pull request in Azure DevOps.

## SYNTAX

```
New-AzDoPullRequest [-CollectionUri] <String> [-RepoName] <String> [-ProjectName] <String> [-Title] <String> [-Description] <String> [-SourceRefName] <String> [-TargetRefName] <String>
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Creates a pull request in Azure DevOps.

## EXAMPLES

### EXAMPLE 1
```
$params = @{
        CollectionUri  = "https://dev.azure.com/contoso"
        RepoName       = "Repo 1"
        ProjectName    = "Project 1"
        Title          = "New Pull Request"
        Description    = "This is a new pull request"
        SourceRefName  = "refs/heads/feature1"
        TargetRefName  = "refs/heads/main"
    }
    New-AzDoPullRequest @params
```

This example creates a new Azure DevOps Pull Request with splatting parameters

### Example 2
```
$params = @{
        CollectionUri = "https://dev.azure.com/contoso"
        RepoName         = "Repo1"
        ProjectName   = "Project 1"
        Title          = "New Pull Request"
        Description    = "This is a new pull request"
        SourceRefName  = "refs/heads/feature1"
        TargetRefName  = "refs/heads/main"
    }
    $params | New-AzDoPullRequest

    This example creates a new Azure DevOps Pull Request with pipeline parameters
```
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

### -RepoName
Name of the repo

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -ProjectName
Name of the project where the repository is hosted

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Title
The title of the new pull request

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 4
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Description
The description of the new pull request

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 5
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -SourceRefName
The source branch path of the pull request

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 6
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -TargetRefName
The target branch path of the pull request

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 7
Default value: None
Accept pipeline input: True (ByPropertyName)
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
###     CollectionUri  = $CollectionUri
###     ProjectName    = $ProjectName
###     RepoId         = $RepoId
###     PullRequestId  = $res.pullRequestId
###     PullRequestURL = $res.url
###   }
## NOTES

## RELATED LINKS
