function Get-AzDoGroupOrUser {
    <#
.SYNOPSIS
    Retrieves properties from a user or group.
.DESCRIPTION
    Retrieves the user/group name, user/group id, descriptor and identity descriptor from a user/group.
    The parameter ProjectName is mandatory if you want to retrieve a user/group from Azure Devops.
    When the parameter ProjectName is not specified, the user/group can be retrieved from AAD.
.EXAMPLE
    $params = @{
        CollectionUri = "https://dev.azure.com/CloudCompetenceCenter"
        AccessToken   = "$env:SYSTEM_ACCESSTOKEN"
        ProjectName   = "RandomProject"
        GroupName     = 'Readers'
    }
    $group = .\Azure\devops\Get-AzDoGroupOrUser.ps1 @params

    This example retrieves the properties of the reader group in project 'RandomProject'.
.OUTPUTS
    PSCustomObject
.NOTES
#>

    [CmdletBinding()]
    param (
        # PAT to authenticate with the organization
        [Parameter(Mandatory)]
        [string]
        $PAT,

        # Collection Uri of the organization
        [Parameter(Mandatory)]
        [string]
        $CollectionUri,

        # Name of the project
        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = 'ProjectNameAndGroup')]
        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = 'ProjectNameAndUser')]
        [string]
        $ProjectName,

        # ID of the project
        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = 'ProjectIdAndGroup')]
        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = 'ProjectIdAndUser')]
        [string]
        $ProjectId,

        # Group to retrieve the object values from
        [Parameter(Mandatory, ParameterSetName = 'ProjectNameAndGroup')]
        [Parameter(Mandatory, ParameterSetName = 'ProjectIdAndGroup')]
        [string]
        $GroupName,

        # User to retrieve the object values from
        [Parameter(Mandatory, ParameterSetName = 'ProjectNameAndUser')]
        [Parameter(Mandatory, ParameterSetName = 'ProjectIdAndUser')]
        [string]
        $UserName
    )
    begin {
        if ($ProjectId) {
            $ProjectName = Get-AzDoProjectName -CollectionUri $CollectionUri -PAT $PAT -ProjectId $ProjectId
        }
        $organizationName = $CollectionUri.split('/')[3]
        $authenticationHeader = @{ Authorization = 'Basic ' + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$($PAT)")) }
    }

    process {
        $uri = "https://vssps.dev.azure.com/$organizationName/_apis/identities?searchFilter=General&filterValue="

        if ($ProjectName) {
            $uri += "[$ProjectName]\"
        }

        if ($GroupName) {
            $uri += $GroupName
        }

        if ($UserName) {
            $uri += $UserName
        }

        $uri += "&api-version=7.0"

        $params = @{
            uri         = $uri
            Method      = 'GET'
            Headers     = $authenticationHeader
            ContentType = 'application/json'
        }

        $response = Invoke-RestMethod @params
        Write-Debug ($response | ConvertTo-Json -Depth 5)

        $identity = [PSCustomObject]@{
            name              = if ($ProjectName) { $response.value.providerDisplayName.Split("]\")[1] } else { $response.value.providerDisplayName }
            id                = $response.value.id
            descriptor        = $response.value.descriptor
            subjectDescriptor = $response.value.subjectDescriptor
        }

        Write-Debug "Descriptor of $($identity.name): $($identity.descriptor)"

        $identity
    }
}

