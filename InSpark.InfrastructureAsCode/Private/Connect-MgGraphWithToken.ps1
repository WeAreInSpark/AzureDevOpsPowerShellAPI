function Connect-MgGraphWithToken {
    [CmdletBinding()]
    param (
        [Parameter()]
        [switch]
        [ValidateScript(
            {
                if (!(Get-AzContext).Account) {
                    throw "No valid session to Azure PowerShell available"
                }
                $true
            }
        )
        ]
        $RequestTokenViaAzurePowerShell
    )

    if ($RequestTokenViaAzurePowerShell) {
        try {
            $Token = (Get-AzAccessToken -ResourceTypeName MSGraph).Token
            Connect-MgGraph -AccessToken $Token | Out-Null
        } catch {
            $_
        }
    } else {
        Connect-MgGraph
    }
}
