function Add-AzDoPermission {
    <#
.SYNOPSIS
    Adds a permission on project or repository level
.DESCRIPTION
    Adds a permission on project or repository level
.EXAMPLE
    $params = @{
        CollectionUri       = "https://dev.azure.com/weareinspark"
        PAT                 = "***"
        ProjectName         = 'TestProject'
        GroupName           = 'Contributors'
        Allow               = 'Create repository'
    }
    Add-AzDoPermission @params

    This example gives the contributors group permission to create repositories
.EXAMPLE
    $params = @{
        CollectionUri           = "https://dev.azure.com/weareinspark"
        PAT                     = "***"
        ProjectId               = '6ed46fc1-9152-4a63-8817-530fd24b1662'
        RoleName                = 'Administrator'
        BuildServicePermissions = $true
        AllServiceConnections   = $true
    }
    Add-AzDoPermission @params

    This example gives the Build Service user the adminstrator role on all service connections in project 6ed46fc1-9152-4a63-8817-530fd24b1662
.EXAMPLE
    $params = @{
        CollectionUri           = "https://dev.azure.com/weareinspark"
        PAT                     = "***"
        ProjectName             = 'TestProject'
        RoleName                = 'Administrator'
        AllVariableGroups       = $true
        BuildServicePermissions = $true
    }
    Add-AzDoPermission @params

    This example gives the Build Service user the administrator role on all variable groups in TestProject
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

        # Name of the project
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]
        $ProjectName,

        # ID of the project
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]
        $ProjectId,

        # Name of the repository
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]
        $RepositoryName,

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
        [string[]]
        $VariableGroupName,

        # Switch to set the permissions on all variable groups
        [Parameter()]
        [switch]
        $AllVariableGroups,

        # Name of the service connection to set the permissions on
        [Parameter()]
        [string]
        $ServiceConnectionName,

        # Switch to set permissions on all service connections
        [Parameter()]
        [switch]
        $AllServiceConnections,

        # When enabled, the permissions will be set on the project build service
        [Parameter()]
        [switch]
        $BuildServicePermissions,

        # Actions to allow
        [Parameter()]
        $Allow,

        # Actions to deny
        [Parameter()]
        $Deny
    )

    begin {
        if ($ProjectName) {
            $ProjectId = (Get-AzDoProject -CollectionUri $CollectionUri -PAT $PAT -ProjectName $ProjectName).ProjectId
        }
        if ($RepositoryName) {
            $RepositoryId = (Get-AzDoRepo -CollectionUri $CollectionUri -PAT $PAT -ProjectName $ProjectName -RepoName $RepositoryName).RepoId
        }
        if ($BuildServicePermissions) {
            if (-not ($ProjectName)) {
                $ProjectName = Get-AzDoProjectName -CollectionUri $CollectionUri -PAT $PAT -ProjectId $ProjectId
            }
            $UserName = "$ProjectName Build Service ($($CollectionUri.split('/')[3]))"
        }
        if ($VariableGroupName -or $AllVariableGroups) {
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
            $Descriptor = (Get-AzDoGroupOrUser -CollectionUri $CollectionUri -PAT $PAT -ProjectId $ProjectId -UserName $UserName).IdentityDescriptor
        }
        if ($GroupName) {
            $Descriptor = (Get-AzDoGroupOrUser -CollectionUri $CollectionUri -PAT $PAT -ProjectId $ProjectId -GroupName $GroupName).IdentityDescriptor
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
            $Token = foreach ($name in $VariableGroupName) {
                $VariableGroupId = ((Invoke-RestMethod @params).value | Where-Object { $_.name -EQ $name }).id
                "Library/$ProjectId/VariableGroup/$VariableGroupId"
            }
        }
        if ($AllVariableGroups) {
            $Allow = $Actions.$RoleName
            $params = @{
                uri         = "$CollectionUri/$ProjectId/_apis/distributedtask/variablegroups?api-version=7.1-preview.2"
                Method      = 'GET'
                Headers     = @{Authorization = 'Basic ' + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$($PAT)")) }
                ContentType = 'application/json'

            }
            $VariableGroupIds = (Invoke-RestMethod @params).value.id
            $Token = foreach ($id in $VariableGroupIds) {
                "Library/$ProjectId/VariableGroup/$id"
            }
        }

        $addAccessControlEntrySplat = @{
            CollectionUri       = $CollectionUri
            PAT                 = $PAT
            SecurityNamespaceId = $SecurityNamespaceId
            Token               = $Token
            ProjectId           = $ProjectId
        }
        if ($UserName) {
            $UserId = (Get-AzDoGroupOrUser -CollectionUri $CollectionUri -PAT $PAT -ProjectId $ProjectId -UserName $UserName).UserId
            $addAccessControlEntrySplat['UserId'] = $UserId
        }
        if ($GroupName) {
            $UserId = (Get-AzDoGroupOrUser -CollectionUri $CollectionUri -PAT $PAT -ProjectId $ProjectId -GroupName $GroupName).GroupId
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