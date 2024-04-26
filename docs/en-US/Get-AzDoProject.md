---
external help file: AzureDevOpsPowerShell-help.xml
Module Name: AzureDevOpsPowerShell
online version:
schema: 2.0.0
---

# Get-AzDoProject

## SYNOPSIS
Gets information about projects in Azure DevOps.

## SYNTAX

```
Get-AzDoProject [-CollectionUri] <String> [[-ProjectName] <String[]>] [-ProgressAction <ActionPreference>]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Gets information about all the projects in Azure DevOps.

## EXAMPLES

### EXAMPLE 1
```
$Params = @{
    CollectionUri = "https://dev.azure.com/contoso"
}
Get-AzDoProject @params
```

This example will List all the projects contained in the collection ('https://dev.azure.com/contoso').

### EXAMPLE 2
```
$Params = @{
    CollectionUri = "https://dev.azure.com/contoso"
    ProjectName = 'Project1'
}
Get-AzDoProject @params
```

This example will get the details of 'Project1' contained in the collection ('https://dev.azure.com/contoso').

### EXAMPLE 3
```
$params = @{
    collectionuri = "https://dev.azure.com/contoso"
}
$somedifferentobject = [PSCustomObject]@{
    ProjectName = 'Project1'
}
$somedifferentobject | Get-AzDoProject @params
```

This example will get the details of 'Project1' contained in the collection ('https://dev.azure.com/contoso').

### EXAMPLE 4
```
$params = @{
    collectionuri = "https://dev.azure.com/contoso"
}
@(
    'Project1',
    'Project2'
) | Get-AzDoProject @params
```

This example will get the details of 'Project1' contained in the collection ('https://dev.azure.com/contoso').

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
Project where the Repos are contained

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
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

### PSObject with repo(s).
## NOTES

## RELATED LINKS
