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

    [Parameter()]
    [string]
    $QueryParameters,

    [Parameter(Mandatory)]
    [ValidateSet('GET', 'POST', 'PATCH', 'DELETE')]
    [string]
    $Method,

    [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [PSCustomObject[]]
    $Body,

    [Parameter()]
    [ValidateSet('application/json', 'application/json-patch+json')]
    [string]
    $ContentType = 'application/json'
  )

  begin {
    Write-Verbose "Starting function: Invoke-AzDoRestMethod"
    Write-Debug "uri: $uri"
    Write-Debug "version: $Version"
    Write-Debug "method: $Method"
    Write-Debug "body: $($body | ConvertTo-Json -Depth 10)"

    if ($script:header.Authorization -match "Bearer") {
      $params = @{
        Uri         = "https://app.vssps.visualstudio.com/_apis/profile/profiles/me?api-version=6.0"
        Method      = 'GET'
        Headers     = $script:header
        ContentType = 'application/json'
      }
      try {
        $profileData = Invoke-RestMethod @params

        if (!$profileData.id) {
          throw
        }
      } catch {
        Write-Verbose "Refreshing authentication header"
        $script:header = $null
      }
    }

    if (-not($script:header)) {
      try {
        New-AzDoAuthHeader -ErrorAction Stop
      } catch {
        throw $_
      }
    }

    $params = @{
      Method      = $Method
      Headers     = $script:header
      ContentType = $ContentType
    }

    if ($QueryParameters) {
      $params.Uri = "$($Uri)?$($QueryParameters)&api-version=$($Version)"
    } else {
      $params.Uri = "$($Uri)?api-version=$($Version)"
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
        $PSCmdlet.ThrowTerminatingError((Write-AzdoError -Message ($_ | ConvertFrom-Json).message))
      }
    }
  }
}
