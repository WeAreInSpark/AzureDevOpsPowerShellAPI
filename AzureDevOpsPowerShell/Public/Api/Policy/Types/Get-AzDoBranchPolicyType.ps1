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
  }

  process {
    $params = @{
      uri     = "$CollectionUri/$ProjectName/_apis/policy/types"
      version = "7.2-preview.1"
      method  = 'GET'
    }

    if ($PSCmdlet.ShouldProcess($ProjectName, "Get Policy ID from: $($PSStyle.Bold)$ProjectName$($PSStyle.Reset)")) {
      $types = (Invoke-AzDoRestMethod @params).value
      if ($PolicyType) {
        foreach ($name in $PolicyType) {
          $type = $types | Where-Object { $_.displayName -eq $name }
          if (-not($type)) {
            Write-Error "policy $name not found"
            continue
          } else {
            $result += $type
          }
        }
      } else {
        $result += $types
      }

    } else {
      $body | Format-List
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
