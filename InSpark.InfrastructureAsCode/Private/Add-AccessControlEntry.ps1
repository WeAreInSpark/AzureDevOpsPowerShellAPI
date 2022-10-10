function Add-AccessControlEntry {
    <#
.SYNOPSIS
    Adds an allow or deny access control entry.
.DESCRIPTION
    Adds an allow or deny access control entry.
.EXAMPLE
    $params = @{
        CollectionUri       = "https://dev.azure.com/weareinspark"
        PAT                 = "***"
        Descriptor          = "Microsoft.TeamFoundation.Identity;S-1-9-1551374245-3245331566-1385259850-2283229967-3528136290-1-1443083650-677473089-2681976939-1296422525"
        SecurityNamespaceId = '2e9eb7ed-3c0a-47d4-87c1-0ffdd275fd87'
        Token               = "repoV2/6ed46fc1-9152-4a63-8817-530fd24b1662"
        Allow               = 256
    }
    Add-AccessControlEntry @params

    This example gives the contributor group permission to create repositories
.EXAMPLE
    $params = @{
        CollectionUri         = "https://dev.azure.com/weareinspark"
        PAT                   = "***"
        UserId                = "8d90d1f6-5f92-48d8-8479-e8020c99c6fb"
        AllServiceConnections = $true
        RoleName              = Administrator
        ProjectId             = 6ed46fc1-9152-4a63-8817-530fd24b1662
    }
    Add-AccessControlEntry @params

    This example gives the user with UserId 8d90d1f6-5f92-48d8-8479-e8020c99c6fb the adminstrator role on all service endpoints in project
    6ed46fc1-9152-4a63-8817-530fd24b1662
.OUTPUTS
PSCustomObject

.NOTES
#>
    [CmdletBinding()]
    param (
        # Collection Uri of the organization
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string]
        $CollectionUri,

        # PAT to authenticate with the organization
        [Parameter()]
        [string]
        $PAT = $env:SYSTEM_ACCESSTOKEN,

        # ID of the project
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]
        $ProjectId,

        # Security namespace ID
        [Parameter()]
        [string]
        $SecurityNamespaceId,

        # User ID of the user to set permissions on
        [Parameter()]
        [string]
        $UserId,

        # Name of the role to assign to the group or user
        [Parameter()]
        [string]
        $RoleName,

        # Token used in the body of the API call
        [Parameter()]
        [string[]]
        $Token,

        # The descriptor for the user/group this AccessControlEntry applies to
        [Parameter()]
        [string]
        $Descriptor,

        # Name of the service connection to set the permissions on
        [Parameter()]
        [string]
        $ServiceConnectionName,

        # Switch to set permissions on all service connections
        [Parameter()]
        [switch]
        $AllServiceConnections,

        # Actions to allow
        [Parameter()]
        [ValidateRange(0, 32768)]
        [int]
        $Allow,

        # Actions to deny
        [Parameter()]
        [ValidateRange(0, 32768)]
        $Deny
    )

    process {
        if ($AllServiceConnections) {
            $body = "[{`"userId`": `"$UserId`",`"roleName`": `"$RoleName`"}]"
            $params = @{
                uri         = "$CollectionUri/_apis/securityroles/scopes/distributedtask.project.serviceendpointrole/roleassignments/resources/$($ProjectId)?api-version=7.1-preview.1"
                body        = $body
                Method      = 'PUT'
                Headers     = @{Authorization = 'Basic ' + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$($PAT)")) }
                ContentType = 'application/json'
            }
            $response = Invoke-RestMethod @params

            [PSCustomObject]@{
                UserName     = $response.value.identity.displayName
                UserId       = $response.value.identity.id
                UserRoleName = $response.value.role.displayName
            }
            return
        } elseif ($ServiceConnectionName) {
            $params = @{
                uri         = "$CollectionUri/$($ProjectId)/_apis/serviceendpoint/endpoints?endpointNames=$($ServiceConnectionName)&api-version=7.1-preview.1"
                Method      = 'GET'
                Headers     = @{Authorization = 'Basic ' + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$($PAT)")) }
                ContentType = 'application/json'
            }
            $response = Invoke-RestMethod @params

            $EnvironmentId = $response.value.id
            $body = "[{`"userId`": `"$UserId`",`"roleName`": `"$RoleName`"}]"
            $params = @{
                uri         = "$CollectionUri/_apis/securityroles/scopes/distributedtask.project.serviceendpointrole/roleassignments/resources/$($ProjectId)_$($EnvironmentId)?api-version=7.1-preview.1"
                body        = $body
                Method      = 'PUT'
                Headers     = @{Authorization = 'Basic ' + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$($PAT)")) }
                ContentType = 'application/json'
            }
            $response = Invoke-RestMethod @params

            [PSCustomObject]@{
                UserName     = $response.value.identity.displayName
                UserId       = $response.value.identity.id
                UserRoleName = $response.value.role.displayName
            }
            return
        }

        $accessControlEntries = @{
            descriptor = $Descriptor
        }
        if ($Allow) {
            $accessControlEntries['Allow'] = $Allow
        }
        if ($Deny) {
            $accessControlEntries['Deny'] = $Deny
        }
        $body = @{
            token                = $Token
            merge                = $true
            accessControlEntries = @(
                $accessControlEntries
            )
        }
        if ($Token -match 'VariableGroup') {
            foreach ($variableGroupToken in $Token) {
                $body = @{
                    token                = $variableGroupToken
                    merge                = $true
                    accessControlEntries = @(
                        $accessControlEntries
                    )
                }
                $params = @{
                    uri         = "$CollectionUri/_apis/accesscontrolentries/$($SecurityNamespaceId)?token=$($variableGroupToken)&descriptors=$($Descriptor)&api-version=7.1-preview.1"
                    body        = $body | ConvertTo-Json -Depth 99
                    Method      = 'DELETE'
                    Headers     = @{Authorization = 'Basic ' + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$($PAT)")) }
                    ContentType = 'application/json'

                }
                $response = Invoke-RestMethod @params

                $params = @{
                    uri         = "$CollectionUri/_apis/accesscontrolentries/$($SecurityNamespaceId)?api-version=7.1-preview.1"
                    body        = $body | ConvertTo-Json -Depth 99
                    Method      = 'POST'
                    Headers     = @{Authorization = 'Basic ' + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$($PAT)")) }
                    ContentType = 'application/json'

                }
                $response = Invoke-RestMethod @params

                [PSCustomObject]@{
                    Descriptor = $response.value.descriptor
                    Allow      = $response.value.allow
                    Deny       = $response.value.deny
                }
            }
        } else {
            $params = @{
                uri         = "$CollectionUri/_apis/accesscontrolentries/$($SecurityNamespaceId)?api-version=7.1-preview.1"
                body        = $body | ConvertTo-Json -Depth 99
                Method      = 'POST'
                Headers     = @{Authorization = 'Basic ' + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$($PAT)")) }
                ContentType = 'application/json'

            }
            $response = Invoke-RestMethod @params

            [PSCustomObject]@{
                Descriptor = $response.value.descriptor
                Allow      = $response.value.allow
                Deny       = $response.value.deny
            }
        }
    }
}
