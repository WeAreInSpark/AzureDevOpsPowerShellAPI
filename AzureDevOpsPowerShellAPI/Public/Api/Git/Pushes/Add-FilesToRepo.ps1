function Add-FilesToRepo {
  <#
.SYNOPSIS
    Upload path to a repo in Azure DevOps.
.DESCRIPTION
    Upload path to a repo in Azure DevOps.
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
    [Parameter(Mandatory, ValueFromPipelineByPropertyName, ValueFromPipeline)]
    [string]
    $CollectionUri,

    # Name of the new repository
    [Parameter(Mandatory, ValueFromPipelineByPropertyName, ValueFromPipeline)]
    [string]
    $RepoName,

    # Name of the project where the new repository has to be created
    [Parameter(Mandatory, ValueFromPipelineByPropertyName, ValueFromPipeline)]
    [string]
    $ProjectName,

    # Name of the project where the new repository has to be created
    [Parameter(Mandatory)]
    [string]
    $Path
  )

  process {

    $changes = @()
    $files = Get-ChildItem -Path $Path -Recurse -File
    foreach ($file in $files) {

      if (($file.Extension -in '.png', '.svg, .jpg', '.jpeg')) {
        $fileContent = Get-Content -Path $file.FullName -AsByteStream
        $content = [convert]::ToBase64String($fileContent)
        $contentType = "base64encoded"
      } else {
        $content = Get-Content -Path $file.FullName -Raw
        $contentType = "rawtext"
      }

      $filePath = ($file.fullName).replace("$($pwd.path)\", '')
      $changes += [PSCustomObject]@{
        changeType = "add"
        item       = @{
          path = $filePath.Replace('\', '/')
        }
        newContent = @{
          content     = $content
          contentType = $contentType
        }
      }
    }

    $Body = @{
      refUpdates = @(
        @{
          name        = "refs/heads/main"
          oldObjectId = "0000000000000000000000000000000000000000"
        }
      )
      commits    = @(
        @{
          comment = "Initial commit"
          changes = $changes
        }
      )
    }

    $params = @{
      uri     = "$CollectionUri/$ProjectName/_apis/git/repositories/$RepoName/pushes"
      version = "7.1-preview.2"
      Method  = 'POST'
    }

    if ($PSCmdlet.ShouldProcess($CollectionUri)) {
      $body | Invoke-AzDoRestMethod @params
    } else {
      $Body | Format-List
    }
  }
}
