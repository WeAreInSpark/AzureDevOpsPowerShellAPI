---
external help file: InSpark.InfrastructureAsCode-help.xml
Module Name: InSpark.InfrastructureAsCode
online version:
schema: 2.0.0
---

# New-AadAppRegistrationCertificate

## SYNOPSIS
<<<<<<< HEAD
Creates a X.509 certificate and uploads it to the App registration in Azure AD.
=======
This script creates a new certificate or secret for an existing app registration.
>>>>>>> 18d4dd8 (InitialVersion)

## SYNTAX

```
New-AadAppRegistrationCertificate [-ObjectId] <String> [[-CertName] <String>] [[-KeyVaultName] <String>]
 [[-SubjectName] <String>] [[-ValidityInMonths] <Int32>] [-ManuallyConnectToGraph] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
<<<<<<< HEAD
Creates a X.509 certificate and uploads it as an authentication factor to the App registration in Azure AD.
The certificate will also be uploaded to an Azure KeyVault.
=======
This script creates a new certificate or secret for an existing app registration.
>>>>>>> 18d4dd8 (InitialVersion)

## EXAMPLES

### EXAMPLE 1
```
To create a secret that lasts 1 year for an existing app registration, input the Application (client) ID of the app registration, a name for $ClientSecretName and set
$ClientSecretDuration to 1.
```

<<<<<<< HEAD
This example will create a new certificate for the app registration, upload it to the Application Registration in Azure AD and upload it to Azure KeyVault.

=======
>>>>>>> 18d4dd8 (InitialVersion)
## PARAMETERS

### -ObjectId
Application (client) ID of the app registration

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

### -CertName
Name of the certificate

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

### -KeyVaultName
Name of the Azure Key Vault to store the certificate

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

### -SubjectName
{{ Fill SubjectName Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ValidityInMonths
Amount of months the certificate must be valid

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: 6
Accept pipeline input: False
Accept wildcard characters: False
```

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

### New-AppRegistrationSecret -ClientSecretName <String> [-Append <Boolean>] -ClientId <String> -ClientSecretDuration <Int32> [-CreateCert <Boolean>] [-CertName <String>]
### [-KeyVaultName <String>] [<CommonParameters>]
### New-AppRegistrationSecret -ClientSecretName <String> [-Append <Boolean>] -ClientId <String> -EndDate <String> [-CreateCert <Boolean>] [-CertName <String>] [-KeyVaultName
### <String>] [<CommonParameters>]
## OUTPUTS

<<<<<<< HEAD
### PSObject containing the thumbprint of the certificate and 2 dates when the certificate is valid.
=======
### New credentials in an app registration, and a variable with the secret.
>>>>>>> 18d4dd8 (InitialVersion)
## NOTES

## RELATED LINKS
