function New-AzDoRepo {
  <#
.SYNOPSIS
    Creates a repo in Azure DevOps.
.DESCRIPTION
    Creates a repo in Azure DevOps.
.EXAMPLE
    $params = @{
        CollectionUri = "https://dev.azure.com/contoso"
        Name          = "Repo 1"
        ProjectName   = "Project 1"
    }
    New-AzDoRepo @params

    This example creates a new Azure DevOps repo with splatting parameters
.EXAMPLE
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
    [ValidateScript({ Validate-CollectionUri -CollectionUri $_ })]
    [string]
    $CollectionUri,

    # Name of the new repository
    [Parameter(Mandatory, ValueFromPipelineByPropertyName, ValueFromPipeline)]
    [string[]]
    $RepoName,

    # Name of the project where the new repository has to be created
    [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
    [string]
    $ProjectName
  )

  begin {
    Write-Verbose "Starting function: New-AzDoRepo"
  }

  process {
    $ProjectId = (Get-AzDoProject -CollectionUri $CollectionUri -ProjectName $ProjectName).Projectid

    $params = @{
      uri     = "$CollectionUri/$ProjectName/_apis/git/repositories"
      version = "7.1-preview.1"
      Method  = 'POST'
    }

    foreach ($name in $RepoName) {
      $body = @{
        name    = $name
        project = @{
          id = $ProjectId
        }
      }

      if ($PSCmdlet.ShouldProcess($CollectionUri, "Create repo named: $($PSStyle.Bold)$name$($PSStyle.Reset)")) {
        try {
          ($body | Invoke-AzDoRestMethod @params) | ForEach-Object {
            [PSCustomObject]@{
              CollectionUri = $CollectionUri
              ProjectName   = $ProjectName
              RepoName      = $_.name
              RepoId        = $_.id
              RepoURL       = $_.url
              WebUrl        = $_.webUrl
              RemoteUrl     = $_.remoteUrl
              SshUrl        = $_.sshUrl
            }
          }
        } catch {
          if ($_ -match 'TF400948') {
            Write-Warning "Repo $name already exists, trying to get it"
            $params.Method = 'GET'
            (Invoke-AzDoRestMethod @params).value | Where-Object { $_.name -eq $name } | ForEach-Object {
              [PSCustomObject]@{
                CollectionUri = $CollectionUri
                ProjectName   = $ProjectName
                RepoName      = $_.name
                RepoId        = $_.id
                RepoURL       = $_.url
                WebUrl        = $_.webUrl
                RemoteUrl     = $_.remoteUrl
                SshUrl        = $_.sshUrl
              }
            }
          } else {
            Write-Error -Message "Error creating repo $name in $projectID Error: $_"
            continue
          }
        }
      } else {
        Write-Verbose "Calling Invoke-AzDoRestMethod with $($params| ConvertTo-Json -Depth 10)"
      }
    }
  }
}
