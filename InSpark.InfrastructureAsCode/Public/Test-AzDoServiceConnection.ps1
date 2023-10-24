function Test-AzDoServiceConnection {
    <#
    .SYNOPSIS
        Function to create a service connection in Azure DevOps
    .DESCRIPTION
        Function to create a service connection in Azure DevOps
    .EXAMPLE
        $params = @{
            CollectionUri               = "https://dev.azure.com/contoso"
            PAT                         = "***"
            ProjectName                 = "Project 1"
            SubscriptionId              = "00000-00000-00000-00000-00000"
            SubscriptionName            = "Subscription 1"
            Tenantid                    = "11111-11111-11111-11111-11111"
            Serviceprincipalid          = "1c03163f-7e4e-4fab-8b41-6f040a8361b9"
            KeyVaultName                = "kv01"
            CertName                    = "Cert01"
            AuthenticationType          = "spnCertificate"
            ProjectID                   = "1f31cb4d-5a69-419f-86f0-ee3a8ed9ced2"
            Name                        = "Project 1"
        }
        Test-AzDoServiceConnection @params

        This example creates a new Azure DevOps service connection with a Certificate from a KeyVault in Azure.
    #>

    [CmdletBinding(SupportsShouldProcess)]
    param (
        # Name of the Project in Azure DevOps.
        [Parameter(Mandatory)]
        [string]
        $ProjectName,

        # Collection Uri. e.g. https://dev.azure.com/contoso.
        [Parameter(Mandatory)]
        [string]
        $CollectionUri,

        # PAT to get access to Azure DevOps.
        [Parameter()]
        [string]
        $PAT = $env:SYSTEM_ACCESSTOKEN,

        # Switch to use PAT instead of OAuth
        [Parameter()]
        [switch]
        $UsePAT = $false,

        # Collection Uri. e.g. https://dev.azure.com/contoso.
        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ValueFromPipeline)]
        [string[]]
        $ServiceConnectionName
    )
    begin {
        # Validate if the user is logged into azure
        if ($KeyVaultName) {
            if (!(Get-AzContext)) {
                try {
                    Write-Error 'Please login to Azure first'
                    throw
                } catch {
                    $PSCmdlet.ThrowTerminatingError($_)
                }
            }
        }
        if ($UsePAT) {
            Write-Verbose 'The [UsePAT]-parameter was set to true, so the PAT will be used to authenticate with the organization.'
            if ($PAT -eq $env:SYSTEM_ACCESSTOKEN) {
                Write-Verbose -Message "Using the PAT from the environment variable 'SYSTEM_ACCESSTOKEN'."
            } elseif (-not [string]::IsNullOrWhitespace($PAT) -and $PSBoundParameters.ContainsKey('PAT')) {
                Write-Verbose -Message "Using a custom PAT supplied in the parameters."
            } else {
                try {
                    throw "Requested to use a PAT, but no custom PAT was supplied in the parameters or the environment variable 'SYSTEM_ACCESSTOKEN' was not set."
                } catch {
                    $PSCmdlet.ThrowTerminatingError($_)
                }
            }
        } else {
            Write-Verbose 'The [UsePAT]-parameter was set to false, so an OAuth will be used to authenticate with the organization.'
            $PAT = ($UsePAT ? $PAT : $null)
        }
        try {
            $Header = New-ADOAuthHeader -PAT $PAT -AccessToken:($UsePAT ? $false : $true) -ErrorAction Stop
        } catch {
            $PSCmdlet.ThrowTerminatingError($_)
        }

        $getAzDoProjectSplat = @{
            CollectionUri = $CollectionUri
        }

        if ($PAT) {
            $getAzDoProjectSplat += @{
                PAT    = $PAT
                UsePAT = $true
            }
        }

        $Projects = Get-AzDoProject @getAzDoProjectSplat
        $ProjectId = ($Projects | Where-Object ProjectName -EQ $ProjectName).Projectid

        $getAzDoServiceConnectionSplat = @{
            CollectionUri = $CollectionUri
            ProjectName   = $ProjectName
        }

        if ($PAT) {
            $getAzDoServiceConnectionSplat += @{
                PAT    = $PAT
                UsePAT = $true
            }
        }

        $Connections = Get-AzDoServiceConnection @getAzDoServiceConnectionSplat
    }
    process {
        foreach ($name in $ServiceConnectionName) {
            $connectioninfo = $connections | Where-Object ServiceConnectionName -EQ $name
        }
        $body = @{
            dataSourceDetails = @{
                dataSourceName = 'TestConnection'
                parameters     = $null
            }
        }

        $Params = @{
            uri         = "$CollectionUri/$ProjectId/_apis/serviceendpoint/endpointproxy?endpointId=$($connectioninfo.ServiceConnectionId)&api-version=7.2-preview.1"
            Method      = 'POST'
            Headers     = New-ADOAuthHeader
            body        = $Body | ConvertTo-Json -Depth 99
            ContentType = 'application/json'
        }
        $response = Invoke-RestMethod @Params
        if ($response.statusCode -eq 'badRequest') {
            Write-Error "Connection $($connectioninfo.ServiceConnectionName) is not working: error $($response.errorMessage)"
        } else {
            [PSCustomObject]@{
                Result = "Connection [$($connectioninfo.ServiceConnectionName)] is working as expected"
            }
            Write-Verbose ($response.result | ConvertFrom-Json -Depth 10 | ConvertTo-Json -Depth 10 -Compress)
        }
    }
}

