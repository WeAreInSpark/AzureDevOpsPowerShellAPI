function New-AzDoRepoMirror {
    <#
.SYNOPSIS
    This script creates a variable group with at least 1 variable in a given project.
.DESCRIPTION
    This script creates a variable group with at least 1 variable in a given project. When used in a pipeline, you can use the pre defined CollectionUri,
    ProjectName and AccessToken (PAT) variables.
.EXAMPLE
    To create a variable group 'test' with one variable:
    New-AzDoVariableGroup -collectionuri 'https://dev.azure.com/weareinspark/' -PAT '*******************' -ProjectName 'BusinessReadyCloud'
    -Name 'test' -Variables @{ test = @{ value = 'test' } } -Description 'This is a test'
.INPUTS
    New-AzDoVariableGroup [-CollectionUri] <string> [-PAT] <string> [-ProjectName] <string> [-Name] <string> [-Variables] <hashtable> [[-Description] <string>]
    [<CommonParameters>]
.OUTPUTS
    New variable group with at least 1 variable in a given project.
.NOTES
#>
    [CmdletBinding()]
    param (
        # Collection Uri of the organization
        [Parameter(Mandatory)]
        [string]
        $SourceOrganizationName,

        # PAT to authentice with the organization
        [Parameter()]
        [string]
        $SourcePAT = $env:SYSTEM_ACCESSTOKEN,

        # Project where the variable group has to be created
        [Parameter(Mandatory)]
        [string]
        $SourceRepoName,

        # Project where the variable group has to be created
        [Parameter(Mandatory)]
        [string]
        $SourceProjectName,

        # Collection Uri of the organization
        [Parameter(Mandatory)]
        [string]
        $DestinationOrganizationName,

        # PAT to authentice with the organization
        [Parameter(Mandatory)]
        [string]
        $DestinationPAT,

        # Project where the variable group has to be created
        [Parameter(Mandatory)]
        [string]
        $DestinationRepoName,

        # Project where the variable group has to be created
        [Parameter(Mandatory)]
        [string]
        $DestinationProjectName
    )

    git clone --mirror "https://$SourcePAT@dev.azure.com/$SourceOrganizationName/$SourceProjectName/_git/$SourceRepoName"
    Set-Location "$SourceRepoName.git"

    if ($Env:OS -match "Windows") {
        git show-ref | Where-Object { $_ -match 'pull' } | ForEach-Object {
            git update-ref -d $_.split(' ')[1]
        }
    }
    else {
        git show-ref | cut -d' ' -f2 | grep 'pull' | xargs -r -L1 git update-ref -d
    }

    git push --mirror "https://$DestinationPAT@dev.azure.com/$DestinationOrganizationName/$DestinationProjectName/_git/$DestinationRepoName"
}