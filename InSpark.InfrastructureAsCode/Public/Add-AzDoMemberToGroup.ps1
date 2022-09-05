function Add-AzDoMemberToGroup {
    <#
.SYNOPSIS
    Adds a member to a group.
.DESCRIPTION
    Adds a member to a group.
.EXAMPLE
    $params = @{
        CollectionUri       = "https://dev.azure.com/weareinspark"
        PAT                 = "***"
        ProjectId           = "6ed46fc1-9152-4a63-8817-530fd24b1662"
        EmailAddress        = 'lucas.bahnmuller@inspark.nl, dylan.prins@inspark.nl'
        GroupName           = 'Readers'
    }
    Add-AzDoMemberToGroup @params

    This example adds lucas.bahnmuller@inspark.nl and dylan.prins@inspark.nl to the Readers group in project 6ed46fc1-9152-4a63-8817-530fd24b1662
.OUTPUTS
    PSCustomObject

.NOTES
#>
    [CmdletBinding()]
    param (
        # Collection Uri of the organization
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]
        $CollectionUri,

        # PAT to authenticate with the organization
        [Parameter(Mandatory)]
        [string]
        $PAT,

        # ID of the project
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]
        $ProjectId,

        # Email Addresses of the members to add to the group
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string[]]
        $EmailAddress,

        # Group to add the members to
        [Parameter(Mandatory)]
        [string]
        $GroupName
    )
    process {
        foreach ($mail in $EmailAddress) {
            $Descriptor = (Get-AzDoObject -CollectionUri $CollectionUri -PAT $PAT -ProjectId $ProjectId -GroupName $GroupName).Descriptor

            $body = @{
                principalName = $mail
            }

            $params = @{
                uri         = "https://vssps.dev.azure.com/$($CollectionUri.split('/')[3])/_apis/graph/users?groupDescriptors=$Descriptor&api-version=6.0-preview.1"
                Method      = 'POST'
                Headers     = @{Authorization = 'Basic ' + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$($PAT)")) }
                body        = $body | ConvertTo-Json -Depth 99
                ContentType = 'application/json'

            }
            $response = Invoke-RestMethod @params

            [PSCustomObject]@{
                UserDirectoryAlias = $response.directoryAlias
                UserId             = $response.originId
                UserDomain         = $response.domain
                Descriptor         = $response.descriptor
            }
        }
    }
}
