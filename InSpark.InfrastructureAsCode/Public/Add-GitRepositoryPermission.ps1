function Add-GitRepositoryPermission {
    <#
.SYNOPSIS
    Adds a permission on project or repository level
.DESCRIPTION
    Adds a permission on project or repository level
.EXAMPLE
    $params = @{
        CollectionUri       = "https://dev.azure.com/weareinspark"
        PAT                 = "***"
        ProjectId           = '6ed46fc1-9152-4a63-8817-530fd24b1662'
        GroupName           = Contributors
        Allow               = 256
    }
    Add-GitRepositoryPermission @params

    This example gives the contributor group permission to create repositories
.EXAMPLE
    $params = @{
        CollectionUri         = "https://dev.azure.com/weareinspark"
        PAT                   = "***"
        ProjectId             = '6ed46fc1-9152-4a63-8817-530fd24b1662'
        UserName              = BRC Build Service (weareinspark)
        RoleName              = Administrator
        AllServiceConnections = $true
    }
    Add-GitRepositoryPermission @params

    This example gives the user 'BRC Build Service (weareinspark)' the adminstrator role on all service endpoints in project
    6ed46fc1-9152-4a63-8817-530fd24b1662
.OUTPUTS

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
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]
        $ProjectId,

        # ID of the repository
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]
        $RepositoryId,

        # Group name to set the permissions on
        [Parameter()]
        [string]
        $GroupName,

        # User name to set the permissions on
        [Parameter()]
        [string]
        $UserName,

        # Name of the role to assign to the group or user
        [Parameter()]
        [string]
        $RoleName,

        # Variable group name to set the permissions on
        [Parameter()]
        [string]
        $VariableGroupName,

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
        $Allow,

        # Actions to deny
        [Parameter()]
        $Deny
    )

    begin {
        if ($VariableGroupName) {
            $SecurityNamespaceId = 'b7e84409-6553-448a-bbb2-af228e07cbeb'
            $Actions = @{
                Administrator = 23
                User          = 17
                Reader        = 1
            }
        } else {
            $SecurityNamespaceId = '2e9eb7ed-3c0a-47d4-87c1-0ffdd275fd87'
            $Actions = @{
                Administer                                      = 1
                GenericRead                                     = 2
                'Read'                                          = 2
                GenericContribute                               = 4
                'Contribute'                                    = 4
                ForcePush                                       = 8
                'Force push'                                    = 8
                CreateBranch                                    = 16
                'Create branch'                                 = 16
                CreateTag                                       = 32
                'Create tag'                                    = 32
                ManageNote                                      = 64
                'Manage notes'                                  = 64
                PolicyExempt                                    = 128
                'Bypass policies when pushing'                  = 128
                CreateRepository                                = 256
                'Create repository'                             = 256
                DeleteRepository                                = 512
                'Delete or disable repository'                  = 512
                RenameRepository                                = 1024
                'Rename repository'                             = 1024
                EditPolicies                                    = 2048
                'Edit policies'                                 = 2048
                RemoveOthersLocks                               = 4096
                'Remove others locks'                           = 4096
                ManagePermissions                               = 8192
                'Manage permissions'                            = 8192
                PullRequestContribute                           = 16384
                'Contribute to pull requests'                   = 16384
                PullRequestBypassPolicy                         = 32768
                'Bypass policies when completing pull requests' = 32768
            }
        }
    }

    process {
        if ($Allow) {
            $Allow = $Actions.$Allow
        }
        if ($Deny) {
            $Deny = $Actions.$Deny
        }
        if ($UserName) {
            $Descriptor = (Get-AzDoObject -CollectionUri $CollectionUri -PAT $PAT -ProjectId $ProjectId -UserName $UserName).IdentityDescriptor
        }
        if ($GroupName) {
            $Descriptor = (Get-AzDoObject -CollectionUri $CollectionUri -PAT $PAT -ProjectId $ProjectId -GroupName $GroupName).IdentityDescriptor
        }
        $Token = "repoV2/$ProjectId"
        if ($RepositoryId) {
            $token += "/$RepositoryId"
        }

        if ($VariableGroupName) {
            $Allow = $Actions.$RoleName
            $params = @{
                uri         = "$CollectionUri/$ProjectId/_apis/distributedtask/variablegroups?api-version=7.1-preview.2"
                Method      = 'GET'
                Headers     = @{Authorization = 'Basic ' + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$($PAT)")) }
                ContentType = 'application/json'

            }
            $VariableGroupId = ((Invoke-RestMethod @params).value | Where-Object { $_.name -EQ $VariableGroupName }).id

            $Token = "Library/$ProjectId/VariableGroup/$VariableGroupId"
        }

        $addAccessControlEntrySplat = @{
            CollectionUri       = $CollectionUri
            PAT                 = $PAT
            SecurityNamespaceId = $SecurityNamespaceId
            Token               = $Token
            ProjectId           = $ProjectId
        }
        if ($UserName) {
            $UserId = (Get-AzDoObject -CollectionUri $CollectionUri -PAT $PAT -ProjectId $ProjectId -UserName $UserName).UserId
            $addAccessControlEntrySplat['UserId'] = $UserId
        }
        if ($GroupName) {
            $UserId = (Get-AzDoObject -CollectionUri $CollectionUri -PAT $PAT -ProjectId $ProjectId -GroupName $GroupName).GroupId
            $addAccessControlEntrySplat['UserId'] = $UserId
        }
        if ($Descriptor) {
            $addAccessControlEntrySplat['Descriptor'] = $Descriptor
        }
        if ($Allow) {
            $addAccessControlEntrySplat['Allow'] = $Allow
        }
        if ($Deny) {
            $addAccessControlEntrySplat['Deny'] = $Deny
        }
        if ($RoleName) {
            $addAccessControlEntrySplat['RoleName'] = $RoleName
        }
        if ($ServiceConnectionName) {
            $addAccessControlEntrySplat['ServiceConnectionName'] = $ServiceConnectionName
        }
        if ($AllServiceConnections) {
            $addAccessControlEntrySplat['AllServiceConnections'] = $AllServiceConnections
        }
        Add-AccessControlEntry @addAccessControlEntrySplat
    }
}
