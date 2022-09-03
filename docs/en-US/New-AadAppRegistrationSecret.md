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

# New-AadAppRegistrationSecret

## SYNOPSIS
<<<<<<< HEAD
<<<<<<< HEAD
Creates a secret and set it to the App registration in Azure AD.
=======
This script creates a new certificate or secret for an existing app registration.
>>>>>>> 18d4dd8 (InitialVersion)
=======
Creates a secret for the App registration
>>>>>>> 690e7a4 (Working version)

## SYNTAX

```
<<<<<<< HEAD
New-AadAppRegistrationSecret [-ObjectID] <String> [-ClientSecretName] <String> [-EndDate] <String>
 [-ManuallyConnectToGraph] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
<<<<<<< HEAD
Creates a secret and uploads it as an authentication factor to the App registration in Azure AD.
The secret will also be uploaded to an Azure KeyVault.
=======
This script creates a new certificate or secret for an existing app registration.
>>>>>>> 18d4dd8 (InitialVersion)
=======
New-AadAppRegistrationSecret -ObjectID <String> -ClientSecretName <String> -EndDate <String> [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Creates a secret for the App registration.
The secret will get uploaded to an Azure KeyVault.
>>>>>>> 690e7a4 (Working version)

## EXAMPLES

### EXAMPLE 1
```
<<<<<<< HEAD
To create a secret that lasts 1 year for an existing app registration, input the Application (client) ID of the app registration, a name for $ClientSecretName and set
$ClientSecretDuration to 1.
```

<<<<<<< HEAD
This example will create a new secret for the app registration, upload it to the Azure KeyVault and add it to the Application Registration in Azure AD.

=======
>>>>>>> 18d4dd8 (InitialVersion)
=======
$newAadAppRegistrationSecretSplat = @{
    ObjectID = "00000-00000-00000-00000-00000"
    ClientSecretName = "Secret 1"
    EndDate = "2022-01-01"
}
New-AadAppRegistrationSecret @newAadAppRegistrationSecretSplat
```

This example will create a new secret for the app registration.

>>>>>>> 690e7a4 (Working version)
## PARAMETERS

### -ObjectID
Application (client) ID of the app registration

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
<<<<<<< HEAD
Position: 1
=======
Position: Named
>>>>>>> 690e7a4 (Working version)
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ClientSecretName
Display name of the secret

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
<<<<<<< HEAD
Position: 2
=======
Position: Named
>>>>>>> 690e7a4 (Working version)
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EndDate
<<<<<<< HEAD
Enddate of validity of the secret
=======
Duration of the secret until this date
>>>>>>> 690e7a4 (Working version)

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
<<<<<<< HEAD
Position: 3
=======
Position: Named
>>>>>>> 690e7a4 (Working version)
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
Shows what would happen if the cmdlet runs.
The cmdlet is not run.
=======
### -WhatIf
Shows what would happen if the cmdlet runs. The cmdlet is not run.
>>>>>>> 690e7a4 (Working version)

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
### New-AppRegistrationSecret -ClientSecretName <String> [-Append <Boolean>] -ClientId <String> -ClientSecretDuration <Int32> [-CreateCert <Boolean>] [-CertName <String>]
### [-KeyVaultName <String>] [<CommonParameters>]
### New-AppRegistrationSecret -ClientSecretName <String> [-Append <Boolean>] -ClientId <String> -EndDate <String> [-CreateCert <Boolean>] [-CertName <String>] [-KeyVaultName
### <String>] [<CommonParameters>]
## OUTPUTS

### New credentials in an app registration, and a variable with the secret.
=======
## OUTPUTS

### The Appsecret
>>>>>>> 690e7a4 (Working version)
## NOTES

## RELATED LINKS
