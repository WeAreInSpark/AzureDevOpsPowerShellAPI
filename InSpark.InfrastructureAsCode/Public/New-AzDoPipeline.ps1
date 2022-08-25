function New-AzDoPipeline {
    <#
.SYNOPSIS
    Creates an Azure Pipeline
.DESCRIPTION
    Creates an Azure Pipeline
.EXAMPLE
    $newAzDoPipelineSplat = @{
        CollectionUri = "https://dev.azure.com/contoso"
        PAT = "***"
        Name = "Pipeline 1"
        RepoName = "Repo 1"
        ProjectName = "Project 1"
    }
    New-AzDoPipeline @newAzDoPipelineSplat

    This example creates a new Azure Pipeline
.OUTPUTS
    PSobject containing Project information
.NOTES
#>
    [CmdletBinding(SupportsShouldProcess)]
    param (
        # Collection Uri of the organization
        [Parameter(Mandatory)]
        [string]
        $CollectionUri,

        # PAT to authentice with the organization
        [Parameter()]
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
                Invoke-RestMethod @params
            } else {
                Write-Output $Body | Format-List
                return
            }
        }
    }
}