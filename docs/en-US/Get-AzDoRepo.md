---
<<<<<<< HEAD
external help file: InSpark.InfrastructureAsCode-help.xml
Module Name: InSpark.InfrastructureAsCode
=======
external help file: InfrastructureAsCode-help.xml
Module Name: InfrastructureAsCode
>>>>>>> 690e7a4 (Working version)
online version:
schema: 2.0.0
---

# Get-AzDoRepo

## SYNOPSIS
<<<<<<< HEAD
Gets information about a repo in Azure DevOps.
=======
Get information about a repo in Azure DevOps.
>>>>>>> 690e7a4 (Working version)

## SYNTAX

```
<<<<<<< HEAD
<<<<<<< HEAD
Get-AzDoRepo -CollectionUri <String> [-PAT <String>] [-RepoName <String>] -ProjectName <String>
=======
Get-AzDoRepo [-CollectionUri] <String> [[-PAT] <String>] [[-Name] <String>] [-ProjectName] <String>
>>>>>>> 18d4dd8 (InitialVersion)
=======
Get-AzDoRepo [-CollectionUri] <String> [-PAT] <String> [[-Name] <String>] [-ProjectName] <String>
>>>>>>> 690e7a4 (Working version)
 [<CommonParameters>]
```

## DESCRIPTION
<<<<<<< HEAD
Gets information about 1 repo if the parameter $Name is filled in.
Otherwise it will list all the repo's.
=======
Get information about 1 repo if the parameter $Name is filled in.
Otherwise it will get all the repo's
>>>>>>> 690e7a4 (Working version)

## EXAMPLES

### EXAMPLE 1
```
$Params = @{
    CollectionUri = "https://dev.azure.com/contoso"
    PAT = "***"
    ProjectName = "Project 1"
    Name "Repo 1"
}
<<<<<<< HEAD
<<<<<<< HEAD
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
=======
>>>>>>> 690e7a4 (Working version)
Get-AzDoRepo -CollectionUri = "https://dev.azure.com/contoso" -PAT = "***" -ProjectName = "Project 1" -Name "Repo 1"
```

This example will fetch information about the repo with the name 'Repo 1'.

<<<<<<< HEAD
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

=======
Get-AzDoRepo @Params
```

>>>>>>> 18d4dd8 (InitialVersion)
=======
>>>>>>> 690e7a4 (Working version)
## PARAMETERS

### -CollectionUri
Collection Uri of the organization

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
<<<<<<< HEAD
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
=======
Position: 1
Default value: None
Accept pipeline input: False
>>>>>>> 690e7a4 (Working version)
Accept wildcard characters: False
```

### -PAT
<<<<<<< HEAD
<<<<<<< HEAD
PAT to authenticate with the organization
=======
=======
>>>>>>> 690e7a4 (Working version)
PAT to authentice with the organization

```yaml
Type: String
Parameter Sets: (All)
Aliases:

<<<<<<< HEAD
Required: False
=======
Required: True
>>>>>>> 690e7a4 (Working version)
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
Project where the variable group has to be created
<<<<<<< HEAD
>>>>>>> 18d4dd8 (InitialVersion)
=======
>>>>>>> 690e7a4 (Working version)

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
<<<<<<< HEAD
Position: Named
Default value: $env:SYSTEM_ACCESSTOKEN
Accept pipeline input: False
Accept wildcard characters: False
```

### -RepoName
Name of the Repo to get information about

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
=======
Position: 3
>>>>>>> 690e7a4 (Working version)
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ProjectName
<<<<<<< HEAD
Project where the Repos are contained
=======
Project where the variable group has to be created
>>>>>>> 690e7a4 (Working version)

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
<<<<<<< HEAD
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
=======
Position: 4
Default value: None
Accept pipeline input: False
>>>>>>> 690e7a4 (Working version)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

<<<<<<< HEAD
### Get-AzDoRepo [-CollectionUri] <string> [-PAT] <string> [-ProjectName] <string> [-Name] <string>
=======
>>>>>>> 690e7a4 (Working version)
## OUTPUTS

### PSObject with repo(s).
## NOTES

## RELATED LINKS
