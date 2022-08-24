function Get-AzDoRepo {
    <#
.SYNOPSIS
    Get information about a repo in Azure DevOps.
.DESCRIPTION
    Get information about 1 repo if the parameter $Name is filled in. Otherwise it will get all the repo's.
.EXAMPLE
    $Params = @{
        CollectionUri = "https://dev.azure.com/contoso"
        PAT = "***"
        ProjectName = "Project 1"
        Name "Repo 1"
    }
    Get-AzDoRepo -CollectionUri = "https://dev.azure.com/contoso" -PAT = "***" -ProjectName = "Project 1" -Name "Repo 1"

    This example will fetch information about the repo with the name 'Repo 1'.
.OUTPUTS
    PSObject with repo(s).
.NOTES
#>
    [CmdletBinding()]
    param (
        # Collection Uri of the organization
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
            uri         = $Uri
            Method      = 'GET'
            Headers     = @{Authorization = 'Basic ' + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$($PAT)")) }
            ContentType = 'application/json'
        }

        Invoke-RestMethod @params
    }
}