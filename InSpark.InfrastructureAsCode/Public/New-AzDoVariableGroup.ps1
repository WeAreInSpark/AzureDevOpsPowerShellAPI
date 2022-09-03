function New-AzDoVariableGroup {
    <#
    .SYNOPSIS
        This script creates a variable group with at least 1 variable in a given project.
    .DESCRIPTION
        This script creates a variable group with at least 1 variable in a given project.
        When used in a pipeline, you can use the pre defined CollectionUri, ProjectName and AccessToken (PAT) variables.
    .EXAMPLE
        $params = @{
            Collectionuri = 'https://dev.azure.com/weareinspark/'
            PAT = '*******************'
            ProjectName = 'Project 1'
            VariableGroupName = 'VariableGroup1'
            Variables = @{ test = @{ value = 'test' } }
            Description = 'This is a test'
        }
        New-AzDoVariableGroup @params

        This example creates a new Variable Group with a variable "test = test".

    .EXAMPLE
        $params = @{
            Collectionuri = 'https://dev.azure.com/ChristianPiet0452/'
            ProjectName = 'Ditproject'
            Variables = @{ test = @{ value = 'test' } }
            Description = 'This is a test'
            PAT = $PAT
        }
        @(
            'dev-group'
            'acc-group'
            'prd-group'
        ) | New-AzDoVariableGroup @params

        This example creates a few new Variable Groups with a variable "test = test".
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
<<<<<<< HEAD
<<<<<<< HEAD
        [Parameter()]
=======
        [Parameter(Mandatory = $false)]
>>>>>>> 18d4dd8 (InitialVersion)
=======
        [Parameter(Mandatory = $false)]
>>>>>>> 18d4dd8 (InitialVersion)
        [string]
        $PAT = $env:SYSTEM_ACCESSTOKEN,

        # Project where the variable group has to be created
        [Parameter(Mandatory)]
        [string]
        $ProjectName,

        # Name of the variable group
        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ValueFromPipeline)]
        [string[]]
        $VariableGroupName,

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
        foreach ($name in $VariableGroupName) {

            $body = @{
                description = $Description
                name        = $name
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
<<<<<<< HEAD

                (Invoke-RestMethod @params) | ForEach-Object {
                    [PSCustomObject]@{
                        VariableGroupName = $_.name
                        VariableGroupId   = $_.id
                        Variables         = $_.variables
                        CreatedOn         = $_.createdOn
                        IsShared          = $_.isShared
                        ProjectName       = $ProjectName
                        CollectionURI     = $CollectionUri
                    }
                }
            } else {
                $body | Out-String
=======
                Invoke-RestMethod @params
            } else {
                Write-Output $Body | Format-List
                return
>>>>>>> 18d4dd8 (InitialVersion)
            }
        }
    }
}
