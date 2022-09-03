function New-AzDoEnv {
    <#
.SYNOPSIS

.DESCRIPTION

.EXAMPLE

.OUTPUTS

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
    Process {
        $newAzDoRepoCloneSplat = @{
            SourceOrganizationName      = $SourceOrganizationName
            SourcePAT                   = $SourcePAT
            SourceRepoName              = $SourceRepoName
            SourceProjectName           = $SourceProjectName
            DestinationOrganizationName = $DestinationOrganizationName
            DestinationPAT              = $DestinationPAT
            DestinationRepoName         = $DestinationRepoName
            DestinationProjectName      = $DestinationProjectName
            NewRepo                     = $true
        }

        New-AzDoRepoClone @newAzDoRepoCloneSplat

    }
}