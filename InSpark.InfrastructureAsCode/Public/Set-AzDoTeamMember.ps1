function Set-AzDoTeamMember {
    <#
    .SYNOPSIS
        Adds a Azure Group to a default team in an Azure DevOps project.
    .DESCRIPTION
        Adds a Azure Group to a default team in an Azure DevOps project.
    .EXAMPLE
        New-AzDoVariableGroup -collectionuri 'https://dev.azure.com/weareinspark/' -PAT '*******************' -ProjectName 'BusinessReadyCloud'
        -Name 'test' -Variables @{ test = @{ value = 'test' } } -Description 'This is a test'

        To create a variable group 'test' with one variable
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
        $OrganizationName,

        # PAT to authentice with the organization
        [Parameter()]
        [string]
        $PAT = $env:SYSTEM_ACCESSTOKEN,

        # Project where the variable group has to be created
        [Parameter(Mandatory)]
        [string]
        $ProjectName,

        # Project where the variable group has to be created
        [Parameter(Mandatory)]
        [string]
        $ObjectId
    )
    $params = @{
        uri     = "https://vssps.dev.azure.com/$OrganizationName/_apis/graph/groups?api-version=7.1-preview.1"
        Method  = 'GET'
        Headers = @{Authorization = 'Basic ' + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$($PAT)")) }
    }

    $Team = (Invoke-RestMethod @params).value | Where-Object { $_.principalName -match "$ProjectName Team" }

    $Body = @{
        originId = $ObjectId
    }

    $params = @{
        uri         = "https://vssps.dev.azure.com/$OrganizationName/_apis/graph/groups?groupDescriptors=$($Team.descriptor)&api-version=7.1-preview.1"
        Method      = 'POST'
        Headers     = @{Authorization = 'Basic ' + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$($PAT)")) }
        body        = $Body | ConvertTo-Json -Depth 99
        ContentType = 'application/json'
    }

    if ($PSCmdlet.ShouldProcess($CollectionUri)) {
        $Response = Invoke-RestMethod @params

        [PSCustomObject]@{
            PrincipalName = $Response.principalName
            MailAddress   = $Response.mailAddress
            Origin        = $Response.origin
        }
    } else {
        Write-Output $Body | Format-List
        return
    }
}