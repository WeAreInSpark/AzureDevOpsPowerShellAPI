---
external help file: AzureDevOpsPowerShell-help.xml
Module Name: AzureDevOpsPowerShell
online version:
schema: 2.0.0
---

# New-AzDoRepo

## SYNOPSIS
Creates a repo in Azure DevOps.

## SYNTAX

```
New-AzDoRepo [-CollectionUri] <String> [-RepoName] <String[]> [-ProjectName] <String>
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Creates a repo in Azure DevOps.

## EXAMPLES

### EXAMPLE 1
```
$params = @{
    CollectionUri = "https://dev.azure.com/contoso"
    PAT           = "***"
    Name          = "Repo 1"
    ProjectName   = "Project 1"
}
New-AzDoRepo @params
```

This example creates a new Azure DevOps repo with splatting parameters

### EXAMPLE 2
```
$env:SYSTEM_ACCESSTOKEN = '***'
'test', 'test2' | New-AzDoRepo -CollectionUri "https://dev.azure.com/contoso" -ProjectName "Project 1"
```

This example creates a new Azure DevOps repo for each in pipeline

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
Name of the new repository

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
Name of the project where the new repository has to be created

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
### RepoName      = $res.name
### RepoId        = $res.id
### RepoURL       = $res.url
### WebUrl        = $res.webUrl
### HttpsUrl      = $res.remoteUrl
### SshUrl        = $res.sshUrl
### }
## NOTES

## RELATED LINKS
