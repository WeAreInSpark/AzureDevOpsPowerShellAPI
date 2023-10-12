function New-AzDoRepo {
    <#
.SYNOPSIS
    Creates a repo in Azure DevOps.
.DESCRIPTION
    Creates a repo in Azure DevOps.
.EXAMPLE
    $params = @{
        CollectionUri = "https://dev.azure.com/contoso"
        PAT           = "***"
        Name          = "Repo 1"
        ProjectName   = "RandomProject"
    }
    New-AzDoRepo @params

    This example creates a new Azure DevOps repo
.OUTPUTS
    PSObject
    Containg the repo information
.NOTES
#>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param (
        # Collection Uri of the organization
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]
        $CollectionUri,

        # PAT to authenticate with the organization
        [Parameter()]
        [string]
        $PAT = $env:SYSTEM_ACCESSTOKEN,

        # Name of the new repository
        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ValueFromPipeline)]
        [string[]]
        [ValidateScript(
            {
                # Length
                if (($_).Length -gt 63) {
                    throw "The project name cannot be longer than 63 characters"
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
                    throw "The project name cannot be one of the following values: $forbiddenNames"
                }

                # - Must not be one of the hidden segments used for IIS request filtering like App_Browsers, App_code, App_Data, App_GlobalResources, App_LocalResources, App_Themes, App_WebResources, bin, or web.config.
                if ($_ -match "App_Browsers|App_code|App_Data|App_GlobalResources|App_LocalResources|App_Themes|App_WebResources|bin|web.config") {
                    throw "The project name cannot be one of the following values: App_Browsers, App_code, App_Data, App_GlobalResources, App_LocalResources, App_Themes, App_WebResources, bin, or web.config"
                }

                # - Must not contain any Unicode control characters or surrogate characters.
                if ($_ -match "[\p{C}\p{Cs}]") {
                    throw "The project name cannot contain any Unicode control characters or surrogate characters"
                }
                # - Must not contain the following printable characters: \ / : * ? " < > | ; # $ * { } , + = [ ].
                if ($_ -match "[\\/:*?`"<>|;#$*{},+=\[\]]") {
                    throw "The project name cannot contain the following printable characters: \ / : * ? `"< > | ; # $ * { } , + = [ ]"
                }
                # - Must not start with an underscore _.
                if ($_ -match "^_") {
                    throw "The project name cannot start with an underscore _"
                }
                # - Must not start or end with a period ..
                if ($_ -match "^\." -or $_ -match "\.$") {
                    throw "The project name cannot start or end with a period ."
                }
                $true
            }
        )]
        $RepoName,

        # Switch to use PAT instead of OAuth
        [Parameter()]
        [switch]
        $UsePAT = $false,

        # Name of the project where the new repository has to be created
        [Parameter(Mandatory)]
        [string]
        $ProjectName
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
        }

        if ($PAT) {
            $getAzDoProjectSplat += @{
                PAT    = $PAT
                UsePAT = $true
            }
        }

        $Projects = Get-AzDoProject @getAzDoProjectSplat
        $ProjectId = ($Projects | Where-Object ProjectName -EQ $ProjectName).Projectid


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
    }
    process {
        foreach ($name in $RepoName) {
            try {
                if ($name -in $repos.RepoName) {
                    Write-Error -Message "The repo name '$name' already exists in the project '$ProjectName'."
                    throw
                }
            } catch {
                continue
                $PSCmdlet.ThrowTerminatingError($_)
            }

            if ($name -like " *" -or $name -like "* *" -or $name -like "* ") {
                Write-Warning -Message "The repo name '$name' contains spaces. It is strongly advised against to do so in Azure DevOps and git repositories. Please consider renaming the repo." -WarningAction Inquire
            }

            $Body = @{
                name    = $name
                project = @{
                    id = $ProjectId
                }
            }

            $params = @{
                uri         = "$CollectionUri/$ProjectId/_apis/git/repositories?api-version=7.1-preview.1"
                Method      = 'POST'
                Headers     = $Header
                body        = $Body | ConvertTo-Json -Depth 99
                ContentType = 'application/json'
            }

            if ($PSCmdlet.ShouldProcess($ProjectName, "Create repo named: $($PSStyle.Bold)$name$($PSStyle.Reset)")) {
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
}
