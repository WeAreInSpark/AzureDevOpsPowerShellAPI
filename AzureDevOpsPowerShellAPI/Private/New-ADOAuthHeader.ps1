function New-ADOAuthHeader {
    [CmdletBinding()]
    param (
        # PAT to authenticate with the organization
        [Parameter()]
        [String]
        $PAT,
        # Get an Access Token to authenticate with the organization using OAuth 2.0
        [Parameter()]
        [Switch]
        $AccessToken = $true
    )

    if ($PAT) {
        $script:header = @{Authorization = 'Basic ' + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$($PAT)")) }
    }
    if ($AccessToken -or $null -eq $PAT) {
        # validate if user is logged in to Azure PowerShell
        try {
            if ((Get-AzContext).Account -eq $null) {
                Write-Error 'Please login to Azure PowerShell first'
                $PSCmdlet.ThrowTerminatingError($PSItem)
            }
            $script:header = @{Authorization = 'Bearer ' + (Get-AzAccessToken -Resource 499b84ac-1321-427f-aa17-267ca6975798).token
            }
        } catch {
            throw 'Please login to Azure PowerShell first'
        }
    }
}
