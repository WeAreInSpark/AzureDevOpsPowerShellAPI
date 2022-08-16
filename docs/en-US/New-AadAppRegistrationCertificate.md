---
external help file: Module-help.xml
Module Name: Module
online version:
schema: 2.0.0
---

# New-AadAppRegistrationCertificate

## SYNOPSIS
Creates a Certificate and uploads it to the App registration.

## SYNTAX

```
New-AadAppRegistrationCertificate [-ObjectId] <String> [[-CertName] <String>] [[-KeyVaultName] <String>]
 [[-SubjectName] <String>] [[-ValidityInMonths] <Int32>] [<CommonParameters>]
```

## DESCRIPTION
Creates a Certificate and uploads it to the App registration.
The certificate will also be saves to an Azure KeyVault.

## EXAMPLES

### EXAMPLE 1
```
$newAadAppRegistrationCertificateSplat = @{
    ObjectID = "00000-00000-00000-00000"
    CertName = "cert01"
    KeyVaultName = "kv01"
    SubjectName = "contoso.com"
}
New-AadAppRegistrationCertificate @newAadAppRegistrationCertificateSplat
```

## PARAMETERS

### -ObjectId
Object Id of the App registration

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
CN for the certificate

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### PSobject containing thumbprint of certificate and 2 dates when the certificate is valid.
## NOTES

## RELATED LINKS
