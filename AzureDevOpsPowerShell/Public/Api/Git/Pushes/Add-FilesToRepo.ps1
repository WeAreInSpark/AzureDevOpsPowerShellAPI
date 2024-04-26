function Add-FilesToRepo {
  <#
.SYNOPSIS
    Upload path to a repo in Azure DevOps.
.DESCRIPTION
    Upload path to a repo in Azure DevOps. Only works if the repo isn't initialized yet.
.EXAMPLE
    $params = @{
        CollectionUri = "https://dev.azure.com/contoso"
        Name          = "Repo 1"
        ProjectName   = "Project 1"
        Path          = "C:\git\BRC\AzureDevOpsPowerShellAPI"
    }
    Add-FilesToRepo @params

    This example adds the files in the path to the repository
.OUTPUTS
    [PSCustomObject]. An object containing information about the commit and repository
.NOTES
#>
  [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
  param (
    # Collection Uri of the organization
    [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
    [ValidateScript({ Validate-CollectionUri -CollectionUri $_ })]
    [string]
    $CollectionUri,

    # Name of the repository to add files to
    [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
    [string]
    $RepoName,

    # Name of the project containing the repository where files need to be added
    [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
    [string]
    $ProjectName,

    # Name of the project where the new repository has to be created
    [Parameter(Mandatory)]
    [string]
    $Path
  )

  begin {
    Write-Verbose "Starting function: Add-FilesToRepo"
  }

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

      if ($null -eq $content) {
        Write-Warning "File $($file.FullName) is empty, skipping"
        continue
      }

      $filePath = ($file.fullName).replace("$($path)", '')
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

    if ($PSCmdlet.ShouldProcess($RepoName, "Add path named: $($PSStyle.Bold)$($file.name)$($PSStyle.Reset)")) {
      try {
        $body | Invoke-AzDoRestMethod @params
      } catch {
        if ($_ -match 'TF401028') {
          Write-Warning "Repo is already initialized, skip uploading files"
        } else {
          Write-AzDoError -message $_
        }
      }
    } else {
      Write-Verbose "Calling Invoke-AzDoRestMethod with $($params| ConvertTo-Json -Depth 10)"
    }
  }
}
