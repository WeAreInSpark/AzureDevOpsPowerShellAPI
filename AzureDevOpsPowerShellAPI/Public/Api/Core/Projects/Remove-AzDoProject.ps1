function Remove-AzDoProject {
  <#
    .SYNOPSIS
        Function to create an Azure DevOps project
    .DESCRIPTION
        Function to create an Azure DevOps project
    .EXAMPLE
        New-AzDoProject -CollectionUri "https://dev.azure.com/contoso" -PAT "***" -ProjectName "Project 1"

        This example creates a new private Azure DevOps project
    .EXAMPLE
        New-AzDoProject -CollectionUri "https://dev.azure.com/contoso" -PAT "***" -ProjectName "Project 1" -Visibility 'public'

        This example creates a new public Azure DevOps project
    .EXAMPLE
        @("MyProject1","Myproject2") | New-AzDoProject -CollectionUri "https://dev.azure.com/contoso" -PAT "***"

        This example creates two new Azure DevOps projects using the pipeline.

    .EXAMPLE
        [pscustomobject]@{
            ProjectName     = 'Project 1'
            Visibility      = 'public'
            Description     = 'This is the best project'
        },
        [pscustomobject]@{
            ProjectName     = 'Project 1'
            Description     = 'This is the best project'
        } | New-AzDoProject -PAT $PAT -CollectionUri $CollectionUri

        This example creates two new Azure DevOps projects using the pipeline.
    #>
  [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
  param (
    # Collection URI. e.g. https://dev.azure.com/contoso.
    # Azure Pipelines has a predefined variable for this.
    [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
    [string]
    $CollectionUri,

    # PAT to get access to Azure DevOps.
    [Parameter()]
    [string]
    $PAT,

    # Name of the project.
    [Parameter(Mandatory, ValueFromPipelineByPropertyName, ValueFromPipeline)]
    [string[]]
    $ProjectName
  )

  Begin {
    if (-not($script:header)) {

      try {
        New-ADOAuthHeader -PAT $PAT -ErrorAction Stop
      } catch {
        $PSCmdlet.ThrowTerminatingError($_)
      }
    }

    $projects = Get-AzDoProject -CollectionUri $CollectionUri -PAT $PAT
  }

  Process {

    $project = $projects | Where-Object -Property ProjectName -EQ -Value $ProjectName

    $params = @{
      uri         = "$CollectionUri/_apis/projects/$($project.ProjectID)?api-version=6.0"
      Method      = 'DELETE'
      Headers     = $script:header
      ContentType = 'application/json'
      ErrorAction = 'Stop'
    }
    if ($PSCmdlet.ShouldProcess($project.ProjectName, "Remove Azure DevOps Project")) {
      Write-Verbose "Trying to remove the project"
      try {
                    (Invoke-RestMethod @params | Out-Null)
      } catch {
        $message = $_
        Write-Error "Failed to create the project [$name]"
        Write-Error $message.ErrorDetails.Message
        continue
      }
    }
  }
}
