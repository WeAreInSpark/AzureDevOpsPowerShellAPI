function Get-AzDoBranchPolicyType {
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
    # Collection Uri of the organization
    [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
    [string]
    $CollectionUri,

    # Project where the get the branch policy from
    [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
    [string]
    $ProjectName,

    # Type of branch policy
    [Parameter(ValueFromPipelineByPropertyName, ValueFromPipeline)]
    [string[]]
    [validateset(
      'Build',
      'Build validation',
      'Comment requirements',
      'Comment resolution',
      'Commit author email validation',
      'File name restriction',
      'File size restriction',
      'Git Commit Hard Limits Push Policy',
      'Git repository settings',
      'GitRepositorySettingsPolicyName',
      'Minimum number of reviewers',
      'Path Length restriction',
      'Require a merge strategy',
      'Required reviewers',
      'Reserved names restriction',
      'Secrets scanning restriction',
      'Status',
      'Work item linking')]
    $PolicyType
  )

  begin {
    $result = @()
    Write-Verbose "Starting function: Get-AzDoBranchPolicyType"
  }

  process {
    $params = @{
      uri     = "$CollectionUri/$ProjectName/_apis/policy/types"
      version = "7.2-preview.1"
      method  = 'GET'
    }

    if ($PSCmdlet.ShouldProcess($ProjectName, "Get Branch Policies from: $($PSStyle.Bold)$ProjectName$($PSStyle.Reset)")) {
      $result += (Invoke-AzDoRestMethod @params).value | Where-Object { -not $PolicyType -or $_.displayName -in $PolicyType }
    } else {
      Write-Verbose "Calling Invoke-AzDoRestMethod with $($params| ConvertTo-Json -Depth 10)"
    }
  }

  end {
    if ($result) {
      $result | ForEach-Object {
        [PSCustomObject]@{
          CollectionUri = $CollectionUri
          ProjectName   = $ProjectName
          PolicyName    = $_.displayName
          PolicyId      = $_.id
          PolicyURL     = $_.url
        }
      }
    }
  }
}
