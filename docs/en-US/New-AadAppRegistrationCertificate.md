---
external help file: InSpark.InfrastructureAsCode-help.xml
Module Name: InSpark.InfrastructureAsCode
online version:
schema: 2.0.0
---

# New-AadAppRegistrationCertificate

## SYNOPSIS
Creates a X.509 certificate and uploads it to the App registration in Azure AD.

## SYNTAX

```
New-AadAppRegistrationCertificate [-ObjectId] <String> [[-CertName] <String>] [[-KeyVaultName] <String>]
 [[-SubjectName] <String>] [[-ValidityInMonths] <Int32>] [-ManuallyConnectToGraph] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
Creates a X.509 certificate and uploads it as an authentication factor to the App registration in Azure AD.
The certificate will also be uploaded to an Azure KeyVault.

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

This example will create a new certificate for the app registration, upload it to the Application Registration in Azure AD and upload it to Azure KeyVault.

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

## OUTPUTS

### PSObject containing the thumbprint of the certificate and 2 dates when the certificate is valid.
## NOTES

## RELATED LINKS
