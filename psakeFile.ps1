Properties {
  $PSBPreference.Help.DefaultLocale = 'en-US'
  $PSBPreference.Test.OutputFile = 'Output/testResults.xml'
  $PSBPreference.Test.ScriptAnalysis.SettingsPath = 'tests/ScriptAnalyzerSettings.psd1'
  $PSBPreference.Test.ScriptAnalysis.Enabled = $ScriptAnalysisEnabled
  $PSBPreference.Test.CodeCoverage.Enabled = $CodeCoverageEnabled
  $PSBPreference.Test.Enabled = $TestEnabled
  $PSBPreference.General.ModuleVersion = $ModuleVersion
}

Task Default -depends Test

Task Test -FromModule PowerShellBuild -minimumVersion '0.6.1'

Task Build -FromModule PowerShellBuild -minimumVersion '0.6.1'

Task Publish -FromModule PowerShellBuild -minimumVersion '0.6.1'

Task Init -FromModule PowerShellBuild -minimumVersion '0.6.1'

Task Clean -FromModule PowerShellBuild -minimumVersion '0.6.1'

Task Stagefiles -FromModule PowerShellBuild -minimumVersion '0.6.1'
