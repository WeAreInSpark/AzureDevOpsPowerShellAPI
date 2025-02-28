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

$ErrorActionPreference = 'Stop'
'1'
# Bootstrap dependencies
if ($Bootstrap.IsPresent) {
  '2'
  Get-PackageProvider -Name Nuget -ForceBootstrap | Out-Null
  '3'
  Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
  '4'
  if ((Test-Path -Path ./requirements.psd1)) {
    '5'
    if (-not (Get-Module -Name PSDepend -ListAvailable)) {
      '6'
      Install-Module -Name PSDepend -Repository PSGallery -Scope CurrentUser -Force
    }
    '7'
    Import-Module -Name PSDepend -Verbose:$false
    '8'
    Invoke-PSDepend -Path './requirements.psd1' -Install -Import -Force -WarningAction SilentlyContinue
  } else {
    Write-Warning 'No [requirements.psd1] found. Skipping build dependency installation.'
  }
}

# Execute psake task(s)
'9'
$psakeFile = './psakeFile.ps1'
if ($PSCmdlet.ParameterSetName -eq 'Help') {
  '10'
  Get-PSakeScriptTasks -buildFile $psakeFile |
  Format-Table -Property Name, Description, Alias, DependsOn
} else {
  '11'
  Set-BuildEnvironment -Force
  '12'
  Invoke-psake -buildFile $psakeFile -taskList $Task -nologo -properties $Properties -parameters $Parameters
  if ($psake.build_success) {
    "Build complete"
    exit 0
  } else {
    Write-Error "Build not complete"
    exit 1
  }
}
