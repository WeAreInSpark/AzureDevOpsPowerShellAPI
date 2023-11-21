---
external help file: AzureDevOpsPowerShellAPI-help.xml
Module Name: AzureDevOpsPowerShellAPI
online version:
schema: 2.0.0
---

# Get-AzDoServiceConnection

## SYNOPSIS
Gets information about a repo in Azure DevOps.

## SYNTAX

```
Get-AzDoServiceConnection [-CollectionUri] <String> [-ProjectName] <String> [[-PAT] <String>]
 [[-ServiceConnectionName] <String[]>] [<CommonParameters>]
```

## DESCRIPTION
Gets information about 1 repo if the parameter $Name is filled in.
Otherwise it will list all the repo's.

## EXAMPLES

### EXAMPLE 1
```
$Params = @{
    CollectionUri = "https://dev.azure.com/contoso"
    PAT = "***"
    ProjectName = "Project 1"
    Name "Repo 1"
}
Get-AzDoRepo -CollectionUri = "https://dev.azure.com/contoso" -PAT = "***" -ProjectName = "Project 1"
```

This example will list all the repo's contained in 'Project 1'.

### EXAMPLE 2
```
$Params = @{
    CollectionUri = "https://dev.azure.com/contoso"
    PAT = "***"
    ProjectName = "Project 1"
    Name "Repo 1"
}
Get-AzDoRepo -CollectionUri = "https://dev.azure.com/contoso" -PAT = "***" -ProjectName = "Project 1" -Name "Repo 1"
```

This example will fetch information about the repo with the name 'Repo 1'.

### EXAMPLE 3
```
$Params = @{
    CollectionUri = "https://dev.azure.com/contoso"
    PAT = "***"
    Name "Repo 1"
}
get-AzDoProject -pat $pat -CollectionUri $collectionuri | Get-AzDoRepo -PAT $PAT
```

This example will fetch information about the repo with the name 'Repo 1'.

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
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -PAT
PAT to authenticate with the organization

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ServiceConnectionName
Name of the Repo to get information about

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
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
