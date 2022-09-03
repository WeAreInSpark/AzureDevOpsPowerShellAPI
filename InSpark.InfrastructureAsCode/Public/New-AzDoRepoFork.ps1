
function New-AzDoRepoFork {
    <#
    .SYNOPSIS
        This script creates a fork of a repo in a project to a given project.
    .DESCRIPTION
        This script creates a fork of a repo in a project to a given project.
        The fork can be based on a specific branch or fork the entire repo (with all branches).

        When used in a pipeline, you can use the pre defined CollectionUri, TeamProject and AccessToken (PAT) variables.
    .EXAMPLE
        This example forks a repo from one project to another and forks a single branch ('main'), the forked repo is called 'ForkedRepo'.
        $newAzDoRepoForkSplat = @{
<<<<<<< HEAD
<<<<<<< HEAD:InSpark.InfrastructureAsCode/Public/New-AzDoRepoFork.ps1
            CollectionUri    = 'https://dev.azure.com/contoso'
=======
            CollectionUri    = 'https://dev.azure.com/ChristianPiet0452'
>>>>>>> 690e7a4 (Working version):InfrastructureAsCode/Public/New-AzDoRepoFork.ps1
=======
            CollectionUri    = 'https://dev.azure.com/contoso'
>>>>>>> 18d4dd8 (InitialVersion)
            ProjectId        = "15bca695-6260-498a-8b4c-38e53097906c"
            SourceProjectId  = "15bca695-6260-498a-8b4c-38e53097906c"
            SourceRepo       = 'b050b2de-2d6c-4357-8a03-3c14c1ccb3f5'
            CopyBranch       = $true
            ForkName         = 'ForkedRepo'
            ToBeForkedBranch = 'main'
        }

        New-AzDoRepoFork @newAzDoRepoForkSplat
    .INPUTS
        New-AzDoRepoFork [-CollectionUri] <String> [[-PAT] <String>] [-ProjectId] <String> [-ForkName] <String> [-SourceProjectId] <String> [-SourceRepo] <String> [[-CopyBranch] <Boolean>] [[-ToBeForkedBranch] <String>] [<CommonParameters>]
    .OUTPUTS
        PSCustomObject
#>
<<<<<<< HEAD
<<<<<<< HEAD:InSpark.InfrastructureAsCode/Public/New-AzDoRepoFork.ps1
    [CmdletBinding(SupportsShouldProcess)]
=======
    [CmdletBinding()]
>>>>>>> 690e7a4 (Working version):InfrastructureAsCode/Public/New-AzDoRepoFork.ps1
=======
    [CmdletBinding(SupportsShouldProcess)]
>>>>>>> 18d4dd8 (InitialVersion)
    param (
        # Collection Uri of the organization
        [Parameter(Mandatory)]
        [string]
        $CollectionUri,

        # PAT to authenticate with the organization
<<<<<<< HEAD
<<<<<<< HEAD:InSpark.InfrastructureAsCode/Public/New-AzDoRepoFork.ps1
        [Parameter(Mandatory = $false)]
        [String]
        $PAT = $env:SYSTEM_ACCESSTOKEN,
=======
        [Parameter()]
        [String]
        $PAT = (Read-Host -MaskInput -Prompt 'Azure DevOps PAT: '),
>>>>>>> 690e7a4 (Working version):InfrastructureAsCode/Public/New-AzDoRepoFork.ps1
=======
        [Parameter(Mandatory = $false)]
        [String]
        $PAT = $env:SYSTEM_ACCESSTOKEN,
>>>>>>> 18d4dd8 (InitialVersion)

        # Project where the variable group has to be created
        [Parameter(Mandatory)]
        [string]
        $ProjectId,

        # Name of the forked repo
        [Parameter(Mandatory)]
        [string]
        $ForkName,

        # Azure DevOps Project-ID where the repo has to be forked from
        [Parameter(Mandatory)]
        [string]
        $SourceProjectId,

        # Azure DevOps Repository-ID which should be forked
        [Parameter(Mandatory)]
        [string]
        $SourceRepo,

        # If set to $true, a single branch specified in the ToBeForkedBranch-variable will be forked. If false will clone the repo with all branches
        [Parameter()]
        [bool]
        $CopyBranch = $false,

        # Project where the variable group has to be created
        [Parameter()]
        [string]
        $ToBeForkedBranch = 'main'
    )
    if ($CopyBranch) {
        $sourceRef = "sourceRef=refs/heads/$ToBeForkedBranch&"
    }

    $body = @{
        name             = $ForkName
        project          = @{
            id = $ProjectId
        }
        parentRepository = @{
            id      = $SourceRepo
            project = @{
                id = $SourceProjectId
            }
        }
    }

    $params = @{
        uri         = "$CollectionUri/$OrganizationName/$ProjectId/_apis/git/repositories?${sourceRef}api-version=7.1-preview.1"
        Method      = 'POST'
        Headers     = @{Authorization = 'Basic ' + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$($PAT)")) }
        body        = $Body | ConvertTo-Json -Depth 99
        ContentType = 'application/json'
    }
<<<<<<< HEAD
<<<<<<< HEAD:InSpark.InfrastructureAsCode/Public/New-AzDoRepoFork.ps1
<<<<<<< HEAD

=======
>>>>>>> 18d4dd8 (InitialVersion)
    if ($PSCmdlet.ShouldProcess($CollectionUri)) {
        Invoke-RestMethod @params
    }
=======

    Invoke-RestMethod @params
>>>>>>> 690e7a4 (Working version):InfrastructureAsCode/Public/New-AzDoRepoFork.ps1
=======
    if ($PSCmdlet.ShouldProcess($CollectionUri)) {
        Invoke-RestMethod @params
    }
>>>>>>> 18d4dd8 (InitialVersion)
}
