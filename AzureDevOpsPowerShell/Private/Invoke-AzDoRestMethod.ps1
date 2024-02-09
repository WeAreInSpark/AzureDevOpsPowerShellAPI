function Invoke-AzDoRestMethod {
  <#
.SYNOPSIS
  General function to invoke Azure DevOps REST API methods
.DESCRIPTION
  We use this function to invoke Azure DevOps REST API methods. It will handle the authentication and refresh the token if needed.
  This way we standarize the logging and error handling.
.EXAMPLE
  $params = @{
    uri     = "$CollectionUri/$ProjectName/_apis/pipelines/checks/configurations"
    version = "7.2-preview.1"
    Method  = "POST"
    body    = $body
  }
  Invoke-AzDoRestMethod @params

  This example will invoke the REST API method to create a new pipeline check configuration.
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
    $Body
  )

  begin {
    Write-Verbose "Starting function: Invoke-AzDoRestMethod"
    Write-Debug "uri: $uri"
    Write-Debug "version: $Version"
    Write-Debug "method: $Method"
    Write-Debug "body: $($body | ConvertTo-Json -Depth 10)"

    # Check if we have a valid authentication header
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

    # If we don't have a valid authentication header, we create a new one
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
      ContentType = 'application/json'
    }

    # Add the query parameters to the uri
    if ($QueryParameters) {
      $params.Uri = "$($Uri)?$($QueryParameters)&api-version=$($Version)"
    } else {
      $params.Uri = "$($Uri)?api-version=$($Version)"
    }

    Write-Verbose "Uri: $($params.Uri)"
    Write-Verbose "Method: $($params.Method)"
  }

  process {
    # Add the body to the parameters if we have one
    if ($Method -eq 'POST' -or ($Method -eq 'PATCH')) {
      Write-Verbose "Body: $($Body | ConvertTo-Json -Depth 10)"
      $params.Body = $Body | ConvertTo-Json -Depth 10
    }

    # Invoke the REST method
    if ($PSCmdlet.ShouldProcess($ProjectName, "Invoke Rest method on: $($PSStyle.Bold)$ProjectName$($PSStyle.Reset)")) {
      try {
        Invoke-RestMethod @params
      } catch {
        Write-AzdoError -Message ($_ | ConvertFrom-Json).message
      }
    }
  }
}
