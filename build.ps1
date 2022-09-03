[cmdletbinding(DefaultParameterSetName = 'Task')]
param(
    # Build task(s) to execute
    [parameter(ParameterSetName = 'task', position = 0)]
    [string[]]$Task = 'default',

    # Bootstrap dependencies
    [switch]$Bootstrap,

    # Calculate version
    [switch]$CalculateVersion,

    # List available build tasks
    [parameter(ParameterSetName = 'Help')]
    [switch]$Help,

    # Optional properties to pass to psake
    [hashtable]$Properties,

    # Optional parameters to pass to psake
    [hashtable]$Parameters = @{
        "PSRepository"          = 'PSGallery'
        "PSRepositoryApiKey"    = ""
        "ScriptAnalysisEnabled" = $true
        "TestEnabled"           = $true
    }
)
<<<<<<< HEAD
=======
 
>>>>>>> 690e7a4 (Working version)
$ErrorActionPreference = 'Stop'

# Bootstrap dependencies
if ($Bootstrap.IsPresent) {
    Get-PackageProvider -Name Nuget -ForceBootstrap | Out-Null
    Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
    if ((Test-Path -Path ./requirements.psd1)) {
        if (-not (Get-Module -Name PSDepend -ListAvailable)) {
            Install-Module -Name PSDepend -Repository PSGallery -Scope CurrentUser -Force
        }
        Import-Module -Name PSDepend -Verbose:$false
        Invoke-PSDepend -Path './requirements.psd1' -Install -Import -Force -WarningAction SilentlyContinue
    }
    else {
        Write-Warning 'No [requirements.psd1] found. Skipping build dependency installation.'
    }
}

if ($CalculateVersion.IsPresent) {
    $CurrentBranch = &git rev-parse --abbrev-ref HEAD
    $LatestTag = git tag --sort=v:refname | Select-Object -Last 1

    [int]$Major = $LatestTag.split('.')[0]
    [int]$Minor = $LatestTag.split('.')[1]
    [int]$Patch = $LatestTag.split('.')[2]

    if ($CurrentBranch -match "patch") {
        $Patch++
    }
    elseif ($CurrentBranch -match "feature") {
        $Minor++
    }
    elseif ($CurrentBranch -match "major") {
        $Major++
    }
    else {
        Write-Error "Wrong branch!"
        exit 1
    }

    [string]$env:NewVersion = "$Major.$Minor.$Patch" 
    Update-ModuleManifest -Path "$PSScriptRoot/InfrastructureAsCode/InfrastructureAsCode.psd1" -ModuleVersion $env:NewVersion
}

# Execute psake task(s)
$psakeFile = './psakeFile.ps1'
if ($PSCmdlet.ParameterSetName -eq 'Help') {
    Get-PSakeScriptTasks -buildFile $psakeFile |
    Format-Table -Property Name, Description, Alias, DependsOn
}
else {
    Set-BuildEnvironment -Force
    Invoke-psake -buildFile $psakeFile -taskList $Task -nologo -properties $Properties -parameters $Parameters
    if ($psake.build_success) {
        Write-Output "Build complete"
        exit 0
    } else {
        Write-Error "Build not complete"
        exit 1
    }
}
