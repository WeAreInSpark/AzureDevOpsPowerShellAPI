function Get-AzDoProject {
    <#
.SYNOPSIS
    Gets information about projects in Azure DevOps.
.DESCRIPTION
    Gets information about all the projects in Azure DevOps.
.EXAMPLE
    $Params = @{
        CollectionUri = "https://dev.azure.com/contoso"
        PAT = "***"
    }
    Get-AzDoProject @params

    This example will List all the projects contained in the collection ('https://dev.azure.com/contoso').

.EXAMPLE
    $Params = @{
        CollectionUri = "https://dev.azure.com/contoso"
        PAT = "***"
        ProjectName = 'Project1'
    }
    Get-AzDoProject @params

    This example will get the details of 'Project1' contained in the collection ('https://dev.azure.com/contoso').

.EXAMPLE
    $params = @{
        collectionuri = "https://dev.azure.com/contoso"
        PAT = "***"
    }
    $somedifferentobject = [PSCustomObject]@{
        ProjectName = 'Project1'
    }
    $somedifferentobject | Get-AzDoProject @params

    This example will get the details of 'Project1' contained in the collection ('https://dev.azure.com/contoso').

.EXAMPLE
    $params = @{
        collectionuri = "https://dev.azure.com/contoso"
        PAT = "***"
    }
    @(
        'Project1',
        'Project2'
    ) | Get-AzDoProject @params

    This example will get the details of 'Project1' contained in the collection ('https://dev.azure.com/contoso').
.OUTPUTS
    PSObject with repo(s).
.NOTES
#>
    [CmdletBinding()]
    param (
        # Collection Uri of the organization
        [Parameter()]
        [string]
        $CollectionUri,

        # PAT to authenticate with the organization
        [Parameter()]
        [string]
        $PAT = $env:SYSTEM_ACCESSTOKEN,

        # Project where the Repos are contained
        [Parameter(ValueFromPipelineByPropertyName, ValueFromPipeline, ParameterSetName = 'Get')]
        [string]
        $ProjectName
    )
    Process {
        if ($ProjectName) {
            $uri = "$CollectionUri/_apis/projects/$($ProjectName)?api-version=7.1-preview.4"
        } else {
            $uri = "$CollectionUri/_apis/projects?api-version=7.1-preview.4"
        }

        $params = @{
            uri         = $uri
            Method      = 'GET'
            Headers     = @{Authorization = 'Basic ' + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$($PAT)")) }
            ContentType = 'application/json'
        }

        if ($ProjectName) {
            (Invoke-RestMethod @params) | ForEach-Object {
                [PSCustomObject]@{
                    ProjectName       = $_.name
                    ProjectID         = $_.id
                    ProjectURL        = $_.url
                    CollectionURI     = $CollectionUri
                    ProjectVisibility = $_.visibility
                    State             = $_.state
                }
            }
        } else {
            (Invoke-RestMethod @params).value | ForEach-Object {
                [PSCustomObject]@{
                    ProjectName       = $_.name
                    ProjectID         = $_.id
                    ProjectURL        = $_.url
                    CollectionURI     = $CollectionUri
                    ProjectVisibility = $_.visibility
                    State             = $_.state
                }
            }
        }
    }
}
