function Invoke-AzDoRestMethod {
  <#
.SYNOPSIS
  A short one-line action-based description, e.g. 'Tests if a function is valid'
.DESCRIPTION
  A longer description of the function, its purpose, common use cases, etc.
.NOTES
  Information or caveats about the function e.g. 'This function is not supported in Linux'
.LINK
  Specify a URI to a help page, this will show when Get-Help -Online is used.
.EXAMPLE
  Test-MyTestFunction -Verbose
  Explanation of the function or its result. You can include multiple examples with additional .EXAMPLE lines
#>
  [CmdletBinding(SupportsShouldProcess)]
  param (
    [Parameter(Mandatory)]
    [string]
    $Uri,

    [Parameter(Mandatory)]
    [string]
    $Version,

    [Parameter(Mandatory)]
    [ValidateSet('GET', 'POST', 'PATCH')]
    [string]
    $Method,

    [Parameter()]
    [string]
    $PAT,

    [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [PSCustomObject[]]
    $Body
  )

  begin {
    if (-not($script:header)) {

      try {
        New-ADOAuthHeader -PAT $PAT -ErrorAction Stop
      } catch {
        $PSCmdlet.ThrowTerminatingError($_)
      }
    }

    $result = New-Object -TypeName "System.Collections.ArrayList"
    $params = @{
      Uri         = "$($Uri)?api-version=$($Version)"
      Method      = $Method
      Headers     = $script:header
      ContentType = 'application/json'
    }

    Write-Verbose "Uri: $($params.Uri)"
    Write-Verbose "Method: $($params.Method)"
  }

  process {
    if ($Method -eq 'POST' -or ($Method -eq 'PATCH')) {
      Write-Verbose "Body: $($Body | ConvertTo-Json -Depth 10)"
      $params.Body = $Body | ConvertTo-Json -Depth 10
    }

    try {
      $result.add((Invoke-RestMethod @params)) | Out-Null
    } catch {
      throw ($_.ErrorDetails.Message | ConvertFrom-Json -Depth 10).Message
    }
  }

  end {
    $result
  }
}
