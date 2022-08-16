function New-AzDoProject {
    <#
    .SYNOPSIS
        Function to create an Azure DevOps project
    .NOTES
        When you are using Azure DevOps with Build service Access token, make sure the setting 'Protect access to repositories in YAML pipelin' is off.
    .EXAMPLE
        New-AzureDevOpsProject -CollectionUri $CollectionUri -PAT $PAT -ProjectName $ProjectName
    .EXAMPLE
        New-AzureDevOpsProject -CollectionUri $CollectionUri -PAT $PAT -ProjectName $ProjectName -Visibility 'public'
    #>
    [CmdletBinding()]
    param (
        # Collection URI. e.g. https://dev.azure.com/contoso. 
        # Azure Pipelines has a predefined variable for this.
        [Parameter(Mandatory)]
        [string]
        $CollectionUri,

        # PAT to get access to Azure DevOps.
        [Parameter(Mandatory)]
        [string]
        $PAT,

        # Name of the project.
        [Parameter(Mandatory)]
        [string[]]
        $Name,

        # Description of the project
        [Parameter(Mandatory = $false)]
        [string]
        $Description = '',

        # Type of source control.
        [Parameter(Mandatory = $false)]
        [string]
        $SourceControlType = 'GIT',

        # Visibility of the project (private or public).
        [Parameter(Mandatory = $false)]
        [ValidateSet('private', 'public')]
        [string]
        $Visibility = 'private'
    )
    Process {
        foreach ($n in $Name) {

            $Body = @{
                name         = $n
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
    
            try {
                Invoke-RestMethod @params > $null
            }
            catch {
                Write-Error $_
                exit
            }

            do {
                Start-Sleep 10
                $params = @{
                    uri     = "$CollectionUri/_apis/projects?api-version=7.1-preview.4"
                    Method  = 'GET'
                    Headers = @{Authorization = 'Basic ' + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$PAT")) }
                }
                $Response = (Invoke-RestMethod @params).value | Where-Object { $_.name -eq $n }
                Write-Verbose "Trying to invoke rest method"
            } while (
                $Response.state -ne 'wellFormed'
            )
            return $Response
        }
    }
}