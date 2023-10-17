function Get-BranchPolicyType {
    <#
.SYNOPSIS
    Creates an Azure Pipeline
.DESCRIPTION
    Creates an Azure Pipeline in a given Azure Project based on a repo
.EXAMPLE
    $newAzDoPipelineSplat = @{
        CollectionUri = "https://dev.azure.com/contoso"
        PAT = "***"
        PipelineName = "Pipeline 1"
        RepoName = "Repo 1"
        ProjectName = "Project 1"
    }
    New-AzDoBranchPolicy @newAzDoPipelineSplat

    This example creates a new Azure Pipeline using the PowerShell pipeline

.EXAMPLE
    Get-AzDoProject -CollectionUri "https://dev.azure.com/contoso" -PAT $PAT |
        Get-AzDoRepo -RepoName 'Repo 1' -PAT $PAT |
            New-AzDoBranchPolicy -PipelineName "Pipeline 1" -PAT $PAT

    This example creates a new Azure Pipeline

.OUTPUTS
    PSobject. An object containing the name, the folder and the URI of the pipeline
.NOTES
#>
    [CmdletBinding(SupportsShouldProcess)]
    param (
        # Collection Uri of the organization
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]
        $CollectionUri,

        # Project where the pipeline will be created.
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]
        $ProjectName,

        # Project where the pipeline will be created.
        [Parameter(Mandatory)]
        [validateset(
            "Path Length restriction",
            "Reserved names restriction",
            "Require a merge strategy",
            "Comment requirements",
            "Status",
            "Git repository settings",
            "Build",
            "File size restriction",
            "File name restriction",
            "Commit author email validation",
            "Required reviewers",
            "Minimum number of reviewers",
            "Work item linking",
            "GitRepositorySettingsPolicyName"
        )]
        [string]
        $PolicyType,

        # PAT to authentice with the organization
        [Parameter()]
        [string]
        $PAT = $env:SYSTEM_ACCESSTOKEN

    )
    Process {

        $params = @{
            uri         = "$CollectionUri/$ProjectName/_apis/policy/types?api-version=7.2-preview.1"
            Method      = 'GET'
            Headers     = @{Authorization = 'Basic ' + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$($PAT)")) }
            ContentType = 'application/json'
        }

        if ($PSCmdlet.ShouldProcess($CollectionUri)) {
            try {
                $response = Invoke-RestMethod @params -ErrorAction Stop
            } catch {
                throw "No response from Azure DevOps"
            }

            ($response.value | Where-Object { $_.displayName -eq $PolicyType }).id
        }
    }
}


