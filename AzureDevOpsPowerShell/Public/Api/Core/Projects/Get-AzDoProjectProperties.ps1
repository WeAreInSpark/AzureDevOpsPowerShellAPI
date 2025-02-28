function Get-AzDoProjectProperties {
  <#
.SYNOPSIS

.DESCRIPTION

.EXAMPLE

.EXAMPLE

.EXAMPLE

.EXAMPLE

.OUTPUTS
#>
  [CmdletBinding(SupportsShouldProcess)]
  param (
    # Collection Uri of the organization
    [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
    [ValidateScript({ Validate-CollectionUri -CollectionUri $_ })]
    [string]
    $CollectionUri,

    # Project where the Repos are contained
    [Parameter(ValueFromPipelineByPropertyName, ValueFromPipeline)]
    [string[]]
    $ProjectName
  )

  begin {
    Write-Verbose "Starting function: Get-AzDoProject"
  }

  process {
    $Results = foreach ($Project in $ProjectName) {
      $ProjectId = (Get-AzDoProject -CollectionUri $CollectionUri -ProjectName $Project).ProjectID

      $params = @{
        uri     = "$CollectionUri/_apis/projects/$ProjectId/Properties"
        version = "7.2-preview.1"
        method  = 'GET'
      }

      if ($PSCmdlet.ShouldProcess($CollectionUri, "Get project $Project properties")) {
        $result = Invoke-AzDoRestMethod @params
        # $ResultsList.Add($result)
        [PSCustomObject]@{
          CollectionURI = $CollectionUri
          ProjectName   = $Project
          Properties    = $Result
        }
      } else {
        Write-Verbose "Calling Invoke-AzDoRestMethod with $($params| ConvertTo-Json -Depth 10)"
      }
    }
    if ($Results) {
      $Results | ForEach-Object {
        [PSCustomObject]@{
          CollectionURI = $CollectionUri
          ProjectName   = $_.ProjectName
          Properties    = $_.Properties
        }
      }
    }
  }
  # end {
  #   if ($ResultsList) {
  #     $ResultsList | ForEach-Object {
  #       [PSCustomObject]@{
  #         CollectionURI = $CollectionUri
  #         ProjectName   = $_.name
  #         Properties    = $Result
  #       }
  #     }
  #   }
  # }
}
