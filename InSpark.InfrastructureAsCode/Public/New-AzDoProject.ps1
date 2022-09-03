function New-AzDoProject {
    <#
    .SYNOPSIS
        Function to create an Azure DevOps project
    .DESCRIPTION
        Function to create an Azure DevOps project
    .EXAMPLE
        New-AzDoProject -CollectionUri "https://dev.azure.com/contoso" -PAT "***" -ProjectName "Project 1"

        This example creates a new private Azure DevOps project
    .EXAMPLE
        New-AzDoProject -CollectionUri "https://dev.azure.com/contoso" -PAT "***" -ProjectName "Project 1" -Visibility 'public'

        This example creates a new public Azure DevOps project
    .EXAMPLE
        @("MyProject1","Myproject2") | New-AzDoProject -CollectionUri "https://dev.azure.com/contoso" -PAT "***"

        This example creates two new Azure DevOps projects using the pipeline.

    .EXAMPLE
        [pscustomobject]@{
            ProjectName     = 'Project 1'
            Visibility      = 'public'
            Description     = 'This is the best project'
        },
        [pscustomobject]@{
            ProjectName     = 'Project 1'
            Description     = 'This is the best project'
        } | New-AzDoProject -PAT $PAT -CollectionUri $CollectionUri

        This example creates two new Azure DevOps projects using the pipeline.
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param (
        # Collection URI. e.g. https://dev.azure.com/contoso.
        # Azure Pipelines has a predefined variable for this.
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]
        $CollectionUri,

        # PAT to get access to Azure DevOps.
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
<<<<<<< HEAD
<<<<<<< HEAD
                $Body | Format-List
=======
                Write-Output $Body | Format-List
>>>>>>> 18d4dd8 (InitialVersion)
=======
                Write-Output $Body | Format-List
>>>>>>> 18d4dd8 (InitialVersion)
                return
            }

            do {
                Start-Sleep 10
                Write-Verbose "Fetching creation state of $name"
                $response = Get-AzDoProject -CollectionUri $CollectionUri -PAT $PAT -ProjectName $name
            } while (
                $Response.State -ne 'wellFormed'
            )
            $Response
        }
    }
}
