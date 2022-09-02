function New-AzDoProject {
    <#
    .SYNOPSIS
        Function to create an Azure DevOps project
    .DESCRIPTION
        Function to create an Azure DevOps project
    .NOTES
        When you are using Azure DevOps with Build service Access token, make sure the setting 'Protect access to repositories in YAML pipelin' is off.
    .EXAMPLE
        New-AzDoProject -CollectionUri "https://dev.azure.com/contoso" -PAT "***" -ProjectName "Project 1"

        This example creates a new private Azure DevOps project
    .EXAMPLE
        New-AzDoProject -CollectionUri "https://dev.azure.com/contoso" -PAT "***" -ProjectName "Project 1" -Visibility 'public'

        This example creates a new public Azure DevOps project
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param (
        # Collection URI. e.g. https://dev.azure.com/contoso.
        # Azure Pipelines has a predefined variable for this.
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]
        $CollectionUri,

        # PAT to get access to Azure DevOps.
        [Parameter()]
        [string]
        $PAT = $env:SYSTEM_ACCESSTOKEN,

        # Name of the project.
        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ValueFromPipeline)]
        [string[]]
        $ProjectName,

        # Description of the project
        [Parameter()]
        [string]
        $Description = '',

        # Type of source control.
        [Parameter()]
        [string]
        $SourceControlType = 'GIT',

        # Visibility of the project (private or public).
        [Parameter()]
        [ValidateSet('private', 'public')]
        [string]
        $Visibility = 'private'
    )
    Process {
        foreach ($name in $ProjectName) {

            $Body = @{
                name         = $name
                description  = $Description
                visibility   = $Visibility
                capabilities = @{
                    versioncontrol  = @{
                        sourceControlType = $SourceControlType
                    }
                    processTemplate = @{
                        templateTypeId = '6b724908-ef14-45cf-84f8-768b5384da45'
                    }
                }
            }

            $params = @{
                uri         = "$CollectionUri/_apis/projects?api-version=6.0"
                Method      = 'POST'
                Headers     = @{Authorization = 'Basic ' + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$PAT")) }
                body        = $Body | ConvertTo-Json
                ContentType = 'application/json'
                ErrorAction = 'Stop'
            }

            if ($PSCmdlet.ShouldProcess($CollectionUri)) {
                Write-Verbose "Trying to create the project"
                Invoke-RestMethod @params
            } else {
                $Body | Format-List
                return
            }

            do {
                Start-Sleep 10
                Write-Verbose "Fetching creation state of $name"
                $response = Get-AzDoProject -CollectionUri $CollectionUri -PAT $PAT -ProjectName $name
            } while (
                $Response.State -ne 'wellFormed'
            )
            return $Response
        }
    }
}
