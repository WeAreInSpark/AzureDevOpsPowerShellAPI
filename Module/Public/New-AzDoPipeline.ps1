function New-AzDoPipeline {
    <#
.SYNOPSIS
    This script creates a variable group with at least 1 variable in a given project.
.DESCRIPTION
    This script creates a variable group with at least 1 variable in a given project. When used in a pipeline, you can use the pre defined CollectionUri,
    ProjectName and AccessToken (PAT) variables.
.EXAMPLE
    New-AzDoVariableGroup -collectionuri 'https://dev.azure.com/weareinspark/' -PAT '*******************' -ProjectName 'BusinessReadyCloud'
    -Name 'test' -Variables @{ test = @{ value = 'test' } } -Description 'This is a test'

    To create a variable group 'test' with one variable:
.INPUTS
    New-AzDoVariableGroup [-CollectionUri] <string> [-PAT] <string> [-ProjectName] <string> [-Name] <string> [-Variables] <hashtable> [[-Description] <string>]
    [<CommonParameters>]
.OUTPUTS
    New variable group with at least 1 variable in a given project.
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
        [string[]]
        $Name,

        # Project where the variable group has to be created
        [Parameter(Mandatory)]
        $RepoName,

        # Project where the variable group has to be created
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
            }
            else {
                Write-Output $Body | format-list
                return
            }
        }
    }
}