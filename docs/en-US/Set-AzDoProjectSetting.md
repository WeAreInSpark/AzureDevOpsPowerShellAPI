---
external help file: AzureDevOpsPowerShell-help.xml
Module Name: AzureDevOpsPowerShell
online version:
schema: 2.0.0
---

# Set-AzDoProjectSetting

## SYNOPSIS
Sets the project settings for the given project.

## SYNTAX

```
Set-AzDoProjectSetting [-CollectionUri] <String> [-ProjectName] <String> [-BuildsEnabledForForks]
 [-DisableClassicBuildPipelineCreation] [-DisableClassicPipelineCreation]
 [-DisableClassicReleasePipelineCreation] [-DisableImpliedYAMLCiTrigger] [-EnableShellTasksArgsSanitizing]
 [-EnableShellTasksArgsSanitizingAudit] [-EnforceJobAuthScope] [-EnforceJobAuthScopeForForks]
 [-EnforceJobAuthScopeForReleases] [-EnforceNoAccessToSecretsFromForks] [-EnforceReferencedRepoScopedToken]
 [-EnforceSettableVar] [-ForkProtectionEnabled] [-IsCommentRequiredForPullRequest] [-PublishPipelineMetadata]
 [-RequireCommentsForNonTeamMemberAndNonContributors] [-RequireCommentsForNonTeamMembersOnly]
 [-StatusBadgesArePrivate] [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Sets the project settings for the given project.

## EXAMPLES

### EXAMPLE 1
```
$params = @{
    CollectionUri = "https://dev.azure.com/contoso"
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

### -ProjectName
Name of the project

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

### -BuildsEnabledForForks
If enabled, enables forked repositories to build pull requests.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -DisableClassicBuildPipelineCreation
If enabled, disables classic build pipelines creation.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -DisableClassicPipelineCreation
If enabled, disables classic pipelines creation.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -DisableClassicReleasePipelineCreation
If enabled, disables classic release pipelines creation.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -DisableImpliedYAMLCiTrigger
If enabled, disables implied pipeline CI triggers if the trigger section in YAML is missing.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -EnableShellTasksArgsSanitizing
Enable shell tasks args sanitizing.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -EnableShellTasksArgsSanitizingAudit
Enable shell tasks args sanitizing preview.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -EnforceJobAuthScope
Limit job authorization scope to current project for for all non-release pipelines reduces to the current project.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -EnforceJobAuthScopeForForks
Limit job authorization scope to current project for builds of forked repositories.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -EnforceJobAuthScopeForReleases
Limit job authorization scope to current project for release pipelines.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -EnforceNoAccessToSecretsFromForks
Enforce no access to secrets for builds of forked repositories.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -EnforceReferencedRepoScopedToken
Restricts the scope of access for all pipelines to only repositories explicitly referenced by the pipeline.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -EnforceSettableVar
If enabled, only those variables that are explicitly marked as "Settable at queue time" can be set at queue time.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ForkProtectionEnabled
Enable settings that enforce certain levels of protection for building pull requests from forks globally.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -IsCommentRequiredForPullRequest
Make comments required to have builds in all pull requests.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -PublishPipelineMetadata
Allows pipelines to record metadata.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -RequireCommentsForNonTeamMemberAndNonContributors
Make comments required to have builds in pull requests from non-team members and non-contributors.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -RequireCommentsForNonTeamMembersOnly
Make comments required to have builds in pull requests from non-team members and non-contributors.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -StatusBadgesArePrivate
Anonymous users can access the status badge API for all pipelines unless this option is enabled.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
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

### PSobject
## NOTES

## RELATED LINKS
