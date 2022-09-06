function Get-AzDoObject {
    <#
.SYNOPSIS
    Retrieves properties from an azure devops object, like a group.
.DESCRIPTION
    Retrieves the user/group name, user/group id, descriptor and identity descriptor from an azure devops object, like a user or group.
.EXAMPLE
    $params = @{
        CollectionUri = "https://dev.azure.com/weareinspark"
        PAT           = "***"
        ProjectName   = "RandomProject"
        GroupName     = 'Readers'
    }
    Get-AzDoObject @params

    This example retrieves the properties of the reader group in project 'RandomProject'.
.OUTPUTS
    PSCustomObject
.NOTES
#>
    [CmdletBinding()]
    param (
        # Collection Uri of the organization
        [Parameter(Mandatory)]
        [string]
        $CollectionUri,

        # PAT to authenticate with the organization
        [Parameter()]
        [string]
        $PAT = $env:SYSTEM_ACCESSTOKEN,

        # ID of the project
        [Parameter(Mandatory, ParameterSetName = 'ProjectId')]
        [string]
        $ProjectId,

        # Name of the project
        [Parameter(Mandatory, ParameterSetName = 'ProjectName')]
        [string]
        $ProjectName,

        # Group to retrieve the object values from
        [Parameter()]
        [string]
        $GroupName,

        # User to retrieve the object values from
        [Parameter()]
        [string]
        $UserName
    )

    begin {
        if ($ProjectId) {
            $ProjectName = Get-AzDoProjectName -CollectionUri $CollectionUri -PAT $PAT -ProjectId $ProjectId
        }
    }

    process {
        if ($GroupName) {
            $apiType = 'groups'
            $objectType = 'Group'
        }
        if ($UserName) {
            $apiType = 'users'
            $objectType = 'User'
        }

        $params = @{
            uri         = "https://vssps.dev.azure.com/$($CollectionUri.split('/')[3])/_apis/graph/$($apiType)?api-version=7.1-preview.1"
            Method      = 'GET'
            Headers     = @{Authorization = 'Basic ' + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$($PAT)")) }
            ContentType = 'application/json'
        }
        $response = Invoke-RestMethod @params

        if ($GroupName) {
            $Object = $response.value | Where-Object { ($_.displayname -EQ $GroupName) -and ($_.principalName -EQ "[$ProjectName]\$GroupName") }
        }
        if ($UserName) {
            $Object = $response.value | Where-Object { $_.displayname -EQ $UserName }
        }

        $params = @{
            uri         = "https://vssps.dev.azure.com/$($CollectionUri.split('/')[3])/_apis/identities?subjectDescriptors=$($Object.Descriptor)&api-version=7.1-preview.1"
            Method      = 'GET'
            Headers     = @{Authorization = 'Basic ' + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$($PAT)")) }
            ContentType = 'application/json'

        }
        $response = Invoke-RestMethod @params

        [PSCustomObject]@{
            "$($objectType)Name" = $Object.displayName
            "$($objectType)Id"   = $Object.originId
            Descriptor           = $Object.descriptor
            IdentityDescriptor   = $response.value.descriptor
        }
    }
}

