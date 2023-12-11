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
    [ValidateSet('GET', 'POST', 'PATCH', 'DELETE')]
    [string]
    $Method,

    [Parameter()]
    [string]
    $Pat,

    [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [PSCustomObject[]]
    $Body
  )

  begin {
    Write-Verbose "Starting function: Invoke-AzDoRestMethod"
    Write-Debug "uri: $uri"
    Write-Debug "version: $Version"
    Write-Debug "method: $Method"
    Write-Debug "body: $($body | ConvertTo-Json -Depth 10)"

    if (-not($script:header)) {
      try {
        New-AzDoAuthHeader -PAT $Pat -ErrorAction Stop
      } catch {
        throw $_
      }
    }

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
    if ($PSCmdlet.ShouldProcess($ProjectName, "Invoke Rest method on: $($PSStyle.Bold)$ProjectName$($PSStyle.Reset)")) {
      try {
        Invoke-RestMethod @params
      } catch {
        Write-AzdoError -Message ($_ | ConvertFrom-Json).message
      }
    }
  }
}
