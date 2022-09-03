---
<<<<<<< HEAD
<<<<<<< HEAD
external help file: InSpark.InfrastructureAsCode-help.xml
Module Name: InSpark.InfrastructureAsCode
=======
external help file: InfrastructureAsCode-help.xml
Module Name: InfrastructureAsCode
>>>>>>> 690e7a4 (Working version)
=======
external help file: InSpark.InfrastructureAsCode-help.xml
Module Name: InSpark.InfrastructureAsCode
>>>>>>> 18d4dd8 (InitialVersion)
online version:
schema: 2.0.0
---

# Set-AzDoProjectSetting

## SYNOPSIS
<<<<<<< HEAD
<<<<<<< HEAD
{{ Fill in the Synopsis }}
=======
Sets the project settings for the given project.
>>>>>>> 690e7a4 (Working version)
=======
{{ Fill in the Synopsis }}
>>>>>>> 18d4dd8 (InitialVersion)

## SYNTAX

```
<<<<<<< HEAD
<<<<<<< HEAD
Set-AzDoProjectSetting [-CollectionUri] <String> [[-PAT] <String>] [-ProjectName] <String>
=======
Set-AzDoProjectSetting [-CollectionUri] <String> [-PAT] <String> [-ProjectName] <String>
>>>>>>> 690e7a4 (Working version)
=======
Set-AzDoProjectSetting [-CollectionUri] <String> [[-PAT] <String>] [-ProjectName] <String>
>>>>>>> 18d4dd8 (InitialVersion)
 [[-EnforceJobAuthScope] <Boolean>] [[-EnforceJobAuthScopeForReleases] <Boolean>]
 [[-EnforceReferencedRepoScopedToken] <Boolean>] [[-EnforceSettableVar] <Boolean>]
 [[-PublishPipelineMetadata] <Boolean>] [[-StatusBadgesArePrivate] <Boolean>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
<<<<<<< HEAD
<<<<<<< HEAD
{{ Fill in the Description }}

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}
=======
Sets the project settings for the given project.
=======
{{ Fill in the Description }}
>>>>>>> 18d4dd8 (InitialVersion)

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

<<<<<<< HEAD
This example sets all the settings available to true.
>>>>>>> 690e7a4 (Working version)
=======
{{ Add example description here }}
>>>>>>> 18d4dd8 (InitialVersion)

## PARAMETERS

### -CollectionUri
<<<<<<< HEAD
<<<<<<< HEAD
{{ Fill CollectionUri Description }}
=======
Collection uri of the organization.
Can be set with the predefined variable from Azure DevOps.
>>>>>>> 690e7a4 (Working version)
=======
{{ Fill CollectionUri Description }}
>>>>>>> 18d4dd8 (InitialVersion)

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
<<<<<<< HEAD
<<<<<<< HEAD
{{ Fill PAT Description }}
=======
PAT to get access to Azure DevOps.
>>>>>>> 690e7a4 (Working version)
=======
{{ Fill PAT Description }}
>>>>>>> 18d4dd8 (InitialVersion)

```yaml
Type: String
Parameter Sets: (All)
Aliases:

<<<<<<< HEAD
<<<<<<< HEAD
Required: False
Position: 2
Default value: $env:SYSTEM_ACCESSTOKEN
=======
Required: True
=======
Required: False
>>>>>>> 18d4dd8 (InitialVersion)
Position: 2
Default value: None
>>>>>>> 690e7a4 (Working version)
Accept pipeline input: False
Accept wildcard characters: False
```

### -ProjectName
<<<<<<< HEAD
<<<<<<< HEAD
{{ Fill ProjectName Description }}
=======
Name of the project
>>>>>>> 690e7a4 (Working version)
=======
{{ Fill ProjectName Description }}
>>>>>>> 18d4dd8 (InitialVersion)

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
<<<<<<< HEAD
<<<<<<< HEAD
{{ Fill EnforceJobAuthScope Description }}
=======
If enabled, scope of access for all pipelines reduces to the current project.
>>>>>>> 690e7a4 (Working version)
=======
{{ Fill EnforceJobAuthScope Description }}
>>>>>>> 18d4dd8 (InitialVersion)

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
<<<<<<< HEAD
<<<<<<< HEAD
Default value: None
=======
Default value: True
>>>>>>> 690e7a4 (Working version)
=======
Default value: None
>>>>>>> 18d4dd8 (InitialVersion)
Accept pipeline input: False
Accept wildcard characters: False
```

### -EnforceJobAuthScopeForReleases
<<<<<<< HEAD
<<<<<<< HEAD
{{ Fill EnforceJobAuthScopeForReleases Description }}
=======
Limit job authorization scope to current project for release pipelines.
>>>>>>> 690e7a4 (Working version)
=======
{{ Fill EnforceJobAuthScopeForReleases Description }}
>>>>>>> 18d4dd8 (InitialVersion)

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
<<<<<<< HEAD
<<<<<<< HEAD
Default value: None
=======
Default value: True
>>>>>>> 690e7a4 (Working version)
=======
Default value: None
>>>>>>> 18d4dd8 (InitialVersion)
Accept pipeline input: False
Accept wildcard characters: False
```

### -EnforceReferencedRepoScopedToken
<<<<<<< HEAD
<<<<<<< HEAD
{{ Fill EnforceReferencedRepoScopedToken Description }}
=======
Restricts the scope of access for all pipelines to only repositories explicitly referenced by the pipeline.
>>>>>>> 690e7a4 (Working version)
=======
{{ Fill EnforceReferencedRepoScopedToken Description }}
>>>>>>> 18d4dd8 (InitialVersion)

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
<<<<<<< HEAD
<<<<<<< HEAD
Default value: None
=======
Default value: True
>>>>>>> 690e7a4 (Working version)
=======
Default value: None
>>>>>>> 18d4dd8 (InitialVersion)
Accept pipeline input: False
Accept wildcard characters: False
```

### -EnforceSettableVar
<<<<<<< HEAD
<<<<<<< HEAD
{{ Fill EnforceSettableVar Description }}
=======
If enabled, only those variables that are explicitly marked as "Settable at queue time" can be set at queue time.
>>>>>>> 690e7a4 (Working version)
=======
{{ Fill EnforceSettableVar Description }}
>>>>>>> 18d4dd8 (InitialVersion)

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
<<<<<<< HEAD
<<<<<<< HEAD
Default value: None
=======
Default value: True
>>>>>>> 690e7a4 (Working version)
=======
Default value: None
>>>>>>> 18d4dd8 (InitialVersion)
Accept pipeline input: False
Accept wildcard characters: False
```

### -PublishPipelineMetadata
<<<<<<< HEAD
<<<<<<< HEAD
{{ Fill PublishPipelineMetadata Description }}
=======
Allows pipelines to record metadata.
>>>>>>> 690e7a4 (Working version)
=======
{{ Fill PublishPipelineMetadata Description }}
>>>>>>> 18d4dd8 (InitialVersion)

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
<<<<<<< HEAD
<<<<<<< HEAD
Default value: None
=======
Default value: False
>>>>>>> 690e7a4 (Working version)
=======
Default value: None
>>>>>>> 18d4dd8 (InitialVersion)
Accept pipeline input: False
Accept wildcard characters: False
```

### -StatusBadgesArePrivate
<<<<<<< HEAD
<<<<<<< HEAD
{{ Fill StatusBadgesArePrivate Description }}
=======
Anonymous users can access the status badge API for all pipelines unless this option is enabled.
>>>>>>> 690e7a4 (Working version)
=======
{{ Fill StatusBadgesArePrivate Description }}
>>>>>>> 18d4dd8 (InitialVersion)

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 9
<<<<<<< HEAD
<<<<<<< HEAD
Default value: None
=======
Default value: True
>>>>>>> 690e7a4 (Working version)
=======
Default value: None
>>>>>>> 18d4dd8 (InitialVersion)
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
<<<<<<< HEAD
<<<<<<< HEAD
Shows what would happen if the cmdlet runs. The cmdlet is not run.
=======
Shows what would happen if the cmdlet runs.
The cmdlet is not run.
>>>>>>> 690e7a4 (Working version)
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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

<<<<<<< HEAD
<<<<<<< HEAD
### None

## OUTPUTS

### System.Object
=======
## OUTPUTS

### PSobject
>>>>>>> 690e7a4 (Working version)
=======
### None

## OUTPUTS

### System.Object
>>>>>>> 18d4dd8 (InitialVersion)
## NOTES

## RELATED LINKS
