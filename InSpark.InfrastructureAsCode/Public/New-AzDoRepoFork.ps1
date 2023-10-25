
function New-AzDoRepoFork {
    <#
    .SYNOPSIS
        This script creates a fork of a repo in a project to a given project.
    .DESCRIPTION
        This script creates a fork of a repo in a project to a given project.
        The fork can be based on a specific branch or fork the entire repo (with all branches).

        When used in a pipeline, you can use the pre defined CollectionUri, TeamProject and AccessToken (PAT) variables.
    .EXAMPLE
        This example forks a repo from one project to another and forks a single branch ('main'), the forked repo is called 'ForkedRepo'.
        $newAzDoRepoForkSplat = @{
            CollectionUri    = 'https://dev.azure.com/contoso'
            ProjectId        = "15bca695-6260-498a-8b4c-38e53097906c"
            SourceProjectId  = "15bca695-6260-498a-8b4c-38e53097906c"
            SourceRepo       = 'b050b2de-2d6c-4357-8a03-3c14c1ccb3f5'
            CopyBranch       = $true
            ForkName         = 'ForkedRepo'
            ToBeForkedBranch = 'main'
        }

        New-AzDoRepoFork @newAzDoRepoForkSplat
    .INPUTS
        New-AzDoRepoFork [-CollectionUri] <String> [[-PAT] <String>] [-ProjectId] <String> [-ForkName] <String> [-SourceProjectId] <String> [-SourceRepo] <String> [[-CopyBranch] <Boolean>] [[-ToBeForkedBranch] <String>] [<CommonParameters>]
    .OUTPUTS
        PSCustomObject
#>
    [CmdletBinding(SupportsShouldProcess)]
    param (
        # Collection Uri of the organization
        [Parameter(Mandatory)]
        [string]
        $CollectionUri,

        # PAT to authenticate with the organization
        [Parameter()]
        [String]
        $PAT = $env:SYSTEM_ACCESSTOKEN,

        # Switch to use PAT instead of OAuth
        [Parameter()]
        [switch]
        $UsePAT = $false,

        # Project where the fork has to be created
        [Parameter(Mandatory)]
        [string]
        $ProjectName,

        # Name of the forked repo
        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ValueFromPipeline)]
        [string]
        [ValidateScript(
            {
                # Length
                if (($_).Length -gt 63) {
                    throw "The forked repo name cannot be longer than 63 characters"
                }

                # - Must not be a system reserved name.
                $forbiddenNames = @(
                    'COM1',
                    'COM2',
                    'COM3',
                    'COM4',
                    'COM5',
                    'COM6',
                    'COM7',
                    'COM8',
                    'COM9',
                    'COM10',
                    'CON',
                    'DefaultCollection',
                    'LPT1',
                    'LPT2',
                    'LPT3',
                    'LPT4',
                    'LPT5',
                    'LPT6',
                    'LPT7',
                    'LPT8',
                    'LPT9',
                    'NUL',
                    'PRN',
                    'SERVER',
                    'SignalR',
                    'Web',
                    'WEB')
                if ($forbiddenNames -contains $_) {
                    throw "The forked repo name cannot be one of the following values: $forbiddenNames"
                }

                # - Must not be one of the hidden segments used for IIS request filtering like App_Browsers, App_code, App_Data, App_GlobalResources, App_LocalResources, App_Themes, App_WebResources, bin, or web.config.
                if ($_ -match "App_Browsers|App_code|App_Data|App_GlobalResources|App_LocalResources|App_Themes|App_WebResources|bin|web.config") {
                    throw "The forked repo name cannot be one of the following values: App_Browsers, App_code, App_Data, App_GlobalResources, App_LocalResources, App_Themes, App_WebResources, bin, or web.config"
                }

                # - Must not contain any Unicode control characters or surrogate characters.
                if ($_ -match "[\p{C}\p{Cs}]") {
                    throw "The forked repo name cannot contain any Unicode control characters or surrogate characters"
                }
                # - Must not contain the following printable characters: \ / : * ? " < > | ; # $ * { } , + = [ ].
                if ($_ -match "[\\/:*?`"<>|;#$*{},+=\[\]]") {
                    throw "The forked repo name cannot contain the following printable characters: \ / : * ? `"< > | ; # $ * { } , + = [ ]"
                }
                # - Must not start with an underscore _.
                if ($_ -match "^_") {
                    throw "The forked repo name cannot start with an underscore _"
                }
                # - Must not start or end with a period ..
                if ($_ -match "^\." -or $_ -match "\.$") {
                    throw "The forked repo name cannot start or end with a period ."
                }
                $true
            }
        )]
        $ForkName,

        # Azure DevOps Project-name where the fork has to be forked from
        [Parameter(Mandatory)]
        [string]
        $SourceProjectName,

        # Azure DevOps Repository-Name which should be forked
        [Parameter(Mandatory)]
        [string]
        $SourceRepoName,

        # If set to $true, a single branch specified in the ToBeForkedBranch-variable will be forked. If false will clone the repo with all branches
        [Parameter()]
        [bool]
        $CopyBranch = $false,

        # Project where the variable group has to be created
        [Parameter()]
        [string]
        $ToBeForkedBranch = 'main'
    )
    begin {
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
        }

        if ($PAT) {
            $getAzDoProjectSplat += @{
                PAT    = $PAT
                UsePAT = $true
            }
        }

        $Projects = Get-AzDoProject @getAzDoProjectSplat
    }

    process {
        $getAzDoRepoSplat = @{
            CollectionUri = $CollectionUri
            ProjectName   = $ProjectName
        }

        if ($PAT) {
            $getAzDoRepoSplat += @{
                PAT    = $PAT
                UsePAT = $true
            }
        }

        $repos = Get-AzDoRepo @getAzDoRepoSplat
        $ProjectId = ($Projects | Where-Object ProjectName -EQ $ProjectName).Projectid
        $SourceProjectId = ($Projects | Where-Object ProjectName -EQ $SourceProjectName).Projectid
        $SourceRepoId = ($repos | Where-Object RepoName -EQ $SourceRepoName).RepoId

        try {
            if ($ForkName -in $repos.RepoName) {
                Write-Error -Message "The repo name '$ForkName' already exists in the project '$ProjectName'."
                throw
            }
        } catch {
            continue
            $PSCmdlet.ThrowTerminatingError($_)
        }

        if ($ForkName -like " *" -or $ForkName -like "* *" -or $ForkName -like "* ") {
            Write-Warning -Message "The repo name '$name' contains spaces. It is strongly advised against to do so in Azure DevOps and git repositories. Please consider renaming the repo." -WarningAction Inquire
        }


        if ($CopyBranch) {
            $sourceRef = "sourceRef=refs/heads/$ToBeForkedBranch&"
        }

        $body = @{
            name             = $ForkName
            project          = @{
                id = $ProjectId
            }
            parentRepository = @{
                id      = $SourceRepoId
                project = @{
                    id = $SourceProjectId
                }
            }
        }

        $params = @{
            uri         = "$CollectionUri/$OrganizationName/$ProjectId/_apis/git/repositories?${sourceRef}api-version=7.1-preview.1"
            Method      = 'POST'
            Headers     = $Header
            body        = $Body | ConvertTo-Json -Depth 99
            ContentType = 'application/json'
        }
        if ($PSCmdlet.ShouldProcess($ProjectName, "Forking repo $($PSStyle.Bold)$SourceRepo$($PSStyle.Reset) named: $($PSStyle.Bold)$ForkName$($PSStyle.Reset) based on the branch $($PSStyle.Bold)$ToBeForkedBranch$($PSStyle.Reset)")) {
            Invoke-RestMethod @params | ForEach-Object {
                [PSCustomObject]@{
                    RepoName      = $_.name
                    RepoId        = $_.id
                    RepoURL       = $_.url
                    ProjectName   = $ProjectName
                    WebUrl        = $_.webUrl
                    HttpsUrl      = $_.remoteUrl
                    SshUrl        = $_.sshUrl
                    CollectionURI = $CollectionUri
                }
            }
        } else {
            $Body | Format-List
            return
        }
    }
}
