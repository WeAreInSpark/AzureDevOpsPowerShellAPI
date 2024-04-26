---
external help file: AzureDevOpsPowerShell-help.xml
Module Name: AzureDevOpsPowerShell
online version:
schema: 2.0.0
---

# Get-AzDoServiceConnection

## SYNOPSIS
Gets information about service connection in an Azure DevOps project.

## SYNTAX

```
Get-AzDoServiceConnection [-CollectionUri] <String> [-ProjectName] <String>
 [[-ServiceConnectionName] <String[]>] [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
Gets information about specific service connection if the parameter $ServiceConnectionName is filled in.
Otherwise it will list all the service connections.

## EXAMPLES

### EXAMPLE 1
```
$getAzDoServiceConnectionSplat = @{
  CollectionUri = "https://dev.azure.com/contoso"
  ProjectName = "Project 1"
}
Get-AzDoServiceConnection @getAzDoServiceConnectionSplat
```

This example will list all the service connections contained in 'Project 1'.

### EXAMPLE 2
```
$getAzDoServiceConnectionSplat = @{
  CollectionUri = "https://dev.azure.com/contoso"
  ProjectName = "Project 1"
  ServiceConnectionName = 'ServiceConnection1', 'ServiceConnection2'
}
Get-AzDoServiceConnection @getAzDoServiceConnectionSplat
```

This example will fetch information about the service connections 'ServiceConnection1', 'ServiceConnection2' in the project 'Project 1'.

### EXAMPLE 3
```
$getAzDoServiceConnectionSplat = @{
  CollectionUri = "https://dev.azure.com/contoso"
  ProjectName = "Project 1"
}
'ServiceConnection1', 'ServiceConnection2' | Get-AzDoServiceConnection @getAzDoServiceConnectionSplat
```

This example will fetch information about the service connections 'ServiceConnection1', 'ServiceConnection2' in the project 'Project 1'.

### EXAMPLE 4
```
[PSCustomObject]@{
  CollectionUri = "https://dev.azure.com/contoso"
  ProjectName = "Project 1"
  ServiceConnectionName = "Service Connection 1", "Service Connection 2"
} | Get-AzDoServiceConnection
```

This example will fetch information about the service connections 'ServiceConnection1', 'ServiceConnection2' in the project 'Project 1'.

### EXAMPLE 5
```
[PSCustomObject]@{
  CollectionUri = "https://dev.azure.com/contoso"
  ProjectName = "Project 1"
  ServiceConnectionName = "Service Connection 1", "Service Connection 2"
} | Get-AzDoServiceConnection
```

This example will fetch information about the service connections 'ServiceConnection1', 'ServiceConnection2' in the project 'Project 1'.

### EXAMPLE 6
```
@(
  [PSCustomObject]@{
  CollectionUri = "https://dev.azure.com/contoso"
  ProjectName = "Project 1"
  ServiceConnectionName = "Service Connection 1"
},
  [PSCustomObject]@{
    CollectionUri = "https://dev.azure.com/contoso"
    ProjectName = "Project 1"
    ServiceConnectionName = "Service Connection 2"
}
) | Get-AzDoServiceConnection
```

This example will fetch information about the service connections 'ServiceConnection1', 'ServiceConnection2' in the project 'Project 1'.

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
Project where the Service Connection is used

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

### -ServiceConnectionName
Name of the Service Connection to get information about

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
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

### PSCustomObject(s) with serviceconnections(s).
## NOTES

## RELATED LINKS
