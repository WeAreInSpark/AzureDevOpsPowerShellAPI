---
external help file: InfrastructureAsCode-help.xml
Module Name: InfrastructureAsCode
online version:
schema: 2.0.0
---

# New-AzDoRepo

## SYNOPSIS
Creates a repo in Azure DevOps.

## SYNTAX

```
New-AzDoRepo [-CollectionUri] <String> [-PAT] <String> [-Name] <String> [-ProjectId] <String> [-WhatIf]
 [-Confirm] [<CommonParameters>]
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
    ProjectId     = "00000-00000-00000-00000-00000"
}
New-AzDoRepo @params
```

This example creates a new Azure DevOps repo

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
Accept pipeline input: False
Accept wildcard characters: False
```

### -PAT
PAT to authentice with the organization

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

### -Name
Project where the variable group has to be created

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

### -ProjectId
Project where the variable group has to be created

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

### PSObject
### Containg the repo information
## NOTES

## RELATED LINKS
