function Get-AzDoRepo {
    <#
.SYNOPSIS
<<<<<<< HEAD
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
=======
    Get information about a repo in Azure DevOps.
.DESCRIPTION
    Get information about 1 repo if the parameter $Name is filled in. Otherwise it will get all the repo's.
>>>>>>> 18d4dd8 (InitialVersion)
.EXAMPLE
    $Params = @{
        CollectionUri = "https://dev.azure.com/contoso"
        PAT = "***"
        ProjectName = "Project 1"
        Name "Repo 1"
    }
    Get-AzDoRepo -CollectionUri = "https://dev.azure.com/contoso" -PAT = "***" -ProjectName = "Project 1" -Name "Repo 1"

    This example will fetch information about the repo with the name 'Repo 1'.
<<<<<<< HEAD
.EXAMPLE
    $Params = @{
        CollectionUri = "https://dev.azure.com/contoso"
        PAT = "***"
        Name "Repo 1"
    }
    get-AzDoProject -pat $pat -CollectionUri $collectionuri | Get-AzDoRepo -PAT $PAT

    This example will fetch information about the repo with the name 'Repo 1'.
=======
>>>>>>> 18d4dd8 (InitialVersion)
.OUTPUTS
    PSObject with repo(s).
.NOTES
#>
    [CmdletBinding()]
    param (
        # Collection Uri of the organization
<<<<<<< HEAD
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
        $RepoName,

        # Project where the Repos are contained
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]
        $ProjectName
    )
    Process {
        if ($RepoName) {
            $uri = "$CollectionUri/$ProjectName/_apis/git/repositories/$($RepoName)?api-version=7.1-preview.1"
        } else {
            $uri = "$CollectionUri/$ProjectName/_apis/git/repositories?api-version=7.1-preview.1"
        }

        $params = @{
            uri         = $uri
            Method      = 'GET'
            Headers     = @{Authorization = 'Basic ' + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$($PAT)")) }
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
=======
        [Parameter(Mandatory)]
        [string]
        $CollectionUri,

        # PAT to authentice with the organization
        [Parameter(Mandatory = $false)]
        [string]
        $PAT = $env:SYSTEM_ACCESSTOKEN,

        # Project where the variable group has to be created
        [Parameter(Mandatory = $false)]
        [string]
        $Name,

        # Project where the variable group has to be created
        [Parameter(Mandatory)]
        [string]
        $ProjectName
    )
    Begin {
        if ($Name) {
            $Uri = "$CollectionUri/$ProjectName/_apis/git/repositories/$($Name)?api-version=7.1-preview.1"
        } else {
            $Uri = "$CollectionUri/$ProjectName/_apis/git/repositories?api-version=7.1-preview.1"
        }
    }
    Process {
        $params = @{
            uri     = $Uri
            Method  = 'GET'
            Headers = @{Authorization = 'Basic ' + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$($PAT)")) }
        }

        Invoke-RestMethod @params
    }
}
>>>>>>> 18d4dd8 (InitialVersion)
