function New-AzDoVariableGroup {
    <#
    .SYNOPSIS
        This script creates a variable group with at least 1 variable in a given project.
    .DESCRIPTION
        This script creates a variable group with at least 1 variable in a given project. When used in a pipeline, you can use the pre defined CollectionUri,
        ProjectName and AccessToken (PAT) variables.
    .EXAMPLE
        $params = @{
            Collectionuri = 'https://dev.azure.com/weareinspark/'
            PAT = '*******************'
            ProjectName = 'Project 1'
            Name = 'VariableGroup1'
            Variables = @{ test = @{ value = 'test' } }
            Description = 'This is a test'
        }
        New-AzDoVariableGroup @params

        This example creates a new Variable Group with a variable "test = test".
    .OUTPUTS
        PSobject
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
        [string]
        $ProjectName,

        # Name of the variable group
        [Parameter(Mandatory)]
        [string[]]
        $Name,

        # Variable names and values
        [Parameter(Mandatory)]
        [hashtable]
        $Variables,

        # Description of the variable group
        [Parameter()]
        [string]
        $Description
    )
    Process {
        foreach ($n in $Name) {

            $Body = @{
                description = $Description
                name        = $n
                variables   = $Variables
            }

            $params = @{
                uri         = "$CollectionUri/$ProjectName/_apis/distributedtask/variablegroups?api-version=5.0-preview.1"
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