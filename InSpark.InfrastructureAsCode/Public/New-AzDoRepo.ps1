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
        [Parameter(Mandatory)]
        [string]
        $CollectionUri,

        # PAT to authenticate with the organization
        [Parameter(Mandatory = $false)]
        [string]
        $PAT = $env:SYSTEM_ACCESSTOKEN,

        # Name of the new repository
        [Parameter(Mandatory)]
        [string]
        $Name,

        # Name of the project where the new repository has to be created
        [Parameter(Mandatory)]
        [string]
        $ProjectName
    )

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