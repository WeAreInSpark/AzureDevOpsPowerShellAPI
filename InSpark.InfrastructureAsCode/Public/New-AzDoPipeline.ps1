function New-AzDoPipeline {
    <#
.SYNOPSIS
    Creates an Azure Pipeline
.DESCRIPTION
<<<<<<< HEAD
<<<<<<< HEAD
    Creates an Azure Pipeline in a given Azure Project based on a repo
=======
    Creates an Azure Pipeline
>>>>>>> 18d4dd8 (InitialVersion)
=======
    Creates an Azure Pipeline
>>>>>>> 18d4dd8 (InitialVersion)
.EXAMPLE
    $newAzDoPipelineSplat = @{
        CollectionUri = "https://dev.azure.com/contoso"
        PAT = "***"
<<<<<<< HEAD
<<<<<<< HEAD
        PipelineName = "Pipeline 1"
=======
        Name = "Pipeline 1"
>>>>>>> 18d4dd8 (InitialVersion)
=======
        Name = "Pipeline 1"
>>>>>>> 18d4dd8 (InitialVersion)
        RepoName = "Repo 1"
        ProjectName = "Project 1"
    }
    New-AzDoPipeline @newAzDoPipelineSplat

<<<<<<< HEAD
<<<<<<< HEAD
    This example creates a new Azure Pipeline using the PowerShell pipeline

.EXAMPLE
    Get-AzDoProject -CollectionUri "https://dev.azure.com/contoso" -PAT $PAT | 
        Get-AzDoRepo -RepoName 'Repo 1' -PAT $PAT |
            New-AzDoPipeline -PipelineName "Pipeline 1" -PAT $PAT

    This example creates a new Azure Pipeline

.OUTPUTS
    PSobject. An object containing the name, the folder and the URI of the pipeline
=======
    This example creates a new Azure Pipeline
.OUTPUTS
    PSobject containing Project information
>>>>>>> 18d4dd8 (InitialVersion)
=======
    This example creates a new Azure Pipeline
.OUTPUTS
    PSobject containing Project information
>>>>>>> 18d4dd8 (InitialVersion)
.NOTES
#>
    [CmdletBinding(SupportsShouldProcess)]
    param (
        # Collection Uri of the organization
<<<<<<< HEAD
<<<<<<< HEAD
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]
        $CollectionUri,

        # Project where the pipeline will be created.
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]
        $ProjectName,

        # PAT to authentice with the organization
        [Parameter()]
        [string]
        $PAT = $env:SYSTEM_ACCESSTOKEN,

        # Name of the Pipeline
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string[]]
        $PipelineName,

        # Name of the Repository containing the YAML-sourcecode
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        $RepoName,

        # Path of the YAML-sourcecode in the Repository
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]
        $Path = '/main.yaml'
    )
    Process {
        $RepoId = (Get-AzDoRepo -CollectionUri $CollectionUri -ProjectName $ProjectName -PAT $PAT -RepoName $RepoName).RepoId

        foreach ($Pipeline in $PipelineName) {
            $Body = @{
                name          = $Pipeline
                folder        = $null
                configuration = @{
                    type       = "yaml"
                    path       = $Path
=======
=======
>>>>>>> 18d4dd8 (InitialVersion)
        [Parameter(Mandatory)]
        [string]
        $CollectionUri,

        # PAT to authentice with the organization
        [Parameter(Mandatory = $false)]
        [string]
        $PAT = $env:SYSTEM_ACCESSTOKEN,

        # Project where the variable group has to be created
        [Parameter(Mandatory)]
        [string[]]
        $Name,

        # Project where the variable group has to be created
        [Parameter(Mandatory)]
        $RepoName,

        # Project where the variable group has to be created.
        [Parameter(Mandatory)]
        [string]
        $ProjectName
    )
    Begin {
        $RepoId = (Get-AzDoRepo -CollectionUri $CollectionUri -ProjectName $ProjectName -PAT $PAT -Name $RepoName).Id
    }
    Process {
        foreach ($n in $Name) {
            $Body = @{
                name          = $n
                folder        = $null
                configuration = @{
                    type       = "yaml"
                    path       = "/main.yaml"
<<<<<<< HEAD
>>>>>>> 18d4dd8 (InitialVersion)
=======
>>>>>>> 18d4dd8 (InitialVersion)
                    repository = @{
                        id   = $RepoId
                        type = "azureReposGit"
                    }
                }
            }

            $params = @{
                uri         = "$CollectionUri/$ProjectName/_apis/pipelines?api-version=7.1-preview.1"
                Method      = 'POST'
                Headers     = @{Authorization = 'Basic ' + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$($PAT)")) }
                body        = $Body | ConvertTo-Json -Depth 99
                ContentType = 'application/json'
            }
            if ($PSCmdlet.ShouldProcess($CollectionUri)) {
<<<<<<< HEAD
<<<<<<< HEAD
                Invoke-RestMethod @params | ForEach-Object {
                    [PSCustomObject]@{
                        PipelineName   = $_.name
                        PipelineFolder = $_.folder
                        PipelineUrl    = $_.url
                    }
                }
            } else {
                $Body | Format-List
=======
                Invoke-RestMethod @params
            } else {
                Write-Output $Body | Format-List
>>>>>>> 18d4dd8 (InitialVersion)
=======
                Invoke-RestMethod @params
            } else {
                Write-Output $Body | Format-List
>>>>>>> 18d4dd8 (InitialVersion)
                return
            }
        }
    }
<<<<<<< HEAD
<<<<<<< HEAD
}

=======
}
>>>>>>> 18d4dd8 (InitialVersion)
=======
}
>>>>>>> 18d4dd8 (InitialVersion)
