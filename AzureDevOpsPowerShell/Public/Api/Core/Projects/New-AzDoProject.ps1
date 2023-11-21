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
  [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
  param (
    # Collection URI. e.g. https://dev.azure.com/contoso.
    # Azure Pipelines has a predefined variable for this.
    [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
    [string]
    $CollectionUri,

    # Name of the project.
    [Parameter(Mandatory, ValueFromPipelineByPropertyName, ValueFromPipeline)]
    [string[]]
    [ValidateScript(
      {
        # Length
        if (($_).Length -gt 63) {
          throw "The project name cannot be longer than 63 characters"
        }

        # - Must not be a system reserved name.
        $forbiddenNames = @(
          'COM1',
          'COM2',
          'COM3',
          'COM4',
          'COM5',
          'COM6',
          'COM7',
          'COM8',
          'COM9',
          'COM10',
          'CON',
          'DefaultCollection',
          'LPT1',
          'LPT2',
          'LPT3',
          'LPT4',
          'LPT5',
          'LPT6',
          'LPT7',
          'LPT8',
          'LPT9',
          'NUL',
          'PRN',
          'SERVER',
          'SignalR',
          'Web',
          'WEB')
        if ($forbiddenNames -contains $_) {
          throw "The project name cannot be one of the following values: $forbiddenNames"
        }

        # - Must not be one of the hidden segments used for IIS request filtering like App_Browsers, App_code, App_Data, App_GlobalResources, App_LocalResources, App_Themes, App_WebResources, bin, or web.config.
        if ($_ -match "App_Browsers|App_code|App_Data|App_GlobalResources|App_LocalResources|App_Themes|App_WebResources|bin|web.config") {
          throw "The project name cannot be one of the following values: App_Browsers, App_code, App_Data, App_GlobalResources, App_LocalResources, App_Themes, App_WebResources, bin, or web.config"
        }

        # - Must not contain any Unicode control characters or surrogate characters.
        if ($_ -match "[\p{C}\p{Cs}]") {
          throw "The project name cannot contain any Unicode control characters or surrogate characters"
        }
        # - Must not contain the following printable characters: \ / : * ? " < > | ; # $ * { } , + = [ ].
        if ($_ -match "[\\/:*?`"<>|;#$*{},+=\[\]]") {
          throw "The project name cannot contain the following printable characters: \ / : * ? `"< > | ; # $ * { } , + = [ ]"
        }
        # - Must not start with an underscore _.
        if ($_ -match "^_") {
          throw "The project name cannot start with an underscore _"
        }
        # - Must not start or end with a period ..
        if ($_ -match "^\." -or $_ -match "\.$") {
          throw "The project name cannot start or end with a period ."
        }
        $true
      }
    )]
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

    $params = @{
      uri     = "$CollectionUri/_apis/projects"
      version = "7.2-preview.4"
      method  = 'POST'
    }

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

      if ($PSCmdlet.ShouldProcess($CollectionUri, "Create project named: $($PSStyle.Bold)$name$($PSStyle.Reset)")) {

        $body | Invoke-AzDoRestMethod @params | Out-Null

        do {
          Start-Sleep 5
          Write-Verbose "Fetching creation state of $name"
          $getAzDoProjectSplat = @{
            CollectionUri = $CollectionUri
            ProjectName   = $name
          }

          $response = Get-AzDoProject @getAzDoProjectSplat
        } while (
          $response.State -ne 'wellFormed'
        )
        $result += ($response)
      }
    }
  }

  End {
    if ($result) {
      $result
    }
  }
}
