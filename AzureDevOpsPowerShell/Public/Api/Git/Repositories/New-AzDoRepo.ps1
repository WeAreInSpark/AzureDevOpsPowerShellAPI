function New-AzDoRepo {
  <#
.SYNOPSIS
    Creates a repo in Azure DevOps.
.DESCRIPTION
    Creates a repo in Azure DevOps.
.EXAMPLE
    $params = @{
        CollectionUri = "https://dev.azure.com/contoso"
        PAT           = "***"
        Name          = "Repo 1"
        ProjectName   = "Project 1"
    }
    New-AzDoRepo @params

    This example creates a new Azure DevOps repo with splatting parameters
.EXAMPLE
    $env:SYSTEM_ACCESSTOKEN = '***'
    'test', 'test2' | New-AzDoRepo -CollectionUri "https://dev.azure.com/contoso" -ProjectName "Project 1"

    This example creates a new Azure DevOps repo for each in pipeline
.OUTPUTS
    [PSCustomObject]@{
        CollectionUri = $CollectionUri
        ProjectName   = $ProjectName
        RepoName      = $res.name
        RepoId        = $res.id
        RepoURL       = $res.url
        WebUrl        = $res.webUrl
        HttpsUrl      = $res.remoteUrl
        SshUrl        = $res.sshUrl
      }
.NOTES
#>
  [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
  param (
    # Collection Uri of the organization
    [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
    [string]
    $CollectionUri,

    # Name of the new repository
    [Parameter(Mandatory, ValueFromPipelineByPropertyName, ValueFromPipeline)]
    [string[]]
    $RepoName,

    # Name of the project where the new repository has to be created
    [Parameter(Mandatory)]
    [string]
    $ProjectName
  )

  Process {
    $ProjectId = (Get-AzDoProject -CollectionUri $CollectionUri -ProjectName $ProjectName).Projectid

    $params = @{
      uri     = "$CollectionUri/$ProjectName/_apis/git/repositories"
      version = "7.1-preview.1"
      Method  = 'POST'
    }

    foreach ($name in $RepoName) {
      $Body = @{
        name    = $name
        project = @{
          id = $ProjectId
        }
      }

      if ($PSCmdlet.ShouldProcess($CollectionUri, "Create repo named: $($PSStyle.Bold)$name$($PSStyle.Reset)")) {
        Write-Information "Creating Repo on Project $ProjectName"
        $result += ($body | Invoke-AzDoRestMethod @params)
      } else {
        $Body | Format-List
      }
    }
  }

  End {
    if ($result) {
      $result | ForEach-Object {
        [PSCustomObject]@{
          CollectionUri = $CollectionUri
          ProjectName   = $ProjectName
          RepoName      = $_.name
          RepoId        = $_.id
          RepoURL       = $_.url
          WebUrl        = $_.webUrl
          HttpsUrl      = $_.remoteUrl
          SshUrl        = $_.sshUrl
        }
      }
    }
  }
}
