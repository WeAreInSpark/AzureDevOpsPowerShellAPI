function Get-AzDoClassificationNode {
  <#
.SYNOPSIS
    Get a Classification Node in Azure DevOps.
.DESCRIPTION
    Get a Classification Node in Azure DevOps. This could be an area or an iteration.
.EXAMPLE
    $Params = @{
      CollectionUri  = "https://dev.azure.com/cantoso"
      ProjectName    = "Playground"
      StructureGroup = "areas"
      Name           = "Area1"
      Depth          = '2'
    }

    Get-AzDoClassificationNode @Params

    This example removes a Classification Node of the type 'areas' within the Project.
.EXAMPLE
    $Params = @{
      CollectionUri  = "https://dev.azure.com/cantoso"
      ProjectName    = "Playground"
      StructureGroup = "areas"
      Name           = "Area1"
      Path           = "Path1"
      Depth          = '2'
    }

    Get-AzDoClassificationNode @Params

    This example removes a Classification Node of the type 'areas' within the specified path.
.EXAMPLE
    $Params = @{
      CollectionUri  = "https://dev.azure.com/cantoso"
      ProjectName    = "Playground"
      StructureGroup = "iterations"
      Name           = "Iteration1"
      Depth          = '2'
    }

    Get-AzDoClassificationNode @Params

    This example removes a Classification Node of the type 'iterations' within the specified path.

.EXAMPLE
    $Params = @{
      CollectionUri  = "https://dev.azure.com/cantoso"
      ProjectName    = "Playground"
      StructureGroup = "iterations"
      Name           = "Iteration1"
      Path           = "Path1"
      Depth          = '2'
    }

    Get-AzDoClassificationNode @Params

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
    $Name,

    # Optional parameter to specify the depth of child nodes to retrieve
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $Depth = '2'
  )
  process {
    Write-Verbose "Starting function: Get-AzDoClassificationNode"

    $ProjectId = (Get-AzDoProject -CollectionUri $CollectionUri -ProjectName $ProjectName).Projectid

    if ($Path) {
      $uri = "$CollectionUri/$ProjectName/_apis/wit/classificationnodes/$StructureGroup/$Path/$Name"
    } else {
      $uri = "$CollectionUri/$ProjectName/_apis/wit/classificationnodes/$StructureGroup/$Name"
    }

    $params = @{
      uri             = $uri
      version         = "7.2-preview.2"
      QueryParameters = "`$depth=$depth"
      Method          = 'GET'
    }

    if ($PSCmdlet.ShouldProcess($ProjectName, "Get Classification Node named: $($PSStyle.Bold)$Name$($PSStyle.Reset)")) {
      try {
        Invoke-AzDoRestMethod @params | ForEach-Object {
          [PSCustomObject]@{
            CollectionUri = $CollectionUri
            ProjectName   = $ProjectName
            Id            = $_.id
            Identifier    = $_.identifier
            Name          = $_.name
            StructureType = $_.structureType
            HasChildren   = $_.hasChildren
            Children      = $_.children
            Path          = $_.path
            Links         = $_._links
            Url           = $_.url
          }
        }
      } catch {
        $PSCmdlet.ThrowTerminatingError((Write-AzDoError -Message "Failed to get Classification Node $Name in project '$ProjectName'. Error: $_" ))
      }
    } else {
      Write-Verbose "Calling Invoke-AzDoRestMethod with $($params| ConvertTo-Json -Depth 10)"
    }
  }
}
