function New-AzDoClassificationNode {
  <#
.SYNOPSIS
    Creates a Classification Node in Azure DevOps.
.DESCRIPTION
    Creates a Classification Node in Azure DevOps. This could be an area or an iteration.
.EXAMPLE
    $Params = @{
      CollectionUri  = "https://dev.azure.com/cantoso"
      ProjectName    = "Playground"
      StructureGroup = "areas"
      Name           = "Area1"
    }

    New-AzDoClassificationNode @Params

    This example creates a Classification Node of the type 'areas' within the Project.
.EXAMPLE
    $Params = @{
      CollectionUri  = "https://dev.azure.com/cantoso"
      ProjectName    = "Playground"
      StructureGroup = "areas"
      Name           = "Area1"
      Path           = "Path1"
    }

    New-AzDoClassificationNode @Params

    This example creates a Classification Node of the type 'areas' within the specified path.
.EXAMPLE
    $Params = @{
      CollectionUri  = "https://dev.azure.com/cantoso"
      ProjectName    = "Playground"
      StructureGroup = "iterations"
      Name           = "Iteration1"
    }

    New-AzDoClassificationNode @Params

    This example creates a Classification Node of the type 'iterations' within the Project.
.EXAMPLE
    $Params = @{
      CollectionUri  = "https://dev.azure.com/cantoso"
      ProjectName    = "Playground"
      StructureGroup = "iterations"
      Name           = "Iteration1"
      Path           = "Path1"
      startDate      = "10//701001 00:00:00
      finishDate     = "10//701008 00:00:00
    }

    New-AzDoClassificationNode @Params

    This example creates a Classification Node of the type 'iterations' within the specified path, it is also possible to use a start and finish date of the iteration by adding the optional parameters 'startDate' and 'finishDate'.
.OUTPUTS
    [PSCustomObject]@{
      CollectionUri = $CollectionUri
      ProjectName   = $ProjectName
      Id            = $_.id
      Identifier    = $_.identifier
      Name          = $_.name
      StructureType = $_.structureType
      HasChildren   = $_.hasChildren
      Path          = $_.path
      Links         = $_._links
      Url           = $_.url
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

    # Start date of the iteration (optional)
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $startDate,

    # Finish date of the iteration (optional)
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $finishDate
  )

  begin {
    Write-Verbose "Starting function: New-AzDoClassificationNode"
  }

  process {
    $ProjectId = (Get-AzDoProject -CollectionUri $CollectionUri -ProjectName $ProjectName).Projectid

    if ($Path) {
      $uri = "$CollectionUri/$ProjectName/_apis/wit/classificationnodes/$StructureGroup/$Path"
    } else {
      $uri = "$CollectionUri/$ProjectName/_apis/wit/classificationnodes/$StructureGroup"
    }

    $params = @{
      uri     = $uri
      version = "7.2-preview.2"
      Method  = 'POST'
    }

    if ($StructureGroup -eq 'areas') {
      $body = @{
        name = $Name
      }
    }
    if ($StructureGroup -eq 'iterations') {
      $body = @{
        name       = $Name
        attributes = @{
          startDate  = $startDate
          finishDate = $finishDate
        }
      }
    }


    if ($PSCmdlet.ShouldProcess($ProjectName, "Create Classification Node named: $($PSStyle.Bold)$Name$($PSStyle.Reset)")) {
      try {
        $body | Invoke-AzDoRestMethod @params | ForEach-Object {
          [PSCustomObject]@{
            CollectionUri = $CollectionUri
            ProjectName   = $ProjectName
            Id            = $_.id
            Identifier    = $_.identifier
            Name          = $_.name
            StructureType = $_.structureType
            HasChildren   = $_.hasChildren
            Path          = $_.path
            Links         = $_._links
            Url           = $_.url
          }
        }
      } catch {
        if ($_ -match 'is already in use by a different') {
          Write-Warning "Classification Node already exists within the path, trying to get it"
          $params.Method = 'GET'
          $params.uri = "$uri/$Name"
          Invoke-AzDoRestMethod @params | ForEach-Object {
            [PSCustomObject]@{
              CollectionUri = $CollectionUri
              ProjectName   = $ProjectName
              Id            = $_.id
              Identifier    = $_.identifier
              Name          = $_.name
              StructureType = $_.structureType
              HasChildren   = $_.hasChildren
              Path          = $_.path
              Links         = $_._links
              Url           = $_.url
            }
          }
        } else {
          $PSCmdlet.ThrowTerminatingError((Write-AzDoError -message $_))
        }
      }
    }
  }
}
