function Get-AzDoBranchPolicy {
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
  [OutputType([System.Collections.ArrayList])]
  param (
    # Collection Uri of the organization
    [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
    [string]
    $CollectionUri,

    # Name of the project containing the branch policy
    [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
    [string]
    $ProjectName,

    # Name of the Branch Policy
    [Parameter(ValueFromPipelineByPropertyName, ValueFromPipeline)]
    [string[]]
    $PolicyName
  )

  begin {
    $result = @()
  }

  process {
    $params = @{
      uri     = "$CollectionUri/$ProjectName/_apis/policy/configurations"
      version = "7.2-preview.1"
      method  = 'GET'
    }

    if ($PSCmdlet.ShouldProcess($ProjectName, "Get Policy ID from: $($PSStyle.Bold)$ProjectName$($PSStyle.Reset)")) {
      Write-Debug "Calling Invoke-AzDoRestMethod with"
      Write-Debug ($params | Out-String)
      $result += (Invoke-AzDoRestMethod @params).value | Where-Object { -not $PolicyName -or $_.Name -in $PolicyName }

    } else {
      Write-Verbose "Calling Invoke-AzDoRestMethod with $($params| ConvertTo-Json -Depth 10)"
    }
  }

  end {
    if ($result) {
      $result
    }
  }
}
