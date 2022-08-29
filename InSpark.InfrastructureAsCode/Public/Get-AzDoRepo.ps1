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

        # Name of the Repo to get information about
        [Parameter(ParameterSetName = 'Get')]
        [string]
        $Name,

        # Project where the Repos are contained
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]
        $ProjectName
    )
    Process {
        if ($Name) {
            $uri = "$CollectionUri/$ProjectName/_apis/git/repositories/$($Name)?api-version=7.1-preview.1"
        } else {
            $uri = "$CollectionUri/$ProjectName/_apis/git/repositories?api-version=7.1-preview.1"
        }

        $params = @{
            uri         = $uri
            Method      = 'GET'
            Headers     = @{Authorization = 'Basic ' + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$($PAT)")) }
            ContentType = 'application/json'
        }

        if ($name) {
        (Invoke-RestMethod @params) | ForEach-Object {
                [PSCustomObject]@{
                    RepoName      = $_.name
                    RepoID        = $_.id
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
                    RepoID        = $_.id
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

Get-AzDoProject -PAT $PAT -CollectionUri $collectionURI -ProjectName DitProject | Get-AzDoRepo -PAT $PAT
