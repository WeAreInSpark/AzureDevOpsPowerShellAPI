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
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param (
        # Collection uri of the organization. Can be set with the predefined variable from Azure DevOps.
        [Parameter(Mandatory)]
        [string]
        $CollectionUri,

        # PAT to get access to Azure DevOps.
        [Parameter()]
        [string]
        $PAT = $env:SYSTEM_ACCESSTOKEN,

        # Switch to use PAT instead of OAuth
        [Parameter()]
        [switch]
        $UsePAT = $false,

        # Name of the project
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string]
        $ProjectName,

        # If enabled, enables forked repositories to build pull requests.
        [Parameter(ValueFromPipelineByPropertyName)]
        [switch]
        $BuildsEnabledForForks = $true,

        # If enabled, disables classic build pipelines creation.
        [Parameter(ValueFromPipelineByPropertyName)]
        [switch]
        $DisableClassicBuildPipelineCreation = $true,

        # If enabled, disables classic pipelines creation.
        [Parameter(ValueFromPipelineByPropertyName)]
        [switch]
        $DisableClassicPipelineCreation = $true,

        # If enabled, disables classic release pipelines creation.
        [Parameter(ValueFromPipelineByPropertyName)]
        [switch]
        $DisableClassicReleasePipelineCreation = $true,

        # If enabled, disables implied pipeline CI triggers if the trigger section in YAML is missing.
        [Parameter(ValueFromPipelineByPropertyName)]
        [switch]
        $DisableImpliedYAMLCiTrigger = $true,

        # Enable shell tasks args sanitizing.
        [Parameter(ValueFromPipelineByPropertyName)]
        [switch]
        $EnableShellTasksArgsSanitizing = $true,

        # Enable shell tasks args sanitizing preview.
        [Parameter(ValueFromPipelineByPropertyName)]
        [switch]
        $EnableShellTasksArgsSanitizingAudit = $true,

        # Limit job authorization scope to current project for for all non-release pipelines reduces to the current project.
        [Parameter(ValueFromPipelineByPropertyName)]
        [switch]
        $EnforceJobAuthScope = $true,

        # Limit job authorization scope to current project for builds of forked repositories.
        [Parameter(ValueFromPipelineByPropertyName)]
        [switch]
        $EnforceJobAuthScopeForForks = $true,

        # Limit job authorization scope to current project for release pipelines.
        [Parameter(ValueFromPipelineByPropertyName)]
        [switch]
        $EnforceJobAuthScopeForReleases = $true,

        # Enforce no access to secrets for builds of forked repositories.
        [Parameter(ValueFromPipelineByPropertyName)]
        [switch]
        $EnforceNoAccessToSecretsFromForks = $true,

        # Restricts the scope of access for all pipelines to only repositories explicitly referenced by the pipeline.
        [Parameter(ValueFromPipelineByPropertyName)]
        [switch]
        $EnforceReferencedRepoScopedToken = $true,

        # If enabled, only those variables that are explicitly marked as "Settable at queue time" can be set at queue time.
        [Parameter(ValueFromPipelineByPropertyName)]
        [switch]
        $EnforceSettableVar = $true,

        # Enable settings that enforce certain levels of protection for building pull requests from forks globally.
        [Parameter(ValueFromPipelineByPropertyName)]
        [switch]
        $ForkProtectionEnabled = $true,

        # Make comments required to have builds in all pull requests.
        [Parameter(ValueFromPipelineByPropertyName)]
        [switch]
        $IsCommentRequiredForPullRequest = $true,

        # Allows pipelines to record metadata.
        [Parameter(ValueFromPipelineByPropertyName)]
        [switch]
        $PublishPipelineMetadata = $false,

        # Make comments required to have builds in pull requests from non-team members and non-contributors.
        [Parameter(ValueFromPipelineByPropertyName)]
        [switch]
        $RequireCommentsForNonTeamMemberAndNonContributors = $false,

        # Make comments required to have builds in pull requests from non-team members and non-contributors.
        [Parameter(ValueFromPipelineByPropertyName)]
        [switch]
        $RequireCommentsForNonTeamMembersOnly = $false,

        # Anonymous users can access the status badge API for all pipelines unless this option is enabled.
        [Parameter(ValueFromPipelineByPropertyName)]
        [switch]
        $StatusBadgesArePrivate = $true
    )
    Begin {
        if ($UsePAT) {
            Write-Verbose 'The [UsePAT]-parameter was set to true, so the PAT will be used to authenticate with the organization.'
            if ($PAT -eq $env:SYSTEM_ACCESSTOKEN) {
                Write-Verbose -Message "Using the PAT from the environment variable 'SYSTEM_ACCESSTOKEN'."
            } elseif (-not [string]::IsNullOrWhitespace($PAT) -and $PSBoundParameters.ContainsKey('PAT')) {
                Write-Verbose -Message "Using a custom PAT supplied in the parameters."
            } else {
                try {
                    throw "Requested to use a PAT, but no custom PAT was supplied in the parameters or the environment variable 'SYSTEM_ACCESSTOKEN' was not set."
                } catch {
                    $PSCmdlet.ThrowTerminatingError($_)
                }
            }
        } else {
            Write-Verbose 'The [UsePAT]-parameter was set to false, so an OAuth will be used to authenticate with the organization.'
            $PAT = ($UsePAT ? $PAT : $null)
        }
        try {
            $Header = New-ADOAuthHeader -PAT $PAT -AccessToken:($UsePAT ? $false : $true) -ErrorAction Stop
        } catch {
            $PSCmdlet.ThrowTerminatingError($_)
        }

        $getAzDoProjectSplat = @{
            CollectionUri = $CollectionUri
            ProjectName   = $ProjectName
        }

        if ($PAT) {
            $getAzDoProjectSplat += @{
                PAT    = $PAT
                UsePAT = $true
            }
        }

        $Projects = Get-AzDoProject @getAzDoProjectSplat
        $ProjectId = ($Projects | Where-Object ProjectName -EQ $ProjectName).Projectid
    }
    Process {
        $Body = @{
            buildsEnabledForForks                             = [bool]$BuildsEnabledForForks
            disableClassicBuildPipelineCreation               = [bool]$DisableClassicBuildPipelineCreation
            disableClassicPipelineCreation                    = [bool]$DisableClassicPipelineCreation
            disableClassicReleasePipelineCreation             = [bool]$DisableClassicReleasePipelineCreation
            disableImpliedYAMLCiTrigger                       = [bool]$DisableImpliedYAMLCiTrigger
            enableShellTasksArgsSanitizing                    = [bool]$EnableShellTasksArgsSanitizing
            enableShellTasksArgsSanitizingAudit               = [bool]$EnableShellTasksArgsSanitizingAudit
            enforceJobAuthScope                               = [bool]$EnforceJobAuthScope
            enforceJobAuthScopeForForks                       = [bool]$EnforceJobAuthScopeForForks
            enforceJobAuthScopeForReleases                    = [bool]$EnforceJobAuthScopeForReleases
            enforceNoAccessToSecretsFromForks                 = [bool]$EnforceNoAccessToSecretsFromForks
            enforceReferencedRepoScopedToken                  = [bool]$EnforceReferencedRepoScopedToken
            enforceSettableVar                                = [bool]$EnforceSettableVar
            forkProtectionEnabled                             = [bool]$ForkProtectionEnabled
            isCommentRequiredForPullRequest                   = [bool]$IsCommentRequiredForPullRequest
            publishPipelineMetadata                           = [bool]$PublishPipelineMetadata
            requireCommentsForNonTeamMemberAndNonContributors = [bool]$RequireCommentsForNonTeamMemberAndNonContributors
            requireCommentsForNonTeamMembersOnly              = [bool]$RequireCommentsForNonTeamMembersOnly
            statusBadgesArePrivate                            = [bool]$StatusBadgesArePrivate
        }

        $params = @{
            uri         = "$CollectionUri/$ProjectId/_apis/build/generalsettings?api-version=7.2-preview.1"
            Method      = 'PATCH'
            Headers     = New-ADOAuthHeader
            body        = $Body | ConvertTo-Json
            ContentType = 'application/json'
        }

        if ($PSCmdlet.ShouldProcess($CollectionUri, "Set provided settings at the project named: $($PSStyle.Bold)$Projectname$($PSStyle.Reset)")) {
            $response = Invoke-RestMethod @params

            [PSCustomObject]@{
                ProjectName                                       = $ProjectName
                BuildsEnabledForForks                             = $response.buildsEnabledForForks
                DisableClassicBuildPipelineCreation               = $response.disableClassicBuildPipelineCreation
                DisableClassicPipelineCreation                    = $response.disableClassicPipelineCreation
                DisableClassicReleasePipelineCreation             = $response.disableClassicReleasePipelineCreation
                DisableImpliedYAMLCiTrigger                       = $response.disableImpliedYAMLCiTrigger
                EnableShellTasksArgsSanitizing                    = $response.enableShellTasksArgsSanitizing
                EnableShellTasksArgsSanitizingAudit               = $response.enableShellTasksArgsSanitizingAudit
                EnforceJobAuthScope                               = $response.enforceJobAuthScope
                EnforceJobAuthScopeForForks                       = $response.enforceJobAuthScopeForForks
                EnforceJobAuthScopeForReleases                    = $response.enforceJobAuthScopeForReleases
                EnforceNoAccessToSecretsFromForks                 = $response.enforceNoAccessToSecretsFromForks
                EnforceReferencedRepoScopedToken                  = $response.enforceReferencedRepoScopedToken
                EnforceSettableVar                                = $response.enforceSettableVar
                ForkProtectionEnabled                             = $response.forkProtectionEnabled
                IsCommentRequiredForPullRequest                   = $response.isCommentRequiredForPullRequest
                PublishPipelineMetadata                           = $response.publishPipelineMetadata
                RequireCommentsForNonTeamMemberAndNonContributors = $response.requireCommentsForNonTeamMemberAndNonContributors
                RequireCommentsForNonTeamMembersOnly              = $response.requireCommentsForNonTeamMembersOnly
                StatusBadgesArePrivate                            = $response.statusBadgesArePrivate
            }
        } else {
            $body
        }
    }
}
