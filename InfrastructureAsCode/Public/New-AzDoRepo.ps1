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
        ProjectId     = "00000-00000-00000-00000-00000"
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

        # PAT to authentice with the organization
        [Parameter(Mandatory)]
        [string]
        $PAT,

        # Project where the variable group has to be created
        [Parameter(Mandatory)]
        [string]
        $Name,

        # Project where the variable group has to be created
        [Parameter(Mandatory)]
        [string]
        $ProjectId
    )

    $Body = @{
        name    = $Name
        project = @{
            id = $ProjectId
        }
    }

    $params = @{
        uri         = "$CollectionUri/$OrganizationName/$ProjectId/_apis/git/repositories?api-version=7.1-preview.1"
        Method      = 'POST'
        Headers     = @{Authorization = 'Basic ' + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$($PAT)")) }
        body        = $Body | ConvertTo-Json -Depth 99
        ContentType = 'application/json'
    }

    if ($PSCmdlet.ShouldProcess($CollectionUri)) {
        Invoke-RestMethod @params
    }
    else {
        Write-Output $Body | format-list
        return
    }
}