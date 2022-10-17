function New-AzDoRepoClone {
    <#
.SYNOPSIS
    Clones the main branch to a new location
.DESCRIPTION
    Clones the main branch to a new location
.EXAMPLE
    $params = @{
        SourceOrganizationName      = "contoso"
        SourceProjectName           = "project1"
        SourcePAT                   = "***"
        SourceRepoName              = "repo1"
        DestinationOrganizationName = "New Contoso"
        DestinationProjectName      = "Project1"
        DestinationPAT              = "***"
        DestinationRepoName         = "repo1"
    }
    New-AzDoRepoClone @params

    This example Clones the main branch to another organization with the same project and repo name.
.OUTPUTS
    PSobject
.NOTES
#>
    [CmdletBinding(SupportsShouldProcess)]
    param (
        # Collection Uri of the organization
        [Parameter(Mandatory)]
        [string]
        $SourceOrganizationName,

        # Project where the variable group has to be created
        [Parameter(Mandatory)]
        [string]
        $SourceProjectName,

        # Project where the variable group has to be created
        [Parameter(Mandatory)]
        [string]
        $SourceRepoName,

        # PAT to authenticate with the organization
        [Parameter()]
        [string]
        $SourcePAT = $env:SYSTEM_ACCESSTOKEN,

        # Collection Uri of the organization
        [Parameter(Mandatory)]
        [string]
        $DestinationOrganizationName,

        # Project where the variable group has to be created
        [Parameter(Mandatory)]
        [string]
        $DestinationProjectName,

        # Project where the variable group has to be created
        [Parameter(Mandatory)]
        [string]
        $DestinationRepoName,

        # PAT to authenticate with the organization
        [Parameter(Mandatory)]
        [string]
        $DestinationPAT,

        # Switch to enable mirroring the repo
        [Parameter()]
        [switch]
        $Mirror,

        # Switch to create a new repo
        [Parameter()]
        [switch]
        $NewRepo
    )
    if ($PSCmdlet.ShouldProcess($DestinationOrganizationName)) {
        if ($NewRepo) {
            $newAzDoRepoSplat = @{
                CollectionUri = "https://dev.azure.com/$DestinationOrganizationName"
                PAT           = $DestinationPAT
                RepoName      = $DestinationRepoName
                ProjectName   = $DestinationProjectName
            }
            New-AzDoRepo @newAzDoRepoSplat | Out-Null
        }

        if ($mirror) {
            git clone --mirror=$Mirror "https://$SourcePAT@dev.azure.com/$SourceOrganizationName/$SourceProjectName/_git/$SourceRepoName"

            if ($Env:OS -match "Windows") {
                git show-ref | Where-Object { $_ -match 'pull' } | ForEach-Object {
                    git update-ref -d $_.split(' ')[1]
                }
            } else {
                git show-ref | cut -d' ' -f2 | grep 'pull' | xargs -r -L1 git update-ref -d
            }

            git push --mirror "https://$DestinationPAT@dev.azure.com/$DestinationOrganizationName/$DestinationProjectName/_git/$DestinationRepoName"
        } else {
            $TempFile = New-TemporaryFile

            git clone "https://$SourcePAT@dev.azure.com/$SourceOrganizationName/$SourceProjectName/_git/$SourceRepoName" --branch main
            Set-Location $SourceRepoName
            git push "https://$DestinationPAT@dev.azure.com/$DestinationOrganizationName/$DestinationProjectName/_git/$DestinationRepoName"

            Remove-Item -Recurse -Force $TempFile
        }

        $getAzDoRepoSplat = @{
            CollectionUri = "https://dev.azure.com/$DestinationOrganizationName"
            RepoName      = $DestinationRepoName
            ProjectName   = $DestinationProjectName
            PAT           = $DestinationPAT
        }
        Get-AzDoRepo @getAzDoRepoSplat
    }
}
