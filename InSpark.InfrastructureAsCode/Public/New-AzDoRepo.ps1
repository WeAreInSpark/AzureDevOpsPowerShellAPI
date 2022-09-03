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
    [CmdletBinding(SupportsShouldProcess)]
    param (
        # Collection Uri of the organization
<<<<<<< HEAD
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
=======
        [Parameter(Mandatory)]
>>>>>>> 18d4dd8 (InitialVersion)
        [string]
        $CollectionUri,

        # PAT to authenticate with the organization
<<<<<<< HEAD
        [Parameter()]
=======
        [Parameter(Mandatory = $false)]
>>>>>>> 18d4dd8 (InitialVersion)
        [string]
        $PAT = $env:SYSTEM_ACCESSTOKEN,

        # Name of the new repository
<<<<<<< HEAD
        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ValueFromPipeline)]
        [string]
        $RepoName,
=======
        [Parameter(Mandatory)]
        [string]
        $Name,
>>>>>>> 18d4dd8 (InitialVersion)

        # Name of the project where the new repository has to be created
        [Parameter(Mandatory)]
        [string]
        $ProjectName
    )
<<<<<<< HEAD
    process {
        $Projects = Get-AzDoProject -CollectionUri $CollectionUri -PAT $PAT
        $ProjectId = ($Projects | Where-Object ProjectName -EQ $ProjectName).Projectid

        $Body = @{
            name    = $RepoName
            project = @{
                id = $ProjectId
            }
        }

        $params = @{
            uri         = "$CollectionUri/$ProjectId/_apis/git/repositories?api-version=7.1-preview.1"
            Method      = 'POST'
            Headers     = @{Authorization = 'Basic ' + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$($PAT)")) }
            body        = $Body | ConvertTo-Json -Depth 99
            ContentType = 'application/json'
        }

        if ($PSCmdlet.ShouldProcess($CollectionUri)) {
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
=======

    $params = @{
        uri         = "$CollectionUri/_apis/projects?api-version=6.0"
        Method      = 'GET'
        Headers     = @{Authorization = 'Basic ' + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$($PAT)")) }
        ContentType = 'application/json'
    }

    $Projects = Invoke-RestMethod @params
    $ProjectId = ($Projects.value | Where-Object name -EQ $ProjectName).id

    $Body = @{
        name    = $Name
        project = @{
            id = $ProjectId
        }
    }

    $params = @{
        uri         = "$CollectionUri/$ProjectId/_apis/git/repositories?api-version=7.1-preview.1"
        Method      = 'POST'
        Headers     = @{Authorization = 'Basic ' + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$($PAT)")) }
        body        = $Body | ConvertTo-Json -Depth 99
        ContentType = 'application/json'
    }

    if ($PSCmdlet.ShouldProcess($CollectionUri)) {
        Invoke-RestMethod @params
    } else {
        Write-Output $Body | Format-List
        return
    }
}
>>>>>>> 18d4dd8 (InitialVersion)
