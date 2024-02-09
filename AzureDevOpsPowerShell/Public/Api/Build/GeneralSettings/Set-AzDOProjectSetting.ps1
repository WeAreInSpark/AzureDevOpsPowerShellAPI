function Set-AzDoProjectSetting {
  <#
    .SYNOPSIS
        Sets the project settings for the given project.
    .DESCRIPTION
        Sets the project settings for the given project.
    .EXAMPLE
        $params = @{
            CollectionUri = "https://dev.azure.com/contoso"
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
  [OutputType([System.Collections.Hashtable])]
  param (
    # Collection uri of the organization. Can be set with the predefined variable from Azure DevOps.
    [Parameter(Mandatory)]
    [string]
    $CollectionUri,

    # Name of the project
    [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [string]
    $ProjectName,

    # If enabled, enables forked repositories to build pull requests.
    [Parameter(ValueFromPipelineByPropertyName)]
    [switch]
    $BuildsEnabledForForks,

    # If enabled, disables classic build pipelines creation.
    [Parameter(ValueFromPipelineByPropertyName)]
    [switch]
    $DisableClassicBuildPipelineCreation,

    # If enabled, disables classic pipelines creation.
    [Parameter(ValueFromPipelineByPropertyName)]
    [switch]
    $DisableClassicPipelineCreation,

    # If enabled, disables classic release pipelines creation.
    [Parameter(ValueFromPipelineByPropertyName)]
    [switch]
    $DisableClassicReleasePipelineCreation,

    # If enabled, disables implied pipeline CI triggers if the trigger section in YAML is missing.
    [Parameter(ValueFromPipelineByPropertyName)]
    [switch]
    $DisableImpliedYAMLCiTrigger,

    # Enable shell tasks args sanitizing.
    [Parameter(ValueFromPipelineByPropertyName)]
    [switch]
    $EnableShellTasksArgsSanitizing,

    # Enable shell tasks args sanitizing preview.
    [Parameter(ValueFromPipelineByPropertyName)]
    [switch]
    $EnableShellTasksArgsSanitizingAudit,

    # Limit job authorization scope to current project for for all non-release pipelines reduces to the current project.
    [Parameter(ValueFromPipelineByPropertyName)]
    [switch]
    $EnforceJobAuthScope,

    # Limit job authorization scope to current project for builds of forked repositories.
    [Parameter(ValueFromPipelineByPropertyName)]
    [switch]
    $EnforceJobAuthScopeForForks,

    # Limit job authorization scope to current project for release pipelines.
    [Parameter(ValueFromPipelineByPropertyName)]
    [switch]
    $EnforceJobAuthScopeForReleases,

    # Enforce no access to secrets for builds of forked repositories.
    [Parameter(ValueFromPipelineByPropertyName)]
    [switch]
    $EnforceNoAccessToSecretsFromForks,

    # Restricts the scope of access for all pipelines to only repositories explicitly referenced by the pipeline.
    [Parameter(ValueFromPipelineByPropertyName)]
    [switch]
    $EnforceReferencedRepoScopedToken,

    # If enabled, only those variables that are explicitly marked as "Settable at queue time" can be set at queue time.
    [Parameter(ValueFromPipelineByPropertyName)]
    [switch]
    $EnforceSettableVar,

    # Enable settings that enforce certain levels of protection for building pull requests from forks globally.
    [Parameter(ValueFromPipelineByPropertyName)]
    [switch]
    $ForkProtectionEnabled,

    # Make comments required to have builds in all pull requests.
    [Parameter(ValueFromPipelineByPropertyName)]
    [switch]
    $IsCommentRequiredForPullRequest,

    # Allows pipelines to record metadata.
    [Parameter(ValueFromPipelineByPropertyName)]
    [switch]
    $PublishPipelineMetadata,

    # Make comments required to have builds in pull requests from non-team members and non-contributors.
    [Parameter(ValueFromPipelineByPropertyName)]
    [switch]
    $RequireCommentsForNonTeamMemberAndNonContributors,

    # Make comments required to have builds in pull requests from non-team members and non-contributors.
    [Parameter(ValueFromPipelineByPropertyName)]
    [switch]
    $RequireCommentsForNonTeamMembersOnly,

    # Anonymous users can access the status badge API for all pipelines unless this option is enabled.
    [Parameter(ValueFromPipelineByPropertyName)]
    [switch]
    $StatusBadgesArePrivate
  )

begin {
  Write-Verbose "Starting function: Set-AzDOProjectSetting"
}

  process {

    $body = @{
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
      uri         = "$CollectionUri/$ProjectName/_apis/build/generalsettings?api-version=7.2-preview.1"
      Method      = 'PATCH'
      Headers     = $script:header
      body        = $body
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
      Write-Verbose "Calling Invoke-AzDoRestMethod with $($params| ConvertTo-Json -Depth 10)"
    }
  }
}
