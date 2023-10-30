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

    # PAT to authenticate with the organization
    [Parameter()]
    [string]
    $PAT = $env:SYSTEM_ACCESSTOKEN,

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
    $ProjectId = (Get-AzDoProject -CollectionUri $CollectionUri -PAT $PAT -ProjectName $ProjectName).Projectid
    $RepoId = (Get-AzDoRepo -CollectionUri $CollectionUri -PAT $PAT -ProjectName $ProjectName -RepoName $RepoName).RepoId

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
          oldObjectId = "d2b15d0782516a571cba4c53822a3ce4ec3576da"
        }
      )
      commits    = @(
        @{
          comment = "Updating active tasks and adding a few new files."
          changes = $changes
        }
      )
    }

    $params = @{
      uri         = "$CollectionUri/$ProjectId/_apis/git/repositories/$RepoId/pushes?api-version=7.1-preview.2"
      Method      = 'POST'
      Headers     = @{Authorization = 'Basic ' + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$($PAT)")) }
      body        = $Body | ConvertTo-Json -Depth 99
      ContentType = 'application/json'
    }

    if ($PSCmdlet.ShouldProcess($CollectionUri)) {
      try {
        Write-Information "Creating Repo on Project $RepoName"
        $res = Invoke-RestMethod @params
      } catch {
        Write-Error $Body
      }
      $res
      # [PSCustomObject]@{
      #   CollectionUri = $CollectionUri
      #   ProjectName   = $ProjectName
      #   RepoName      = $res.name
      #   RepoId        = $res.id
      #   RepoURL       = $res.url
      #   WebUrl        = $res.webUrl
      #   HttpsUrl      = $res.remoteUrl
      #   SshUrl        = $res.sshUrl
      # }
    } else {
      $Body | Format-List
    }
  }
}
