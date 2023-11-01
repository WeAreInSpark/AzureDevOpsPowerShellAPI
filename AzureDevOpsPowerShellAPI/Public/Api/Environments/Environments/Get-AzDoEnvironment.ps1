function Get-AzDoEnvironment {
  <#
.SYNOPSIS
    Creates a Build Validation policy on a branch
.DESCRIPTION
    Creates a Build Validation policy on a branch
.EXAMPLE
    $params = @{
        CollectionUri = "https://dev.azure.com/contoso"
        PAT = "***"
        Name = "Policy 1"
        RepoName = "Repo 1"
        ProjectName = "Project 1"
        Id = 1
    }
    Set-AzDoBranchPolicyBuildValidation @params

    This example creates a policy with splatting parameters

.EXAMPLE
    $env:SYSTEM_ACCESSTOKEN = '***'
    New-AzDoPipeline -CollectionUri "https://dev.azure.com/contoso" -ProjectName "Project 1" -Name "Pipeline 1" -RepoName "Repo 1" -Path "main.yml"
    | Set-AzDoBranchPolicyBuildValidation

    This example creates a new Azure Pipeline and sets this pipeline as Build Validation policy on the main branch

.OUTPUTS
    [PSCustomObject]@{
      CollectionUri = $CollectionUri
      ProjectName   = $ProjectName
      RepoName      = $RepoName
      Id            = $result.id
      Url           = $result.url
    }
.NOTES
#>
  [CmdletBinding(SupportsShouldProcess)]
  param (
    # Collection Uri of the organization
    [Parameter(Mandatory, ValueFromPipelineByPropertyName, ValueFromPipeline)]
    [string]
    $CollectionUri,

    # Project where the pipeline will be created.
    [Parameter(Mandatory, ValueFromPipelineByPropertyName, ValueFromPipeline)]
    [string]
    $ProjectName,

    # PAT to authentice with the organization
    [Parameter()]
    [string]
    $PAT,

    # Name of the Build Validation policy. Default is the name of the Build Definition
    [Parameter()]
    [string]
    $Name
  )

  begin {
    if (-not($script:header)) {

      try {
        New-ADOAuthHeader -PAT $PAT -ErrorAction Stop
      } catch {
        $PSCmdlet.ThrowTerminatingError($_)
      }
    }

    $api = "pipelines/environments"
    $apiVersion = "7.2-preview.1"
    $apiMethod = "GET"
  }

  Process {
    $projectId = (Get-AzDoproject -CollectionUri $CollectionUri -ProjectName $ProjectName -PAT $PAT).projectId

    $params = @{
      uri         = "$CollectionUri/$projectId/_apis/pipelines/environments?api-version=$apiVersion"
      Method      = $apiMethod
      Headers     = $script:header
      ContentType = 'application/json'
    }

    if ($PSCmdlet.ShouldProcess($CollectionUri)) {
      try {
        Write-Information "Creating Environment on $RepoName/$branch"

        if ($name) {
          $result = (Invoke-RestMethod @params).value | Where-Object { $_.name -eq $name }
        } else {
          $result = (Invoke-RestMethod @params).value
        }

        $result | ForEach-Object {
          [PSCustomObject]@{
            CollectionUri   = $CollectionUri
            ProjectName     = $ProjectName
            Id              = $_.id
            environmentName = $_.name
          }
        }
      } catch {
        $body | Format-List
        throw ($_.ErrorDetails.Message | ConvertFrom-Json).message
      }
    } else {
      $body | Format-List
    }
  }
}
