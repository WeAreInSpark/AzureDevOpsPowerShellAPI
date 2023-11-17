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

    # Name of the project.
    [Parameter(Mandatory, ValueFromPipelineByPropertyName, ValueFromPipeline)]
    [string[]]
    $ProjectName
  )

  begin {
    $result = New-Object -TypeName "System.Collections.ArrayList"
  }

  Process {
    foreach ($name in $ProjectName) {

      $projectId = (Get-AzDoProject -CollectionUri $CollectionUri -ProjectName $name).ProjectID

      $params = @{
        uri     = "$CollectionUri/_apis/projects/$projectID"
        version = "7.1-preview.4"
        method  = 'DELETE'
      }

      if ($PSCmdlet.ShouldProcess($CollectionUri, "Delete project named: $($PSStyle.Bold)$name$($PSStyle.Reset)")) {
        $result.add((Invoke-AzDoRestMethod @params)) | Out-Null
      }
    }
  }

  end {
    if ($result) {
      $result
    }
  }
}
