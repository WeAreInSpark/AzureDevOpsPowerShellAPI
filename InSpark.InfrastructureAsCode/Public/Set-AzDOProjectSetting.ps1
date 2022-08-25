function Set-AzDoProjectSetting {
    <#
    .SYNOPSIS
        Sets the project settings for the given project.
    .DESCRIPTION
        Sets the project settings for the given project.
    .EXAMPLE
        $params = @{
            CollectionUri = "https://dev.azure.com/contoso"
            PAT = "***"
            ProjectName = "Project01"
            EnforceJobAuthScope = $true
            EnforceJobAuthScopeForReleases = $true
            EnforceReferencedRepoScopedToken = $true
            EnforceSettableVar = $true
            PublishPipelineMetadata = $true
            StatusBadgesArePrivate = $true
        }
        Set-AzDOProjectSettings

        This example sets all the settings available to true.
    .OUTPUTS
        PSobject
    .NOTES
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param (
        # Collection uri of the organization. Can be set with the predefined variable from Azure DevOps.
        [Parameter(Mandatory)]
        [string]
        $CollectionUri,

        # PAT to get access to Azure DevOps.
        [Parameter()]
        [string]
        $PAT = $env:SYSTEM_ACCESSTOKEN,

        # Name of the project
        [Parameter(Mandatory)]
        [string]
        $ProjectName,

        # If enabled, scope of access for all pipelines reduces to the current project.
        [Parameter(Mandatory = $false)]
        [bool]
        $EnforceJobAuthScope = $true,

        # Limit job authorization scope to current project for release pipelines.
        [Parameter(Mandatory = $false)]
        [bool]
        $EnforceJobAuthScopeForReleases = $true,

        # Restricts the scope of access for all pipelines to only repositories explicitly referenced by the pipeline.
        [Parameter(Mandatory = $false)]
        [bool]
        $EnforceReferencedRepoScopedToken = $true,

        # If enabled, only those variables that are explicitly marked as "Settable at queue time" can be set at queue time.
        [Parameter(Mandatory = $false)]
        [bool]
        $EnforceSettableVar = $true,

        # Allows pipelines to record metadata.
        [Parameter(Mandatory = $false)]
        [bool]
        $PublishPipelineMetadata = $false,

        # Anonymous users can access the status badge API for all pipelines unless this option is enabled.
        [Parameter(Mandatory = $false)]
        [bool]
        $StatusBadgesArePrivate = $true
    )

    $Body = @{
        enforceJobAuthScope              = $EnforceJobAuthScope
        enforceJobAuthScopeForReleases   = $EnforceJobAuthScopeForReleases
        enforceReferencedRepoScopedToken = $EnforceReferencedRepoScopedToken
        enforceSettableVar               = $EnforceSettableVar
        publishPipelineMetadata          = $PublishPipelineMetadata
        statusBadgesArePrivate           = $StatusBadgesArePrivate
    }

    $params = @{
        uri         = "$CollectionUri/$ProjectName/_apis/build/generalsettings?api-version=6.1-preview.1"
        Method      = 'PATCH'
        Headers     = @{Authorization = 'Basic ' + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$($PAT)")) }
        body        = $Body | ConvertTo-Json
        ContentType = 'application/json'
    }

    if ($PSCmdlet.ShouldProcess($CollectionUri)) {
        Invoke-RestMethod @params
    } else {
        Write-Output $Body | Format-List
        return
    }
}