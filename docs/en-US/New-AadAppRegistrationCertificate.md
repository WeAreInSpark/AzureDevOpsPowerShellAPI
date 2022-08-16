---
external help file: Module-help.xml
Module Name: Module
online version:
schema: 2.0.0
---

# New-AadAppRegistrationCertificate

## SYNOPSIS
This script creates a new certificate or secret for an existing app registration.

## SYNTAX

```
New-AadAppRegistrationCertificate [-ObjectId] <String> [[-CertName] <String>] [[-KeyVaultName] <String>]
 [[-SubjectName] <String>] [[-ValidityInMonths] <Int32>] [<CommonParameters>]
```

## DESCRIPTION
This script creates a new certificate or secret for an existing app registration.

## EXAMPLES

### EXAMPLE 1
```
To create a secret that lasts 1 year for an existing app registration, input the Application (client) ID of the app registration, a name for $ClientSecretName and set
$ClientSecretDuration to 1.
```

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
Name of the keyvault to store the certificate

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
{{ Fill ValidityInMonths Description }}

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### New-AppRegistrationSecret -ClientSecretName <String> [-Append <Boolean>] -ClientId <String> -ClientSecretDuration <Int32> [-CreateCert <Boolean>] [-CertName <String>]
### [-KeyVaultName <String>] [<CommonParameters>]
### New-AppRegistrationSecret -ClientSecretName <String> [-Append <Boolean>] -ClientId <String> -EndDate <String> [-CreateCert <Boolean>] [-CertName <String>] [-KeyVaultName
### <String>] [<CommonParameters>]
## OUTPUTS

### New credentials in an app registration, and a variable with the secret.
## NOTES

## RELATED LINKS
