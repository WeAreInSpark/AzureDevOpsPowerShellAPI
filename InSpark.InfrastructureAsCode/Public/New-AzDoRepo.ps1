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
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]
        $CollectionUri,

        # PAT to authenticate with the organization
        [Parameter()]
        [string]
        $PAT = $env:SYSTEM_ACCESSTOKEN,

        # Name of the new repository
        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ValueFromPipeline)]
        [string]
        $RepoName,

        # Name of the project where the new repository has to be created
        [Parameter(Mandatory)]
        [string]
        $ProjectName
    )
    process {
        $Projects = Get-AzDoProject -CollectionUri $CollectionUri -PAT $PAT
        $ProjectId = ($Projects | Where-Object ProjectName -EQ $ProjectName).ProjectId

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
