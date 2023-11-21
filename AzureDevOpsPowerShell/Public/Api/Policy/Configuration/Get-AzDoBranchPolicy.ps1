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
    $result = New-Object -TypeName "System.Collections.ArrayList"
  }

  process {
    $params = @{
      uri     = "$CollectionUri/$ProjectName/_apis/policy/configurations"
      version = "7.2-preview.1"
      method  = 'GET'
    }

    if ($PSCmdlet.ShouldProcess($ProjectName, "Get Policy ID from: $($PSStyle.Bold)$ProjectName$($PSStyle.Reset)")) {
      $policies = (Invoke-AzDoRestMethod @params).value
      if ($PolicyName) {
        foreach ($name in $PolicyName) {
          $policy = $policies | Where-Object { $_.name -eq $name }
          if (-not($policy)) {
            Write-Error "policy $name not found"
            continue
          } else {
            $result.add($policy) | Out-Null
          }
        }
      } else {
        $result.add($policies) | Out-Null
      }

    } else {
      $body | Format-List
    }
  }

  end {
    if ($result) {
      $result
    }
  }
}
