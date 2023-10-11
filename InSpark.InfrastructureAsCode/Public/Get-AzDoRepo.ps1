function Get-AzDoRepo {
    <#
.SYNOPSIS
    Gets information about a repo in Azure DevOps.
.DESCRIPTION
    Gets information about 1 repo if the parameter $Name is filled in. Otherwise it will list all the repo's.
.EXAMPLE
    $Params = @{
        CollectionUri = "https://dev.azure.com/contoso"
        PAT = "***"
        ProjectName = "Project 1"
        Name "Repo 1"
    }
    Get-AzDoRepo -CollectionUri = "https://dev.azure.com/contoso" -PAT = "***" -ProjectName = "Project 1"

    This example will list all the repo's contained in 'Project 1'.
.EXAMPLE
    $Params = @{
        CollectionUri = "https://dev.azure.com/contoso"
        PAT = "***"
        ProjectName = "Project 1"
        Name "Repo 1"
    }
    Get-AzDoRepo -CollectionUri = "https://dev.azure.com/contoso" -PAT = "***" -ProjectName = "Project 1" -Name "Repo 1"

    This example will fetch information about the repo with the name 'Repo 1'.
.EXAMPLE
    $Params = @{
        CollectionUri = "https://dev.azure.com/contoso"
        PAT = "***"
        Name "Repo 1"
    }
    get-AzDoProject -pat $pat -CollectionUri $collectionuri | Get-AzDoRepo -PAT $PAT

    This example will fetch information about the repo with the name 'Repo 1'.
.OUTPUTS
    PSObject with repo(s).
.NOTES
#>
    [CmdletBinding()]
    param (
        # Collection Uri of the organization
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]
        $CollectionUri,

        # PAT to authenticate with the organization
        [Parameter()]
        [string]
        $PAT = $env:SYSTEM_ACCESSTOKEN,

        # Switch to use PAT instead of OAuth
        [Parameter()]
        [switch]
        $UsePAT = $false,

        # Name of the Repo to get information about
        [Parameter()]
        [string]
        $RepoName,

        # Project where the Repos are contained
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
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
    }
    Process {
        if ($RepoName) {
            $uri = "$CollectionUri/$ProjectName/_apis/git/repositories/$($RepoName)?api-version=7.1-preview.1"
        } else {
            $uri = "$CollectionUri/$ProjectName/_apis/git/repositories?api-version=7.1-preview.1"
        }

        $params = @{
            uri         = $uri
            Method      = 'GET'
            Headers     = New-ADOAuthHeader
            ContentType = 'application/json'
        }

        if ($RepoName) {
        (Invoke-RestMethod @params) | ForEach-Object {
                [PSCustomObject]@{
                    RepoName      = $_.name
                    RepoId        = $_.id
                    RepoURL       = $_.url
                    ProjectName   = $ProjectName
                    DefaultBranch = $_.defaultBranch
                    WebUrl        = $_.webUrl
                    HttpsUrl      = $_.remoteUrl
                    SshUrl        = $_.sshUrl
                    CollectionURI = $CollectionUri
                    IsDisabled    = $_.IsDisabled
                }
            }
        } else {
            (Invoke-RestMethod @params).value | ForEach-Object {
                [PSCustomObject]@{
                    RepoName      = $_.name
                    RepoId        = $_.id
                    RepoURL       = $_.url
                    ProjectName   = $ProjectName
                    DefaultBranch = $_.defaultBranch
                    WebUrl        = $_.webUrl
                    HttpsUrl      = $_.remoteUrl
                    SshUrl        = $_.sshUrl
                    CollectionURI = $CollectionUri
                    IsDisabled    = $_.IsDisabled
                }
            }
        }
    }
}
