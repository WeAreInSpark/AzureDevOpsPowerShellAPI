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
  [CmdletBinding(SupportsShouldProcess)]
  param (
    # Collection Uri of the organization
    [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
    [string]
    $CollectionUri,

    # PAT to authenticate with the organization
    [Parameter()]
    [string]
    $PAT,

    # Name of the new repository
    [Parameter(Mandatory, ValueFromPipelineByPropertyName, ValueFromPipeline)]
    [string]
    $RepoName,

    # Name of the project where the new repository has to be created
    [Parameter(Mandatory)]
    [string]
    $ProjectName
  )

  begin {
    if (-not($script:header)) {

      try {
        New-ADOAuthHeader -PAT $PAT -ErrorAction Stop
      } catch {
        $PSCmdlet.ThrowTerminatingError($_)
      }
    }
  }
  process {
    $ProjectId = (Get-AzDoProject -CollectionUri $CollectionUri -PAT $PAT -ProjectName $ProjectName).Projectid


    $Body = @{
      name    = $RepoName
      project = @{
        id = $ProjectId
      }
    }

    $params = @{
      uri         = "$CollectionUri/$ProjectId/_apis/git/repositories?api-version=7.1-preview.1"
      Method      = 'POST'
      Headers     = $script:header
      body        = $Body | ConvertTo-Json -Depth 99
      ContentType = 'application/json'
    }

    if ($PSCmdlet.ShouldProcess($CollectionUri)) {
      try {
        Write-Information "Creating Repo on Project $RepoName"
        $res = Invoke-RestMethod @params
      } catch {
        Write-Error $_.Exception.Message
        return
      }

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
    } else {
      $Body | Format-List
    }
  }
}
