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
        [Parameter()]
        [string]
        $PAT = $env:SYSTEM_ACCESSTOKEN,

        # Switch to use PAT instead of OAuth
        [Parameter()]
        [switch]
        $UsePAT = $false,

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
    Begin {
        if ($UsePAT) {
            Write-Verbose 'The [UsePAT]-parameter was set to true, so the PAT will be used to authenticate with the organization.'
            if ($PAT -eq $env:SYSTEM_ACCESSTOKEN) {
                Write-Verbose -Message "Using the PAT from the environment variable 'SYSTEM_ACCESSTOKEN'."
            } elseif (-not [string]::IsNullOrWhitespace($PAT) -and $PSBoundParameters.ContainsKey('PAT')) {
                Write-Verbose -Message "Using a custom PAT supplied in the parameters."
            } else {
                try {
                    throw "Requested to use a PAT, but no custom PAT was supplied in the parameters or the environment variable 'SYSTEM_ACCESSTOKEN' was not set."
                } catch {
                    $PSCmdlet.ThrowTerminatingError($_)
                }
            }
        } else {
            Write-Verbose 'The [UsePAT]-parameter was set to false, so an OAuth will be used to authenticate with the organization.'
            $PAT = ($UsePAT ? $PAT : $null)
        }
        try {
            $Header = New-ADOAuthHeader -PAT $PAT -AccessToken:($UsePAT ? $false : $true) -ErrorAction Stop
        } catch {
            $PSCmdlet.ThrowTerminatingError($_)
        }
    }
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
                Headers     = $Header
                body        = $Body | ConvertTo-Json
                ContentType = 'application/json'
                ErrorAction = 'Stop'
            }

            if ($PSCmdlet.ShouldProcess($CollectionUri)) {
                Write-Verbose "Trying to create the project"
                try {
                    (Invoke-RestMethod @params | Out-Null)
                } catch {
                    $message = $_
                    Write-Error "Failed to create the project [$name]"
                    Write-Error $message.ErrorDetails.Message
                    continue
                }
            } else {
                $Body | Format-List
                return
            }

            do {
                Start-Sleep 5
                Write-Verbose "Fetching creation state of $name"
                $getAzDoProjectSplat = @{
                    CollectionUri = $CollectionUri
                    ProjectName   = $name
                }
                if ($PAT) {
                    $getAzDoProjectSplat += @{
                        PAT    = $PAT
                        UsePAT = $true
                    }
                }

                $response = Get-AzDoProject @getAzDoProjectSplat
            } while (
                $Response.State -ne 'wellFormed'
            )
            $Response
        }
    }
}
