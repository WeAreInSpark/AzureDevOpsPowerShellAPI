function Get-AzDoProjectName {
    <#
.SYNOPSIS
    Gets the name of a project by using the project ID.
.DESCRIPTION
    Gets the name of a project by using the project ID.
.EXAMPLE
    $params = @{
        CollectionUri       = "https://dev.azure.com/contoso"
        PAT                 = "***"
        ProjectId           = "6ed46fc1-9152-4a63-8817-530fd24b1662"
    }
    Get-AzDoProjectName @params

    This example gets the name of the project with ID "6ed46fc1-9152-4a63-8817-530fd24b1662"
.OUTPUTS
    string
    ProjectName
.NOTES
#>
    [CmdletBinding()]
    param (
        # Collection Uri of the organization
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]
        $CollectionUri,

        # PAT to authenticate with the organization
        [Parameter()]
        [string]
        $PAT = $env:SYSTEM_ACCESSTOKEN,

        # ID of the project
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]
        $ProjectId
    )

    $params = @{
        uri         = "$CollectionUri/_apis/projects/$($ProjectId)?api-version=7.1-preview.4"
        Method      = 'GET'
        Headers     = @{Authorization = 'Basic ' + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$($PAT)")) }
        ContentType = 'application/json'

    }
    $response = Invoke-RestMethod @params
    $ProjectName = $response.name

    $ProjectName
}
