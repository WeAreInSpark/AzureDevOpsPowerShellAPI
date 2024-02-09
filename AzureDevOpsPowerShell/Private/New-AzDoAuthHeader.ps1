<#
.SYNOPSIS
  Create a new authentication header for Azure DevOps REST API
.DESCRIPTION
  This function will create a new authentication header for Azure DevOps REST API. It will use the Azure PowerShell context to get the access token or use a PAT if provided.
.EXAMPLE
  New-AzDoAuthHeader

  This example will create a new authentication header using the Azure PowerShell context to get the access token.
.EXAMPLE
  New-AzDoAuthHeader -Pat 'myPat'

  This example will create a new authentication header using the provided PAT.
#>

function New-AzDoAuthHeader {
  [CmdletBinding(SupportsShouldProcess)]
  param (
    # PAT to authenticate with the organization
    [Parameter()]
    [String]
    $Pat
  )

  if ($PSCmdlet.ShouldProcess("Creating new authentication header")) {
    Write-Verbose "Function: New-AzDoAuthHeader"
    if ($Pat -eq '') {
      # validate if user is logged in to Azure PowerShell
      Write-Verbose "Using Access Token"

      try {

        if ($null -eq (Get-AzContext).Account) {
          Write-Error 'Please login to Azure PowerShell first'

          $PSCmdlet.ThrowTerminatingError($PSItem)
        }

        Write-Verbose "Getting Access Token"

        $script:header = @{Authorization = 'Bearer ' + (Get-AzAccessToken -Resource 499b84ac-1321-427f-aa17-267ca6975798).token
        }
      } catch {
        throw 'Please login to Azure PowerShell first'
      }
    } else {
      Write-Verbose "Using PAT"
      Write-Verbose "Getting Access Token"

      $script:header = @{Authorization = 'Basic ' + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$($PAT)")) }
    }
  }
}
