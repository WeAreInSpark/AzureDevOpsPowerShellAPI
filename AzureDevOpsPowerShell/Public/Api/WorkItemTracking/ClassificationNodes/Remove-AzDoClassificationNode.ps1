function Remove-AzDoClassificationNode {
  <#
.SYNOPSIS
    Delete a Classification Node in Azure DevOps.
.DESCRIPTION
    Delete a Classification Node in Azure DevOps. This could be an area or an iteration.
.EXAMPLE
    $Params = @{
      CollectionUri  = "https://dev.azure.com/cantoso"
      ProjectName    = "Playground"
      StructureGroup = "areas"
      Name           = "Area1"
    }

    Remove-AzDoClassificationNode @Params

    This example removes a Classification Node of the type 'areas' within the Project.
.EXAMPLE
    $Params = @{
      CollectionUri  = "https://dev.azure.com/cantoso"
      ProjectName    = "Playground"
      StructureGroup = "areas"
      Name           = "Area1"
      Path           = "Path1"
    }

    Remove-AzDoClassificationNode @Params

    This example removes a Classification Node of the type 'areas' within the specified path.
.EXAMPLE
    $Params = @{
      CollectionUri  = "https://dev.azure.com/cantoso"
      ProjectName    = "Playground"
      StructureGroup = "iterations"
      Name           = "Iteration1"
    }

    Remove-AzDoClassificationNode @Params

    This example removes a Classification Node of the type 'iterations' within the specified path.

.EXAMPLE
    $Params = @{
      CollectionUri  = "https://dev.azure.com/cantoso"
      ProjectName    = "Playground"
      StructureGroup = "iterations"
      Name           = "Iteration1"
      Path           = "Path1"
    }

    Remove-AzDoClassificationNode @Params

    This example removes a Classification Node of the type 'iterations' within the specified path.
#>
  [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
  param (
    # Collection Uri of the organization
    [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
    [ValidateScript({ Validate-CollectionUri -CollectionUri $_ })]
    [string]
    $CollectionUri,

    # Name of the project where the new repository has to be created
    [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
    [string]
    $ProjectName,

    # Name of the project where the new repository has to be created
    [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
    [string]
    $StructureGroup,

    # Path of the classification node (optional)
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $Path,

    # Name of the classification node
    [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
    [string]
    $Name
  )

  begin {
    Write-Verbose "Starting function: Remove-AzDoClassificationNode"
    $result = @()
  }

  process {
    $ProjectId = (Get-AzDoProject -CollectionUri $CollectionUri -ProjectName $ProjectName).Projectid

    if ($Path) {
      $uri = "$CollectionUri/$ProjectName/_apis/wit/classificationnodes/$StructureGroup/$Path/$Name"
    } else {
      $uri = "$CollectionUri/$ProjectName/_apis/wit/classificationnodes/$StructureGroup/$Name"
    }

    $params = @{
      uri     = $uri
      version = "7.2-preview.2"
      Method  = 'DELETE'
    }

    if ($PSCmdlet.ShouldProcess($ProjectName, "Delete Classification Node named: $($PSStyle.Bold)$Name$($PSStyle.Reset)")) {
      $result += Invoke-AzDoRestMethod @params
    } else {
      Write-Verbose "Calling Invoke-AzDoRestMethod with $($params| ConvertTo-Json -Depth 10)"
    }
  }

  end {
    if ($result) {
      $result
    }
  }
}
