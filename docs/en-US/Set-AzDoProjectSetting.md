---
external help file: InfrastructureAsCode-help.xml
Module Name: InfrastructureAsCode
online version:
schema: 2.0.0
---

# Set-AzDoProjectSetting

## SYNOPSIS
Sets the project settings for the given project.

## SYNTAX

```
Set-AzDoProjectSetting [-CollectionUri] <String> [-PAT] <String> [-ProjectName] <String>
 [[-EnforceJobAuthScope] <Boolean>] [[-EnforceJobAuthScopeForReleases] <Boolean>]
 [[-EnforceReferencedRepoScopedToken] <Boolean>] [[-EnforceSettableVar] <Boolean>]
 [[-PublishPipelineMetadata] <Boolean>] [[-StatusBadgesArePrivate] <Boolean>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
Sets the project settings for the given project.

## EXAMPLES

### EXAMPLE 1
```
$params = @{
    CollectionUri = "https://dev.azure.com/contoso"
    PAT = "***"
    ProjectName = "Project01"
    EnforceJobAuthScope = $true
    EnforceJobAuthScopeForReleases = $true
    EnforceReferencedRepoScopedToken = $true
    EnforceSettableVar = $true
    PublishPipelineMetadata = $true
    StatusBadgesArePrivate = $true
}
Set-AzDOProjectSettings
```

This example sets all the settings available to true.

## PARAMETERS

### -CollectionUri
Collection uri of the organization.
Can be set with the predefined variable from Azure DevOps.

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
PAT to get access to Azure DevOps.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ProjectName
Name of the project

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

### -EnforceJobAuthScope
If enabled, scope of access for all pipelines reduces to the current project.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: True
Accept pipeline input: False
Accept wildcard characters: False
```

### -EnforceJobAuthScopeForReleases
Limit job authorization scope to current project for release pipelines.

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

### -EnforceReferencedRepoScopedToken
Restricts the scope of access for all pipelines to only repositories explicitly referenced by the pipeline.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: True
Accept pipeline input: False
Accept wildcard characters: False
```

### -EnforceSettableVar
If enabled, only those variables that are explicitly marked as "Settable at queue time" can be set at queue time.

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

### -PublishPipelineMetadata
Allows pipelines to record metadata.

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

### -StatusBadgesArePrivate
Anonymous users can access the status badge API for all pipelines unless this option is enabled.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 9
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

### PSobject
## NOTES

## RELATED LINKS
