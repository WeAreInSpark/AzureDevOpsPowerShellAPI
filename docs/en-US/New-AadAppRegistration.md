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

# New-AadAppRegistration

## SYNOPSIS
<<<<<<< HEAD
<<<<<<< HEAD
This script creates a new app registration with a certificate or secret.
=======
Creates an App registration in Azure AD.
>>>>>>> 690e7a4 (Working version)
=======
This script creates a new app registration with a certificate or secret.
>>>>>>> 18d4dd8 (InitialVersion)

## SYNTAX

```
<<<<<<< HEAD
New-AadAppRegistration [-Name] <String> [-ManuallyConnectToGraph] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
<<<<<<< HEAD
Creates an App regestration in Azure AD, if no App registration with the same name exists.
=======
This script creates a new app registration with a certificate or secret.
>>>>>>> 18d4dd8 (InitialVersion)
=======
New-AadAppRegistration [-Name] <String> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
<<<<<<< HEAD
Creates an App regestration in Azure AD when no App registration with the same name exists.
>>>>>>> 690e7a4 (Working version)
=======
This script creates a new app registration with a certificate or secret.
>>>>>>> 18d4dd8 (InitialVersion)

## EXAMPLES

### EXAMPLE 1
```
<<<<<<< HEAD
<<<<<<< HEAD
To create an app registration with a secret that lasts 1 year, choose a name for $AppRegName, a name for $ClientSecretName and set $ClientSecretDuration to 1.
```

## PARAMETERS

### -Name
Name of the app registration
=======
New-AadAppRegistration -Name "App 1"
=======
To create an app registration with a secret that lasts 1 year, choose a name for $AppRegName, a name for $ClientSecretName and set $ClientSecretDuration to 1.
>>>>>>> 18d4dd8 (InitialVersion)
```

## PARAMETERS

### -Name
<<<<<<< HEAD
Name of the App registration
>>>>>>> 690e7a4 (Working version)
=======
Name of the app registration
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

<<<<<<< HEAD
### -ManuallyConnectToGraph
Manually connect to Microsoft Graph

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs. The cmdlet is not run.
=======
### -WhatIf
<<<<<<< HEAD
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
=======
>>>>>>> 18d4dd8 (InitialVersion)
### New-AppRegistration -AppRegName <String> -ClientSecretName <String> -EndDate <String> [-Append <Boolean>] [-CreateCert <Boolean>] [-CertName <String>] [-KeyVaultName <String>]
### [<CommonParameters>]
### New-AppRegistration -AppRegName <String> -ClientSecretName <String> -ClientSecretDuration <Int32> [-Append <Boolean>] [-CreateCert <Boolean>] [-CertName <String>] [-KeyVaultName
### <String>] [<CommonParameters>]
<<<<<<< HEAD
## OUTPUTS

<<<<<<< HEAD
### PSobject with the object ID and application ID of the App registration.
=======
### New app registration with credentials, and variables with the ID and secret.
>>>>>>> 18d4dd8 (InitialVersion)
=======
## OUTPUTS

### PSobject with the object ID and application ID of the App registration
>>>>>>> 690e7a4 (Working version)
=======
## OUTPUTS

### New app registration with credentials, and variables with the ID and secret.
>>>>>>> 18d4dd8 (InitialVersion)
## NOTES

## RELATED LINKS
