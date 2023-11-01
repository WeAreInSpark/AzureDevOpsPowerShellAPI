---
external help file: AzureDevOpsPowerShellAPI-help.xml
Module Name: AzureDevOpsPowerShellAPI
online version:
schema: 2.0.0
---

# Get-AzDoProject

## SYNOPSIS
Gets information about projects in Azure DevOps.

## SYNTAX

```
Get-AzDoProject [[-CollectionUri] <String>] [[-PAT] <String>] [[-ProjectName] <String>] [<CommonParameters>]
```

## DESCRIPTION
Gets information about all the projects in Azure DevOps.

## EXAMPLES

### EXAMPLE 1
```
$Params = @{
    CollectionUri = "https://dev.azure.com/contoso"
    PAT = "***"
}
Get-AzDoProject @params
```

This example will List all the projects contained in the collection ('https://dev.azure.com/contoso').

### EXAMPLE 2
```
$Params = @{
    CollectionUri = "https://dev.azure.com/contoso"
    PAT = "***"
    ProjectName = 'Project1'
}
Get-AzDoProject @params
```

This example will get the details of 'Project1' contained in the collection ('https://dev.azure.com/contoso').

### EXAMPLE 3
```
$params = @{
    collectionuri = "https://dev.azure.com/contoso"
    PAT = "***"
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
    PAT = "***"
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

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PAT
PAT to authenticate with the organization

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ProjectName
Project where the Repos are contained

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### PSObject with repo(s).
## NOTES

## RELATED LINKS
